--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : pp_row_32                                                    ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF pp_row_32 IS 

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

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus1 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus3 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimNet0 : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus1(31 DOWNTO 0) <= Rm;
   s_logisimNet0              <= Rs_bit;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   result <= s_logisimBus3(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Bit Extender
    s_logisimBus2(0)  <=  s_logisimNet0;
    s_logisimBus2(1)  <=  s_logisimNet0;
    s_logisimBus2(2)  <=  s_logisimNet0;
    s_logisimBus2(3)  <=  s_logisimNet0;
    s_logisimBus2(4)  <=  s_logisimNet0;
    s_logisimBus2(5)  <=  s_logisimNet0;
    s_logisimBus2(6)  <=  s_logisimNet0;
    s_logisimBus2(7)  <=  s_logisimNet0;
    s_logisimBus2(8)  <=  s_logisimNet0;
    s_logisimBus2(9)  <=  s_logisimNet0;
    s_logisimBus2(10)  <=  s_logisimNet0;
    s_logisimBus2(11)  <=  s_logisimNet0;
    s_logisimBus2(12)  <=  s_logisimNet0;
    s_logisimBus2(13)  <=  s_logisimNet0;
    s_logisimBus2(14)  <=  s_logisimNet0;
    s_logisimBus2(15)  <=  s_logisimNet0;
    s_logisimBus2(16)  <=  s_logisimNet0;
    s_logisimBus2(17)  <=  s_logisimNet0;
    s_logisimBus2(18)  <=  s_logisimNet0;
    s_logisimBus2(19)  <=  s_logisimNet0;
    s_logisimBus2(20)  <=  s_logisimNet0;
    s_logisimBus2(21)  <=  s_logisimNet0;
    s_logisimBus2(22)  <=  s_logisimNet0;
    s_logisimBus2(23)  <=  s_logisimNet0;
    s_logisimBus2(24)  <=  s_logisimNet0;
    s_logisimBus2(25)  <=  s_logisimNet0;
    s_logisimBus2(26)  <=  s_logisimNet0;
    s_logisimBus2(27)  <=  s_logisimNet0;
    s_logisimBus2(28)  <=  s_logisimNet0;
    s_logisimBus2(29)  <=  s_logisimNet0;
    s_logisimBus2(30)  <=  s_logisimNet0;
    s_logisimBus2(31)  <=  s_logisimNet0;


   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   GATES_1 : AND_GATE_BUS
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus1(31 DOWNTO 0),
                 input2 => s_logisimBus2(31 DOWNTO 0),
                 result => s_logisimBus3(31 DOWNTO 0) );


END platformIndependent;
