--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : reg16x32_1                                                   ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY reg16x32_1 IS
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
END ENTITY reg16x32_1;
