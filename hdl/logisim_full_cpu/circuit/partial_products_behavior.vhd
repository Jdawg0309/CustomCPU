--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : partial_products                                             ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF partial_products IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT Shifter_32_bit
         GENERIC ( shifterMode : INTEGER );
         PORT ( dataA       : IN  std_logic_vector( 31 DOWNTO 0 );
                shiftAmount : IN  std_logic_vector( 4 DOWNTO 0 );
                result      : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT pp_row_32
         PORT ( Rm                : IN  std_logic_vector( 31 DOWNTO 0 );
                Rs_bit            : IN  std_logic;
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                result            : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus0   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus1   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus10  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus100 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus101 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus102 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus103 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus104 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus105 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus106 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus107 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus108 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus109 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus11  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus110 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus111 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus112 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus113 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus114 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus115 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus116 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus117 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus118 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus119 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus12  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus120 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus121 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus122 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus123 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus124 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus125 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus126 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus127 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus128 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus129 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus13  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus14  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus15  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus16  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus17  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus18  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus19  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus20  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus21  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus22  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus23  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus24  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus25  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus26  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus27  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus28  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus29  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus3   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus30  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus31  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus32  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus33  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus34  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus35  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus36  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus37  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus38  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus39  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus4   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus40  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus41  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus42  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus43  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus44  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus45  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus46  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus47  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus48  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus49  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus5   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus50  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus51  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus52  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus53  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus54  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus55  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus56  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus57  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus58  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus59  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus6   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus60  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus61  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus62  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus63  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus64  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus7   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus8   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus9   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus97  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus98  : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus99  : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimNet65  : std_logic;
   SIGNAL s_logisimNet66  : std_logic;
   SIGNAL s_logisimNet67  : std_logic;
   SIGNAL s_logisimNet68  : std_logic;
   SIGNAL s_logisimNet69  : std_logic;
   SIGNAL s_logisimNet70  : std_logic;
   SIGNAL s_logisimNet71  : std_logic;
   SIGNAL s_logisimNet72  : std_logic;
   SIGNAL s_logisimNet73  : std_logic;
   SIGNAL s_logisimNet74  : std_logic;
   SIGNAL s_logisimNet75  : std_logic;
   SIGNAL s_logisimNet76  : std_logic;
   SIGNAL s_logisimNet77  : std_logic;
   SIGNAL s_logisimNet78  : std_logic;
   SIGNAL s_logisimNet79  : std_logic;
   SIGNAL s_logisimNet80  : std_logic;
   SIGNAL s_logisimNet81  : std_logic;
   SIGNAL s_logisimNet82  : std_logic;
   SIGNAL s_logisimNet83  : std_logic;
   SIGNAL s_logisimNet84  : std_logic;
   SIGNAL s_logisimNet85  : std_logic;
   SIGNAL s_logisimNet86  : std_logic;
   SIGNAL s_logisimNet87  : std_logic;
   SIGNAL s_logisimNet88  : std_logic;
   SIGNAL s_logisimNet89  : std_logic;
   SIGNAL s_logisimNet90  : std_logic;
   SIGNAL s_logisimNet91  : std_logic;
   SIGNAL s_logisimNet92  : std_logic;
   SIGNAL s_logisimNet93  : std_logic;
   SIGNAL s_logisimNet94  : std_logic;
   SIGNAL s_logisimNet95  : std_logic;
   SIGNAL s_logisimNet96  : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus0(31 DOWNTO 0)  <= Rm;
   s_logisimBus97(31 DOWNTO 0) <= Rs;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   p0  <= s_logisimBus49(31 DOWNTO 0);
   p1  <= s_logisimBus50(31 DOWNTO 0);
   p10 <= s_logisimBus41(31 DOWNTO 0);
   p11 <= s_logisimBus42(31 DOWNTO 0);
   p12 <= s_logisimBus34(31 DOWNTO 0);
   p13 <= s_logisimBus35(31 DOWNTO 0);
   p14 <= s_logisimBus36(31 DOWNTO 0);
   p15 <= s_logisimBus37(31 DOWNTO 0);
   p16 <= s_logisimBus38(31 DOWNTO 0);
   p17 <= s_logisimBus39(31 DOWNTO 0);
   p18 <= s_logisimBus40(31 DOWNTO 0);
   p19 <= s_logisimBus53(31 DOWNTO 0);
   p2  <= s_logisimBus48(31 DOWNTO 0);
   p20 <= s_logisimBus54(31 DOWNTO 0);
   p21 <= s_logisimBus55(31 DOWNTO 0);
   p22 <= s_logisimBus52(31 DOWNTO 0);
   p23 <= s_logisimBus56(31 DOWNTO 0);
   p24 <= s_logisimBus57(31 DOWNTO 0);
   p25 <= s_logisimBus58(31 DOWNTO 0);
   p26 <= s_logisimBus59(31 DOWNTO 0);
   p27 <= s_logisimBus60(31 DOWNTO 0);
   p28 <= s_logisimBus61(31 DOWNTO 0);
   p29 <= s_logisimBus62(31 DOWNTO 0);
   p3  <= s_logisimBus51(31 DOWNTO 0);
   p30 <= s_logisimBus63(31 DOWNTO 0);
   p31 <= s_logisimBus64(31 DOWNTO 0);
   p4  <= s_logisimBus46(31 DOWNTO 0);
   p5  <= s_logisimBus47(31 DOWNTO 0);
   p6  <= s_logisimBus45(31 DOWNTO 0);
   p7  <= s_logisimBus33(31 DOWNTO 0);
   p8  <= s_logisimBus44(31 DOWNTO 0);
   p9  <= s_logisimBus43(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Constant
    s_logisimBus129(4 DOWNTO 0)  <=  "0"&X"8";


   -- Constant
    s_logisimBus98(4 DOWNTO 0)  <=  "0"&X"9";


   -- Constant
    s_logisimBus99(4 DOWNTO 0)  <=  "0"&X"A";


   -- Constant
    s_logisimBus100(4 DOWNTO 0)  <=  "0"&X"B";


   -- Constant
    s_logisimBus101(4 DOWNTO 0)  <=  "0"&X"C";


   -- Constant
    s_logisimBus102(4 DOWNTO 0)  <=  "0"&X"D";


   -- Constant
    s_logisimBus103(4 DOWNTO 0)  <=  "0"&X"E";


   -- Constant
    s_logisimBus104(4 DOWNTO 0)  <=  "0"&X"F";


   -- Constant
    s_logisimBus105(4 DOWNTO 0)  <=  "1"&X"0";


   -- Constant
    s_logisimBus106(4 DOWNTO 0)  <=  "1"&X"1";


   -- Constant
    s_logisimBus107(4 DOWNTO 0)  <=  "1"&X"2";


   -- Constant
    s_logisimBus108(4 DOWNTO 0)  <=  "1"&X"3";


   -- Constant
    s_logisimBus109(4 DOWNTO 0)  <=  "1"&X"4";


   -- Constant
    s_logisimBus110(4 DOWNTO 0)  <=  "1"&X"5";


   -- Constant
    s_logisimBus111(4 DOWNTO 0)  <=  "1"&X"6";


   -- Constant
    s_logisimBus112(4 DOWNTO 0)  <=  "1"&X"7";


   -- Constant
    s_logisimBus113(4 DOWNTO 0)  <=  "1"&X"8";


   -- Constant
    s_logisimBus114(4 DOWNTO 0)  <=  "1"&X"9";


   -- Constant
    s_logisimBus115(4 DOWNTO 0)  <=  "1"&X"A";


   -- Constant
    s_logisimBus116(4 DOWNTO 0)  <=  "1"&X"B";


   -- Constant
    s_logisimBus117(4 DOWNTO 0)  <=  "1"&X"C";


   -- Constant
    s_logisimBus118(4 DOWNTO 0)  <=  "1"&X"D";


   -- Constant
    s_logisimBus119(4 DOWNTO 0)  <=  "1"&X"E";


   -- Constant
    s_logisimBus120(4 DOWNTO 0)  <=  "1"&X"F";


   -- Constant
    s_logisimBus121(4 DOWNTO 0)  <=  "0"&X"0";


   -- Constant
    s_logisimBus122(4 DOWNTO 0)  <=  "0"&X"1";


   -- Constant
    s_logisimBus123(4 DOWNTO 0)  <=  "0"&X"2";


   -- Constant
    s_logisimBus124(4 DOWNTO 0)  <=  "0"&X"3";


   -- Constant
    s_logisimBus125(4 DOWNTO 0)  <=  "0"&X"4";


   -- Constant
    s_logisimBus126(4 DOWNTO 0)  <=  "0"&X"5";


   -- Constant
    s_logisimBus127(4 DOWNTO 0)  <=  "0"&X"6";


   -- Constant
    s_logisimBus128(4 DOWNTO 0)  <=  "0"&X"7";


   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   ARITH_1 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus1(31 DOWNTO 0),
                 result      => s_logisimBus43(31 DOWNTO 0),
                 shiftAmount => s_logisimBus98(4 DOWNTO 0) );

   ARITH_2 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus6(31 DOWNTO 0),
                 result      => s_logisimBus41(31 DOWNTO 0),
                 shiftAmount => s_logisimBus99(4 DOWNTO 0) );

   ARITH_3 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus12(31 DOWNTO 0),
                 result      => s_logisimBus42(31 DOWNTO 0),
                 shiftAmount => s_logisimBus100(4 DOWNTO 0) );

   ARITH_4 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus13(31 DOWNTO 0),
                 result      => s_logisimBus34(31 DOWNTO 0),
                 shiftAmount => s_logisimBus101(4 DOWNTO 0) );

   ARITH_5 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus14(31 DOWNTO 0),
                 result      => s_logisimBus35(31 DOWNTO 0),
                 shiftAmount => s_logisimBus102(4 DOWNTO 0) );

   ARITH_6 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus18(31 DOWNTO 0),
                 result      => s_logisimBus36(31 DOWNTO 0),
                 shiftAmount => s_logisimBus103(4 DOWNTO 0) );

   ARITH_7 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus19(31 DOWNTO 0),
                 result      => s_logisimBus37(31 DOWNTO 0),
                 shiftAmount => s_logisimBus104(4 DOWNTO 0) );

   ARITH_8 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus20(31 DOWNTO 0),
                 result      => s_logisimBus38(31 DOWNTO 0),
                 shiftAmount => s_logisimBus105(4 DOWNTO 0) );

   ARITH_9 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus16(31 DOWNTO 0),
                 result      => s_logisimBus39(31 DOWNTO 0),
                 shiftAmount => s_logisimBus106(4 DOWNTO 0) );

   ARITH_10 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus21(31 DOWNTO 0),
                 result      => s_logisimBus40(31 DOWNTO 0),
                 shiftAmount => s_logisimBus107(4 DOWNTO 0) );

   ARITH_11 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus15(31 DOWNTO 0),
                 result      => s_logisimBus53(31 DOWNTO 0),
                 shiftAmount => s_logisimBus108(4 DOWNTO 0) );

   ARITH_12 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus22(31 DOWNTO 0),
                 result      => s_logisimBus54(31 DOWNTO 0),
                 shiftAmount => s_logisimBus109(4 DOWNTO 0) );

   ARITH_13 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus17(31 DOWNTO 0),
                 result      => s_logisimBus55(31 DOWNTO 0),
                 shiftAmount => s_logisimBus110(4 DOWNTO 0) );

   ARITH_14 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus23(31 DOWNTO 0),
                 result      => s_logisimBus52(31 DOWNTO 0),
                 shiftAmount => s_logisimBus111(4 DOWNTO 0) );

   ARITH_15 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus24(31 DOWNTO 0),
                 result      => s_logisimBus56(31 DOWNTO 0),
                 shiftAmount => s_logisimBus112(4 DOWNTO 0) );

   ARITH_16 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus25(31 DOWNTO 0),
                 result      => s_logisimBus57(31 DOWNTO 0),
                 shiftAmount => s_logisimBus113(4 DOWNTO 0) );

   ARITH_17 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus26(31 DOWNTO 0),
                 result      => s_logisimBus58(31 DOWNTO 0),
                 shiftAmount => s_logisimBus114(4 DOWNTO 0) );

   ARITH_18 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus27(31 DOWNTO 0),
                 result      => s_logisimBus59(31 DOWNTO 0),
                 shiftAmount => s_logisimBus115(4 DOWNTO 0) );

   ARITH_19 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus28(31 DOWNTO 0),
                 result      => s_logisimBus60(31 DOWNTO 0),
                 shiftAmount => s_logisimBus116(4 DOWNTO 0) );

   ARITH_20 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus29(31 DOWNTO 0),
                 result      => s_logisimBus61(31 DOWNTO 0),
                 shiftAmount => s_logisimBus117(4 DOWNTO 0) );

   ARITH_21 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus30(31 DOWNTO 0),
                 result      => s_logisimBus62(31 DOWNTO 0),
                 shiftAmount => s_logisimBus118(4 DOWNTO 0) );

   ARITH_22 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus31(31 DOWNTO 0),
                 result      => s_logisimBus63(31 DOWNTO 0),
                 shiftAmount => s_logisimBus119(4 DOWNTO 0) );

   ARITH_23 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus32(31 DOWNTO 0),
                 result      => s_logisimBus64(31 DOWNTO 0),
                 shiftAmount => s_logisimBus120(4 DOWNTO 0) );

   ARITH_24 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus4(31 DOWNTO 0),
                 result      => s_logisimBus49(31 DOWNTO 0),
                 shiftAmount => s_logisimBus121(4 DOWNTO 0) );

   ARITH_25 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus5(31 DOWNTO 0),
                 result      => s_logisimBus50(31 DOWNTO 0),
                 shiftAmount => s_logisimBus122(4 DOWNTO 0) );

   ARITH_26 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus3(31 DOWNTO 0),
                 result      => s_logisimBus48(31 DOWNTO 0),
                 shiftAmount => s_logisimBus123(4 DOWNTO 0) );

   ARITH_27 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus2(31 DOWNTO 0),
                 result      => s_logisimBus51(31 DOWNTO 0),
                 shiftAmount => s_logisimBus124(4 DOWNTO 0) );

   ARITH_28 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus10(31 DOWNTO 0),
                 result      => s_logisimBus46(31 DOWNTO 0),
                 shiftAmount => s_logisimBus125(4 DOWNTO 0) );

   ARITH_29 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus11(31 DOWNTO 0),
                 result      => s_logisimBus47(31 DOWNTO 0),
                 shiftAmount => s_logisimBus126(4 DOWNTO 0) );

   ARITH_30 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus8(31 DOWNTO 0),
                 result      => s_logisimBus45(31 DOWNTO 0),
                 shiftAmount => s_logisimBus127(4 DOWNTO 0) );

   ARITH_31 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus9(31 DOWNTO 0),
                 result      => s_logisimBus33(31 DOWNTO 0),
                 shiftAmount => s_logisimBus128(4 DOWNTO 0) );

   ARITH_32 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus7(31 DOWNTO 0),
                 result      => s_logisimBus44(31 DOWNTO 0),
                 shiftAmount => s_logisimBus129(4 DOWNTO 0) );


   --------------------------------------------------------------------------------
   -- Here all sub-circuits are defined                                          --
   --------------------------------------------------------------------------------

   pp_row_32_10 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(9),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus1(31 DOWNTO 0) );

   pp_row_32_11 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(10),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus6(31 DOWNTO 0) );

   pp_row_32_12 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(11),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus12(31 DOWNTO 0) );

   pp_row_32_13 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(12),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus13(31 DOWNTO 0) );

   pp_row_32_14 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(13),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus14(31 DOWNTO 0) );

   pp_row_32_15 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(14),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus18(31 DOWNTO 0) );

   pp_row_32_16 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(15),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus19(31 DOWNTO 0) );

   pp_row_32_17 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(16),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus20(31 DOWNTO 0) );

   pp_row_32_18 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(17),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus16(31 DOWNTO 0) );

   pp_row_32_19 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(18),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus21(31 DOWNTO 0) );

   pp_row_32_20 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(19),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus15(31 DOWNTO 0) );

   pp_row_32_21 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(20),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus22(31 DOWNTO 0) );

   pp_row_32_22 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(21),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus17(31 DOWNTO 0) );

   pp_row_32_23 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(22),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus23(31 DOWNTO 0) );

   pp_row_32_24 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(23),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus24(31 DOWNTO 0) );

   pp_row_32_25 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(24),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus25(31 DOWNTO 0) );

   pp_row_32_26 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(25),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus26(31 DOWNTO 0) );

   pp_row_32_27 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(26),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus27(31 DOWNTO 0) );

   pp_row_32_28 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(27),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus28(31 DOWNTO 0) );

   pp_row_32_29 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(28),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus29(31 DOWNTO 0) );

   pp_row_32_30 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(29),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus30(31 DOWNTO 0) );

   pp_row_32_31 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(30),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus31(31 DOWNTO 0) );

   pp_row_32_32 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(31),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus32(31 DOWNTO 0) );

   pp_row_32_1 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(0),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus4(31 DOWNTO 0) );

   pp_row_32_2 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(1),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus5(31 DOWNTO 0) );

   pp_row_32_3 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(2),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus3(31 DOWNTO 0) );

   pp_row_32_4 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(3),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus2(31 DOWNTO 0) );

   pp_row_32_5 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(4),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus10(31 DOWNTO 0) );

   pp_row_32_6 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(5),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus11(31 DOWNTO 0) );

   pp_row_32_7 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(6),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus8(31 DOWNTO 0) );

   pp_row_32_8 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(7),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus9(31 DOWNTO 0) );

   pp_row_32_9 : pp_row_32
      PORT MAP ( Rm                => s_logisimBus0(31 DOWNTO 0),
                 Rs_bit            => s_logisimBus97(8),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus7(31 DOWNTO 0) );

END platformIndependent;
