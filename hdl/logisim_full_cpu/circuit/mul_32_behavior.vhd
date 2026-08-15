--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : mul_32                                                       ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF mul_32 IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT csa_3to_2
         PORT ( X                 : IN  std_logic_vector( 31 DOWNTO 0 );
                Y                 : IN  std_logic_vector( 31 DOWNTO 0 );
                Z                 : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                carry             : OUT std_logic_vector( 31 DOWNTO 0 );
                sum               : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT partial_products
         PORT ( Rm                : IN  std_logic_vector( 31 DOWNTO 0 );
                Rs                : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                p0                : OUT std_logic_vector( 31 DOWNTO 0 );
                p1                : OUT std_logic_vector( 31 DOWNTO 0 );
                p10               : OUT std_logic_vector( 31 DOWNTO 0 );
                p11               : OUT std_logic_vector( 31 DOWNTO 0 );
                p12               : OUT std_logic_vector( 31 DOWNTO 0 );
                p13               : OUT std_logic_vector( 31 DOWNTO 0 );
                p14               : OUT std_logic_vector( 31 DOWNTO 0 );
                p15               : OUT std_logic_vector( 31 DOWNTO 0 );
                p16               : OUT std_logic_vector( 31 DOWNTO 0 );
                p17               : OUT std_logic_vector( 31 DOWNTO 0 );
                p18               : OUT std_logic_vector( 31 DOWNTO 0 );
                p19               : OUT std_logic_vector( 31 DOWNTO 0 );
                p2                : OUT std_logic_vector( 31 DOWNTO 0 );
                p20               : OUT std_logic_vector( 31 DOWNTO 0 );
                p21               : OUT std_logic_vector( 31 DOWNTO 0 );
                p22               : OUT std_logic_vector( 31 DOWNTO 0 );
                p23               : OUT std_logic_vector( 31 DOWNTO 0 );
                p24               : OUT std_logic_vector( 31 DOWNTO 0 );
                p25               : OUT std_logic_vector( 31 DOWNTO 0 );
                p26               : OUT std_logic_vector( 31 DOWNTO 0 );
                p27               : OUT std_logic_vector( 31 DOWNTO 0 );
                p28               : OUT std_logic_vector( 31 DOWNTO 0 );
                p29               : OUT std_logic_vector( 31 DOWNTO 0 );
                p3                : OUT std_logic_vector( 31 DOWNTO 0 );
                p30               : OUT std_logic_vector( 31 DOWNTO 0 );
                p31               : OUT std_logic_vector( 31 DOWNTO 0 );
                p4                : OUT std_logic_vector( 31 DOWNTO 0 );
                p5                : OUT std_logic_vector( 31 DOWNTO 0 );
                p6                : OUT std_logic_vector( 31 DOWNTO 0 );
                p7                : OUT std_logic_vector( 31 DOWNTO 0 );
                p8                : OUT std_logic_vector( 31 DOWNTO 0 );
                p9                : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus0  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus1  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus10 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus11 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus12 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus13 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus14 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus15 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus16 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus17 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus18 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus19 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus20 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus21 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus22 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus23 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus24 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus25 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus26 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus27 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus28 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus29 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus3  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus30 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus31 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus32 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus33 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus34 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus35 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus36 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus37 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus38 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus39 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus4  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus40 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus41 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus42 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus43 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus44 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus45 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus46 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus47 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus48 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus49 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus5  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus50 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus51 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus52 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus53 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus54 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus55 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus56 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus57 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus58 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus59 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus6  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus60 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus61 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus62 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus63 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus64 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus65 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus66 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus67 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus68 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus69 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus7  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus70 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus71 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus72 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus73 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus74 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus75 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus76 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus77 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus78 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus79 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus8  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus80 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus81 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus82 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus83 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus84 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus85 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus86 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus87 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus88 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus89 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus9  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus90 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus91 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus92 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus93 : std_logic_vector( 31 DOWNTO 0 );

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus74(31 DOWNTO 0) <= A;
   s_logisimBus75(31 DOWNTO 0) <= B;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   carry <= s_logisimBus91(31 DOWNTO 0);
   sum   <= s_logisimBus90(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all sub-circuits are defined                                          --
   --------------------------------------------------------------------------------

   dos : csa_3to_2
      PORT MAP ( X                 => s_logisimBus92(31 DOWNTO 0),
                 Y                 => s_logisimBus93(31 DOWNTO 0),
                 Z                 => s_logisimBus8(31 DOWNTO 0),
                 carry             => s_logisimBus34(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus33(31 DOWNTO 0) );

   tres : csa_3to_2
      PORT MAP ( X                 => s_logisimBus33(31 DOWNTO 0),
                 Y                 => s_logisimBus34(31 DOWNTO 0),
                 Z                 => s_logisimBus5(31 DOWNTO 0),
                 carry             => s_logisimBus36(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus35(31 DOWNTO 0) );

   csa_3to_2_1 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus35(31 DOWNTO 0),
                 Y                 => s_logisimBus36(31 DOWNTO 0),
                 Z                 => s_logisimBus14(31 DOWNTO 0),
                 carry             => s_logisimBus38(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus37(31 DOWNTO 0) );

   cinco : csa_3to_2
      PORT MAP ( X                 => s_logisimBus37(31 DOWNTO 0),
                 Y                 => s_logisimBus38(31 DOWNTO 0),
                 Z                 => s_logisimBus3(31 DOWNTO 0),
                 carry             => s_logisimBus40(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus39(31 DOWNTO 0) );

   csa_3to_2_2 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus39(31 DOWNTO 0),
                 Y                 => s_logisimBus40(31 DOWNTO 0),
                 Z                 => s_logisimBus24(31 DOWNTO 0),
                 carry             => s_logisimBus42(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus41(31 DOWNTO 0) );

   siete : csa_3to_2
      PORT MAP ( X                 => s_logisimBus41(31 DOWNTO 0),
                 Y                 => s_logisimBus42(31 DOWNTO 0),
                 Z                 => s_logisimBus2(31 DOWNTO 0),
                 carry             => s_logisimBus44(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus43(31 DOWNTO 0) );

   csa_3to_2_3 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus43(31 DOWNTO 0),
                 Y                 => s_logisimBus44(31 DOWNTO 0),
                 Z                 => s_logisimBus20(31 DOWNTO 0),
                 carry             => s_logisimBus46(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus45(31 DOWNTO 0) );

   csa_3to_2_4 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus45(31 DOWNTO 0),
                 Y                 => s_logisimBus46(31 DOWNTO 0),
                 Z                 => s_logisimBus27(31 DOWNTO 0),
                 carry             => s_logisimBus48(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus47(31 DOWNTO 0) );

   diez : csa_3to_2
      PORT MAP ( X                 => s_logisimBus47(31 DOWNTO 0),
                 Y                 => s_logisimBus48(31 DOWNTO 0),
                 Z                 => s_logisimBus30(31 DOWNTO 0),
                 carry             => s_logisimBus50(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus49(31 DOWNTO 0) );

   csa_3to_2_5 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus49(31 DOWNTO 0),
                 Y                 => s_logisimBus50(31 DOWNTO 0),
                 Z                 => s_logisimBus9(31 DOWNTO 0),
                 carry             => s_logisimBus52(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus51(31 DOWNTO 0) );

   csa_3to_2_6 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus51(31 DOWNTO 0),
                 Y                 => s_logisimBus52(31 DOWNTO 0),
                 Z                 => s_logisimBus17(31 DOWNTO 0),
                 carry             => s_logisimBus54(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus53(31 DOWNTO 0) );

   trece : csa_3to_2
      PORT MAP ( X                 => s_logisimBus53(31 DOWNTO 0),
                 Y                 => s_logisimBus54(31 DOWNTO 0),
                 Z                 => s_logisimBus1(31 DOWNTO 0),
                 carry             => s_logisimBus56(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus55(31 DOWNTO 0) );

   csa_3to_2_7 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus55(31 DOWNTO 0),
                 Y                 => s_logisimBus56(31 DOWNTO 0),
                 Z                 => s_logisimBus0(31 DOWNTO 0),
                 carry             => s_logisimBus58(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus57(31 DOWNTO 0) );

   quince : csa_3to_2
      PORT MAP ( X                 => s_logisimBus57(31 DOWNTO 0),
                 Y                 => s_logisimBus58(31 DOWNTO 0),
                 Z                 => s_logisimBus13(31 DOWNTO 0),
                 carry             => s_logisimBus59(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus31(31 DOWNTO 0) );

   csa_3to_2_8 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus31(31 DOWNTO 0),
                 Y                 => s_logisimBus59(31 DOWNTO 0),
                 Z                 => s_logisimBus28(31 DOWNTO 0),
                 carry             => s_logisimBus61(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus60(31 DOWNTO 0) );

   diecsiete : csa_3to_2
      PORT MAP ( X                 => s_logisimBus60(31 DOWNTO 0),
                 Y                 => s_logisimBus61(31 DOWNTO 0),
                 Z                 => s_logisimBus25(31 DOWNTO 0),
                 carry             => s_logisimBus63(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus62(31 DOWNTO 0) );

   csa_3to_2_9 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus62(31 DOWNTO 0),
                 Y                 => s_logisimBus63(31 DOWNTO 0),
                 Z                 => s_logisimBus7(31 DOWNTO 0),
                 carry             => s_logisimBus65(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus64(31 DOWNTO 0) );

   csa_3to_2_10 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus64(31 DOWNTO 0),
                 Y                 => s_logisimBus65(31 DOWNTO 0),
                 Z                 => s_logisimBus19(31 DOWNTO 0),
                 carry             => s_logisimBus67(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus66(31 DOWNTO 0) );

   viente : csa_3to_2
      PORT MAP ( X                 => s_logisimBus66(31 DOWNTO 0),
                 Y                 => s_logisimBus67(31 DOWNTO 0),
                 Z                 => s_logisimBus32(31 DOWNTO 0),
                 carry             => s_logisimBus69(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus68(31 DOWNTO 0) );

   csa_3to_2_11 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus68(31 DOWNTO 0),
                 Y                 => s_logisimBus69(31 DOWNTO 0),
                 Z                 => s_logisimBus6(31 DOWNTO 0),
                 carry             => s_logisimBus71(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus70(31 DOWNTO 0) );

   csa_3to_2_12 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus70(31 DOWNTO 0),
                 Y                 => s_logisimBus71(31 DOWNTO 0),
                 Z                 => s_logisimBus12(31 DOWNTO 0),
                 carry             => s_logisimBus73(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus72(31 DOWNTO 0) );

   csa_3to_2_13 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus72(31 DOWNTO 0),
                 Y                 => s_logisimBus73(31 DOWNTO 0),
                 Z                 => s_logisimBus16(31 DOWNTO 0),
                 carry             => s_logisimBus77(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus76(31 DOWNTO 0) );

   partial_products_1 : partial_products
      PORT MAP ( Rm                => s_logisimBus74(31 DOWNTO 0),
                 Rs                => s_logisimBus75(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 p0                => s_logisimBus21(31 DOWNTO 0),
                 p1                => s_logisimBus22(31 DOWNTO 0),
                 p10               => s_logisimBus27(31 DOWNTO 0),
                 p11               => s_logisimBus30(31 DOWNTO 0),
                 p12               => s_logisimBus9(31 DOWNTO 0),
                 p13               => s_logisimBus17(31 DOWNTO 0),
                 p14               => s_logisimBus1(31 DOWNTO 0),
                 p15               => s_logisimBus0(31 DOWNTO 0),
                 p16               => s_logisimBus13(31 DOWNTO 0),
                 p17               => s_logisimBus28(31 DOWNTO 0),
                 p18               => s_logisimBus25(31 DOWNTO 0),
                 p19               => s_logisimBus7(31 DOWNTO 0),
                 p2                => s_logisimBus23(31 DOWNTO 0),
                 p20               => s_logisimBus19(31 DOWNTO 0),
                 p21               => s_logisimBus32(31 DOWNTO 0),
                 p22               => s_logisimBus6(31 DOWNTO 0),
                 p23               => s_logisimBus12(31 DOWNTO 0),
                 p24               => s_logisimBus16(31 DOWNTO 0),
                 p25               => s_logisimBus29(31 DOWNTO 0),
                 p26               => s_logisimBus11(31 DOWNTO 0),
                 p27               => s_logisimBus18(31 DOWNTO 0),
                 p28               => s_logisimBus15(31 DOWNTO 0),
                 p29               => s_logisimBus4(31 DOWNTO 0),
                 p3                => s_logisimBus8(31 DOWNTO 0),
                 p30               => s_logisimBus10(31 DOWNTO 0),
                 p31               => s_logisimBus26(31 DOWNTO 0),
                 p4                => s_logisimBus5(31 DOWNTO 0),
                 p5                => s_logisimBus14(31 DOWNTO 0),
                 p6                => s_logisimBus3(31 DOWNTO 0),
                 p7                => s_logisimBus24(31 DOWNTO 0),
                 p8                => s_logisimBus2(31 DOWNTO 0),
                 p9                => s_logisimBus20(31 DOWNTO 0) );

   vente4 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus76(31 DOWNTO 0),
                 Y                 => s_logisimBus77(31 DOWNTO 0),
                 Z                 => s_logisimBus29(31 DOWNTO 0),
                 carry             => s_logisimBus79(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus78(31 DOWNTO 0) );

   csa_3to_2_14 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus78(31 DOWNTO 0),
                 Y                 => s_logisimBus79(31 DOWNTO 0),
                 Z                 => s_logisimBus11(31 DOWNTO 0),
                 carry             => s_logisimBus81(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus80(31 DOWNTO 0) );

   csa_3to_2_15 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus80(31 DOWNTO 0),
                 Y                 => s_logisimBus81(31 DOWNTO 0),
                 Z                 => s_logisimBus18(31 DOWNTO 0),
                 carry             => s_logisimBus83(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus82(31 DOWNTO 0) );

   vente7 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus82(31 DOWNTO 0),
                 Y                 => s_logisimBus83(31 DOWNTO 0),
                 Z                 => s_logisimBus15(31 DOWNTO 0),
                 carry             => s_logisimBus85(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus84(31 DOWNTO 0) );

   csa_3to_2_16 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus84(31 DOWNTO 0),
                 Y                 => s_logisimBus85(31 DOWNTO 0),
                 Z                 => s_logisimBus4(31 DOWNTO 0),
                 carry             => s_logisimBus87(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus86(31 DOWNTO 0) );

   csa_3to_2_17 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus86(31 DOWNTO 0),
                 Y                 => s_logisimBus87(31 DOWNTO 0),
                 Z                 => s_logisimBus10(31 DOWNTO 0),
                 carry             => s_logisimBus89(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus88(31 DOWNTO 0) );

   csa_3to_2_18 : csa_3to_2
      PORT MAP ( X                 => s_logisimBus88(31 DOWNTO 0),
                 Y                 => s_logisimBus89(31 DOWNTO 0),
                 Z                 => s_logisimBus26(31 DOWNTO 0),
                 carry             => s_logisimBus91(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus90(31 DOWNTO 0) );

   un : csa_3to_2
      PORT MAP ( X                 => s_logisimBus21(31 DOWNTO 0),
                 Y                 => s_logisimBus22(31 DOWNTO 0),
                 Z                 => s_logisimBus23(31 DOWNTO 0),
                 carry             => s_logisimBus93(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 sum               => s_logisimBus92(31 DOWNTO 0) );

END platformIndependent;
