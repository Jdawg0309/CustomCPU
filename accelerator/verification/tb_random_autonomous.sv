`timescale 1ns/1ps

// Implementation-facing randomized regression. This intentionally drives only
// the public autonomous host interface and makes no assumptions about latency.
module tb_random_autonomous;
    localparam N = 4;
    localparam MAX_M = 8;
    localparam MAX_N = 8;
    localparam MAX_K = 8;
    localparam CASES = 30;

    reg clk = 0;
    reg rst = 1;
    always #5 clk = ~clk;

    reg start = 0;
    reg [15:0] cfg_m = 0, cfg_n = 0, cfg_k = 0;
    reg cfg_bias_enable = 0, cfg_relu_enable = 0, cfg_int8_enable = 1;
    reg [4:0] cfg_requant_shift = 0;
    wire busy, done, error;
    reg a_we = 0, b_we = 0, bias_we = 0;
    reg [15:0] a_addr = 0, b_addr = 0, bias_addr = 0, c_addr = 0;
    reg signed [7:0] a_wdata = 0, b_wdata = 0;
    reg signed [31:0] bias_wdata = 0;
    wire signed [31:0] c_rdata;
    wire signed [7:0] c_rdata_int8;

    integer avec [0:MAX_M*MAX_K-1];
    integer bvec [0:MAX_K*MAX_N-1];
    integer biases [0:MAX_N-1];
    integer expected_acc [0:MAX_M*MAX_N-1];
    integer expected_i8 [0:MAX_M*MAX_N-1];
    integer testcase, m, n, k, i, j, q, value, quantized;
    integer failures = 0, cycles, seed;

    autonomous_systolic_npu #(
        .N(N), .MAX_M(MAX_M), .MAX_N(MAX_N), .MAX_K(MAX_K), .ADDR_W(16)
    ) dut (.*);

    task write_a(input integer address, input integer data);
        begin
            @(negedge clk); a_addr = address; a_wdata = data; a_we = 1;
            @(negedge clk); a_we = 0;
        end
    endtask
    task write_b(input integer address, input integer data);
        begin
            @(negedge clk); b_addr = address; b_wdata = data; b_we = 1;
            @(negedge clk); b_we = 0;
        end
    endtask
    task write_bias(input integer address, input integer data);
        begin
            @(negedge clk); bias_addr = address; bias_wdata = data; bias_we = 1;
            @(negedge clk); bias_we = 0;
        end
    endtask

    function integer sat8(input integer x);
        begin
            if (x > 127) sat8 = 127;
            else if (x < -128) sat8 = -128;
            else sat8 = x;
        end
    endfunction

    initial begin
        seed = 32'h004e5055;
        repeat (4) @(posedge clk);
        @(negedge clk); rst = 0;

        for (testcase = 0; testcase < CASES; testcase = testcase + 1) begin
            // A deterministic sweep includes both sides of the physical N=4 tile.
            case (testcase % 8)
                0: begin m=1; n=1; k=1; end
                1: begin m=3; n=4; k=5; end
                2: begin m=4; n=5; k=3; end
                3: begin m=5; n=3; k=4; end
                4: begin m=5; n=5; k=5; end
                5: begin m=8; n=1; k=7; end
                6: begin m=1; n=8; k=8; end
                default: begin m=8; n=8; k=8; end
            endcase
            cfg_m = m; cfg_n = n; cfg_k = k;
            cfg_bias_enable = (testcase % 2) != 0;
            cfg_relu_enable = (testcase % 3) == 0;
            cfg_int8_enable = 1;
            cfg_requant_shift = testcase % 7;

            for (i = 0; i < m*k; i = i + 1) begin
                value = ($random(seed) % 256);
                if (value > 127) value = value - 256;
                if (value < -128) value = value + 256;
                avec[i] = value;
                write_a(i, value);
            end
            for (i = 0; i < k*n; i = i + 1) begin
                value = ($random(seed) % 256);
                if (value > 127) value = value - 256;
                if (value < -128) value = value + 256;
                bvec[i] = value;
                write_b(i, value);
            end
            for (j = 0; j < n; j = j + 1) begin
                biases[j] = ($random(seed) % 40001) - 20000;
                write_bias(j, biases[j]);
            end

            for (i = 0; i < m; i = i + 1) begin
                for (j = 0; j < n; j = j + 1) begin
                    value = 0;
                    for (q = 0; q < k; q = q + 1)
                        value = value + avec[i*k+q] * bvec[q*n+j];
                    if (cfg_bias_enable) value = value + biases[j];
                    if (cfg_relu_enable && value < 0) value = 0;
                    expected_acc[i*n+j] = value;
                    quantized = value >>> cfg_requant_shift;
                    expected_i8[i*n+j] = sat8(quantized);
                end
            end

            @(negedge clk); start = 1;
            @(negedge clk); start = 0;
            cycles = 0;
            while (!done && cycles < 10000) begin
                @(posedge clk);
                cycles = cycles + 1;
            end
            if (!done || error) begin
                $display("FAIL case=%0d timeout/error cycles=%0d error=%0b", testcase, cycles, error);
                failures = failures + 1;
            end

            for (i = 0; i < m; i = i + 1) begin
                for (j = 0; j < n; j = j + 1) begin
                    c_addr = i*n+j;
                    #1;
                    if ($signed(c_rdata) !== expected_acc[i*n+j]) begin
                        $display("FAIL case=%0d C[%0d,%0d] got=%0d expected=%0d",
                                 testcase, i, j, $signed(c_rdata), expected_acc[i*n+j]);
                        failures = failures + 1;
                    end
                    if ($signed(c_rdata_int8) !== expected_i8[i*n+j]) begin
                        $display("FAIL case=%0d C8[%0d,%0d] got=%0d expected=%0d",
                                 testcase, i, j, $signed(c_rdata_int8), expected_i8[i*n+j]);
                        failures = failures + 1;
                    end
                end
            end
            $display("PASS case=%0d shape=%0dx%0dx%0d cycles=%0d bias=%0b relu=%0b shift=%0d",
                     testcase, m, n, k, cycles, cfg_bias_enable,
                     cfg_relu_enable, cfg_requant_shift);
        end

        if (failures == 0)
            $display("PASS randomized autonomous RTL: %0d cases", CASES);
        else
            $display("FAIL randomized autonomous RTL: failures=%0d", failures);
        $finish(failures != 0);
    end
endmodule
