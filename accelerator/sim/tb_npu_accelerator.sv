`timescale 1ns/1ps

module tb_npu_accelerator;
    localparam ARRAY_SIZE = 4;
    localparam MAX_M = 8;
    localparam MAX_N = 8;
    localparam MAX_K = 8;

    reg clk = 0;
    reg rst = 1;
    always #5 clk = ~clk;

    reg start = 0;
    reg [15:0] cfg_m, cfg_n, cfg_k;
    reg cfg_bias_enable, cfg_relu_enable, cfg_int8_enable;
    reg [4:0] cfg_requant_shift;
    wire busy, done, error;
    reg a_we = 0, b_we = 0, bias_we = 0;
    reg [15:0] a_addr, b_addr, bias_addr, c_addr;
    reg signed [7:0] a_wdata, b_wdata;
    reg signed [31:0] bias_wdata;
    wire signed [31:0] c_rdata;
    wire signed [7:0] c_rdata_int8;

    integer m, n, k, idx, expected, failures;
    integer avec [0:39];
    integer bvec [0:47];
    integer bias [0:5];

`ifdef SYSTOLIC_DUT
    autonomous_systolic_npu #(
        .N(ARRAY_SIZE), .MAX_M(MAX_M), .MAX_N(MAX_N),
        .MAX_K(MAX_K), .ADDR_W(16)
    ) dut (.*);
`else
    npu_accelerator #(
        .ARRAY_SIZE(ARRAY_SIZE), .MAX_M(MAX_M), .MAX_N(MAX_N),
        .MAX_K(MAX_K), .ADDR_W(16)
    ) dut (.*);
`endif

    task write_a(input integer address, input integer value);
        begin
            @(negedge clk); a_addr = address; a_wdata = value; a_we = 1;
            @(negedge clk); a_we = 0;
        end
    endtask
    task write_b(input integer address, input integer value);
        begin
            @(negedge clk); b_addr = address; b_wdata = value; b_we = 1;
            @(negedge clk); b_we = 0;
        end
    endtask
    task write_bias(input integer address, input integer value);
        begin
            @(negedge clk); bias_addr = address; bias_wdata = value; bias_we = 1;
            @(negedge clk); bias_we = 0;
        end
    endtask

    initial begin
        failures = 0;
        cfg_m = 5; cfg_n = 6; cfg_k = 7;
        cfg_bias_enable = 1;
        cfg_relu_enable = 1;
        cfg_int8_enable = 1;
        cfg_requant_shift = 2;
        a_addr = 0; b_addr = 0; bias_addr = 0; c_addr = 0;
        a_wdata = 0; b_wdata = 0; bias_wdata = 0;

        repeat (3) @(posedge clk);
        rst = 0;

        // Deterministic signed data; M and N exceed ARRAY_SIZE to test tiling.
        for (idx = 0; idx < 35; idx = idx + 1) begin
            avec[idx] = (idx % 9) - 4;
            write_a(idx, avec[idx]);
        end
        for (idx = 0; idx < 42; idx = idx + 1) begin
            bvec[idx] = (idx % 7) - 3;
            write_b(idx, bvec[idx]);
        end
        for (idx = 0; idx < 6; idx = idx + 1) begin
            bias[idx] = idx - 2;
            write_bias(idx, bias[idx]);
        end

        @(negedge clk); start = 1;
        @(negedge clk); start = 0;
        wait(done);
        if (error) begin
            $display("FAIL accelerator raised error");
            failures = failures + 1;
        end

        for (m = 0; m < 5; m = m + 1) begin
            for (n = 0; n < 6; n = n + 1) begin
                expected = bias[n];
                for (k = 0; k < 7; k = k + 1)
                    expected = expected + avec[m*7+k] * bvec[k*6+n];
                if (expected < 0) expected = 0;
                c_addr = m*6+n;
                #1;
                if ($signed(c_rdata) !== expected) begin
                    $display("FAIL C[%0d,%0d] got=%0d expected=%0d",
                             m, n, $signed(c_rdata), expected);
                    failures = failures + 1;
                end
                if ($signed(c_rdata_int8) !== ((expected >>> 2) > 127
                                               ? 127 : (expected >>> 2))) begin
                    $display("FAIL C8[%0d,%0d] got=%0d expected=%0d",
                             m, n, $signed(c_rdata_int8), (expected >>> 2));
                    failures = failures + 1;
                end
            end
        end

        if (failures == 0)
            $display("PASS autonomous tiled GEMM 5x7 * 7x6, bias, ReLU, requant");
        else
            $display("FAILURES=%0d", failures);
        $finish(failures != 0);
    end
endmodule
