--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : csa_3to_2                                                    ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY csa_3to_2 IS
   PORT ( X                 : IN  std_logic_vector( 31 DOWNTO 0 );
          Y                 : IN  std_logic_vector( 31 DOWNTO 0 );
          Z                 : IN  std_logic_vector( 31 DOWNTO 0 );
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          carry             : OUT std_logic_vector( 31 DOWNTO 0 );
          sum               : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY csa_3to_2;
