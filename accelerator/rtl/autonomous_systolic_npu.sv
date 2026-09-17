`timescale 1ns/1ps

// Complete standalone tiled GEMM engine around the registered systolic fabric.
// The host loads local memories, pulses start once, and waits for done.
module autonomous_systolic_npu #(
    parameter integer N      = 32,
    parameter integer MAX_M  = 64,
    parameter integer MAX_N  = 64,
    parameter integer MAX_K  = 64,
    parameter integer ADDR_W = 16
) (
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   start,
    input  wire [15:0]            cfg_m,
    input  wire [15:0]            cfg_n,
    input  wire [15:0]            cfg_k,
    input  wire                   cfg_bias_enable,
    input  wire                   cfg_relu_enable,
    input  wire                   cfg_int8_enable,
    input  wire [4:0]             cfg_requant_shift,
    output reg                    busy,
    output reg                    done,
    output reg                    error,

    input  wire                   a_we,
    input  wire [ADDR_W-1:0]      a_addr,
    input  wire signed [7:0]      a_wdata,
    input  wire                   b_we,
    input  wire [ADDR_W-1:0]      b_addr,
    input  wire signed [7:0]      b_wdata,
    input  wire                   bias_we,
    input  wire [ADDR_W-1:0]      bias_addr,
    input  wire signed [31:0]     bias_wdata,
    input  wire [ADDR_W-1:0]      c_addr,
    output wire signed [31:0]     c_rdata,
    output wire signed [7:0]      c_rdata_int8
);
    localparam integer A_DEPTH = MAX_M * MAX_K;
    localparam integer B_DEPTH = MAX_K * MAX_N;
    localparam integer C_DEPTH = MAX_M * MAX_N;
    localparam [2:0] IDLE=0, CLEAR=1, RUN=2, STORE=3, NEXT_TILE=4;

    reg signed [7:0]  a_mem [0:A_DEPTH-1];
    reg signed [7:0]  b_mem [0:B_DEPTH-1];
    reg signed [31:0] bias_mem [0:MAX_N-1];
    reg signed [31:0] c_mem [0:C_DEPTH-1];
    reg signed [7:0]  c8_mem [0:C_DEPTH-1];

    reg [2:0] state;
    integer tile_m, tile_n, wave_cycle, store_index;
    integer r, c, k_for_lane;
    integer store_r, store_c, global_r, global_c, output_address;
    reg [15:0] m_q, n_q, k_q;
    reg bias_q, relu_q, int8_q;
    reg [4:0] shift_q;

    reg  [N*8-1:0] west_a;
    reg  [N-1:0] west_a_valid;
    reg  [N*8-1:0] north_b;
    reg  [N-1:0] north_b_valid;
    wire [N*8-1:0] east_a, south_b;
    wire [N-1:0] east_a_valid, south_b_valid;
    wire [N*N*32-1:0] accumulators;
    wire array_clear = (state == CLEAR);

    reg signed [31:0] selected_acc;
    reg signed [31:0] biased_value;
    reg signed [31:0] activated_value;
    reg signed [31:0] requant_value;

    assign c_rdata = (c_addr < C_DEPTH) ? c_mem[c_addr] : 32'sd0;
    assign c_rdata_int8 = (c_addr < C_DEPTH) ? c8_mem[c_addr] : 8'sd0;

    function automatic signed [7:0] sat8(input signed [31:0] value);
        begin
            if (value > 127) sat8 = 8'sd127;
            else if (value < -128) sat8 = -8'sd128;
            else sat8 = value[7:0];
        end
    endfunction

    // Boundary skew: row r receives A[r,k] at t=k+r; column c receives
    // B[k,c] at t=k+c. Neighbor registers perform all interior movement.
    always @* begin
        west_a = '0;
        west_a_valid = '0;
        north_b = '0;
        north_b_valid = '0;
        if (state == RUN) begin
            for (r = 0; r < N; r = r + 1) begin
                k_for_lane = wave_cycle - r;
                if ((tile_m+r) < m_q && k_for_lane >= 0 && k_for_lane < k_q) begin
                    west_a[r*8 +: 8] = a_mem[(tile_m+r)*k_q+k_for_lane];
                    west_a_valid[r] = 1'b1;
                end
            end
            for (c = 0; c < N; c = c + 1) begin
                k_for_lane = wave_cycle - c;
                if ((tile_n+c) < n_q && k_for_lane >= 0 && k_for_lane < k_q) begin
                    north_b[c*8 +: 8] = b_mem[k_for_lane*n_q+(tile_n+c)];
                    north_b_valid[c] = 1'b1;
                end
            end
        end
    end

    systolic_array_int8 #(.N(N), .DATA_W(8), .ACC_W(32)) array (
        .clk(clk), .rst(rst), .clear(array_clear), .step(state == RUN),
        .west_a(west_a), .west_a_valid(west_a_valid),
        .north_b(north_b), .north_b_valid(north_b_valid),
        .east_a(east_a), .east_a_valid(east_a_valid),
        .south_b(south_b), .south_b_valid(south_b_valid),
        .accumulators(accumulators)
    );

    always @* begin
        store_r = store_index / N;
        store_c = store_index % N;
        global_r = tile_m + store_r;
        global_c = tile_n + store_c;
        output_address = global_r*n_q + global_c;
        selected_acc = $signed(accumulators[store_index*32 +: 32]);
        biased_value = selected_acc;
        if (bias_q && global_c < n_q)
            biased_value = selected_acc + bias_mem[global_c];
        activated_value = biased_value;
        if (relu_q && biased_value < 0)
            activated_value = 0;
        requant_value = activated_value >>> shift_q;
    end

    always @(posedge clk) begin
        done <= 1'b0;
        if (rst) begin
            state <= IDLE;
            busy <= 0;
            done <= 0;
            error <= 0;
            tile_m <= 0;
            tile_n <= 0;
            wave_cycle <= 0;
            store_index <= 0;
        end else begin
            if (!busy) begin
                if (a_we && a_addr < A_DEPTH) a_mem[a_addr] <= a_wdata;
                if (b_we && b_addr < B_DEPTH) b_mem[b_addr] <= b_wdata;
                if (bias_we && bias_addr < MAX_N) bias_mem[bias_addr] <= bias_wdata;
            end

            case (state)
                IDLE: begin
                    busy <= 0;
                    if (start) begin
                        if (cfg_m == 0 || cfg_n == 0 || cfg_k == 0 ||
                            cfg_m > MAX_M || cfg_n > MAX_N || cfg_k > MAX_K) begin
                            error <= 1;
                            done <= 1;
                        end else begin
                            m_q <= cfg_m; n_q <= cfg_n; k_q <= cfg_k;
                            bias_q <= cfg_bias_enable;
                            relu_q <= cfg_relu_enable;
                            int8_q <= cfg_int8_enable;
                            shift_q <= cfg_requant_shift;
                            error <= 0; busy <= 1;
                            tile_m <= 0; tile_n <= 0;
                            state <= CLEAR;
                        end
                    end
                end
                CLEAR: begin
                    wave_cycle <= 0;
                    store_index <= 0;
                    state <= RUN;
                end
                RUN: begin
                    // Final product reaches PE(N-1,N-1) at K+2N-3.
                    if (wave_cycle >= k_q + 2*N - 3) begin
                        store_index <= 0;
                        state <= STORE;
                    end else
                        wave_cycle <= wave_cycle + 1;
                end
                STORE: begin
                    if (global_r < m_q && global_c < n_q) begin
                        c_mem[output_address] <= activated_value;
                        c8_mem[output_address] <= int8_q ? sat8(requant_value)
                                                        : sat8(activated_value);
                    end
                    if (store_index == N*N-1)
                        state <= NEXT_TILE;
                    else
                        store_index <= store_index + 1;
                end
                NEXT_TILE: begin
                    if (tile_n + N < n_q) begin
                        tile_n <= tile_n + N;
                        state <= CLEAR;
                    end else if (tile_m + N < m_q) begin
                        tile_n <= 0;
                        tile_m <= tile_m + N;
                        state <= CLEAR;
                    end else begin
                        busy <= 0;
                        done <= 1;
                        state <= IDLE;
                    end
                end
                default: begin
                    state <= IDLE; busy <= 0; error <= 1;
                end
            endcase
        end
    end
endmodule
