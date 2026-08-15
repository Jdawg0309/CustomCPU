--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : ks_32b                                                       ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY ks_32b IS
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
END ENTITY ks_32b;
