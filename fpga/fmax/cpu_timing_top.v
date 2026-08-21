// Timing wrapper: all CPU outputs XOR-folded into 4 registered bits so
// synthesis cannot prove them unobservable and delete the core.
module cpu_timing_top(input wire clk, output wire [3:0] signature);
  wire o_Output_1;
  wire o_Output_2;
  wire [31:0] o_Output_bus_1;
  wire [31:0] o_Output_bus_10;
  wire [31:0] o_Output_bus_11;
  wire [31:0] o_Output_bus_12;
  wire [31:0] o_Output_bus_13;
  wire [31:0] o_Output_bus_14;
  wire [31:0] o_Output_bus_15;
  wire [31:0] o_Output_bus_16;
  wire [31:0] o_Output_bus_17;
  wire [31:0] o_Output_bus_18;
  wire [31:0] o_Output_bus_19;
  wire [31:0] o_Output_bus_2;
  wire [31:0] o_Output_bus_20;
  wire [31:0] o_Output_bus_3;
  wire [31:0] o_Output_bus_4;
  wire [31:0] o_Output_bus_5;
  wire [31:0] o_Output_bus_6;
  wire [31:0] o_Output_bus_7;
  wire [31:0] o_Output_bus_8;
  wire [31:0] o_Output_bus_9;
  wire [31:0] o_RD_A;
  wire o_bl_taken;
  wire o_branch_taken;
  wire o_condition_pass;
  wire o_is_BL;
  wire o_is_BX;
  wire o_is_LDR;
  wire o_is_STR;
  wire o_ldr_reg_we;
  wire o_mem_class;
  wire [31:0] o_mem_offset;
  wire [31:0] o_memory_address;
  wire [31:0] o_memory_offset_effective;
  wire o_normal_reg_WE;
  main cpu (
    .Input_1(1'b0),
    .logisimClockTree0({5{clk}}),
    .Output_1(o_Output_1),
    .Output_2(o_Output_2),
    .Output_bus_1(o_Output_bus_1),
    .Output_bus_10(o_Output_bus_10),
    .Output_bus_11(o_Output_bus_11),
    .Output_bus_12(o_Output_bus_12),
    .Output_bus_13(o_Output_bus_13),
    .Output_bus_14(o_Output_bus_14),
    .Output_bus_15(o_Output_bus_15),
    .Output_bus_16(o_Output_bus_16),
    .Output_bus_17(o_Output_bus_17),
    .Output_bus_18(o_Output_bus_18),
    .Output_bus_19(o_Output_bus_19),
    .Output_bus_2(o_Output_bus_2),
    .Output_bus_20(o_Output_bus_20),
    .Output_bus_3(o_Output_bus_3),
    .Output_bus_4(o_Output_bus_4),
    .Output_bus_5(o_Output_bus_5),
    .Output_bus_6(o_Output_bus_6),
    .Output_bus_7(o_Output_bus_7),
    .Output_bus_8(o_Output_bus_8),
    .Output_bus_9(o_Output_bus_9),
    .RD_A(o_RD_A),
    .bl_taken(o_bl_taken),
    .branch_taken(o_branch_taken),
    .condition_pass(o_condition_pass),
    .is_BL(o_is_BL),
    .is_BX(o_is_BX),
    .is_LDR(o_is_LDR),
    .is_STR(o_is_STR),
    .ldr_reg_we(o_ldr_reg_we),
    .mem_class(o_mem_class),
    .mem_offset(o_mem_offset),
    .memory_address(o_memory_address),
    .memory_offset_effective(o_memory_offset_effective),
    .normal_reg_WE(o_normal_reg_WE)
  );
  wire [3:0] fold = {
    (^o_Output_bus_10 ^ ^o_Output_bus_14 ^ ^o_Output_bus_18 ^ ^o_Output_bus_3 ^ ^o_Output_bus_7 ^ o_bl_taken ^ o_is_BX ^ o_mem_class ^ o_normal_reg_WE),
    (^o_Output_bus_1 ^ ^o_Output_bus_13 ^ ^o_Output_bus_17 ^ ^o_Output_bus_20 ^ ^o_Output_bus_6 ^ ^o_RD_A ^ o_is_BL ^ o_ldr_reg_we ^ ^o_memory_offset_effective),
    (o_Output_2 ^ ^o_Output_bus_12 ^ ^o_Output_bus_16 ^ ^o_Output_bus_2 ^ ^o_Output_bus_5 ^ ^o_Output_bus_9 ^ o_condition_pass ^ o_is_STR ^ ^o_memory_address),
    (o_Output_1 ^ ^o_Output_bus_11 ^ ^o_Output_bus_15 ^ ^o_Output_bus_19 ^ ^o_Output_bus_4 ^ ^o_Output_bus_8 ^ o_branch_taken ^ o_is_LDR ^ ^o_mem_offset)
  };
  reg [3:0] sig;
  always @(posedge clk) sig <= fold;
  assign signature = sig;
endmodule
