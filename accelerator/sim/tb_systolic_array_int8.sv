`timescale 1ns/1ps

module tb_systolic_array_int8;
    localparam N = 2;
    reg clk = 0, rst = 1, clear = 0, step = 0;
    reg [N*8-1:0] west_a = 0, north_b = 0;
    reg [N-1:0] west_a_valid = 0, north_b_valid = 0;
    wire [N*N*32-1:0] accumulators;
    wire [N*8-1:0] east_a, south_b;
    wire [N-1:0] east_a_valid, south_b_valid;

    systolic_array_int8 #(.N(N)) dut (
        .clk(clk), .rst(rst), .clear(clear), .step(step),
        .west_a(west_a), .west_a_valid(west_a_valid),
        .north_b(north_b), .north_b_valid(north_b_valid),
        .east_a(east_a), .east_a_valid(east_a_valid),
        .south_b(south_b), .south_b_valid(south_b_valid),
        .accumulators(accumulators)
    );
    always #5 clk = ~clk;

    task drive;
        input signed [7:0] a0, a1, b0, b1;
        input [1:0] av, bv;
        begin
            @(negedge clk);
            west_a = {a1, a0}; north_b = {b1, b0};
            west_a_valid = av; north_b_valid = bv; step = 1;
        end
    endtask

    initial begin
        repeat (2) @(posedge clk);
        @(negedge clk); rst = 0; clear = 1;
        @(negedge clk); clear = 0;
        // A={{1,2},{-3,4}}, B={{5,-6},{7,8}}; operands are skewed.
        drive( 1, 0, 5, 0, 2'b01, 2'b01);
        drive( 2,-3, 7,-6, 2'b11, 2'b11);
        drive( 0, 4, 0, 8, 2'b10, 2'b10);
        drive( 0, 0, 0, 0, 2'b00, 2'b00);
        @(negedge clk); step = 0;
        if ($signed(accumulators[0*32 +: 32]) !== 32'sd19 ||
            $signed(accumulators[1*32 +: 32]) !== 32'sd10 ||
            $signed(accumulators[2*32 +: 32]) !== 32'sd13 ||
            $signed(accumulators[3*32 +: 32]) !== 32'sd50) begin
            $display("FAIL results %0d %0d %0d %0d",
                $signed(accumulators[0*32 +: 32]), $signed(accumulators[1*32 +: 32]),
                $signed(accumulators[2*32 +: 32]), $signed(accumulators[3*32 +: 32]));
            $fatal(1);
        end
        $display("PASS 2x2 signed systolic timing and accumulation");
        $finish;
    end
endmodule
