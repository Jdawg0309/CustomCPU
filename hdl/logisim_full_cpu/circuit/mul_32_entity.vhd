--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : mul_32                                                       ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY mul_32 IS
   PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
          B                 : IN  std_logic_vector( 31 DOWNTO 0 );
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          carry             : OUT std_logic_vector( 31 DOWNTO 0 );
          sum               : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY mul_32;
