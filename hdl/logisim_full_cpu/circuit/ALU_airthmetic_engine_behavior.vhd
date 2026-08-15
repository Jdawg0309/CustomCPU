--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : ALU_airthmetic_engine                                        ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF ALU_airthmetic_engine IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT XOR_GATE_BUS_ONEHOT
         GENERIC ( BubblesMask : std_logic_vector;
                   NrOfBits    : INTEGER );
         PORT ( input1 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                input2 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                result : OUT std_logic_vector( (NrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT Multiplexer_4
         PORT ( enable  : IN  std_logic;
                muxIn_0 : IN  std_logic;
                muxIn_1 : IN  std_logic;
                muxIn_2 : IN  std_logic;
                muxIn_3 : IN  std_logic;
                sel     : IN  std_logic_vector( 1 DOWNTO 0 );
                muxOut  : OUT std_logic );
      END COMPONENT;

      COMPONENT ks_32b
         PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
                B                 : IN  std_logic_vector( 31 DOWNTO 0 );
                Cin               : IN  std_logic;
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                Cout              : OUT std_logic;
                SUM10             : OUT std_logic;
                SUM11             : OUT std_logic;
                SUM12             : OUT std_logic;
                SUM13             : OUT std_logic;
                SUM14             : OUT std_logic;
                SUM15             : OUT std_logic;
                SUM16             : OUT std_logic;
                SUM17             : OUT std_logic;
                SUM18             : OUT std_logic;
                SUM19             : OUT std_logic;
                SUM2              : OUT std_logic;
                SUM20             : OUT std_logic;
                SUM21             : OUT std_logic;
                SUM22             : OUT std_logic;
                SUM23             : OUT std_logic;
                SUM24             : OUT std_logic;
                SUM25             : OUT std_logic;
                SUM26             : OUT std_logic;
                SUM27             : OUT std_logic;
                SUM28             : OUT std_logic;
                SUM29             : OUT std_logic;
                SUM3              : OUT std_logic;
                SUM30             : OUT std_logic;
                SUM31             : OUT std_logic;
                SUM4              : OUT std_logic;
                SUM5              : OUT std_logic;
                SUM6              : OUT std_logic;
                SUM7              : OUT std_logic;
                SUM8              : OUT std_logic;
                SUM9              : OUT std_logic;
                sum0              : OUT std_logic;
                sum1              : OUT std_logic );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus1  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus10 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus2  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus4  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus45 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus46 : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_logisimBus6  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus8  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimNet0  : std_logic;
   SIGNAL s_logisimNet11 : std_logic;
   SIGNAL s_logisimNet12 : std_logic;
   SIGNAL s_logisimNet13 : std_logic;
   SIGNAL s_logisimNet14 : std_logic;
   SIGNAL s_logisimNet15 : std_logic;
   SIGNAL s_logisimNet16 : std_logic;
   SIGNAL s_logisimNet17 : std_logic;
   SIGNAL s_logisimNet18 : std_logic;
   SIGNAL s_logisimNet19 : std_logic;
   SIGNAL s_logisimNet20 : std_logic;
   SIGNAL s_logisimNet21 : std_logic;
   SIGNAL s_logisimNet22 : std_logic;
   SIGNAL s_logisimNet23 : std_logic;
   SIGNAL s_logisimNet24 : std_logic;
   SIGNAL s_logisimNet25 : std_logic;
   SIGNAL s_logisimNet26 : std_logic;
   SIGNAL s_logisimNet27 : std_logic;
   SIGNAL s_logisimNet28 : std_logic;
   SIGNAL s_logisimNet29 : std_logic;
   SIGNAL s_logisimNet3  : std_logic;
   SIGNAL s_logisimNet30 : std_logic;
   SIGNAL s_logisimNet31 : std_logic;
   SIGNAL s_logisimNet32 : std_logic;
   SIGNAL s_logisimNet33 : std_logic;
   SIGNAL s_logisimNet34 : std_logic;
   SIGNAL s_logisimNet35 : std_logic;
   SIGNAL s_logisimNet36 : std_logic;
   SIGNAL s_logisimNet37 : std_logic;
   SIGNAL s_logisimNet38 : std_logic;
   SIGNAL s_logisimNet39 : std_logic;
   SIGNAL s_logisimNet40 : std_logic;
   SIGNAL s_logisimNet41 : std_logic;
   SIGNAL s_logisimNet42 : std_logic;
   SIGNAL s_logisimNet43 : std_logic;
   SIGNAL s_logisimNet44 : std_logic;
   SIGNAL s_logisimNet47 : std_logic;
   SIGNAL s_logisimNet5  : std_logic;
   SIGNAL s_logisimNet7  : std_logic;
   SIGNAL s_logisimNet9  : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus1(31 DOWNTO 0) <= A;
   s_logisimBus46(1 DOWNTO 0) <= Cin_sel;
   s_logisimBus8(31 DOWNTO 0) <= B;
   s_logisimNet0              <= b_inversion;
   s_logisimNet12             <= unused;
   s_logisimNet5              <= a_inversion;
   s_logisimNet9              <= Cflag;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   Cout   <= s_logisimNet47;
   Result <= s_logisimBus45(31 DOWNTO 0);

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Constant
    s_logisimNet7  <=  '0';


   -- Constant
    s_logisimNet11  <=  '1';


   -- Bit Extender
    s_logisimBus4(0)  <=  s_logisimNet0;
    s_logisimBus4(1)  <=  s_logisimNet0;
    s_logisimBus4(2)  <=  s_logisimNet0;
    s_logisimBus4(3)  <=  s_logisimNet0;
    s_logisimBus4(4)  <=  s_logisimNet0;
    s_logisimBus4(5)  <=  s_logisimNet0;
    s_logisimBus4(6)  <=  s_logisimNet0;
    s_logisimBus4(7)  <=  s_logisimNet0;
    s_logisimBus4(8)  <=  s_logisimNet0;
    s_logisimBus4(9)  <=  s_logisimNet0;
    s_logisimBus4(10)  <=  s_logisimNet0;
    s_logisimBus4(11)  <=  s_logisimNet0;
    s_logisimBus4(12)  <=  s_logisimNet0;
    s_logisimBus4(13)  <=  s_logisimNet0;
    s_logisimBus4(14)  <=  s_logisimNet0;
    s_logisimBus4(15)  <=  s_logisimNet0;
    s_logisimBus4(16)  <=  s_logisimNet0;
    s_logisimBus4(17)  <=  s_logisimNet0;
    s_logisimBus4(18)  <=  s_logisimNet0;
    s_logisimBus4(19)  <=  s_logisimNet0;
    s_logisimBus4(20)  <=  s_logisimNet0;
    s_logisimBus4(21)  <=  s_logisimNet0;
    s_logisimBus4(22)  <=  s_logisimNet0;
    s_logisimBus4(23)  <=  s_logisimNet0;
    s_logisimBus4(24)  <=  s_logisimNet0;
    s_logisimBus4(25)  <=  s_logisimNet0;
    s_logisimBus4(26)  <=  s_logisimNet0;
    s_logisimBus4(27)  <=  s_logisimNet0;
    s_logisimBus4(28)  <=  s_logisimNet0;
    s_logisimBus4(29)  <=  s_logisimNet0;
    s_logisimBus4(30)  <=  s_logisimNet0;
    s_logisimBus4(31)  <=  s_logisimNet0;


   -- Bit Extender
    s_logisimBus10(0)  <=  s_logisimNet5;
    s_logisimBus10(1)  <=  s_logisimNet5;
    s_logisimBus10(2)  <=  s_logisimNet5;
    s_logisimBus10(3)  <=  s_logisimNet5;
    s_logisimBus10(4)  <=  s_logisimNet5;
    s_logisimBus10(5)  <=  s_logisimNet5;
    s_logisimBus10(6)  <=  s_logisimNet5;
    s_logisimBus10(7)  <=  s_logisimNet5;
    s_logisimBus10(8)  <=  s_logisimNet5;
    s_logisimBus10(9)  <=  s_logisimNet5;
    s_logisimBus10(10)  <=  s_logisimNet5;
    s_logisimBus10(11)  <=  s_logisimNet5;
    s_logisimBus10(12)  <=  s_logisimNet5;
    s_logisimBus10(13)  <=  s_logisimNet5;
    s_logisimBus10(14)  <=  s_logisimNet5;
    s_logisimBus10(15)  <=  s_logisimNet5;
    s_logisimBus10(16)  <=  s_logisimNet5;
    s_logisimBus10(17)  <=  s_logisimNet5;
    s_logisimBus10(18)  <=  s_logisimNet5;
    s_logisimBus10(19)  <=  s_logisimNet5;
    s_logisimBus10(20)  <=  s_logisimNet5;
    s_logisimBus10(21)  <=  s_logisimNet5;
    s_logisimBus10(22)  <=  s_logisimNet5;
    s_logisimBus10(23)  <=  s_logisimNet5;
    s_logisimBus10(24)  <=  s_logisimNet5;
    s_logisimBus10(25)  <=  s_logisimNet5;
    s_logisimBus10(26)  <=  s_logisimNet5;
    s_logisimBus10(27)  <=  s_logisimNet5;
    s_logisimBus10(28)  <=  s_logisimNet5;
    s_logisimBus10(29)  <=  s_logisimNet5;
    s_logisimBus10(30)  <=  s_logisimNet5;
    s_logisimBus10(31)  <=  s_logisimNet5;


   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   GATES_1 : XOR_GATE_BUS_ONEHOT
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus10(31 DOWNTO 0),
                 input2 => s_logisimBus1(31 DOWNTO 0),
                 result => s_logisimBus6(31 DOWNTO 0) );

   GATES_2 : XOR_GATE_BUS_ONEHOT
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus8(31 DOWNTO 0),
                 input2 => s_logisimBus4(31 DOWNTO 0),
                 result => s_logisimBus2(31 DOWNTO 0) );

   PLEXERS_3 : Multiplexer_4
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimNet7,
                 muxIn_1 => s_logisimNet11,
                 muxIn_2 => s_logisimNet9,
                 muxIn_3 => s_logisimNet12,
                 muxOut  => s_logisimNet3,
                 sel     => s_logisimBus46(1 DOWNTO 0) );


   --------------------------------------------------------------------------------
   -- Here all sub-circuits are defined                                          --
   --------------------------------------------------------------------------------

   ks_32b_1 : ks_32b
      PORT MAP ( A                 => s_logisimBus6(31 DOWNTO 0),
                 B                 => s_logisimBus2(31 DOWNTO 0),
                 Cin               => s_logisimNet3,
                 Cout              => s_logisimNet47,
                 SUM10             => s_logisimBus45(10),
                 SUM11             => s_logisimBus45(11),
                 SUM12             => s_logisimBus45(12),
                 SUM13             => s_logisimBus45(13),
                 SUM14             => s_logisimBus45(14),
                 SUM15             => s_logisimBus45(15),
                 SUM16             => s_logisimBus45(16),
                 SUM17             => s_logisimBus45(17),
                 SUM18             => s_logisimBus45(18),
                 SUM19             => s_logisimBus45(19),
                 SUM2              => s_logisimBus45(2),
                 SUM20             => s_logisimBus45(20),
                 SUM21             => s_logisimBus45(21),
                 SUM22             => s_logisimBus45(22),
                 SUM23             => s_logisimBus45(23),
                 SUM24             => s_logisimBus45(24),
                 SUM25             => s_logisimBus45(25),
                 SUM26             => s_logisimBus45(26),
                 SUM27             => s_logisimBus45(27),
                 SUM28             => s_logisimBus45(28),
                 SUM29             => s_logisimBus45(29),
                 SUM3              => s_logisimBus45(3),
                 SUM30             => s_logisimBus45(30),
                 SUM31             => s_logisimBus45(31),
                 SUM4              => s_logisimBus45(4),
                 SUM5              => s_logisimBus45(5),
                 SUM6              => s_logisimBus45(6),
                 SUM7              => s_logisimBus45(7),
                 SUM8              => s_logisimBus45(8),
                 SUM9              => s_logisimBus45(9),
                 logisimClockTree0 => logisimClockTree0,
                 sum0              => s_logisimBus45(0),
                 sum1              => s_logisimBus45(1) );

END platformIndependent;
