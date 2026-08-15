--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : barrel_32b                                                   ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY barrel_32b IS
   PORT ( amnt              : IN  std_logic_vector( 4 DOWNTO 0 );
          input_32b         : IN  std_logic_vector( 31 DOWNTO 0 );
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          typ               : IN  std_logic_vector( 1 DOWNTO 0 );
          outp              : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY barrel_32b;
