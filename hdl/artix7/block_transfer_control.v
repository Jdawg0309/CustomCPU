`default_nettype none

// Synthesizable mirror of the sandbox block-transfer sequencer.
// Supported operations are ARM PUSH (STMDB SP!) and POP (LDMIA SP!).
module block_transfer_control (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire        is_pop,
    input  wire [15:0] reg_list_in,
    input  wire [31:0] base_in,

    output wire        active,
    output reg         done,
    output wire        hold_pc,
    output wire [3:0]  reg_idx,
    output wire        reg_selected,
    output wire [31:0] transfer_address,
    output wire        store_enable,
    output wire        pop_request,
    output wire        pop_wait,
    output wire        pop_commit,
    output reg         base_write_enable,
    output reg  [31:0] base_write_data
);
    reg        active_r;
    reg        is_pop_r;
    reg [15:0] reg_list_r;
    reg [3:0]  reg_idx_r;
    reg [31:0] address_r;
    reg        pop_pending_r;

    wire accept_start = start && !active_r && !done;
    wire terminal = is_pop_r ? (reg_idx_r == 4'hf) : (reg_idx_r == 4'h0);
    wire selected = reg_list_r[reg_idx_r];
    wire selected_push = active_r && !is_pop_r && selected;
    wire selected_pop = active_r && is_pop_r && selected;

    assign active = active_r;
    assign hold_pc = start || active_r;
    assign reg_idx = reg_idx_r;
    assign reg_selected = active_r && selected;
    assign transfer_address = is_pop_r ? address_r : (address_r - 32'd4);
    assign store_enable = selected_push;
    assign pop_request = selected_pop;
    assign pop_wait = selected_pop && !pop_pending_r;
    assign pop_commit = selected_pop && pop_pending_r;

    always @(posedge clk) begin
        if (rst) begin
            active_r         <= 1'b0;
            done             <= 1'b0;
            is_pop_r         <= 1'b0;
            reg_list_r       <= 16'b0;
            reg_idx_r        <= 4'b0;
            address_r        <= 32'b0;
            pop_pending_r    <= 1'b0;
            base_write_enable <= 1'b0;
            base_write_data  <= 32'b0;
        end else begin
            done              <= 1'b0;
            base_write_enable <= 1'b0;

            if (accept_start) begin
                active_r      <= 1'b1;
                is_pop_r      <= is_pop;
                reg_list_r    <= reg_list_in;
                reg_idx_r     <= is_pop ? 4'h0 : 4'hf;
                address_r     <= base_in;
                pop_pending_r <= 1'b0;
            end else if (active_r) begin
                if (selected_pop && !pop_pending_r) begin
                    // First POP cycle presents the synchronous-RAM address.
                    // Hold both index and address until the returned word commits.
                    pop_pending_r <= 1'b1;
                end else begin
                    pop_pending_r <= 1'b0;

                    if (selected_push)
                        address_r <= address_r - 32'd4;
                    else if (selected_pop)
                        address_r <= address_r + 32'd4;

                    if (terminal) begin
                        active_r          <= 1'b0;
                        done              <= 1'b1;
                        base_write_enable <= 1'b1;
                        if (selected_push)
                            base_write_data <= address_r - 32'd4;
                        else if (selected_pop)
                            base_write_data <= address_r + 32'd4;
                        else
                            base_write_data <= address_r;
                    end else begin
                        reg_idx_r <= is_pop_r ? (reg_idx_r + 4'd1)
                                              : (reg_idx_r - 4'd1);
                    end
                end
            end
        end
    end
endmodule

`default_nettype wire
