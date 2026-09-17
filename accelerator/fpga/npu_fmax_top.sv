`timescale 1ns/1ps

// Registered harness for measuring the systolic fabric itself. All operand
// paths begin at registers; accumulator outputs are observable and false-pathed
// only after their internal accumulator registers.
module npu_fmax_top #(
    parameter integer N = 32
) (
    input  wire clk,
    input  wire rst,
    output wire [31:0] result_probe
);
    reg [31:0] pattern;
    reg [N*8-1:0] west_a;
    reg [N*8-1:0] north_b;
    reg [N-1:0] west_valid;
    reg [N-1:0] north_valid;
    reg clear;
    wire [N*8-1:0] east_a, south_b;
    wire [N-1:0] east_valid, south_valid;
    integer lane;

    always @(posedge clk) begin
        if (rst) begin
            pattern <= 32'h1;
            west_a <= '0;
            north_b <= '0;
            west_valid <= '0;
            north_valid <= '0;
            clear <= 1'b1;
        end else begin
            pattern <= {pattern[30:0], pattern[31]^pattern[21]^pattern[1]^pattern[0]};
            clear <= 1'b0;
            west_valid <= {N{1'b1}};
            north_valid <= {N{1'b1}};
            for (lane = 0; lane < N; lane = lane + 1) begin
                west_a[lane*8 +: 8] <= pattern[7:0] + lane;
                north_b[lane*8 +: 8] <= pattern[15:8] - lane;
            end
        end
    end

    wire [N*N*32-1:0] all_accumulators;
    (* DONT_TOUCH = "yes", KEEP_HIERARCHY = "yes" *)
    systolic_array_int8 #(.N(N), .DATA_W(8), .ACC_W(32)) dut (
        .clk(clk), .rst(rst), .clear(clear), .step(1'b1),
        .west_a(west_a), .west_a_valid(west_valid),
        .north_b(north_b), .north_b_valid(north_valid),
        .east_a(east_a), .east_a_valid(east_valid),
        .south_b(south_b), .south_b_valid(south_valid),
        .accumulators(all_accumulators)
    );
    assign result_probe = all_accumulators[31:0];
endmodule
