`timescale 1ns/1ps

// One output-stationary signed INT8 processing element.
// A and B advance one PE per cycle.  The accumulator remains local until clear.
// Synthesis tools can map the signed multiply/add into a DSP48E1.
module systolic_pe_int8 #(
    parameter integer DATA_W = 8,
    parameter integer ACC_W  = 32
) (
    input  wire                         clk,
    input  wire                         rst,
    input  wire                         clear,
    input  wire                         step,
    input  wire signed [DATA_W-1:0]     a_in,
    input  wire signed [DATA_W-1:0]     b_in,
    input  wire                         a_valid_in,
    input  wire                         b_valid_in,
    output reg  signed [DATA_W-1:0]     a_out,
    output reg  signed [DATA_W-1:0]     b_out,
    output reg                          a_valid_out,
    output reg                          b_valid_out,
    output reg  signed [ACC_W-1:0]      accumulator
);
    // Force the multiply-accumulate into the XC7K DSP48E1 rather than LUTs.
    // This attribute is ignored by behavioral simulators.
    (* use_dsp = "yes" *) reg signed [ACC_W-1:0] dsp_accumulator;
    wire signed [(2*DATA_W)-1:0] product = $signed(a_in) * $signed(b_in);

    always @* accumulator = dsp_accumulator;

    always @(posedge clk) begin
        if (rst) begin
            a_out       <= '0;
            b_out       <= '0;
            a_valid_out <= 1'b0;
            b_valid_out <= 1'b0;
            dsp_accumulator <= '0;
        end else if (clear) begin
            // Clear the output tile without advancing an operand wavefront.
            a_out       <= '0;
            b_out       <= '0;
            a_valid_out <= 1'b0;
            b_valid_out <= 1'b0;
            dsp_accumulator <= '0;
        end else if (step) begin
            // Movement is independent of accumulation. Bubbles therefore travel
            // through the fabric without disturbing neighboring wavefronts.
            a_out       <= a_in;
            b_out       <= b_in;
            a_valid_out <= a_valid_in;
            b_valid_out <= b_valid_in;

            if (a_valid_in && b_valid_in)
                dsp_accumulator <= dsp_accumulator
                    + {{(ACC_W-2*DATA_W){product[2*DATA_W-1]}}, product};
        end
    end
endmodule
