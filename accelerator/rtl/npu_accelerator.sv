`timescale 1ns/1ps

module npu_accelerator #(
    parameter integer ARRAY_SIZE = 32,
    parameter integer MAX_M      = 64,
    parameter integer MAX_N      = 64,
    parameter integer MAX_K      = 64,
    parameter integer ADDR_W     = 16
) (
    input  wire                    clk,
    input  wire                    rst,

    // Autonomous command. Configuration must remain stable while busy.
    input  wire                    start,
    input  wire [15:0]             cfg_m,
    input  wire [15:0]             cfg_n,
    input  wire [15:0]             cfg_k,
    input  wire                    cfg_bias_enable,
    input  wire                    cfg_relu_enable,
    input  wire                    cfg_int8_enable,
    input  wire [4:0]              cfg_requant_shift,
    output reg                     busy,
    output reg                     done,
    output reg                     error,

    // Host loading ports. Writes are accepted only while idle.
    input  wire                    a_we,
    input  wire [ADDR_W-1:0]       a_addr,
    input  wire signed [7:0]       a_wdata,
    input  wire                    b_we,
    input  wire [ADDR_W-1:0]       b_addr,
    input  wire signed [7:0]       b_wdata,
    input  wire                    bias_we,
    input  wire [ADDR_W-1:0]       bias_addr,
    input  wire signed [31:0]      bias_wdata,

    input  wire [ADDR_W-1:0]       c_addr,
    output wire signed [31:0]      c_rdata,
    output wire signed [7:0]       c_rdata_int8
);

    localparam integer A_DEPTH = MAX_M * MAX_K;
    localparam integer B_DEPTH = MAX_K * MAX_N;
    localparam integer C_DEPTH = MAX_M * MAX_N;

    localparam [2:0] S_IDLE  = 3'd0,
                     S_CLEAR = 3'd1,
                     S_MAC   = 3'd2,
                     S_STORE = 3'd3,
                     S_NEXT  = 3'd4;

    reg [2:0] state;
    reg signed [7:0]  a_mem [0:A_DEPTH-1];
    reg signed [7:0]  b_mem [0:B_DEPTH-1];
    reg signed [31:0] bias_mem [0:MAX_N-1];
    reg signed [31:0] c_mem [0:C_DEPTH-1];
    reg signed [7:0]  c8_mem [0:C_DEPTH-1];
    reg signed [31:0] accum [0:ARRAY_SIZE-1][0:ARRAY_SIZE-1];

    integer tile_m, tile_n, k_index;
    integer i, j;
    integer global_m, global_n;
    reg signed [31:0] post_value;
    reg signed [31:0] shifted_value;

    assign c_rdata      = (c_addr < C_DEPTH) ? c_mem[c_addr] : 32'sd0;
    assign c_rdata_int8 = (c_addr < C_DEPTH) ? c8_mem[c_addr] : 8'sd0;

    function automatic signed [7:0] saturate_int8;
        input signed [31:0] value;
        begin
            if (value > 32'sd127)
                saturate_int8 = 8'sd127;
            else if (value < -32'sd128)
                saturate_int8 = -8'sd128;
            else
                saturate_int8 = value[7:0];
        end
    endfunction

    always @(posedge clk) begin
        done <= 1'b0;

        if (rst) begin
            state   <= S_IDLE;
            busy    <= 1'b0;
            done    <= 1'b0;
            error   <= 1'b0;
            tile_m  <= 0;
            tile_n  <= 0;
            k_index <= 0;
        end else begin
            if (!busy) begin
                if (a_we && a_addr < A_DEPTH)
                    a_mem[a_addr] <= a_wdata;
                if (b_we && b_addr < B_DEPTH)
                    b_mem[b_addr] <= b_wdata;
                if (bias_we && bias_addr < MAX_N)
                    bias_mem[bias_addr] <= bias_wdata;
            end

            case (state)
                S_IDLE: begin
                    busy <= 1'b0;
                    if (start) begin
                        if (cfg_m == 0 || cfg_n == 0 || cfg_k == 0 ||
                            cfg_m > MAX_M || cfg_n > MAX_N || cfg_k > MAX_K) begin
                            error <= 1'b1;
                            done  <= 1'b1;
                        end else begin
                            error   <= 1'b0;
                            busy    <= 1'b1;
                            tile_m  <= 0;
                            tile_n  <= 0;
                            k_index <= 0;
                            state   <= S_CLEAR;
                        end
                    end
                end

                S_CLEAR: begin
                    for (i = 0; i < ARRAY_SIZE; i = i + 1)
                        for (j = 0; j < ARRAY_SIZE; j = j + 1)
                            accum[i][j] <= 32'sd0;
                    k_index <= 0;
                    state <= S_MAC;
                end

                // ARRAY_SIZE^2 independent signed MACs execute each cycle.
                S_MAC: begin
                    for (i = 0; i < ARRAY_SIZE; i = i + 1) begin
                        for (j = 0; j < ARRAY_SIZE; j = j + 1) begin
                            if ((tile_m + i) < cfg_m && (tile_n + j) < cfg_n)
                                accum[i][j] <= accum[i][j]
                                    + $signed(a_mem[(tile_m+i)*cfg_k+k_index])
                                    * $signed(b_mem[k_index*cfg_n+(tile_n+j)]);
                        end
                    end
                    if (k_index + 1 >= cfg_k)
                        state <= S_STORE;
                    else
                        k_index <= k_index + 1;
                end

                S_STORE: begin
                    for (i = 0; i < ARRAY_SIZE; i = i + 1) begin
                        for (j = 0; j < ARRAY_SIZE; j = j + 1) begin
                            global_m = tile_m + i;
                            global_n = tile_n + j;
                            if (global_m < cfg_m && global_n < cfg_n) begin
                                post_value = accum[i][j];
                                if (cfg_bias_enable)
                                    post_value = post_value + bias_mem[global_n];
                                if (cfg_relu_enable && post_value < 0)
                                    post_value = 0;
                                shifted_value = post_value >>> cfg_requant_shift;
                                c_mem[global_m*cfg_n+global_n] <= post_value;
                                if (cfg_int8_enable)
                                    c8_mem[global_m*cfg_n+global_n]
                                        <= saturate_int8(shifted_value);
                                else
                                    c8_mem[global_m*cfg_n+global_n]
                                        <= saturate_int8(post_value);
                            end
                        end
                    end
                    state <= S_NEXT;
                end

                S_NEXT: begin
                    k_index <= 0;
                    if (tile_n + ARRAY_SIZE < cfg_n) begin
                        tile_n <= tile_n + ARRAY_SIZE;
                        state <= S_CLEAR;
                    end else if (tile_m + ARRAY_SIZE < cfg_m) begin
                        tile_n <= 0;
                        tile_m <= tile_m + ARRAY_SIZE;
                        state <= S_CLEAR;
                    end else begin
                        busy  <= 1'b0;
                        done  <= 1'b1;
                        state <= S_IDLE;
                    end
                end

                default: begin
                    state <= S_IDLE;
                    busy  <= 1'b0;
                    error <= 1'b1;
                end
            endcase
        end
    end
endmodule
