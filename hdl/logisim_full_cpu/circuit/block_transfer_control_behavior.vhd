--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : block_transfer_control                                       ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF block_transfer_control IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT AND_GATE
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT OR_GATE
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT AND_GATE_3_INPUTS
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                input3 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT REGISTER_FLIP_FLOP
         GENERIC ( invertClock : INTEGER;
                   nrOfBits    : INTEGER );
         PORT ( clock       : IN  std_logic;
                clockEnable : IN  std_logic;
                d           : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                reset       : IN  std_logic;
                tick        : IN  std_logic;
                q           : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT Multiplexer_bus_2
         GENERIC ( nrOfBits : INTEGER );
         PORT ( enable  : IN  std_logic;
                muxIn_0 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_1 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                sel     : IN  std_logic;
                muxOut  : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT Multiplexer_16
         PORT ( enable   : IN  std_logic;
                muxIn_0  : IN  std_logic;
                muxIn_1  : IN  std_logic;
                muxIn_10 : IN  std_logic;
                muxIn_11 : IN  std_logic;
                muxIn_12 : IN  std_logic;
                muxIn_13 : IN  std_logic;
                muxIn_14 : IN  std_logic;
                muxIn_15 : IN  std_logic;
                muxIn_2  : IN  std_logic;
                muxIn_3  : IN  std_logic;
                muxIn_4  : IN  std_logic;
                muxIn_5  : IN  std_logic;
                muxIn_6  : IN  std_logic;
                muxIn_7  : IN  std_logic;
                muxIn_8  : IN  std_logic;
                muxIn_9  : IN  std_logic;
                sel      : IN  std_logic_vector( 3 DOWNTO 0 );
                muxOut   : OUT std_logic );
      END COMPONENT;

      COMPONENT Comparator
         GENERIC ( nrOfBits       : INTEGER;
                   twosComplement : INTEGER );
         PORT ( dataA         : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                dataB         : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                aEqualsB      : OUT std_logic;
                aGreaterThanB : OUT std_logic;
                aLessThanB    : OUT std_logic );
      END COMPONENT;

      COMPONENT Adder
         GENERIC ( extendedBits : INTEGER;
                   nrOfBits     : INTEGER );
         PORT ( carryIn  : IN  std_logic;
                dataA    : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                dataB    : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                carryOut : OUT std_logic;
                result   : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus0  : std_logic_vector( 15 DOWNTO 0 );
   SIGNAL s_logisimBus17 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus18 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus21 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus24 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus3  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus30 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus34 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus36 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus40 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus45 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus49 : std_logic_vector( 15 DOWNTO 0 );
   SIGNAL s_logisimBus51 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus52 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus67 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus68 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus69 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus7  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus70 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus71 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus72 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus73 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus74 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimNet1  : std_logic;
   SIGNAL s_logisimNet10 : std_logic;
   SIGNAL s_logisimNet11 : std_logic;
   SIGNAL s_logisimNet12 : std_logic;
   SIGNAL s_logisimNet13 : std_logic;
   SIGNAL s_logisimNet14 : std_logic;
   SIGNAL s_logisimNet15 : std_logic;
   SIGNAL s_logisimNet16 : std_logic;
   SIGNAL s_logisimNet19 : std_logic;
   SIGNAL s_logisimNet20 : std_logic;
   SIGNAL s_logisimNet22 : std_logic;
   SIGNAL s_logisimNet23 : std_logic;
   SIGNAL s_logisimNet25 : std_logic;
   SIGNAL s_logisimNet26 : std_logic;
   SIGNAL s_logisimNet27 : std_logic;
   SIGNAL s_logisimNet28 : std_logic;
   SIGNAL s_logisimNet29 : std_logic;
   SIGNAL s_logisimNet31 : std_logic;
   SIGNAL s_logisimNet32 : std_logic;
   SIGNAL s_logisimNet33 : std_logic;
   SIGNAL s_logisimNet35 : std_logic;
   SIGNAL s_logisimNet37 : std_logic;
   SIGNAL s_logisimNet38 : std_logic;
   SIGNAL s_logisimNet39 : std_logic;
   SIGNAL s_logisimNet4  : std_logic;
   SIGNAL s_logisimNet41 : std_logic;
   SIGNAL s_logisimNet42 : std_logic;
   SIGNAL s_logisimNet43 : std_logic;
   SIGNAL s_logisimNet44 : std_logic;
   SIGNAL s_logisimNet46 : std_logic;
   SIGNAL s_logisimNet47 : std_logic;
   SIGNAL s_logisimNet48 : std_logic;
   SIGNAL s_logisimNet5  : std_logic;
   SIGNAL s_logisimNet50 : std_logic;
   SIGNAL s_logisimNet53 : std_logic;
   SIGNAL s_logisimNet54 : std_logic;
   SIGNAL s_logisimNet55 : std_logic;
   SIGNAL s_logisimNet56 : std_logic;
   SIGNAL s_logisimNet57 : std_logic;
   SIGNAL s_logisimNet58 : std_logic;
   SIGNAL s_logisimNet59 : std_logic;
   SIGNAL s_logisimNet6  : std_logic;
   SIGNAL s_logisimNet60 : std_logic;
   SIGNAL s_logisimNet61 : std_logic;
   SIGNAL s_logisimNet62 : std_logic;
   SIGNAL s_logisimNet63 : std_logic;
   SIGNAL s_logisimNet64 : std_logic;
   SIGNAL s_logisimNet65 : std_logic;
   SIGNAL s_logisimNet66 : std_logic;
   SIGNAL s_logisimNet8  : std_logic;
   SIGNAL s_logisimNet9  : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- All clock generator connections are defined here                           --
   --------------------------------------------------------------------------------
   s_logisimNet50 <= logisimClockTree0(0);

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus40(31 DOWNTO 0) <= base_in;
   s_logisimBus49(15 DOWNTO 0) <= reg_list_in;
   s_logisimNet22              <= rst;
   s_logisimNet25              <= start;
   s_logisimNet5               <= is_pop;
   s_logisimNet63              <= clk;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   active           <= s_logisimNet23;
   addr             <= s_logisimBus17(31 DOWNTO 0);
   done             <= s_logisimNet28;
   hold_pc          <= s_logisimNet61;
   pop_request      <= s_logisimNet10;
   reg_idx          <= s_logisimBus2(3 DOWNTO 0);
   reg_selected     <= s_logisimNet35;
   transfer_address <= s_logisimBus45(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Constant
    s_logisimNet64  <=  '1';


   -- Constant
    s_logisimNet65  <=  '1';


   -- Constant
    s_logisimNet66  <=  '1';


   -- Constant
    s_logisimBus71(31 DOWNTO 0)  <=  X"00000004";


   -- Constant
    s_logisimBus72(31 DOWNTO 0)  <=  X"FFFFFFFC";


   -- Constant
    s_logisimBus73(3 DOWNTO 0)  <=  X"1";


   -- Constant
    s_logisimBus74(3 DOWNTO 0)  <=  X"F";


   -- Constant
    s_logisimBus67(3 DOWNTO 0)  <=  X"F";


   -- Constant
    s_logisimBus68(3 DOWNTO 0)  <=  X"0";


   -- Constant
    s_logisimBus69(3 DOWNTO 0)  <=  X"F";


   -- Constant
    s_logisimBus70(3 DOWNTO 0)  <=  X"0";


   -- NOT Gate
   s_logisimNet41 <=  NOT s_logisimNet5;

   -- NOT Gate
   s_logisimNet31 <=  NOT s_logisimNet44;

   -- NOT Gate
   s_logisimNet37 <=  NOT s_logisimNet11;

   -- NOT Gate
   s_logisimNet58 <=  NOT s_logisimNet6;

   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   GATES_1 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet23,
                 input2 => s_logisimNet58,
                 result => s_logisimNet9 );

   GATES_2 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet23,
                 input2 => s_logisimNet28,
                 result => s_logisimNet44 );

   GATES_3 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet23,
                 input2 => s_logisimNet14,
                 result => s_logisimNet35 );

   GATES_4 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet23,
                 input2 => s_logisimNet35,
                 result => s_logisimNet20 );

   GATES_5 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet16,
                 input2 => s_logisimNet5,
                 result => s_logisimNet29 );

   GATES_6 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet55,
                 input2 => s_logisimNet41,
                 result => s_logisimNet38 );

   GATES_7 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet31,
                 input2 => s_logisimNet25,
                 result => s_logisimNet8 );

   GATES_8 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet29,
                 input2 => s_logisimNet38,
                 result => s_logisimNet62 );

   GATES_9 : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimNet23,
                 input2 => s_logisimNet5,
                 input3 => s_logisimNet35,
                 result => s_logisimNet10 );

   GATES_10 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet23,
                 input2 => s_logisimNet62,
                 result => s_logisimNet6 );

   GATES_11 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet23,
                 input2 => s_logisimNet8,
                 result => s_logisimNet61 );

   GATES_12 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet8,
                 input2 => s_logisimNet9,
                 result => s_logisimNet4 );

   GATES_13 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet10,
                 input2 => s_logisimNet37,
                 result => s_logisimNet19 );

   GATES_14 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet10,
                 input2 => s_logisimNet11,
                 result => s_logisimNet48 );

   GATES_15 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet50,
                 input2 => s_logisimNet63,
                 result => s_logisimNet15 );

   GATES_16 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet8,
                 input2 => s_logisimNet20,
                 result => s_logisimNet39 );

   GATES_17 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet23,
                 input2 => s_logisimNet6,
                 result => s_logisimNet1 );

   POP_PENDING : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 1 )
      PORT MAP ( clock       => s_logisimNet15,
                 clockEnable => s_logisimNet10,
                 d(0)        => s_logisimNet19,
                 q(0)        => s_logisimNet11,
                 reset       => s_logisimNet22,
                 tick        => '1' );

   ADDRESS : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => s_logisimNet15,
                 clockEnable => s_logisimNet39,
                 d           => s_logisimBus30(31 DOWNTO 0),
                 q           => s_logisimBus17(31 DOWNTO 0),
                 reset       => s_logisimNet22,
                 tick        => '1' );

   MEMORY_20 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 16 )
      PORT MAP ( clock       => s_logisimNet15,
                 clockEnable => s_logisimNet8,
                 d           => s_logisimBus49(15 DOWNTO 0),
                 q           => s_logisimBus0(15 DOWNTO 0),
                 reset       => s_logisimNet22,
                 tick        => '1' );

   REG_INDEX : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 4 )
      PORT MAP ( clock       => s_logisimNet15,
                 clockEnable => s_logisimNet64,
                 d           => s_logisimBus21(3 DOWNTO 0),
                 q           => s_logisimBus2(3 DOWNTO 0),
                 reset       => s_logisimNet22,
                 tick        => '1' );

   ACTIVE_REG : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 1 )
      PORT MAP ( clock       => s_logisimNet15,
                 clockEnable => s_logisimNet65,
                 d(0)        => s_logisimNet4,
                 q(0)        => s_logisimNet23,
                 reset       => s_logisimNet22,
                 tick        => '1' );

   DONE_REG : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 1 )
      PORT MAP ( clock       => s_logisimNet15,
                 clockEnable => s_logisimNet66,
                 d(0)        => s_logisimNet1,
                 q(0)        => s_logisimNet28,
                 reset       => s_logisimNet22,
                 tick        => '1' );

   PLEXERS_24 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 4 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus67(3 DOWNTO 0),
                 muxIn_1 => s_logisimBus68(3 DOWNTO 0),
                 muxOut  => s_logisimBus3(3 DOWNTO 0),
                 sel     => s_logisimNet5 );

   PLEXERS_25 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus7(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus52(31 DOWNTO 0),
                 muxOut  => s_logisimBus18(31 DOWNTO 0),
                 sel     => s_logisimNet5 );

   PLEXERS_26 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 4 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus51(3 DOWNTO 0),
                 muxIn_1 => s_logisimBus34(3 DOWNTO 0),
                 muxOut  => s_logisimBus36(3 DOWNTO 0),
                 sel     => s_logisimNet5 );

   PLEXERS_27 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 4 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus2(3 DOWNTO 0),
                 muxIn_1 => s_logisimBus36(3 DOWNTO 0),
                 muxOut  => s_logisimBus24(3 DOWNTO 0),
                 sel     => s_logisimNet9 );

   PLEXERS_28 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 4 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus24(3 DOWNTO 0),
                 muxIn_1 => s_logisimBus3(3 DOWNTO 0),
                 muxOut  => s_logisimBus21(3 DOWNTO 0),
                 sel     => s_logisimNet8 );

   PLEXERS_29 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus18(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus40(31 DOWNTO 0),
                 muxOut  => s_logisimBus30(31 DOWNTO 0),
                 sel     => s_logisimNet8 );

   PLEXERS_30 : Multiplexer_16
      PORT MAP ( enable   => '1',
                 muxIn_0  => s_logisimBus0(0),
                 muxIn_1  => s_logisimBus0(1),
                 muxIn_10 => s_logisimBus0(10),
                 muxIn_11 => s_logisimBus0(11),
                 muxIn_12 => s_logisimBus0(12),
                 muxIn_13 => s_logisimBus0(13),
                 muxIn_14 => s_logisimBus0(14),
                 muxIn_15 => s_logisimBus0(15),
                 muxIn_2  => s_logisimBus0(2),
                 muxIn_3  => s_logisimBus0(3),
                 muxIn_4  => s_logisimBus0(4),
                 muxIn_5  => s_logisimBus0(5),
                 muxIn_6  => s_logisimBus0(6),
                 muxIn_7  => s_logisimBus0(7),
                 muxIn_8  => s_logisimBus0(8),
                 muxIn_9  => s_logisimBus0(9),
                 muxOut   => s_logisimNet14,
                 sel      => s_logisimBus2(3 DOWNTO 0) );

   PLEXERS_31 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus7(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus17(31 DOWNTO 0),
                 muxOut  => s_logisimBus45(31 DOWNTO 0),
                 sel     => s_logisimNet5 );

   ARITH_32 : Comparator
      GENERIC MAP ( nrOfBits       => 4,
                    twosComplement => 1 )
      PORT MAP ( aEqualsB      => s_logisimNet16,
                 aGreaterThanB => OPEN,
                 aLessThanB    => OPEN,
                 dataA         => s_logisimBus2(3 DOWNTO 0),
                 dataB         => s_logisimBus69(3 DOWNTO 0) );

   ARITH_33 : Comparator
      GENERIC MAP ( nrOfBits       => 4,
                    twosComplement => 1 )
      PORT MAP ( aEqualsB      => s_logisimNet55,
                 aGreaterThanB => OPEN,
                 aLessThanB    => OPEN,
                 dataA         => s_logisimBus2(3 DOWNTO 0),
                 dataB         => s_logisimBus70(3 DOWNTO 0) );

   ARITH_34 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => '0',
                 carryOut => OPEN,
                 dataA    => s_logisimBus17(31 DOWNTO 0),
                 dataB    => s_logisimBus71(31 DOWNTO 0),
                 result   => s_logisimBus52(31 DOWNTO 0) );

   ARITH_35 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => '0',
                 carryOut => OPEN,
                 dataA    => s_logisimBus17(31 DOWNTO 0),
                 dataB    => s_logisimBus72(31 DOWNTO 0),
                 result   => s_logisimBus7(31 DOWNTO 0) );

   ARITH_36 : Adder
      GENERIC MAP ( extendedBits => 5,
                    nrOfBits     => 4 )
      PORT MAP ( carryIn  => '0',
                 carryOut => OPEN,
                 dataA    => s_logisimBus2(3 DOWNTO 0),
                 dataB    => s_logisimBus73(3 DOWNTO 0),
                 result   => s_logisimBus34(3 DOWNTO 0) );

   ARITH_37 : Adder
      GENERIC MAP ( extendedBits => 5,
                    nrOfBits     => 4 )
      PORT MAP ( carryIn  => '0',
                 carryOut => OPEN,
                 dataA    => s_logisimBus2(3 DOWNTO 0),
                 dataB    => s_logisimBus74(3 DOWNTO 0),
                 result   => s_logisimBus51(3 DOWNTO 0) );


END platformIndependent;
