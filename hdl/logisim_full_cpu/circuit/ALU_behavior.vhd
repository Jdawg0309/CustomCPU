--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : ALU                                                          ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF ALU IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT XOR_GATE_ONEHOT
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT AND_GATE
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT OR_GATE_32_INPUTS
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1  : IN  std_logic;
                input10 : IN  std_logic;
                input11 : IN  std_logic;
                input12 : IN  std_logic;
                input13 : IN  std_logic;
                input14 : IN  std_logic;
                input15 : IN  std_logic;
                input16 : IN  std_logic;
                input17 : IN  std_logic;
                input18 : IN  std_logic;
                input19 : IN  std_logic;
                input2  : IN  std_logic;
                input20 : IN  std_logic;
                input21 : IN  std_logic;
                input22 : IN  std_logic;
                input23 : IN  std_logic;
                input24 : IN  std_logic;
                input25 : IN  std_logic;
                input26 : IN  std_logic;
                input27 : IN  std_logic;
                input28 : IN  std_logic;
                input29 : IN  std_logic;
                input3  : IN  std_logic;
                input30 : IN  std_logic;
                input31 : IN  std_logic;
                input32 : IN  std_logic;
                input4  : IN  std_logic;
                input5  : IN  std_logic;
                input6  : IN  std_logic;
                input7  : IN  std_logic;
                input8  : IN  std_logic;
                input9  : IN  std_logic;
                result  : OUT std_logic );
      END COMPONENT;

      COMPONENT XNOR_GATE_ONEHOT
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT Multiplexer_bus_4
         GENERIC ( nrOfBits : INTEGER );
         PORT ( enable  : IN  std_logic;
                muxIn_0 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_1 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_2 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_3 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                sel     : IN  std_logic_vector( 1 DOWNTO 0 );
                muxOut  : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT mul_32
         PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
                B                 : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                carry             : OUT std_logic_vector( 31 DOWNTO 0 );
                sum               : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT ALU_logic_engine
         PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
                B                 : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                select_bit        : IN  std_logic_vector( 2 DOWNTO 0 );
                result            : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT ALU_airthmetic_engine
         PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
                B                 : IN  std_logic_vector( 31 DOWNTO 0 );
                Cflag             : IN  std_logic;
                Cin_sel           : IN  std_logic_vector( 1 DOWNTO 0 );
                a_inversion       : IN  std_logic;
                b_inversion       : IN  std_logic;
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                unused            : IN  std_logic;
                Cout              : OUT std_logic;
                Result            : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT ks_32b
         PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
                B                 : IN  std_logic_vector( 31 DOWNTO 0 );
                Cin               : IN  std_logic;
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                Cout              : OUT std_logic;
                SUM10             : OUT std_logic;
                SUM11             : OUT std_logic;
                SUM12             : OUT std_logic;
                SUM13             : OUT std_logic;
                SUM14             : OUT std_logic;
                SUM15             : OUT std_logic;
                SUM16             : OUT std_logic;
                SUM17             : OUT std_logic;
                SUM18             : OUT std_logic;
                SUM19             : OUT std_logic;
                SUM2              : OUT std_logic;
                SUM20             : OUT std_logic;
                SUM21             : OUT std_logic;
                SUM22             : OUT std_logic;
                SUM23             : OUT std_logic;
                SUM24             : OUT std_logic;
                SUM25             : OUT std_logic;
                SUM26             : OUT std_logic;
                SUM27             : OUT std_logic;
                SUM28             : OUT std_logic;
                SUM29             : OUT std_logic;
                SUM3              : OUT std_logic;
                SUM30             : OUT std_logic;
                SUM31             : OUT std_logic;
                SUM4              : OUT std_logic;
                SUM5              : OUT std_logic;
                SUM6              : OUT std_logic;
                SUM7              : OUT std_logic;
                SUM8              : OUT std_logic;
                SUM9              : OUT std_logic;
                sum0              : OUT std_logic;
                sum1              : OUT std_logic );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus0  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus11 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus12 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus16 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus24 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus26 : std_logic_vector( 2 DOWNTO 0 );
   SIGNAL s_logisimBus28 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus35 : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_logisimBus42 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus51 : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_logisimBus57 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus58 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimNet1  : std_logic;
   SIGNAL s_logisimNet10 : std_logic;
   SIGNAL s_logisimNet13 : std_logic;
   SIGNAL s_logisimNet14 : std_logic;
   SIGNAL s_logisimNet15 : std_logic;
   SIGNAL s_logisimNet17 : std_logic;
   SIGNAL s_logisimNet18 : std_logic;
   SIGNAL s_logisimNet19 : std_logic;
   SIGNAL s_logisimNet2  : std_logic;
   SIGNAL s_logisimNet20 : std_logic;
   SIGNAL s_logisimNet21 : std_logic;
   SIGNAL s_logisimNet22 : std_logic;
   SIGNAL s_logisimNet23 : std_logic;
   SIGNAL s_logisimNet25 : std_logic;
   SIGNAL s_logisimNet27 : std_logic;
   SIGNAL s_logisimNet29 : std_logic;
   SIGNAL s_logisimNet3  : std_logic;
   SIGNAL s_logisimNet30 : std_logic;
   SIGNAL s_logisimNet31 : std_logic;
   SIGNAL s_logisimNet32 : std_logic;
   SIGNAL s_logisimNet33 : std_logic;
   SIGNAL s_logisimNet34 : std_logic;
   SIGNAL s_logisimNet36 : std_logic;
   SIGNAL s_logisimNet37 : std_logic;
   SIGNAL s_logisimNet38 : std_logic;
   SIGNAL s_logisimNet39 : std_logic;
   SIGNAL s_logisimNet4  : std_logic;
   SIGNAL s_logisimNet40 : std_logic;
   SIGNAL s_logisimNet41 : std_logic;
   SIGNAL s_logisimNet43 : std_logic;
   SIGNAL s_logisimNet44 : std_logic;
   SIGNAL s_logisimNet45 : std_logic;
   SIGNAL s_logisimNet46 : std_logic;
   SIGNAL s_logisimNet47 : std_logic;
   SIGNAL s_logisimNet48 : std_logic;
   SIGNAL s_logisimNet49 : std_logic;
   SIGNAL s_logisimNet5  : std_logic;
   SIGNAL s_logisimNet50 : std_logic;
   SIGNAL s_logisimNet52 : std_logic;
   SIGNAL s_logisimNet53 : std_logic;
   SIGNAL s_logisimNet54 : std_logic;
   SIGNAL s_logisimNet55 : std_logic;
   SIGNAL s_logisimNet56 : std_logic;
   SIGNAL s_logisimNet59 : std_logic;
   SIGNAL s_logisimNet6  : std_logic;
   SIGNAL s_logisimNet60 : std_logic;
   SIGNAL s_logisimNet61 : std_logic;
   SIGNAL s_logisimNet62 : std_logic;
   SIGNAL s_logisimNet63 : std_logic;
   SIGNAL s_logisimNet64 : std_logic;
   SIGNAL s_logisimNet65 : std_logic;
   SIGNAL s_logisimNet66 : std_logic;
   SIGNAL s_logisimNet67 : std_logic;
   SIGNAL s_logisimNet68 : std_logic;
   SIGNAL s_logisimNet69 : std_logic;
   SIGNAL s_logisimNet7  : std_logic;
   SIGNAL s_logisimNet70 : std_logic;
   SIGNAL s_logisimNet71 : std_logic;
   SIGNAL s_logisimNet72 : std_logic;
   SIGNAL s_logisimNet73 : std_logic;
   SIGNAL s_logisimNet74 : std_logic;
   SIGNAL s_logisimNet75 : std_logic;
   SIGNAL s_logisimNet76 : std_logic;
   SIGNAL s_logisimNet77 : std_logic;
   SIGNAL s_logisimNet78 : std_logic;
   SIGNAL s_logisimNet79 : std_logic;
   SIGNAL s_logisimNet8  : std_logic;
   SIGNAL s_logisimNet80 : std_logic;
   SIGNAL s_logisimNet81 : std_logic;
   SIGNAL s_logisimNet82 : std_logic;
   SIGNAL s_logisimNet83 : std_logic;
   SIGNAL s_logisimNet84 : std_logic;
   SIGNAL s_logisimNet85 : std_logic;
   SIGNAL s_logisimNet86 : std_logic;
   SIGNAL s_logisimNet87 : std_logic;
   SIGNAL s_logisimNet88 : std_logic;
   SIGNAL s_logisimNet89 : std_logic;
   SIGNAL s_logisimNet9  : std_logic;
   SIGNAL s_logisimNet90 : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus12(31 DOWNTO 0) <= B;
   s_logisimBus16(31 DOWNTO 0) <= A;
   s_logisimBus26(2 DOWNTO 0)  <= logic_sel;
   s_logisimBus35(1 DOWNTO 0)  <= engine_sel;
   s_logisimBus51(1 DOWNTO 0)  <= cin_sel;
   s_logisimNet21              <= b_inv;
   s_logisimNet25              <= a_inv;
   s_logisimNet27              <= unused;
   s_logisimNet49              <= write_enable;
   s_logisimNet50              <= Cflag;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   C                <= s_logisimNet56;
   N                <= s_logisimBus28(31);
   V                <= s_logisimNet22;
   Z                <= s_logisimNet43;
   result           <= s_logisimBus28(31 DOWNTO 0);
   write_enable_out <= s_logisimNet49;

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- NOT Gate
   s_logisimNet43 <=  NOT s_logisimNet33;

   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   GATES_1 : XOR_GATE_ONEHOT
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimBus28(31),
                 input2 => s_logisimNet9,
                 result => s_logisimNet29 );

   GATES_2 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet29,
                 input2 => s_logisimNet30,
                 result => s_logisimNet22 );

   GATES_3 : OR_GATE_32_INPUTS
      GENERIC MAP ( BubblesMask => X"00000000" )
      PORT MAP ( input1  => s_logisimBus28(0),
                 input10 => s_logisimBus28(9),
                 input11 => s_logisimBus28(10),
                 input12 => s_logisimBus28(11),
                 input13 => s_logisimBus28(12),
                 input14 => s_logisimBus28(13),
                 input15 => s_logisimBus28(14),
                 input16 => s_logisimBus28(15),
                 input17 => s_logisimBus28(16),
                 input18 => s_logisimBus28(17),
                 input19 => s_logisimBus28(18),
                 input2  => s_logisimBus28(1),
                 input20 => s_logisimBus28(19),
                 input21 => s_logisimBus28(20),
                 input22 => s_logisimBus28(21),
                 input23 => s_logisimBus28(22),
                 input24 => s_logisimBus28(23),
                 input25 => s_logisimBus28(24),
                 input26 => s_logisimBus28(25),
                 input27 => s_logisimBus28(26),
                 input28 => s_logisimBus28(27),
                 input29 => s_logisimBus28(28),
                 input3  => s_logisimBus28(2),
                 input30 => s_logisimBus28(29),
                 input31 => s_logisimBus28(30),
                 input32 => s_logisimBus28(31),
                 input4  => s_logisimBus28(3),
                 input5  => s_logisimBus28(4),
                 input6  => s_logisimBus28(5),
                 input7  => s_logisimBus28(6),
                 input8  => s_logisimBus28(7),
                 input9  => s_logisimBus28(8),
                 result  => s_logisimNet33 );

   B_eff : XOR_GATE_ONEHOT
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet21,
                 input2 => s_logisimBus12(31),
                 result => s_logisimNet10 );

   A_eff : XOR_GATE_ONEHOT
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet25,
                 input2 => s_logisimBus16(31),
                 result => s_logisimNet9 );

   GATES_6 : XNOR_GATE_ONEHOT
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet9,
                 input2 => s_logisimNet10,
                 result => s_logisimNet30 );

   PLEXERS_7 : Multiplexer_bus_4
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus24(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus11(31 DOWNTO 0),
                 muxIn_2 => s_logisimBus0(31 DOWNTO 0),
                 muxIn_3 => s_logisimBus42(31 DOWNTO 0),
                 muxOut  => s_logisimBus28(31 DOWNTO 0),
                 sel     => s_logisimBus35(1 DOWNTO 0) );


   --------------------------------------------------------------------------------
   -- Here all sub-circuits are defined                                          --
   --------------------------------------------------------------------------------

   mul_32_1 : mul_32
      PORT MAP ( A                 => s_logisimBus16(31 DOWNTO 0),
                 B                 => s_logisimBus12(31 DOWNTO 0),
                 carry             => s_logisimBus58(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus57(31 DOWNTO 0) );

   ALU_logic_engine_1 : ALU_logic_engine
      PORT MAP ( A                 => s_logisimBus16(31 DOWNTO 0),
                 B                 => s_logisimBus12(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus24(31 DOWNTO 0),
                 select_bit        => s_logisimBus26(2 DOWNTO 0) );

   ALU_airthmetic_engine_1 : ALU_airthmetic_engine
      PORT MAP ( A                 => s_logisimBus16(31 DOWNTO 0),
                 B                 => s_logisimBus12(31 DOWNTO 0),
                 Cflag             => s_logisimNet50,
                 Cin_sel           => s_logisimBus51(1 DOWNTO 0),
                 Cout              => s_logisimNet56,
                 Result            => s_logisimBus11(31 DOWNTO 0),
                 a_inversion       => s_logisimNet25,
                 b_inversion       => s_logisimNet21,
                 logisimClockTree0 => logisimClockTree0,
                 unused            => s_logisimNet27 );

   ks_32b_1 : ks_32b
      PORT MAP ( A                 => s_logisimBus57(31 DOWNTO 0),
                 B                 => s_logisimBus58(31 DOWNTO 0),
                 Cin               => '0',
                 Cout              => OPEN,
                 SUM10             => s_logisimBus0(10),
                 SUM11             => s_logisimBus0(11),
                 SUM12             => s_logisimBus0(12),
                 SUM13             => s_logisimBus0(13),
                 SUM14             => s_logisimBus0(14),
                 SUM15             => s_logisimBus0(15),
                 SUM16             => s_logisimBus0(16),
                 SUM17             => s_logisimBus0(17),
                 SUM18             => s_logisimBus0(18),
                 SUM19             => s_logisimBus0(19),
                 SUM2              => s_logisimBus0(2),
                 SUM20             => s_logisimBus0(20),
                 SUM21             => s_logisimBus0(21),
                 SUM22             => s_logisimBus0(22),
                 SUM23             => s_logisimBus0(23),
                 SUM24             => s_logisimBus0(24),
                 SUM25             => s_logisimBus0(25),
                 SUM26             => s_logisimBus0(26),
                 SUM27             => s_logisimBus0(27),
                 SUM28             => s_logisimBus0(28),
                 SUM29             => s_logisimBus0(29),
                 SUM3              => s_logisimBus0(3),
                 SUM30             => s_logisimBus0(30),
                 SUM31             => s_logisimBus0(31),
                 SUM4              => s_logisimBus0(4),
                 SUM5              => s_logisimBus0(5),
                 SUM6              => s_logisimBus0(6),
                 SUM7              => s_logisimBus0(7),
                 SUM8              => s_logisimBus0(8),
                 SUM9              => s_logisimBus0(9),
                 logisimClockTree0 => logisimClockTree0,
                 sum0              => s_logisimBus0(0),
                 sum1              => s_logisimBus0(1) );

END platformIndependent;
