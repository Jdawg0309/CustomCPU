--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : condition_checker                                            ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF condition_checker IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT AND_GATE
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT OR_GATE
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT XOR_GATE_ONEHOT
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT Multiplexer_16
         PORT ( enable   : IN  std_logic;
                muxIn_0  : IN  std_logic;
                muxIn_1  : IN  std_logic;
                muxIn_10 : IN  std_logic;
                muxIn_11 : IN  std_logic;
                muxIn_12 : IN  std_logic;
                muxIn_13 : IN  std_logic;
                muxIn_14 : IN  std_logic;
                muxIn_15 : IN  std_logic;
                muxIn_2  : IN  std_logic;
                muxIn_3  : IN  std_logic;
                muxIn_4  : IN  std_logic;
                muxIn_5  : IN  std_logic;
                muxIn_6  : IN  std_logic;
                muxIn_7  : IN  std_logic;
                muxIn_8  : IN  std_logic;
                muxIn_9  : IN  std_logic;
                sel      : IN  std_logic_vector( 3 DOWNTO 0 );
                muxOut   : OUT std_logic );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus15 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimNet0  : std_logic;
   SIGNAL s_logisimNet1  : std_logic;
   SIGNAL s_logisimNet10 : std_logic;
   SIGNAL s_logisimNet11 : std_logic;
   SIGNAL s_logisimNet12 : std_logic;
   SIGNAL s_logisimNet13 : std_logic;
   SIGNAL s_logisimNet14 : std_logic;
   SIGNAL s_logisimNet16 : std_logic;
   SIGNAL s_logisimNet17 : std_logic;
   SIGNAL s_logisimNet2  : std_logic;
   SIGNAL s_logisimNet3  : std_logic;
   SIGNAL s_logisimNet4  : std_logic;
   SIGNAL s_logisimNet5  : std_logic;
   SIGNAL s_logisimNet6  : std_logic;
   SIGNAL s_logisimNet7  : std_logic;
   SIGNAL s_logisimNet8  : std_logic;
   SIGNAL s_logisimNet9  : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimBus15(3 DOWNTO 0) <= cond;
   s_logisimNet0              <= C;
   s_logisimNet11             <= Z;
   s_logisimNet2              <= N;
   s_logisimNet4              <= V;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   Output_1 <= s_logisimNet12;

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Constant
    s_logisimNet16  <=  '1';


   -- Constant
    s_logisimNet17  <=  '0';


   -- NOT Gate
   s_logisimNet3 <=  NOT s_logisimNet2;

   -- NOT Gate
   s_logisimNet9 <=  NOT s_logisimNet11;

   -- NOT Gate
   s_logisimNet6 <=  NOT s_logisimNet0;

   -- NOT Gate
   s_logisimNet14 <=  NOT s_logisimNet4;

   -- NOT Gate
   s_logisimNet10 <=  NOT s_logisimNet8;

   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   GATES_1 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet0,
                 input2 => s_logisimNet9,
                 result => s_logisimNet5 );

   GATES_2 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet6,
                 input2 => s_logisimNet11,
                 result => s_logisimNet13 );

   GATES_3 : XOR_GATE_ONEHOT
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet2,
                 input2 => s_logisimNet4,
                 result => s_logisimNet8 );

   GATES_4 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet9,
                 input2 => s_logisimNet10,
                 result => s_logisimNet1 );

   GATES_5 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet11,
                 input2 => s_logisimNet8,
                 result => s_logisimNet7 );

   PLEXERS_6 : Multiplexer_16
      PORT MAP ( enable   => '1',
                 muxIn_0  => s_logisimNet11,
                 muxIn_1  => s_logisimNet9,
                 muxIn_10 => s_logisimNet10,
                 muxIn_11 => s_logisimNet8,
                 muxIn_12 => s_logisimNet1,
                 muxIn_13 => s_logisimNet7,
                 muxIn_14 => s_logisimNet16,
                 muxIn_15 => s_logisimNet17,
                 muxIn_2  => s_logisimNet0,
                 muxIn_3  => s_logisimNet6,
                 muxIn_4  => s_logisimNet2,
                 muxIn_5  => s_logisimNet3,
                 muxIn_6  => s_logisimNet4,
                 muxIn_7  => s_logisimNet14,
                 muxIn_8  => s_logisimNet5,
                 muxIn_9  => s_logisimNet13,
                 muxOut   => s_logisimNet12,
                 sel      => s_logisimBus15(3 DOWNTO 0) );


END platformIndependent;
