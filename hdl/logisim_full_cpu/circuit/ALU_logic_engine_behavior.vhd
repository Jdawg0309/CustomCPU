--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : ALU_logic_engine                                             ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF ALU_logic_engine IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT AND_GATE_BUS
         GENERIC ( BubblesMask : std_logic_vector;
                   NrOfBits    : INTEGER );
         PORT ( input1 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                input2 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                result : OUT std_logic_vector( (NrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT OR_GATE_BUS
         GENERIC ( BubblesMask : std_logic_vector;
                   NrOfBits    : INTEGER );
         PORT ( input1 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                input2 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                result : OUT std_logic_vector( (NrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT XOR_GATE_BUS_ONEHOT
         GENERIC ( BubblesMask : std_logic_vector;
                   NrOfBits    : INTEGER );
         PORT ( input1 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                input2 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                result : OUT std_logic_vector( (NrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT Multiplexer_bus_8
         GENERIC ( nrOfBits : INTEGER );
         PORT ( enable  : IN  std_logic;
                muxIn_0 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_1 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_2 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_3 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_4 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_5 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_6 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_7 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                sel     : IN  std_logic_vector( 2 DOWNTO 0 );
                muxOut  : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus0 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus1 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus3 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus4 : std_logic_vector( 2 DOWNTO 0 );
   SIGNAL s_logisimBus5 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus6 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus7 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus8 : std_logic_vector( 31 DOWNTO 0 );

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus0(31 DOWNTO 0) <= B;
   s_logisimBus1(31 DOWNTO 0) <= A;
   s_logisimBus4(2 DOWNTO 0)  <= select_bit;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   result <= s_logisimBus7(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- NOT Gate
   s_logisimBus3 <=  NOT s_logisimBus0;

   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   GATES_1 : AND_GATE_BUS
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus1(31 DOWNTO 0),
                 input2 => s_logisimBus0(31 DOWNTO 0),
                 result => s_logisimBus8(31 DOWNTO 0) );

   GATES_2 : OR_GATE_BUS
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus1(31 DOWNTO 0),
                 input2 => s_logisimBus0(31 DOWNTO 0),
                 result => s_logisimBus2(31 DOWNTO 0) );

   GATES_3 : XOR_GATE_BUS_ONEHOT
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus1(31 DOWNTO 0),
                 input2 => s_logisimBus0(31 DOWNTO 0),
                 result => s_logisimBus5(31 DOWNTO 0) );

   GATES_4 : AND_GATE_BUS
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus1(31 DOWNTO 0),
                 input2 => s_logisimBus3(31 DOWNTO 0),
                 result => s_logisimBus6(31 DOWNTO 0) );

   PLEXERS_5 : Multiplexer_bus_8
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus8(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus5(31 DOWNTO 0),
                 muxIn_2 => s_logisimBus2(31 DOWNTO 0),
                 muxIn_3 => s_logisimBus0(31 DOWNTO 0),
                 muxIn_4 => s_logisimBus6(31 DOWNTO 0),
                 muxIn_5 => s_logisimBus3(31 DOWNTO 0),
                 muxIn_6 => X"00000000",
                 muxIn_7 => X"00000000",
                 muxOut  => s_logisimBus7(31 DOWNTO 0),
                 sel     => s_logisimBus4(2 DOWNTO 0) );


END platformIndependent;
