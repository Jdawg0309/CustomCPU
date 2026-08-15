--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : bs_stage_8                                                   ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF bs_stage_8 IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

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

      COMPONENT Multiplexer_bus_2
         GENERIC ( nrOfBits : INTEGER );
         PORT ( enable  : IN  std_logic;
                muxIn_0 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_1 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                sel     : IN  std_logic;
                muxOut  : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT Shifter_32_bit
         GENERIC ( shifterMode : INTEGER );
         PORT ( dataA       : IN  std_logic_vector( 31 DOWNTO 0 );
                shiftAmount : IN  std_logic_vector( 4 DOWNTO 0 );
                result      : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus0 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus1 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus3 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus4 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus5 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus7 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus8 : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_logisimBus9 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimNet6 : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus1(31 DOWNTO 0) <= input_32;
   s_logisimBus8(1 DOWNTO 0)  <= typ_2;
   s_logisimNet6              <= enable;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   out_1 <= s_logisimBus7(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Constant
    s_logisimBus3(4 DOWNTO 0)  <=  "0"&X"8";


   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   PLEXERS_1 : Multiplexer_bus_4
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus0(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus4(31 DOWNTO 0),
                 muxIn_2 => s_logisimBus5(31 DOWNTO 0),
                 muxIn_3 => s_logisimBus2(31 DOWNTO 0),
                 muxOut  => s_logisimBus9(31 DOWNTO 0),
                 sel     => s_logisimBus8(1 DOWNTO 0) );

   PLEXERS_2 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus1(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus9(31 DOWNTO 0),
                 muxOut  => s_logisimBus7(31 DOWNTO 0),
                 sel     => s_logisimNet6 );

   ARITH_3 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus1(31 DOWNTO 0),
                 result      => s_logisimBus0(31 DOWNTO 0),
                 shiftAmount => s_logisimBus3(4 DOWNTO 0) );

   ARITH_4 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 2 )
      PORT MAP ( dataA       => s_logisimBus1(31 DOWNTO 0),
                 result      => s_logisimBus4(31 DOWNTO 0),
                 shiftAmount => s_logisimBus3(4 DOWNTO 0) );

   ARITH_5 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 3 )
      PORT MAP ( dataA       => s_logisimBus1(31 DOWNTO 0),
                 result      => s_logisimBus5(31 DOWNTO 0),
                 shiftAmount => s_logisimBus3(4 DOWNTO 0) );

   ARITH_6 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 4 )
      PORT MAP ( dataA       => s_logisimBus1(31 DOWNTO 0),
                 result      => s_logisimBus2(31 DOWNTO 0),
                 shiftAmount => s_logisimBus3(4 DOWNTO 0) );


END platformIndependent;
