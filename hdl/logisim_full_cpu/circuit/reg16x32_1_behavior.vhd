--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : reg16x32_1                                                   ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF reg16x32_1 IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT OR_GATE
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

      COMPONENT Decoder_16
         PORT ( enable        : IN  std_logic;
                sel           : IN  std_logic_vector( 3 DOWNTO 0 );
                decoderOut_0  : OUT std_logic;
                decoderOut_1  : OUT std_logic;
                decoderOut_10 : OUT std_logic;
                decoderOut_11 : OUT std_logic;
                decoderOut_12 : OUT std_logic;
                decoderOut_13 : OUT std_logic;
                decoderOut_14 : OUT std_logic;
                decoderOut_15 : OUT std_logic;
                decoderOut_2  : OUT std_logic;
                decoderOut_3  : OUT std_logic;
                decoderOut_4  : OUT std_logic;
                decoderOut_5  : OUT std_logic;
                decoderOut_6  : OUT std_logic;
                decoderOut_7  : OUT std_logic;
                decoderOut_8  : OUT std_logic;
                decoderOut_9  : OUT std_logic );
      END COMPONENT;

      COMPONENT Multiplexer_bus_16
         GENERIC ( nrOfBits : INTEGER );
         PORT ( enable   : IN  std_logic;
                muxIn_0  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_1  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_10 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_11 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_12 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_13 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_14 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_15 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_2  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_3  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_4  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_5  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_6  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_7  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_8  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_9  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                sel      : IN  std_logic_vector( 3 DOWNTO 0 );
                muxOut   : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus0   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus1   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus10  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus101 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus102 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus104 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus105 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus11  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus15  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus17  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus20  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus24  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus25  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus27  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus29  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus31  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus32  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus36  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus41  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus50  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus55  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus57  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus59  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus61  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus62  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus65  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus69  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus79  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus8   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus84  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus86  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus87  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus9   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus92  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus94  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus96  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus97  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus98  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus99  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimNet100 : std_logic;
   SIGNAL s_logisimNet103 : std_logic;
   SIGNAL s_logisimNet106 : std_logic;
   SIGNAL s_logisimNet107 : std_logic;
   SIGNAL s_logisimNet12  : std_logic;
   SIGNAL s_logisimNet13  : std_logic;
   SIGNAL s_logisimNet14  : std_logic;
   SIGNAL s_logisimNet16  : std_logic;
   SIGNAL s_logisimNet18  : std_logic;
   SIGNAL s_logisimNet19  : std_logic;
   SIGNAL s_logisimNet21  : std_logic;
   SIGNAL s_logisimNet22  : std_logic;
   SIGNAL s_logisimNet23  : std_logic;
   SIGNAL s_logisimNet26  : std_logic;
   SIGNAL s_logisimNet28  : std_logic;
   SIGNAL s_logisimNet3   : std_logic;
   SIGNAL s_logisimNet30  : std_logic;
   SIGNAL s_logisimNet33  : std_logic;
   SIGNAL s_logisimNet34  : std_logic;
   SIGNAL s_logisimNet35  : std_logic;
   SIGNAL s_logisimNet37  : std_logic;
   SIGNAL s_logisimNet38  : std_logic;
   SIGNAL s_logisimNet39  : std_logic;
   SIGNAL s_logisimNet4   : std_logic;
   SIGNAL s_logisimNet40  : std_logic;
   SIGNAL s_logisimNet42  : std_logic;
   SIGNAL s_logisimNet43  : std_logic;
   SIGNAL s_logisimNet44  : std_logic;
   SIGNAL s_logisimNet45  : std_logic;
   SIGNAL s_logisimNet46  : std_logic;
   SIGNAL s_logisimNet47  : std_logic;
   SIGNAL s_logisimNet48  : std_logic;
   SIGNAL s_logisimNet49  : std_logic;
   SIGNAL s_logisimNet5   : std_logic;
   SIGNAL s_logisimNet51  : std_logic;
   SIGNAL s_logisimNet52  : std_logic;
   SIGNAL s_logisimNet53  : std_logic;
   SIGNAL s_logisimNet54  : std_logic;
   SIGNAL s_logisimNet56  : std_logic;
   SIGNAL s_logisimNet58  : std_logic;
   SIGNAL s_logisimNet6   : std_logic;
   SIGNAL s_logisimNet60  : std_logic;
   SIGNAL s_logisimNet63  : std_logic;
   SIGNAL s_logisimNet64  : std_logic;
   SIGNAL s_logisimNet66  : std_logic;
   SIGNAL s_logisimNet67  : std_logic;
   SIGNAL s_logisimNet68  : std_logic;
   SIGNAL s_logisimNet7   : std_logic;
   SIGNAL s_logisimNet70  : std_logic;
   SIGNAL s_logisimNet71  : std_logic;
   SIGNAL s_logisimNet72  : std_logic;
   SIGNAL s_logisimNet73  : std_logic;
   SIGNAL s_logisimNet74  : std_logic;
   SIGNAL s_logisimNet75  : std_logic;
   SIGNAL s_logisimNet76  : std_logic;
   SIGNAL s_logisimNet77  : std_logic;
   SIGNAL s_logisimNet78  : std_logic;
   SIGNAL s_logisimNet80  : std_logic;
   SIGNAL s_logisimNet81  : std_logic;
   SIGNAL s_logisimNet82  : std_logic;
   SIGNAL s_logisimNet83  : std_logic;
   SIGNAL s_logisimNet85  : std_logic;
   SIGNAL s_logisimNet88  : std_logic;
   SIGNAL s_logisimNet89  : std_logic;
   SIGNAL s_logisimNet90  : std_logic;
   SIGNAL s_logisimNet91  : std_logic;
   SIGNAL s_logisimNet93  : std_logic;
   SIGNAL s_logisimNet95  : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus1(31 DOWNTO 0)  <= WD;
   s_logisimBus10(31 DOWNTO 0) <= WD2;
   s_logisimBus25(3 DOWNTO 0)  <= WA;
   s_logisimBus41(3 DOWNTO 0)  <= RA;
   s_logisimBus50(3 DOWNTO 0)  <= RB;
   s_logisimBus97(3 DOWNTO 0)  <= WA2;
   s_logisimNet107             <= WE2;
   s_logisimNet16              <= RST;
   s_logisimNet21              <= WE;
   s_logisimNet23              <= CLK;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   R0_OUTPUT  <= s_logisimBus9(31 DOWNTO 0);
   R10_OUTPUT <= s_logisimBus59(31 DOWNTO 0);
   R11_OUTPUT <= s_logisimBus15(31 DOWNTO 0);
   R12_OUTPUT <= s_logisimBus2(31 DOWNTO 0);
   R13_OUTPUT <= s_logisimBus27(31 DOWNTO 0);
   R14_OUTPUT <= s_logisimBus57(31 DOWNTO 0);
   R15_OUTPUT <= s_logisimBus29(31 DOWNTO 0);
   R1_OUTPUT  <= s_logisimBus61(31 DOWNTO 0);
   R2_OUPUT   <= s_logisimBus79(31 DOWNTO 0);
   R3_OUTPUT  <= s_logisimBus8(31 DOWNTO 0);
   R4_OUTPUT  <= s_logisimBus0(31 DOWNTO 0);
   R5_OUTPUT  <= s_logisimBus36(31 DOWNTO 0);
   R6_OUTPUT  <= s_logisimBus32(31 DOWNTO 0);
   R7_OUTPUT  <= s_logisimBus24(31 DOWNTO 0);
   R8_OUTPUT  <= s_logisimBus20(31 DOWNTO 0);
   R9_OUTPUT  <= s_logisimBus55(31 DOWNTO 0);
   RD_A       <= s_logisimBus96(31 DOWNTO 0);
   RD_B       <= s_logisimBus98(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   GATES_1 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet22,
                 input2 => s_logisimNet56,
                 result => s_logisimNet71 );

   GATES_2 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet103,
                 input2 => s_logisimNet34,
                 result => s_logisimNet66 );

   GATES_3 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet49,
                 input2 => s_logisimNet40,
                 result => s_logisimNet91 );

   GATES_4 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet70,
                 input2 => s_logisimNet18,
                 result => s_logisimNet81 );

   GATES_5 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet63,
                 input2 => s_logisimNet42,
                 result => s_logisimNet72 );

   GATES_6 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet45,
                 input2 => s_logisimNet6,
                 result => s_logisimNet54 );

   GATES_7 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet30,
                 input2 => s_logisimNet64,
                 result => s_logisimNet89 );

   GATES_8 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet100,
                 input2 => s_logisimNet19,
                 result => s_logisimNet95 );

   GATES_9 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet106,
                 input2 => s_logisimNet78,
                 result => s_logisimNet75 );

   GATES_10 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet85,
                 input2 => s_logisimNet28,
                 result => s_logisimNet53 );

   GATES_11 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet93,
                 input2 => s_logisimNet44,
                 result => s_logisimNet39 );

   GATES_12 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet51,
                 input2 => s_logisimNet52,
                 result => s_logisimNet73 );

   GATES_13 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet68,
                 input2 => s_logisimNet21,
                 result => s_logisimNet103 );

   GATES_14 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet67,
                 input2 => s_logisimNet21,
                 result => s_logisimNet38 );

   GATES_15 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet48,
                 input2 => s_logisimNet21,
                 result => s_logisimNet5 );

   GATES_16 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet88,
                 input2 => s_logisimNet21,
                 result => s_logisimNet100 );

   GATES_17 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet43,
                 input2 => s_logisimNet21,
                 result => s_logisimNet45 );

   GATES_18 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet26,
                 input2 => s_logisimNet21,
                 result => s_logisimNet35 );

   GATES_19 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet37,
                 input2 => s_logisimNet21,
                 result => s_logisimNet90 );

   GATES_20 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet13,
                 input2 => s_logisimNet21,
                 result => s_logisimNet49 );

   GATES_21 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet83,
                 input2 => s_logisimNet21,
                 result => s_logisimNet70 );

   GATES_22 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet77,
                 input2 => s_logisimNet21,
                 result => s_logisimNet106 );

   GATES_23 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet4,
                 input2 => s_logisimNet21,
                 result => s_logisimNet63 );

   GATES_24 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet12,
                 input2 => s_logisimNet21,
                 result => s_logisimNet85 );

   GATES_25 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet7,
                 input2 => s_logisimNet21,
                 result => s_logisimNet93 );

   GATES_26 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet33,
                 input2 => s_logisimNet21,
                 result => s_logisimNet51 );

   GATES_27 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet14,
                 input2 => s_logisimNet21,
                 result => s_logisimNet22 );

   GATES_28 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet3,
                 input2 => s_logisimNet21,
                 result => s_logisimNet30 );

   GATES_29 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet38,
                 input2 => s_logisimNet46,
                 result => s_logisimNet80 );

   GATES_30 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet5,
                 input2 => s_logisimNet58,
                 result => s_logisimNet74 );

   GATES_31 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet35,
                 input2 => s_logisimNet76,
                 result => s_logisimNet82 );

   GATES_32 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet90,
                 input2 => s_logisimNet47,
                 result => s_logisimNet60 );

   R12 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet95,
                 d           => s_logisimBus104(31 DOWNTO 0),
                 q           => s_logisimBus2(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R4 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet91,
                 d           => s_logisimBus11(31 DOWNTO 0),
                 q           => s_logisimBus0(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R6 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet80,
                 d           => s_logisimBus17(31 DOWNTO 0),
                 q           => s_logisimBus32(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R8 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet75,
                 d           => s_logisimBus62(31 DOWNTO 0),
                 q           => s_logisimBus20(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R0 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet89,
                 d           => s_logisimBus92(31 DOWNTO 0),
                 q           => s_logisimBus9(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R14 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet82,
                 d           => s_logisimBus69(31 DOWNTO 0),
                 q           => s_logisimBus57(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R10 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet39,
                 d           => s_logisimBus94(31 DOWNTO 0),
                 q           => s_logisimBus59(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R2 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet71,
                 d           => s_logisimBus31(31 DOWNTO 0),
                 q           => s_logisimBus79(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R7 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet74,
                 d           => s_logisimBus101(31 DOWNTO 0),
                 q           => s_logisimBus24(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R13 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet54,
                 d           => s_logisimBus84(31 DOWNTO 0),
                 q           => s_logisimBus27(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R15 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet60,
                 d           => s_logisimBus87(31 DOWNTO 0),
                 q           => s_logisimBus29(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R5 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet81,
                 d           => s_logisimBus65(31 DOWNTO 0),
                 q           => s_logisimBus36(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R9 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet53,
                 d           => s_logisimBus99(31 DOWNTO 0),
                 q           => s_logisimBus55(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R11 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet73,
                 d           => s_logisimBus102(31 DOWNTO 0),
                 q           => s_logisimBus15(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R1 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet72,
                 d           => s_logisimBus86(31 DOWNTO 0),
                 q           => s_logisimBus61(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   R3 : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet66,
                 d           => s_logisimBus105(31 DOWNTO 0),
                 q           => s_logisimBus8(31 DOWNTO 0),
                 reset       => s_logisimNet16,
                 tick        => logisimClockTree0(2) );

   PLEXERS_49 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus104(31 DOWNTO 0),
                 sel     => s_logisimNet19 );

   PLEXERS_50 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus69(31 DOWNTO 0),
                 sel     => s_logisimNet76 );

   PLEXERS_51 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus62(31 DOWNTO 0),
                 sel     => s_logisimNet78 );

   PLEXERS_52 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus94(31 DOWNTO 0),
                 sel     => s_logisimNet44 );

   PLEXERS_53 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus92(31 DOWNTO 0),
                 sel     => s_logisimNet64 );

   PLEXERS_54 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus31(31 DOWNTO 0),
                 sel     => s_logisimNet56 );

   PLEXERS_55 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus11(31 DOWNTO 0),
                 sel     => s_logisimNet40 );

   PLEXERS_56 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus17(31 DOWNTO 0),
                 sel     => s_logisimNet46 );

   PLEXERS_57 : Decoder_16
      PORT MAP ( decoderOut_0  => s_logisimNet3,
                 decoderOut_1  => s_logisimNet4,
                 decoderOut_10 => s_logisimNet7,
                 decoderOut_11 => s_logisimNet33,
                 decoderOut_12 => s_logisimNet88,
                 decoderOut_13 => s_logisimNet43,
                 decoderOut_14 => s_logisimNet26,
                 decoderOut_15 => s_logisimNet37,
                 decoderOut_2  => s_logisimNet14,
                 decoderOut_3  => s_logisimNet68,
                 decoderOut_4  => s_logisimNet13,
                 decoderOut_5  => s_logisimNet83,
                 decoderOut_6  => s_logisimNet67,
                 decoderOut_7  => s_logisimNet48,
                 decoderOut_8  => s_logisimNet77,
                 decoderOut_9  => s_logisimNet12,
                 enable        => s_logisimNet21,
                 sel           => s_logisimBus25(3 DOWNTO 0) );

   PLEXERS_58 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus101(31 DOWNTO 0),
                 sel     => s_logisimNet58 );

   PLEXERS_59 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus65(31 DOWNTO 0),
                 sel     => s_logisimNet18 );

   PLEXERS_60 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus99(31 DOWNTO 0),
                 sel     => s_logisimNet28 );

   PLEXERS_61 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus102(31 DOWNTO 0),
                 sel     => s_logisimNet52 );

   PLEXERS_62 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus84(31 DOWNTO 0),
                 sel     => s_logisimNet6 );

   PLEXERS_63 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus87(31 DOWNTO 0),
                 sel     => s_logisimNet47 );

   PLEXERS_64 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus86(31 DOWNTO 0),
                 sel     => s_logisimNet42 );

   PLEXERS_65 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus105(31 DOWNTO 0),
                 sel     => s_logisimNet34 );

   PLEXERS_66 : Multiplexer_bus_16
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable   => '1',
                 muxIn_0  => s_logisimBus9(31 DOWNTO 0),
                 muxIn_1  => s_logisimBus61(31 DOWNTO 0),
                 muxIn_10 => s_logisimBus59(31 DOWNTO 0),
                 muxIn_11 => s_logisimBus15(31 DOWNTO 0),
                 muxIn_12 => s_logisimBus2(31 DOWNTO 0),
                 muxIn_13 => s_logisimBus27(31 DOWNTO 0),
                 muxIn_14 => s_logisimBus57(31 DOWNTO 0),
                 muxIn_15 => s_logisimBus29(31 DOWNTO 0),
                 muxIn_2  => s_logisimBus79(31 DOWNTO 0),
                 muxIn_3  => s_logisimBus8(31 DOWNTO 0),
                 muxIn_4  => s_logisimBus0(31 DOWNTO 0),
                 muxIn_5  => s_logisimBus36(31 DOWNTO 0),
                 muxIn_6  => s_logisimBus32(31 DOWNTO 0),
                 muxIn_7  => s_logisimBus24(31 DOWNTO 0),
                 muxIn_8  => s_logisimBus20(31 DOWNTO 0),
                 muxIn_9  => s_logisimBus55(31 DOWNTO 0),
                 muxOut   => s_logisimBus96(31 DOWNTO 0),
                 sel      => s_logisimBus41(3 DOWNTO 0) );

   PLEXERS_67 : Multiplexer_bus_16
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable   => '1',
                 muxIn_0  => s_logisimBus9(31 DOWNTO 0),
                 muxIn_1  => s_logisimBus61(31 DOWNTO 0),
                 muxIn_10 => s_logisimBus59(31 DOWNTO 0),
                 muxIn_11 => s_logisimBus15(31 DOWNTO 0),
                 muxIn_12 => s_logisimBus2(31 DOWNTO 0),
                 muxIn_13 => s_logisimBus27(31 DOWNTO 0),
                 muxIn_14 => s_logisimBus57(31 DOWNTO 0),
                 muxIn_15 => s_logisimBus29(31 DOWNTO 0),
                 muxIn_2  => s_logisimBus79(31 DOWNTO 0),
                 muxIn_3  => s_logisimBus8(31 DOWNTO 0),
                 muxIn_4  => s_logisimBus0(31 DOWNTO 0),
                 muxIn_5  => s_logisimBus36(31 DOWNTO 0),
                 muxIn_6  => s_logisimBus32(31 DOWNTO 0),
                 muxIn_7  => s_logisimBus24(31 DOWNTO 0),
                 muxIn_8  => s_logisimBus20(31 DOWNTO 0),
                 muxIn_9  => s_logisimBus55(31 DOWNTO 0),
                 muxOut   => s_logisimBus98(31 DOWNTO 0),
                 sel      => s_logisimBus50(3 DOWNTO 0) );

   PLEXERS_68 : Decoder_16
      PORT MAP ( decoderOut_0  => s_logisimNet64,
                 decoderOut_1  => s_logisimNet42,
                 decoderOut_10 => s_logisimNet44,
                 decoderOut_11 => s_logisimNet52,
                 decoderOut_12 => s_logisimNet19,
                 decoderOut_13 => s_logisimNet6,
                 decoderOut_14 => s_logisimNet76,
                 decoderOut_15 => s_logisimNet47,
                 decoderOut_2  => s_logisimNet56,
                 decoderOut_3  => s_logisimNet34,
                 decoderOut_4  => s_logisimNet40,
                 decoderOut_5  => s_logisimNet18,
                 decoderOut_6  => s_logisimNet46,
                 decoderOut_7  => s_logisimNet58,
                 decoderOut_8  => s_logisimNet78,
                 decoderOut_9  => s_logisimNet28,
                 enable        => s_logisimNet107,
                 sel           => s_logisimBus97(3 DOWNTO 0) );


END platformIndependent;
