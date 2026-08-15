`timescale 1ns/1ps
`default_nettype none

module block_transfer_control_tb;
    reg clk = 0;
    reg rst = 1;
    reg start = 0;
    reg is_pop = 0;
    reg [15:0] reg_list = 0;
    reg [31:0] base = 0;
    wire active, done, hold_pc, selected, store_en;
    wire pop_request, pop_wait, pop_commit, base_we;
    wire [3:0] idx;
    wire [31:0] address, base_wd;

    block_transfer_control dut (
        .clk(clk), .rst(rst), .start(start), .is_pop(is_pop),
        .reg_list_in(reg_list), .base_in(base), .active(active),
        .done(done), .hold_pc(hold_pc), .reg_idx(idx),
        .reg_selected(selected), .transfer_address(address),
        .store_enable(store_en), .pop_request(pop_request),
        .pop_wait(pop_wait), .pop_commit(pop_commit),
        .base_write_enable(base_we), .base_write_data(base_wd)
    );

    always #5 clk = ~clk;

    task tick;
        begin @(posedge clk); #1; end
    endtask

    task fail;
        input [255:0] reason;
        begin
            $display("FAIL: %0s", reason);
            $finish_and_return(1);
        end
    endtask

    initial begin
        tick; rst = 0;

        // PUSH {r4,lr}: r14 must store at 3fc, then r4 at 3f8.
        is_pop = 0; reg_list = 16'h4010; base = 32'h400; start = 1;
        tick; start = 0;
        while (!(store_en && idx == 4'he)) tick;
        if (address !== 32'h3fc) fail("PUSH r14 address");
        tick;
        while (!(store_en && idx == 4'h4)) tick;
        if (address !== 32'h3f8) fail("PUSH r4 address");
        while (!done) tick;
        if (!base_we || base_wd !== 32'h3f8) fail("PUSH SP writeback");
        tick;

        // POP {r4,lr}: every selected register gets one wait and one commit.
        is_pop = 1; reg_list = 16'h4010; base = 32'h3f8; start = 1;
        tick; start = 0;
        while (!(pop_wait && idx == 4'h4)) tick;
        if (address !== 32'h3f8) fail("POP r4 request address");
        tick;
        if (!(pop_commit && idx == 4'h4) || address !== 32'h3f8)
            fail("POP r4 commit/hold");
        tick;
        while (!(pop_wait && idx == 4'he)) tick;
        if (address !== 32'h3fc) fail("POP r14 request address");
        tick;
        if (!(pop_commit && idx == 4'he) || address !== 32'h3fc)
            fail("POP r14 commit/hold");
        while (!done) tick;
        if (!base_we || base_wd !== 32'h400) fail("POP SP writeback");

        $display("PASS: PUSH/POP sequencing and SP writeback");
        $finish;
    end
endmodule

`default_nettype wire
