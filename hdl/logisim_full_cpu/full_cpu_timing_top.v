`default_nettype none

// Timing wrapper for the complete HDL hierarchy exported from
// sandbox_armv4t.circ. Wide diagnostic outputs are folded into four pins so
// the CPU logic remains observable without consuming hundreds of FPGA I/Os.
module full_cpu_timing_top (
    input  wire       clk,
    output wire [3:0] signature
);
    wire output_1;
    wire [31:0] output_bus_1, output_bus_2, output_bus_3, output_bus_4;
    wire [31:0] output_bus_5, output_bus_6, output_bus_7, output_bus_8;
    wire [31:0] output_bus_9, output_bus_10, output_bus_11, output_bus_12;
    wire [31:0] output_bus_13, output_bus_14, output_bus_15, output_bus_16;
    wire [31:0] output_bus_17, output_bus_18, output_bus_19, output_bus_20;
    wire [31:0] rd_a, mem_offset, memory_address;
    wire [31:0] memory_offset_effective;
    wire bl_taken, branch_taken, condition_pass, is_bl, is_bx;
    wire is_ldr, is_str, ldr_reg_we, mem_class, normal_reg_we;

    main cpu (
        .Input_1(1'b0),
        // logisimClockTree0[4] feeds raw-FDRE-style .clock() pins; bit[0]
        // feeds the .clk()/.clock() ports of block_transfer_control,
        // pc_fetch, and reg16x32_1_1 (see full_cpu.v:6416/6614/6716,
        // s_logisimnet48 <= logisimClockTree0[0]). Tying bits [3:0] to a
        // constant (as the prior wrapper did) freezes those blocks forever,
        // so Yosys proves the whole CPU constant and deletes it. Replicate
        // the real clock onto every bit instead.
        .logisimClockTree0({clk, clk, clk, clk, clk}),
        .Output_1(output_1),
        .Output_bus_1(output_bus_1),
        .Output_bus_2(output_bus_2),
        .Output_bus_3(output_bus_3),
        .Output_bus_4(output_bus_4),
        .Output_bus_5(output_bus_5),
        .Output_bus_6(output_bus_6),
        .Output_bus_7(output_bus_7),
        .Output_bus_8(output_bus_8),
        .Output_bus_9(output_bus_9),
        .Output_bus_10(output_bus_10),
        .Output_bus_11(output_bus_11),
        .Output_bus_12(output_bus_12),
        .Output_bus_13(output_bus_13),
        .Output_bus_14(output_bus_14),
        .Output_bus_15(output_bus_15),
        .Output_bus_16(output_bus_16),
        .Output_bus_17(output_bus_17),
        .Output_bus_18(output_bus_18),
        .Output_bus_19(output_bus_19),
        .Output_bus_20(output_bus_20),
        .RD_A(rd_a),
        .bl_taken(bl_taken),
        .branch_taken(branch_taken),
        .condition_pass(condition_pass),
        .is_BL(is_bl),
        .is_BX(is_bx),
        .is_LDR(is_ldr),
        .is_STR(is_str),
        .ldr_reg_we(ldr_reg_we),
        .mem_class(mem_class),
        .mem_offset(mem_offset),
        .memory_address(memory_address),
        .memory_offset_effective(memory_offset_effective),
        .normal_reg_WE(normal_reg_we)
    );

    assign signature[0] = ^{output_bus_1, output_bus_5, output_bus_9,
                            output_bus_13, output_bus_17, rd_a};
    assign signature[1] = ^{output_bus_2, output_bus_6, output_bus_10,
                            output_bus_14, output_bus_18, mem_offset};
    assign signature[2] = ^{output_bus_3, output_bus_7, output_bus_11,
                            output_bus_15, output_bus_19, memory_address};
    assign signature[3] = ^{output_bus_4, output_bus_8, output_bus_12,
                            output_bus_16, output_bus_20,
                            memory_offset_effective, output_1, bl_taken,
                            branch_taken, condition_pass, is_bl, is_bx,
                            is_ldr, is_str, ldr_reg_we, mem_class,
                            normal_reg_we};
endmodule

`default_nettype wire
