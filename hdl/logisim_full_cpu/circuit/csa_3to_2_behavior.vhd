--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : csa_3to_2                                                    ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF csa_3to_2 IS 

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

      COMPONENT XOR_GATE_BUS_ONEHOT
         GENERIC ( BubblesMask : std_logic_vector;
                   NrOfBits    : INTEGER );
         PORT ( input1 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                input2 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                result : OUT std_logic_vector( (NrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT OR_GATE_BUS_3_INPUTS
         GENERIC ( BubblesMask : std_logic_vector;
                   NrOfBits    : INTEGER );
         PORT ( input1 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                input2 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                input3 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                result : OUT std_logic_vector( (NrOfBits - 1) DOWNTO 0 ) );
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
   SIGNAL s_logisimBus0  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus1  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus10 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus3  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus4  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus5  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus6  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus7  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus8  : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus9  : std_logic_vector( 31 DOWNTO 0 );

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus2(31 DOWNTO 0) <= Y;
   s_logisimBus3(31 DOWNTO 0) <= X;
   s_logisimBus4(31 DOWNTO 0) <= Z;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   carry <= s_logisimBus10(31 DOWNTO 0);
   sum   <= s_logisimBus9(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Constant
    s_logisimBus8(4 DOWNTO 0)  <=  "0"&X"1";


   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   XandY : AND_GATE_BUS
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus3(31 DOWNTO 0),
                 input2 => s_logisimBus2(31 DOWNTO 0),
                 result => s_logisimBus0(31 DOWNTO 0) );

   XandZ : AND_GATE_BUS
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus3(31 DOWNTO 0),
                 input2 => s_logisimBus4(31 DOWNTO 0),
                 result => s_logisimBus6(31 DOWNTO 0) );

   YandZ : AND_GATE_BUS
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus2(31 DOWNTO 0),
                 input2 => s_logisimBus4(31 DOWNTO 0),
                 result => s_logisimBus1(31 DOWNTO 0) );

   GATES_4 : XOR_GATE_BUS_ONEHOT
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus3(31 DOWNTO 0),
                 input2 => s_logisimBus4(31 DOWNTO 0),
                 result => s_logisimBus5(31 DOWNTO 0) );

   maj : OR_GATE_BUS_3_INPUTS
      GENERIC MAP ( BubblesMask => "000",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus0(31 DOWNTO 0),
                 input2 => s_logisimBus6(31 DOWNTO 0),
                 input3 => s_logisimBus1(31 DOWNTO 0),
                 result => s_logisimBus7(31 DOWNTO 0) );

   GATES_6 : XOR_GATE_BUS_ONEHOT
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus2(31 DOWNTO 0),
                 input2 => s_logisimBus5(31 DOWNTO 0),
                 result => s_logisimBus9(31 DOWNTO 0) );

   ARITH_7 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus7(31 DOWNTO 0),
                 result      => s_logisimBus10(31 DOWNTO 0),
                 shiftAmount => s_logisimBus8(4 DOWNTO 0) );


END platformIndependent;
