--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : pc_fetch                                                     ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF pc_fetch IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

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
   SIGNAL s_logisimBus1  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus10 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus12 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus13 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus3  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus4  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus5  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus6  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimNet0  : std_logic;
   SIGNAL s_logisimNet11 : std_logic;
   SIGNAL s_logisimNet14 : std_logic;
   SIGNAL s_logisimNet15 : std_logic;
   SIGNAL s_logisimNet16 : std_logic;
   SIGNAL s_logisimNet17 : std_logic;
   SIGNAL s_logisimNet7  : std_logic;
   SIGNAL s_logisimNet8  : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus12(31 DOWNTO 0) <= IMM;
   s_logisimBus6(31 DOWNTO 0)  <= abs_target;
   s_logisimNet11              <= CLK;
   s_logisimNet14              <= abs_select;
   s_logisimNet15              <= BRANCH;
   s_logisimNet7               <= hold;
   s_logisimNet8               <= RST;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   pc_out   <= s_logisimBus1(5 DOWNTO 2);
   pc_plus4 <= s_logisimBus3(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Constant
    s_logisimNet0  <=  '1';


   -- Constant
    s_logisimBus4(31 DOWNTO 0)  <=  X"00000004";


   -- Constant
    s_logisimNet16  <=  '0';


   -- Constant
    s_logisimNet17  <=  '0';


   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   PC : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 32 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet0,
                 d           => s_logisimBus2(31 DOWNTO 0),
                 q           => s_logisimBus1(31 DOWNTO 0),
                 reset       => s_logisimNet8,
                 tick        => logisimClockTree0(2) );

   PLEXERS_2 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus13(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus6(31 DOWNTO 0),
                 muxOut  => s_logisimBus5(31 DOWNTO 0),
                 sel     => s_logisimNet14 );

   PLEXERS_3 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus3(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus5(31 DOWNTO 0),
                 muxOut  => s_logisimBus10(31 DOWNTO 0),
                 sel     => s_logisimNet15 );

   PLEXERS_4 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus10(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus1(31 DOWNTO 0),
                 muxOut  => s_logisimBus2(31 DOWNTO 0),
                 sel     => s_logisimNet7 );

   ARITH_5 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => s_logisimNet16,
                 carryOut => OPEN,
                 dataA    => s_logisimBus1(31 DOWNTO 0),
                 dataB    => s_logisimBus4(31 DOWNTO 0),
                 result   => s_logisimBus3(31 DOWNTO 0) );

   ARITH_6 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => s_logisimNet17,
                 carryOut => OPEN,
                 dataA    => s_logisimBus1(31 DOWNTO 0),
                 dataB    => s_logisimBus12(31 DOWNTO 0),
                 result   => s_logisimBus13(31 DOWNTO 0) );


END platformIndependent;
