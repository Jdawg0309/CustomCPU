--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : kogge_stone_1b                                               ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY kogge_stone_1b IS
   PORT ( A                 : IN  std_logic;
          B                 : IN  std_logic;
          C_in              : IN  std_logic;
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          g                 : OUT std_logic;
          p                 : OUT std_logic;
          sum               : OUT std_logic );
END ENTITY kogge_stone_1b;
