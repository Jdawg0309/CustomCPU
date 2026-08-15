--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : barrel_32b                                                   ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF barrel_32b IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT bs_stage_4
         PORT ( enable            : IN  std_logic;
                input_32          : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                typ_2             : IN  std_logic_vector( 1 DOWNTO 0 );
                out_1             : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT bs_stage_8
         PORT ( enable            : IN  std_logic;
                input_32          : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                typ_2             : IN  std_logic_vector( 1 DOWNTO 0 );
                out_1             : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT bs_stage_16
         PORT ( enable            : IN  std_logic;
                input_32          : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                typ_2             : IN  std_logic_vector( 1 DOWNTO 0 );
                out_1             : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT bs_stage_1
         PORT ( enable            : IN  std_logic;
                input_32          : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                typ_2             : IN  std_logic_vector( 1 DOWNTO 0 );
                out_1             : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT bs_stage_2
         PORT ( enable            : IN  std_logic;
                input_32          : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                typ_2             : IN  std_logic_vector( 1 DOWNTO 0 );
                out_1             : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus1  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus10 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus11 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus12 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2  : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_logisimBus7  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus8  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus9  : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimNet0  : std_logic;
   SIGNAL s_logisimNet3  : std_logic;
   SIGNAL s_logisimNet4  : std_logic;
   SIGNAL s_logisimNet5  : std_logic;
   SIGNAL s_logisimNet6  : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus1(31 DOWNTO 0) <= input_32b;
   s_logisimBus2(1 DOWNTO 0)  <= typ;
   s_logisimBus9(4 DOWNTO 0)  <= amnt;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   outp <= s_logisimBus12(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all sub-circuits are defined                                          --
   --------------------------------------------------------------------------------

   bs_stage_4_1 : bs_stage_4
      PORT MAP ( enable            => s_logisimBus9(2),
                 input_32          => s_logisimBus7(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 out_1             => s_logisimBus10(31 DOWNTO 0),
                 typ_2             => s_logisimBus2(1 DOWNTO 0) );

   bs_stage_8_1 : bs_stage_8
      PORT MAP ( enable            => s_logisimBus9(3),
                 input_32          => s_logisimBus10(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 out_1             => s_logisimBus8(31 DOWNTO 0),
                 typ_2             => s_logisimBus2(1 DOWNTO 0) );

   bs_stage_16_1 : bs_stage_16
      PORT MAP ( enable            => s_logisimBus9(4),
                 input_32          => s_logisimBus8(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 out_1             => s_logisimBus12(31 DOWNTO 0),
                 typ_2             => s_logisimBus2(1 DOWNTO 0) );

   bs_stage_1_1 : bs_stage_1
      PORT MAP ( enable            => s_logisimBus9(0),
                 input_32          => s_logisimBus1(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 out_1             => s_logisimBus11(31 DOWNTO 0),
                 typ_2             => s_logisimBus2(1 DOWNTO 0) );

   bs_stage_2_1 : bs_stage_2
      PORT MAP ( enable            => s_logisimBus9(1),
                 input_32          => s_logisimBus11(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 out_1             => s_logisimBus7(31 DOWNTO 0),
                 typ_2             => s_logisimBus2(1 DOWNTO 0) );

END platformIndependent;
