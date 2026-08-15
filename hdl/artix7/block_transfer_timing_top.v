`default_nettype none

// Self-stimulating FPGA wrapper: keeps every controller input/output live while
// requiring only one clock pin and four observation pins on the Artix-7 board.
module block_transfer_timing_top (
    input  wire       clk,
    output wire [3:0] signature
);
    reg [31:0] stimulus = 32'h1ace_b00c;
    always @(posedge clk)
        stimulus <= {stimulus[30:0], stimulus[31] ^ stimulus[21] ^ stimulus[1]};

    wire active, done, hold_pc, selected, store_enable;
    wire pop_request, pop_wait, pop_commit, base_we;
    wire [3:0] idx;
    wire [31:0] transfer_address, base_wd;

    block_transfer_control dut (
        .clk(clk),
        .rst(1'b0),
        .start(stimulus[0] & stimulus[7]),
        .is_pop(stimulus[3]),
        .reg_list_in(stimulus[31:16]),
        .base_in({stimulus[29:0], 2'b00}),
        .active(active),
        .done(done),
        .hold_pc(hold_pc),
        .reg_idx(idx),
        .reg_selected(selected),
        .transfer_address(transfer_address),
        .store_enable(store_enable),
        .pop_request(pop_request),
        .pop_wait(pop_wait),
        .pop_commit(pop_commit),
        .base_write_enable(base_we),
        .base_write_data(base_wd)
    );

    assign signature[0] = ^transfer_address ^ active ^ store_enable;
    assign signature[1] = ^base_wd ^ done ^ base_we;
    assign signature[2] = ^idx ^ hold_pc ^ selected;
    assign signature[3] = pop_request ^ pop_wait ^ pop_commit ^ stimulus[31];
endmodule

`default_nettype wire
