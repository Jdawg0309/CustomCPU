--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : main                                                         ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF main IS 

   -----------------------------------------------------------------------------
   -- Here all used components are defined                                    --
   -----------------------------------------------------------------------------

      COMPONENT AND_GATE_3_INPUTS
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                input3 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT AND_GATE_BUS
         GENERIC ( BubblesMask : std_logic_vector;
                   NrOfBits    : INTEGER );
         PORT ( input1 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                input2 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                result : OUT std_logic_vector( (NrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT AND_GATE
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

      COMPONENT XOR_GATE_BUS_ONEHOT
         GENERIC ( BubblesMask : std_logic_vector;
                   NrOfBits    : INTEGER );
         PORT ( input1 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                input2 : IN  std_logic_vector( (NrOfBits - 1) DOWNTO 0 );
                result : OUT std_logic_vector( (NrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT OR_GATE
         GENERIC ( BubblesMask : std_logic_vector );
         PORT ( input1 : IN  std_logic;
                input2 : IN  std_logic;
                result : OUT std_logic );
      END COMPONENT;

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

      COMPONENT RAMCONTENTS_RAM_1
         PORT ( address : IN  std_logic_vector( 7 DOWNTO 0 );
                clock   : IN  std_logic;
                dataIn  : IN  std_logic_vector( 31 DOWNTO 0 );
                oe      : IN  std_logic;
                tick    : IN  std_logic;
                we      : IN  std_logic;
                dataOut : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT Multiplexer_bus_2
         GENERIC ( nrOfBits : INTEGER );
         PORT ( enable  : IN  std_logic;
                muxIn_0 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                muxIn_1 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                sel     : IN  std_logic;
                muxOut  : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT Comparator
         GENERIC ( nrOfBits       : INTEGER;
                   twosComplement : INTEGER );
         PORT ( dataA         : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                dataB         : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
                aEqualsB      : OUT std_logic;
                aGreaterThanB : OUT std_logic;
                aLessThanB    : OUT std_logic );
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

      COMPONENT Shifter_32_bit
         GENERIC ( shifterMode : INTEGER );
         PORT ( dataA       : IN  std_logic_vector( 31 DOWNTO 0 );
                shiftAmount : IN  std_logic_vector( 4 DOWNTO 0 );
                result      : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT pc_fetch
         PORT ( BRANCH            : IN  std_logic;
                CLK               : IN  std_logic;
                IMM               : IN  std_logic_vector( 31 DOWNTO 0 );
                RST               : IN  std_logic;
                abs_select        : IN  std_logic;
                abs_target        : IN  std_logic_vector( 31 DOWNTO 0 );
                hold              : IN  std_logic;
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                pc_out            : OUT std_logic_vector( 3 DOWNTO 0 );
                pc_plus4          : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT block_transfer_control
         PORT ( base_in           : IN  std_logic_vector( 31 DOWNTO 0 );
                clk               : IN  std_logic;
                is_pop            : IN  std_logic;
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                reg_list_in       : IN  std_logic_vector( 15 DOWNTO 0 );
                rst               : IN  std_logic;
                start             : IN  std_logic;
                active            : OUT std_logic;
                addr              : OUT std_logic_vector( 31 DOWNTO 0 );
                done              : OUT std_logic;
                hold_pc           : OUT std_logic;
                pop_request       : OUT std_logic;
                reg_idx           : OUT std_logic_vector( 3 DOWNTO 0 );
                reg_selected      : OUT std_logic;
                transfer_address  : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT reg16x32_1
         PORT ( CLK               : IN  std_logic;
                RA                : IN  std_logic_vector( 3 DOWNTO 0 );
                RB                : IN  std_logic_vector( 3 DOWNTO 0 );
                RST               : IN  std_logic;
                WA                : IN  std_logic_vector( 3 DOWNTO 0 );
                WA2               : IN  std_logic_vector( 3 DOWNTO 0 );
                WD                : IN  std_logic_vector( 31 DOWNTO 0 );
                WD2               : IN  std_logic_vector( 31 DOWNTO 0 );
                WE                : IN  std_logic;
                WE2               : IN  std_logic;
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                R0_OUTPUT         : OUT std_logic_vector( 31 DOWNTO 0 );
                R10_OUTPUT        : OUT std_logic_vector( 31 DOWNTO 0 );
                R11_OUTPUT        : OUT std_logic_vector( 31 DOWNTO 0 );
                R12_OUTPUT        : OUT std_logic_vector( 31 DOWNTO 0 );
                R13_OUTPUT        : OUT std_logic_vector( 31 DOWNTO 0 );
                R14_OUTPUT        : OUT std_logic_vector( 31 DOWNTO 0 );
                R15_OUTPUT        : OUT std_logic_vector( 31 DOWNTO 0 );
                R1_OUTPUT         : OUT std_logic_vector( 31 DOWNTO 0 );
                R2_OUPUT          : OUT std_logic_vector( 31 DOWNTO 0 );
                R3_OUTPUT         : OUT std_logic_vector( 31 DOWNTO 0 );
                R4_OUTPUT         : OUT std_logic_vector( 31 DOWNTO 0 );
                R5_OUTPUT         : OUT std_logic_vector( 31 DOWNTO 0 );
                R6_OUTPUT         : OUT std_logic_vector( 31 DOWNTO 0 );
                R7_OUTPUT         : OUT std_logic_vector( 31 DOWNTO 0 );
                R8_OUTPUT         : OUT std_logic_vector( 31 DOWNTO 0 );
                R9_OUTPUT         : OUT std_logic_vector( 31 DOWNTO 0 );
                RD_A              : OUT std_logic_vector( 31 DOWNTO 0 );
                RD_B              : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT barrel_32b
         PORT ( amnt              : IN  std_logic_vector( 4 DOWNTO 0 );
                input_32b         : IN  std_logic_vector( 31 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                typ               : IN  std_logic_vector( 1 DOWNTO 0 );
                outp              : OUT std_logic_vector( 31 DOWNTO 0 ) );
      END COMPONENT;

      COMPONENT ALU
         PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
                B                 : IN  std_logic_vector( 31 DOWNTO 0 );
                Cflag             : IN  std_logic;
                a_inv             : IN  std_logic;
                b_inv             : IN  std_logic;
                cin_sel           : IN  std_logic_vector( 1 DOWNTO 0 );
                engine_sel        : IN  std_logic_vector( 1 DOWNTO 0 );
                logic_sel         : IN  std_logic_vector( 2 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                unused            : IN  std_logic;
                write_enable      : IN  std_logic;
                C                 : OUT std_logic;
                N                 : OUT std_logic;
                V                 : OUT std_logic;
                Z                 : OUT std_logic;
                result            : OUT std_logic_vector( 31 DOWNTO 0 );
                write_enable_out  : OUT std_logic );
      END COMPONENT;

      COMPONENT condition_checker
         PORT ( C                 : IN  std_logic;
                N                 : IN  std_logic;
                V                 : IN  std_logic;
                Z                 : IN  std_logic;
                cond              : IN  std_logic_vector( 3 DOWNTO 0 );
                logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
                Output_1          : OUT std_logic );
      END COMPONENT;

--------------------------------------------------------------------------------
-- All used signals are defined here                                          --
--------------------------------------------------------------------------------
   SIGNAL s_logisimBus0   : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus10  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus102 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus106 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus107 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus109 : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_logisimBus119 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus120 : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_logisimBus125 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus126 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus128 : std_logic_vector( 15 DOWNTO 0 );
   SIGNAL s_logisimBus129 : std_logic_vector( 2 DOWNTO 0 );
   SIGNAL s_logisimBus130 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus131 : std_logic_vector( 9 DOWNTO 0 );
   SIGNAL s_logisimBus136 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus142 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus143 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus144 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus145 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus152 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus154 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus155 : std_logic_vector( 11 DOWNTO 0 );
   SIGNAL s_logisimBus157 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus158 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus159 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus160 : std_logic_vector( 23 DOWNTO 0 );
   SIGNAL s_logisimBus161 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus167 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus17  : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus173 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus181 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus182 : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_logisimBus183 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus184 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus195 : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_logisimBus196 : std_logic_vector( 2 DOWNTO 0 );
   SIGNAL s_logisimBus197 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus198 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus199 : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus2   : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_logisimBus200 : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus201 : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus21  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus29  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus32  : std_logic_vector( 2 DOWNTO 0 );
   SIGNAL s_logisimBus35  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus36  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus37  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus42  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus44  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus50  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus51  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus53  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus54  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus55  : std_logic_vector( 4 DOWNTO 0 );
   SIGNAL s_logisimBus57  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus58  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus61  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus65  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus69  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus74  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus75  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus76  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus77  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus8   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus84  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus86  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus9   : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus93  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus94  : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_logisimBus98  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimBus99  : std_logic_vector( 3 DOWNTO 0 );
   SIGNAL s_logisimNet1   : std_logic;
   SIGNAL s_logisimNet100 : std_logic;
   SIGNAL s_logisimNet101 : std_logic;
   SIGNAL s_logisimNet103 : std_logic;
   SIGNAL s_logisimNet105 : std_logic;
   SIGNAL s_logisimNet11  : std_logic;
   SIGNAL s_logisimNet110 : std_logic;
   SIGNAL s_logisimNet111 : std_logic;
   SIGNAL s_logisimNet112 : std_logic;
   SIGNAL s_logisimNet113 : std_logic;
   SIGNAL s_logisimNet114 : std_logic;
   SIGNAL s_logisimNet116 : std_logic;
   SIGNAL s_logisimNet117 : std_logic;
   SIGNAL s_logisimNet118 : std_logic;
   SIGNAL s_logisimNet12  : std_logic;
   SIGNAL s_logisimNet121 : std_logic;
   SIGNAL s_logisimNet123 : std_logic;
   SIGNAL s_logisimNet124 : std_logic;
   SIGNAL s_logisimNet127 : std_logic;
   SIGNAL s_logisimNet13  : std_logic;
   SIGNAL s_logisimNet132 : std_logic;
   SIGNAL s_logisimNet133 : std_logic;
   SIGNAL s_logisimNet134 : std_logic;
   SIGNAL s_logisimNet135 : std_logic;
   SIGNAL s_logisimNet137 : std_logic;
   SIGNAL s_logisimNet138 : std_logic;
   SIGNAL s_logisimNet139 : std_logic;
   SIGNAL s_logisimNet140 : std_logic;
   SIGNAL s_logisimNet146 : std_logic;
   SIGNAL s_logisimNet147 : std_logic;
   SIGNAL s_logisimNet148 : std_logic;
   SIGNAL s_logisimNet149 : std_logic;
   SIGNAL s_logisimNet15  : std_logic;
   SIGNAL s_logisimNet150 : std_logic;
   SIGNAL s_logisimNet151 : std_logic;
   SIGNAL s_logisimNet153 : std_logic;
   SIGNAL s_logisimNet156 : std_logic;
   SIGNAL s_logisimNet16  : std_logic;
   SIGNAL s_logisimNet162 : std_logic;
   SIGNAL s_logisimNet163 : std_logic;
   SIGNAL s_logisimNet164 : std_logic;
   SIGNAL s_logisimNet165 : std_logic;
   SIGNAL s_logisimNet166 : std_logic;
   SIGNAL s_logisimNet169 : std_logic;
   SIGNAL s_logisimNet170 : std_logic;
   SIGNAL s_logisimNet171 : std_logic;
   SIGNAL s_logisimNet172 : std_logic;
   SIGNAL s_logisimNet174 : std_logic;
   SIGNAL s_logisimNet175 : std_logic;
   SIGNAL s_logisimNet177 : std_logic;
   SIGNAL s_logisimNet179 : std_logic;
   SIGNAL s_logisimNet18  : std_logic;
   SIGNAL s_logisimNet180 : std_logic;
   SIGNAL s_logisimNet185 : std_logic;
   SIGNAL s_logisimNet187 : std_logic;
   SIGNAL s_logisimNet188 : std_logic;
   SIGNAL s_logisimNet189 : std_logic;
   SIGNAL s_logisimNet19  : std_logic;
   SIGNAL s_logisimNet190 : std_logic;
   SIGNAL s_logisimNet191 : std_logic;
   SIGNAL s_logisimNet192 : std_logic;
   SIGNAL s_logisimNet193 : std_logic;
   SIGNAL s_logisimNet194 : std_logic;
   SIGNAL s_logisimNet20  : std_logic;
   SIGNAL s_logisimNet202 : std_logic;
   SIGNAL s_logisimNet203 : std_logic;
   SIGNAL s_logisimNet23  : std_logic;
   SIGNAL s_logisimNet24  : std_logic;
   SIGNAL s_logisimNet25  : std_logic;
   SIGNAL s_logisimNet26  : std_logic;
   SIGNAL s_logisimNet28  : std_logic;
   SIGNAL s_logisimNet3   : std_logic;
   SIGNAL s_logisimNet30  : std_logic;
   SIGNAL s_logisimNet31  : std_logic;
   SIGNAL s_logisimNet33  : std_logic;
   SIGNAL s_logisimNet34  : std_logic;
   SIGNAL s_logisimNet38  : std_logic;
   SIGNAL s_logisimNet39  : std_logic;
   SIGNAL s_logisimNet4   : std_logic;
   SIGNAL s_logisimNet40  : std_logic;
   SIGNAL s_logisimNet43  : std_logic;
   SIGNAL s_logisimNet45  : std_logic;
   SIGNAL s_logisimNet46  : std_logic;
   SIGNAL s_logisimNet47  : std_logic;
   SIGNAL s_logisimNet48  : std_logic;
   SIGNAL s_logisimNet5   : std_logic;
   SIGNAL s_logisimNet52  : std_logic;
   SIGNAL s_logisimNet56  : std_logic;
   SIGNAL s_logisimNet59  : std_logic;
   SIGNAL s_logisimNet6   : std_logic;
   SIGNAL s_logisimNet62  : std_logic;
   SIGNAL s_logisimNet64  : std_logic;
   SIGNAL s_logisimNet66  : std_logic;
   SIGNAL s_logisimNet67  : std_logic;
   SIGNAL s_logisimNet68  : std_logic;
   SIGNAL s_logisimNet7   : std_logic;
   SIGNAL s_logisimNet70  : std_logic;
   SIGNAL s_logisimNet71  : std_logic;
   SIGNAL s_logisimNet73  : std_logic;
   SIGNAL s_logisimNet78  : std_logic;
   SIGNAL s_logisimNet79  : std_logic;
   SIGNAL s_logisimNet80  : std_logic;
   SIGNAL s_logisimNet81  : std_logic;
   SIGNAL s_logisimNet82  : std_logic;
   SIGNAL s_logisimNet83  : std_logic;
   SIGNAL s_logisimNet85  : std_logic;
   SIGNAL s_logisimNet87  : std_logic;
   SIGNAL s_logisimNet89  : std_logic;
   SIGNAL s_logisimNet90  : std_logic;
   SIGNAL s_logisimNet91  : std_logic;
   SIGNAL s_logisimNet92  : std_logic;
   SIGNAL s_logisimNet95  : std_logic;
   SIGNAL s_logisimNet96  : std_logic;
   SIGNAL s_logisimNet97  : std_logic;

BEGIN

   --------------------------------------------------------------------------------
   -- All clock generator connections are defined here                           --
   --------------------------------------------------------------------------------
   s_logisimNet48 <= logisimClockTree0(0);

   --------------------------------------------------------------------------------
   -- Here all wiring is defined                                                 --
   --------------------------------------------------------------------------------
   s_logisimBus120(0)  <= s_logisimNet191;
   s_logisimBus120(1)  <= s_logisimNet192;
   s_logisimBus128(0)  <= s_logisimBus77(0);
   s_logisimBus128(1)  <= s_logisimBus77(1);
   s_logisimBus128(2)  <= s_logisimBus77(2);
   s_logisimBus128(3)  <= s_logisimBus77(3);
   s_logisimBus129(0)  <= s_logisimNet188;
   s_logisimBus129(1)  <= s_logisimNet189;
   s_logisimBus129(2)  <= s_logisimNet190;
   s_logisimBus145(1)  <= s_logisimBus157(0);
   s_logisimBus145(2)  <= s_logisimBus157(1);
   s_logisimBus145(3)  <= s_logisimBus157(2);
   s_logisimBus145(4)  <= s_logisimBus157(3);
   s_logisimBus155(0)  <= s_logisimNet164;
   s_logisimBus155(1)  <= s_logisimNet116;
   s_logisimBus155(10) <= s_logisimNet6;
   s_logisimBus155(11) <= s_logisimNet150;
   s_logisimBus155(2)  <= s_logisimNet5;
   s_logisimBus155(3)  <= s_logisimNet149;
   s_logisimBus155(4)  <= s_logisimNet91;
   s_logisimBus155(5)  <= s_logisimNet179;
   s_logisimBus155(6)  <= s_logisimNet134;
   s_logisimBus155(7)  <= s_logisimNet67;
   s_logisimBus155(8)  <= s_logisimNet165;
   s_logisimBus155(9)  <= s_logisimNet117;
   s_logisimBus157(0)  <= s_logisimBus53(8);
   s_logisimBus157(1)  <= s_logisimBus53(9);
   s_logisimBus157(2)  <= s_logisimBus53(10);
   s_logisimBus157(3)  <= s_logisimBus53(11);
   s_logisimBus2(0)    <= s_logisimNet193;
   s_logisimBus2(1)    <= s_logisimNet194;
   s_logisimBus32(0)   <= s_logisimNet163;
   s_logisimBus32(1)   <= s_logisimNet38;
   s_logisimBus32(2)   <= s_logisimNet114;
   s_logisimBus55(0)   <= s_logisimNet111;
   s_logisimBus55(1)   <= s_logisimNet40;
   s_logisimBus55(2)   <= s_logisimNet147;
   s_logisimBus55(3)   <= s_logisimNet39;
   s_logisimBus55(4)   <= s_logisimNet25;
   s_logisimBus76(0)   <= s_logisimNet156;
   s_logisimBus76(1)   <= s_logisimNet185;
   s_logisimBus76(2)   <= s_logisimNet103;
   s_logisimBus76(3)   <= s_logisimNet148;
   s_logisimBus77(0)   <= s_logisimBus53(21);
   s_logisimBus77(1)   <= s_logisimBus53(22);
   s_logisimBus77(2)   <= s_logisimBus53(23);
   s_logisimBus77(3)   <= s_logisimBus53(24);
   s_logisimBus86(0)   <= s_logisimNet166;
   s_logisimBus86(1)   <= s_logisimNet118;
   s_logisimBus86(2)   <= s_logisimNet7;
   s_logisimBus86(3)   <= s_logisimNet151;
   s_logisimNet103     <= s_logisimBus53(30);
   s_logisimNet111     <= s_logisimBus53(20);
   s_logisimNet114     <= s_logisimBus53(27);
   s_logisimNet116     <= s_logisimBus53(1);
   s_logisimNet117     <= s_logisimBus53(9);
   s_logisimNet118     <= s_logisimBus53(17);
   s_logisimNet134     <= s_logisimBus53(6);
   s_logisimNet147     <= s_logisimBus53(22);
   s_logisimNet148     <= s_logisimBus53(31);
   s_logisimNet149     <= s_logisimBus53(3);
   s_logisimNet150     <= s_logisimBus53(11);
   s_logisimNet151     <= s_logisimBus53(19);
   s_logisimNet156     <= s_logisimBus53(28);
   s_logisimNet163     <= s_logisimBus53(25);
   s_logisimNet164     <= s_logisimBus53(0);
   s_logisimNet165     <= s_logisimBus53(8);
   s_logisimNet166     <= s_logisimBus53(16);
   s_logisimNet179     <= s_logisimBus53(5);
   s_logisimNet185     <= s_logisimBus53(29);
   s_logisimNet188     <= s_logisimBus131(1);
   s_logisimNet189     <= s_logisimBus131(2);
   s_logisimNet190     <= s_logisimBus131(3);
   s_logisimNet191     <= s_logisimBus131(4);
   s_logisimNet192     <= s_logisimBus131(5);
   s_logisimNet193     <= s_logisimBus131(8);
   s_logisimNet194     <= s_logisimBus131(9);
   s_logisimNet25      <= s_logisimBus53(24);
   s_logisimNet38      <= s_logisimBus53(26);
   s_logisimNet39      <= s_logisimBus53(23);
   s_logisimNet40      <= s_logisimBus53(21);
   s_logisimNet5       <= s_logisimBus53(2);
   s_logisimNet6       <= s_logisimBus53(10);
   s_logisimNet67      <= s_logisimBus53(7);
   s_logisimNet7       <= s_logisimBus53(18);
   s_logisimNet91      <= s_logisimBus53(4);

   --------------------------------------------------------------------------------
   -- Here all input connections are defined                                     --
   --------------------------------------------------------------------------------
   s_logisimNet33 <= Input_1;

   --------------------------------------------------------------------------------
   -- Here all output connections are defined                                    --
   --------------------------------------------------------------------------------
   Output_1                <= s_logisimBus77(3);
   Output_bus_1            <= s_logisimBus61(31 DOWNTO 0);
   Output_bus_10           <= s_logisimBus167(31 DOWNTO 0);
   Output_bus_11           <= s_logisimBus21(31 DOWNTO 0);
   Output_bus_12           <= s_logisimBus119(31 DOWNTO 0);
   Output_bus_13           <= s_logisimBus158(31 DOWNTO 0);
   Output_bus_14           <= s_logisimBus8(31 DOWNTO 0);
   Output_bus_15           <= s_logisimBus107(31 DOWNTO 0);
   Output_bus_16           <= s_logisimBus152(31 DOWNTO 0);
   Output_bus_17           <= s_logisimBus183(31 DOWNTO 0);
   Output_bus_18           <= s_logisimBus94(31 DOWNTO 0);
   Output_bus_19           <= s_logisimBus144(31 DOWNTO 0);
   Output_bus_2            <= s_logisimBus93(31 DOWNTO 0);
   Output_bus_20           <= s_logisimBus10(31 DOWNTO 0);
   Output_bus_3            <= s_logisimBus143(31 DOWNTO 0);
   Output_bus_4            <= s_logisimBus181(31 DOWNTO 0);
   Output_bus_5            <= s_logisimBus84(31 DOWNTO 0);
   Output_bus_6            <= s_logisimBus136(31 DOWNTO 0);
   Output_bus_7            <= s_logisimBus173(31 DOWNTO 0);
   Output_bus_8            <= s_logisimBus69(31 DOWNTO 0);
   Output_bus_9            <= s_logisimBus126(31 DOWNTO 0);
   RD_A                    <= s_logisimBus58(31 DOWNTO 0);
   bl_taken                <= s_logisimNet24;
   branch_taken            <= s_logisimNet15;
   condition_pass          <= s_logisimNet12;
   is_BL                   <= s_logisimNet70;
   is_BX                   <= s_logisimNet30;
   is_LDR                  <= s_logisimNet26;
   is_STR                  <= s_logisimNet95;
   ldr_reg_we              <= s_logisimNet56;
   mem_class               <= s_logisimNet80;
   mem_offset              <= s_logisimBus57(31 DOWNTO 0);
   memory_address          <= s_logisimBus36(31 DOWNTO 0);
   memory_offset_effective <= s_logisimBus75(31 DOWNTO 0);
   normal_reg_WE           <= s_logisimNet18;

   --------------------------------------------------------------------------------
   -- Here all in-lined components are defined                                   --
   --------------------------------------------------------------------------------

   -- Constant
    s_logisimBus160(23 DOWNTO 0)  <=  X"12FFF1";


   -- Constant
    s_logisimBus159(31 DOWNTO 0)  <=  X"FFFFFFFC";


   -- Constant
    s_logisimBus196(2 DOWNTO 0)  <=  "100";


   -- Bit Extender
    s_logisimBus57(0)  <=  s_logisimBus155(0);
    s_logisimBus57(1)  <=  s_logisimBus155(1);
    s_logisimBus57(2)  <=  s_logisimBus155(2);
    s_logisimBus57(3)  <=  s_logisimBus155(3);
    s_logisimBus57(4)  <=  s_logisimBus155(4);
    s_logisimBus57(5)  <=  s_logisimBus155(5);
    s_logisimBus57(6)  <=  s_logisimBus155(6);
    s_logisimBus57(7)  <=  s_logisimBus155(7);
    s_logisimBus57(8)  <=  s_logisimBus155(8);
    s_logisimBus57(9)  <=  s_logisimBus155(9);
    s_logisimBus57(10)  <=  s_logisimBus155(10);
    s_logisimBus57(11)  <=  s_logisimBus155(11);
    s_logisimBus57(12)  <=  '0';
    s_logisimBus57(13)  <=  '0';
    s_logisimBus57(14)  <=  '0';
    s_logisimBus57(15)  <=  '0';
    s_logisimBus57(16)  <=  '0';
    s_logisimBus57(17)  <=  '0';
    s_logisimBus57(18)  <=  '0';
    s_logisimBus57(19)  <=  '0';
    s_logisimBus57(20)  <=  '0';
    s_logisimBus57(21)  <=  '0';
    s_logisimBus57(22)  <=  '0';
    s_logisimBus57(23)  <=  '0';
    s_logisimBus57(24)  <=  '0';
    s_logisimBus57(25)  <=  '0';
    s_logisimBus57(26)  <=  '0';
    s_logisimBus57(27)  <=  '0';
    s_logisimBus57(28)  <=  '0';
    s_logisimBus57(29)  <=  '0';
    s_logisimBus57(30)  <=  '0';
    s_logisimBus57(31)  <=  '0';


   -- Constant
    s_logisimBus42(3 DOWNTO 0)  <=  X"E";


   -- Bit Extender
    s_logisimBus51(0)  <=  s_logisimNet11;
    s_logisimBus51(1)  <=  s_logisimNet11;
    s_logisimBus51(2)  <=  s_logisimNet11;
    s_logisimBus51(3)  <=  s_logisimNet11;
    s_logisimBus51(4)  <=  s_logisimNet11;
    s_logisimBus51(5)  <=  s_logisimNet11;
    s_logisimBus51(6)  <=  s_logisimNet11;
    s_logisimBus51(7)  <=  s_logisimNet11;
    s_logisimBus51(8)  <=  s_logisimNet11;
    s_logisimBus51(9)  <=  s_logisimNet11;
    s_logisimBus51(10)  <=  s_logisimNet11;
    s_logisimBus51(11)  <=  s_logisimNet11;
    s_logisimBus51(12)  <=  s_logisimNet11;
    s_logisimBus51(13)  <=  s_logisimNet11;
    s_logisimBus51(14)  <=  s_logisimNet11;
    s_logisimBus51(15)  <=  s_logisimNet11;
    s_logisimBus51(16)  <=  s_logisimNet11;
    s_logisimBus51(17)  <=  s_logisimNet11;
    s_logisimBus51(18)  <=  s_logisimNet11;
    s_logisimBus51(19)  <=  s_logisimNet11;
    s_logisimBus51(20)  <=  s_logisimNet11;
    s_logisimBus51(21)  <=  s_logisimNet11;
    s_logisimBus51(22)  <=  s_logisimNet11;
    s_logisimBus51(23)  <=  s_logisimNet11;
    s_logisimBus51(24)  <=  s_logisimNet11;
    s_logisimBus51(25)  <=  s_logisimNet11;
    s_logisimBus51(26)  <=  s_logisimNet11;
    s_logisimBus51(27)  <=  s_logisimNet11;
    s_logisimBus51(28)  <=  s_logisimNet11;
    s_logisimBus51(29)  <=  s_logisimNet11;
    s_logisimBus51(30)  <=  s_logisimNet11;
    s_logisimBus51(31)  <=  s_logisimNet11;


   -- Constant
    s_logisimBus197(4 DOWNTO 0)  <=  "1"&X"2";


   -- Constant
    s_logisimBus198(4 DOWNTO 0)  <=  "0"&X"B";


   -- Bit Extender
    s_logisimBus102(0)  <=  s_logisimBus53(0);
    s_logisimBus102(1)  <=  s_logisimBus53(1);
    s_logisimBus102(2)  <=  s_logisimBus53(2);
    s_logisimBus102(3)  <=  s_logisimBus53(3);
    s_logisimBus102(4)  <=  s_logisimBus53(4);
    s_logisimBus102(5)  <=  s_logisimBus53(5);
    s_logisimBus102(6)  <=  s_logisimBus53(6);
    s_logisimBus102(7)  <=  s_logisimBus53(7);
    s_logisimBus102(8)  <=  '0';
    s_logisimBus102(9)  <=  '0';
    s_logisimBus102(10)  <=  '0';
    s_logisimBus102(11)  <=  '0';
    s_logisimBus102(12)  <=  '0';
    s_logisimBus102(13)  <=  '0';
    s_logisimBus102(14)  <=  '0';
    s_logisimBus102(15)  <=  '0';
    s_logisimBus102(16)  <=  '0';
    s_logisimBus102(17)  <=  '0';
    s_logisimBus102(18)  <=  '0';
    s_logisimBus102(19)  <=  '0';
    s_logisimBus102(20)  <=  '0';
    s_logisimBus102(21)  <=  '0';
    s_logisimBus102(22)  <=  '0';
    s_logisimBus102(23)  <=  '0';
    s_logisimBus102(24)  <=  '0';
    s_logisimBus102(25)  <=  '0';
    s_logisimBus102(26)  <=  '0';
    s_logisimBus102(27)  <=  '0';
    s_logisimBus102(28)  <=  '0';
    s_logisimBus102(29)  <=  '0';
    s_logisimBus102(30)  <=  '0';
    s_logisimBus102(31)  <=  '0';


   -- Constant
    s_logisimBus128(4)  <=  '0';


   -- Constant
    s_logisimBus128(15 DOWNTO 5)  <=  "000"&X"00";


   -- Constant
    s_logisimBus145(0)  <=  '0';


   -- Bit Extender
    s_logisimBus184(0)  <=  s_logisimBus53(0);
    s_logisimBus184(1)  <=  s_logisimBus53(1);
    s_logisimBus184(2)  <=  s_logisimBus53(2);
    s_logisimBus184(3)  <=  s_logisimBus53(3);
    s_logisimBus184(4)  <=  s_logisimBus53(4);
    s_logisimBus184(5)  <=  s_logisimBus53(5);
    s_logisimBus184(6)  <=  s_logisimBus53(6);
    s_logisimBus184(7)  <=  s_logisimBus53(7);
    s_logisimBus184(8)  <=  s_logisimBus53(8);
    s_logisimBus184(9)  <=  s_logisimBus53(9);
    s_logisimBus184(10)  <=  s_logisimBus53(10);
    s_logisimBus184(11)  <=  s_logisimBus53(11);
    s_logisimBus184(12)  <=  s_logisimBus53(12);
    s_logisimBus184(13)  <=  s_logisimBus53(13);
    s_logisimBus184(14)  <=  s_logisimBus53(14);
    s_logisimBus184(15)  <=  s_logisimBus53(15);
    s_logisimBus184(16)  <=  s_logisimBus53(16);
    s_logisimBus184(17)  <=  s_logisimBus53(17);
    s_logisimBus184(18)  <=  s_logisimBus53(18);
    s_logisimBus184(19)  <=  s_logisimBus53(19);
    s_logisimBus184(20)  <=  s_logisimBus53(20);
    s_logisimBus184(21)  <=  s_logisimBus53(21);
    s_logisimBus184(22)  <=  s_logisimBus53(22);
    s_logisimBus184(23)  <=  s_logisimBus53(23);
    s_logisimBus184(24)  <=  s_logisimBus53(23);
    s_logisimBus184(25)  <=  s_logisimBus53(23);
    s_logisimBus184(26)  <=  s_logisimBus53(23);
    s_logisimBus184(27)  <=  s_logisimBus53(23);
    s_logisimBus184(28)  <=  s_logisimBus53(23);
    s_logisimBus184(29)  <=  s_logisimBus53(23);
    s_logisimBus184(30)  <=  s_logisimBus53(23);
    s_logisimBus184(31)  <=  s_logisimBus53(23);


   -- Constant
    s_logisimBus199(3 DOWNTO 0)  <=  X"D";


   -- Constant
    s_logisimBus200(4 DOWNTO 0)  <=  "0"&X"2";


   -- Constant
    s_logisimBus195(1 DOWNTO 0)  <=  "11";


   -- Constant
    s_logisimBus201(31 DOWNTO 0)  <=  X"00000008";


   -- Constant
    s_logisimNet202  <=  '0';


   -- Constant
    s_logisimNet203  <=  '0';


   -- Constant
    s_logisimNet3  <=  '1';


   -- NOT Gate
   s_logisimNet124 <=  NOT s_logisimBus21(0);

   -- NOT Gate
   s_logisimNet11 <=  NOT s_logisimNet39;

   -- NOT Gate
   s_logisimNet31 <=  NOT s_logisimBus53(20);

   -- NOT Gate
   s_logisimNet127 <=  NOT s_logisimBus53(27);

   -- NOT Gate
   s_logisimNet162 <=  NOT s_logisimBus53(26);

   -- NOT Gate
   s_logisimNet172 <=  NOT s_logisimNet25;

   -- NOT Gate: not_link
   s_logisimNet153 <=  NOT s_logisimNet70;

   -- NOT Gate
   s_logisimNet4 <=  NOT s_logisimNet123;

   -- ROM: ROM_1
   WITH (s_logisimBus99) SELECT s_logisimBus53 <=
      X"E3A0DB01" WHEN X"0",
      X"E3A04044" WHEN X"1",
      X"E3A0E088" WHEN X"2",
      X"E92D4010" WHEN X"3",
      X"E3A04000" WHEN X"4",
      X"E3A0E000" WHEN X"5",
      X"E8BD4010" WHEN X"6",
      X"E3A00000" WHEN X"7",
      X"E5804100" WHEN X"8",
      X"E580E104" WHEN X"9",
      X"E580D108" WHEN X"A",
      X"E12FFF10" WHEN X"B",
      X"00000000" WHEN OTHERS;

   -- ROM: ROM_2
   WITH (s_logisimBus128) SELECT s_logisimBus131 <=
      "00"&X"01" WHEN X"0000",
      "00"&X"03" WHEN X"0001",
      "01"&X"51" WHEN X"0002",
      "01"&X"91" WHEN X"0003",
      "01"&X"01" WHEN X"0004",
      "01"&X"21" WHEN X"0005",
      "01"&X"61" WHEN X"0006",
      "01"&X"A1" WHEN X"0007",
      "00"&X"02" WHEN X"0009",
      "01"&X"50" WHEN X"000A",
      "01"&X"00" WHEN X"000B",
      "00"&X"05" WHEN X"000C",
      "00"&X"07" WHEN X"000D",
      "00"&X"09" WHEN X"000E",
      "00"&X"0B" WHEN X"000F",
      "10"&X"01" WHEN X"0010",
      "00"&X"00" WHEN OTHERS;

   --------------------------------------------------------------------------------
   -- Here all normal components are defined                                     --
   --------------------------------------------------------------------------------
   bx_taken : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimNet30,
                 input2 => s_logisimNet124,
                 input3 => s_logisimNet12,
                 result => s_logisimNet64 );

   bx_arm_target : AND_GATE_BUS
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus21(31 DOWNTO 0),
                 input2 => s_logisimBus159(31 DOWNTO 0),
                 result => s_logisimBus65(31 DOWNTO 0) );

   GATES_3 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet1,
                 input2 => s_logisimNet12,
                 result => s_logisimNet52 );

   GATES_4 : XOR_GATE_BUS_ONEHOT
      GENERIC MAP ( BubblesMask => "00",
                    NrOfBits    => 32 )
      PORT MAP ( input1 => s_logisimBus57(31 DOWNTO 0),
                 input2 => s_logisimBus51(31 DOWNTO 0),
                 result => s_logisimBus75(31 DOWNTO 0) );

   GATES_5 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet13,
                 input2 => s_logisimNet112,
                 result => s_logisimNet34 );

   final_reg_we : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet18,
                 input2 => s_logisimNet24,
                 result => s_logisimNet138 );

   GATES_7 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet138,
                 input2 => s_logisimNet56,
                 result => s_logisimNet112 );

   GATES_8 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimBus53(26),
                 input2 => s_logisimNet127,
                 result => s_logisimNet80 );

   GATES_9 : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimNet52,
                 input2 => s_logisimNet82,
                 input3 => s_logisimNet66,
                 result => s_logisimNet20 );

   GATES_10 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet80,
                 input2 => s_logisimNet31,
                 result => s_logisimNet95 );

   GATES_11 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet80,
                 input2 => s_logisimBus53(20),
                 result => s_logisimNet26 );

   GATES_12 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet40,
                 input2 => s_logisimNet172,
                 result => s_logisimNet105 );

   GATES_13 : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimNet81,
                 input2 => s_logisimNet43,
                 input3 => s_logisimNet20,
                 result => s_logisimNet19 );

   branch_class : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimBus53(25),
                 input2 => s_logisimNet162,
                 input3 => s_logisimBus53(27),
                 result => s_logisimNet89 );

   GATES_15 : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimNet12,
                 input2 => s_logisimNet95,
                 input3 => s_logisimNet105,
                 result => s_logisimNet13 );

   GATES_16 : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimNet52,
                 input2 => s_logisimNet59,
                 input3 => s_logisimNet66,
                 result => s_logisimNet46 );

   GATES_17 : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimNet26,
                 input2 => s_logisimNet12,
                 input3 => s_logisimNet105,
                 result => s_logisimNet71 );

   GATES_18 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet89,
                 input2 => s_logisimBus77(3),
                 result => s_logisimNet70 );

   GATES_19 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet30,
                 input2 => s_logisimNet89,
                 result => s_logisimNet100 );

   GATES_20 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet46,
                 input2 => s_logisimNet20,
                 result => s_logisimNet90 );

   GATES_21 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet100,
                 input2 => s_logisimNet80,
                 result => s_logisimNet123 );

   is_B : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet89,
                 input2 => s_logisimNet153,
                 result => s_logisimNet132 );

   data_ram_we : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet12,
                 input2 => s_logisimNet95,
                 result => s_logisimNet140 );

   GATES_24 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet26,
                 input2 => s_logisimNet12,
                 result => s_logisimNet56 );

   GATES_25 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet12,
                 input2 => s_logisimNet70,
                 result => s_logisimNet24 );

   GATES_26 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet140,
                 input2 => s_logisimNet19,
                 result => s_logisimNet169 );

   CSPR_enable : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimNet12,
                 input2 => s_logisimNet4,
                 input3 => s_logisimBus53(20),
                 result => s_logisimNet110 );

   GATES_28 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet24,
                 input2 => s_logisimNet15,
                 result => s_logisimNet101 );

   GATES_29 : AND_GATE_3_INPUTS
      GENERIC MAP ( BubblesMask => "000" )
      PORT MAP ( input1 => s_logisimNet16,
                 input2 => s_logisimNet4,
                 input3 => s_logisimNet12,
                 result => s_logisimNet18 );

   GATES_30 : AND_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet12,
                 input2 => s_logisimNet132,
                 result => s_logisimNet15 );

   GATES_31 : OR_GATE
      GENERIC MAP ( BubblesMask => "00" )
      PORT MAP ( input1 => s_logisimNet101,
                 input2 => s_logisimNet64,
                 result => s_logisimNet170 );

   CSPR : REGISTER_FLIP_FLOP
      GENERIC MAP ( invertClock => 0,
                    nrOfBits    => 4 )
      PORT MAP ( clock       => logisimClockTree0(4),
                 clockEnable => s_logisimNet110,
                 d           => s_logisimBus106(3 DOWNTO 0),
                 q           => s_logisimBus125(3 DOWNTO 0),
                 reset       => s_logisimNet33,
                 tick        => logisimClockTree0(2) );

   RAM_1 : RAMCONTENTS_RAM_1
      PORT MAP ( address => s_logisimBus182(7 DOWNTO 0),
                 clock   => logisimClockTree0(4),
                 dataIn  => s_logisimBus21(31 DOWNTO 0),
                 dataOut => s_logisimBus10(31 DOWNTO 0),
                 oe      => '1',
                 tick    => logisimClockTree0(3),
                 we      => s_logisimNet169 );

   PLEXERS_34 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus61(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus44(31 DOWNTO 0),
                 muxOut  => s_logisimBus74(31 DOWNTO 0),
                 sel     => s_logisimNet24 );

   PLEXERS_35 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus74(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus10(31 DOWNTO 0),
                 muxOut  => s_logisimBus29(31 DOWNTO 0),
                 sel     => s_logisimNet26 );

   PLEXERS_36 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 4 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus53(15 DOWNTO 12),
                 muxIn_1 => s_logisimBus42(3 DOWNTO 0),
                 muxOut  => s_logisimBus98(3 DOWNTO 0),
                 sel     => s_logisimNet24 );

   PLEXERS_37 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 4 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus98(3 DOWNTO 0),
                 muxIn_1 => s_logisimBus53(19 DOWNTO 16),
                 muxOut  => s_logisimBus0(3 DOWNTO 0),
                 sel     => s_logisimNet13 );

   PLEXERS_38 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus29(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus9(31 DOWNTO 0),
                 muxOut  => s_logisimBus54(31 DOWNTO 0),
                 sel     => s_logisimNet13 );

   PLEXERS_39 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 4 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus53(3 DOWNTO 0),
                 muxIn_1 => s_logisimBus53(15 DOWNTO 12),
                 muxOut  => s_logisimBus142(3 DOWNTO 0),
                 sel     => s_logisimNet95 );

   PLEXERS_40 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 4 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus142(3 DOWNTO 0),
                 muxIn_1 => s_logisimBus50(3 DOWNTO 0),
                 muxOut  => s_logisimBus35(3 DOWNTO 0),
                 sel     => s_logisimNet81 );

   PLEXERS_41 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 5 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus53(11 DOWNTO 7),
                 muxIn_1 => s_logisimBus145(4 DOWNTO 0),
                 muxOut  => s_logisimBus17(4 DOWNTO 0),
                 sel     => s_logisimBus53(25) );

   PLEXERS_42 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 2 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus53(6 DOWNTO 5),
                 muxIn_1 => s_logisimBus195(1 DOWNTO 0),
                 muxOut  => s_logisimBus109(1 DOWNTO 0),
                 sel     => s_logisimBus53(25) );

   PLEXERS_43 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus58(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus9(31 DOWNTO 0),
                 muxOut  => s_logisimBus36(31 DOWNTO 0),
                 sel     => s_logisimNet25 );

   PLEXERS_44 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 32 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus21(31 DOWNTO 0),
                 muxIn_1 => s_logisimBus102(31 DOWNTO 0),
                 muxOut  => s_logisimBus161(31 DOWNTO 0),
                 sel     => s_logisimBus53(25) );

   PLEXERS_45 : Multiplexer_bus_2
      GENERIC MAP ( nrOfBits => 8 )
      PORT MAP ( enable  => '1',
                 muxIn_0 => s_logisimBus36(9 DOWNTO 2),
                 muxIn_1 => s_logisimBus154(9 DOWNTO 2),
                 muxOut  => s_logisimBus182(7 DOWNTO 0),
                 sel     => s_logisimNet81 );

   ARITH_46 : Comparator
      GENERIC MAP ( nrOfBits       => 24,
                    twosComplement => 1 )
      PORT MAP ( aEqualsB      => s_logisimNet30,
                 aGreaterThanB => OPEN,
                 aLessThanB    => OPEN,
                 dataA         => s_logisimBus53(27 DOWNTO 4),
                 dataB         => s_logisimBus160(23 DOWNTO 0) );

   ARITH_47 : Comparator
      GENERIC MAP ( nrOfBits       => 3,
                    twosComplement => 1 )
      PORT MAP ( aEqualsB      => s_logisimNet1,
                 aGreaterThanB => OPEN,
                 aLessThanB    => OPEN,
                 dataA         => s_logisimBus32(2 DOWNTO 0),
                 dataB         => s_logisimBus196(2 DOWNTO 0) );

   ARITH_48 : Comparator
      GENERIC MAP ( nrOfBits       => 5,
                    twosComplement => 1 )
      PORT MAP ( aEqualsB      => s_logisimNet82,
                 aGreaterThanB => OPEN,
                 aLessThanB    => OPEN,
                 dataA         => s_logisimBus197(4 DOWNTO 0),
                 dataB         => s_logisimBus55(4 DOWNTO 0) );

   ARITH_49 : Comparator
      GENERIC MAP ( nrOfBits       => 5,
                    twosComplement => 1 )
      PORT MAP ( aEqualsB      => s_logisimNet59,
                 aGreaterThanB => OPEN,
                 aLessThanB    => OPEN,
                 dataA         => s_logisimBus198(4 DOWNTO 0),
                 dataB         => s_logisimBus55(4 DOWNTO 0) );

   ARITH_50 : Comparator
      GENERIC MAP ( nrOfBits       => 4,
                    twosComplement => 1 )
      PORT MAP ( aEqualsB      => s_logisimNet66,
                 aGreaterThanB => OPEN,
                 aLessThanB    => OPEN,
                 dataA         => s_logisimBus199(3 DOWNTO 0),
                 dataB         => s_logisimBus53(19 DOWNTO 16) );

   ARITH_51 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => s_logisimNet11,
                 carryOut => OPEN,
                 dataA    => s_logisimBus58(31 DOWNTO 0),
                 dataB    => s_logisimBus75(31 DOWNTO 0),
                 result   => s_logisimBus9(31 DOWNTO 0) );

   ARITH_52 : Shifter_32_bit
      GENERIC MAP ( shifterMode => 0 )
      PORT MAP ( dataA       => s_logisimBus184(31 DOWNTO 0),
                 result      => s_logisimBus130(31 DOWNTO 0),
                 shiftAmount => s_logisimBus200(4 DOWNTO 0) );

   ARITH_53 : Adder
      GENERIC MAP ( extendedBits => 33,
                    nrOfBits     => 32 )
      PORT MAP ( carryIn  => '0',
                 carryOut => OPEN,
                 dataA    => s_logisimBus130(31 DOWNTO 0),
                 dataB    => s_logisimBus201(31 DOWNTO 0),
                 result   => s_logisimBus37(31 DOWNTO 0) );


   --------------------------------------------------------------------------------
   -- Here all sub-circuits are defined                                          --
   --------------------------------------------------------------------------------

   pc_fetch_1 : pc_fetch
      PORT MAP ( BRANCH            => s_logisimNet170,
                 CLK               => s_logisimNet48,
                 IMM               => s_logisimBus37(31 DOWNTO 0),
                 RST               => s_logisimNet33,
                 abs_select        => s_logisimNet64,
                 abs_target        => s_logisimBus65(31 DOWNTO 0),
                 hold              => s_logisimNet79,
                 logisimClockTree0 => logisimClockTree0,
                 pc_out            => s_logisimBus99(3 DOWNTO 0),
                 pc_plus4          => s_logisimBus44(31 DOWNTO 0) );

   block_transfer_control_1 : block_transfer_control
      PORT MAP ( active            => s_logisimNet81,
                 addr              => OPEN,
                 base_in           => s_logisimBus58(31 DOWNTO 0),
                 clk               => s_logisimNet48,
                 done              => s_logisimNet113,
                 hold_pc           => s_logisimNet79,
                 is_pop            => s_logisimNet46,
                 logisimClockTree0 => logisimClockTree0,
                 pop_request       => s_logisimNet47,
                 reg_idx           => s_logisimBus50(3 DOWNTO 0),
                 reg_list_in       => s_logisimBus53(15 DOWNTO 0),
                 reg_selected      => s_logisimNet43,
                 rst               => s_logisimNet33,
                 start             => s_logisimNet90,
                 transfer_address  => s_logisimBus154(31 DOWNTO 0) );

   reg16x32_1_1 : reg16x32_1
      PORT MAP ( CLK               => s_logisimNet48,
                 R0_OUTPUT         => s_logisimBus93(31 DOWNTO 0),
                 R10_OUTPUT        => s_logisimBus107(31 DOWNTO 0),
                 R11_OUTPUT        => s_logisimBus8(31 DOWNTO 0),
                 R12_OUTPUT        => s_logisimBus183(31 DOWNTO 0),
                 R13_OUTPUT        => s_logisimBus152(31 DOWNTO 0),
                 R14_OUTPUT        => s_logisimBus144(31 DOWNTO 0),
                 R15_OUTPUT        => s_logisimBus94(31 DOWNTO 0),
                 R1_OUTPUT         => s_logisimBus143(31 DOWNTO 0),
                 R2_OUPUT          => s_logisimBus84(31 DOWNTO 0),
                 R3_OUTPUT         => s_logisimBus181(31 DOWNTO 0),
                 R4_OUTPUT         => s_logisimBus173(31 DOWNTO 0),
                 R5_OUTPUT         => s_logisimBus136(31 DOWNTO 0),
                 R6_OUTPUT         => s_logisimBus167(31 DOWNTO 0),
                 R7_OUTPUT         => s_logisimBus126(31 DOWNTO 0),
                 R8_OUTPUT         => s_logisimBus119(31 DOWNTO 0),
                 R9_OUTPUT         => s_logisimBus158(31 DOWNTO 0),
                 RA                => s_logisimBus53(19 DOWNTO 16),
                 RB                => s_logisimBus35(3 DOWNTO 0),
                 RD_A              => s_logisimBus58(31 DOWNTO 0),
                 RD_B              => s_logisimBus21(31 DOWNTO 0),
                 RST               => s_logisimNet33,
                 WA                => s_logisimBus0(3 DOWNTO 0),
                 WA2               => s_logisimBus86(3 DOWNTO 0),
                 WD                => s_logisimBus54(31 DOWNTO 0),
                 WD2               => s_logisimBus9(31 DOWNTO 0),
                 WE                => s_logisimNet34,
                 WE2               => s_logisimNet71,
                 logisimClockTree0 => logisimClockTree0 );

   barrel_32b_1 : barrel_32b
      PORT MAP ( amnt              => s_logisimBus17(4 DOWNTO 0),
                 input_32b         => s_logisimBus161(31 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 outp              => s_logisimBus69(31 DOWNTO 0),
                 typ               => s_logisimBus109(1 DOWNTO 0) );

   ALU_1 : ALU
      PORT MAP ( A                 => s_logisimBus58(31 DOWNTO 0),
                 B                 => s_logisimBus69(31 DOWNTO 0),
                 C                 => s_logisimBus106(1),
                 Cflag             => s_logisimNet202,
                 N                 => s_logisimBus106(3),
                 V                 => s_logisimBus106(0),
                 Z                 => s_logisimBus106(2),
                 a_inv             => s_logisimBus131(7),
                 b_inv             => s_logisimBus131(6),
                 cin_sel           => s_logisimBus120(1 DOWNTO 0),
                 engine_sel        => s_logisimBus2(1 DOWNTO 0),
                 logic_sel         => s_logisimBus129(2 DOWNTO 0),
                 logisimClockTree0 => logisimClockTree0,
                 result            => s_logisimBus61(31 DOWNTO 0),
                 unused            => s_logisimNet203,
                 write_enable      => s_logisimBus131(0),
                 write_enable_out  => s_logisimNet16 );

   condition_checker_1 : condition_checker
      PORT MAP ( C                 => s_logisimBus125(1),
                 N                 => s_logisimBus125(3),
                 Output_1          => s_logisimNet12,
                 V                 => s_logisimBus125(0),
                 Z                 => s_logisimBus125(2),
                 cond              => s_logisimBus53(31 DOWNTO 28),
                 logisimClockTree0 => logisimClockTree0 );

END platformIndependent;
