`timescale 1ns/1ps

// Output-stationary N x N systolic fabric.
//
// The controller injects one A value per row on west_a and one B value per
// column on north_b each cycle. Operands MUST be skewed by row/column index.
// Valid bits permit bubbles and edge-tile masking. Results are row-major:
// accumulators[(row*N+col)*ACC_W +: ACC_W].
module systolic_array_int8 #(
    parameter integer N      = 32,
    parameter integer DATA_W = 8,
    parameter integer ACC_W  = 32
) (
    input  wire                         clk,
    input  wire                         rst,
    input  wire                         clear,
    input  wire                         step,
    input  wire [N*DATA_W-1:0]          west_a,
    input  wire [N-1:0]                 west_a_valid,
    input  wire [N*DATA_W-1:0]          north_b,
    input  wire [N-1:0]                 north_b_valid,
    output wire [N*DATA_W-1:0]          east_a,
    output wire [N-1:0]                 east_a_valid,
    output wire [N*DATA_W-1:0]          south_b,
    output wire [N-1:0]                 south_b_valid,
    output wire [N*N*ACC_W-1:0]         accumulators
);
    wire signed [DATA_W-1:0] a_link [0:N-1][0:N];
    wire signed [DATA_W-1:0] b_link [0:N][0:N-1];
    wire                      av_link[0:N-1][0:N];
    wire                      bv_link[0:N][0:N-1];

    genvar r, c;
    generate
        for (r = 0; r < N; r = r + 1) begin : gen_row_edges
            assign a_link[r][0] = $signed(west_a[r*DATA_W +: DATA_W]);
            assign av_link[r][0] = west_a_valid[r];
            assign east_a[r*DATA_W +: DATA_W] = a_link[r][N];
            assign east_a_valid[r] = av_link[r][N];
        end
        for (c = 0; c < N; c = c + 1) begin : gen_col_edges
            assign b_link[0][c] = $signed(north_b[c*DATA_W +: DATA_W]);
            assign bv_link[0][c] = north_b_valid[c];
            assign south_b[c*DATA_W +: DATA_W] = b_link[N][c];
            assign south_b_valid[c] = bv_link[N][c];
        end

        for (r = 0; r < N; r = r + 1) begin : gen_rows
            for (c = 0; c < N; c = c + 1) begin : gen_cols
                wire signed [ACC_W-1:0] pe_accumulator;
                systolic_pe_int8 #(.DATA_W(DATA_W), .ACC_W(ACC_W)) pe (
                    .clk(clk), .rst(rst), .clear(clear), .step(step),
                    .a_in(a_link[r][c]), .b_in(b_link[r][c]),
                    .a_valid_in(av_link[r][c]), .b_valid_in(bv_link[r][c]),
                    .a_out(a_link[r][c+1]), .b_out(b_link[r+1][c]),
                    .a_valid_out(av_link[r][c+1]), .b_valid_out(bv_link[r+1][c]),
                    .accumulator(pe_accumulator)
                );
                assign accumulators[(r*N+c)*ACC_W +: ACC_W] = pe_accumulator;
            end
        end
    endgenerate
endmodule
