--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : pp_row_32                                                    ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY pp_row_32 IS
   PORT ( Rm                : IN  std_logic_vector( 31 DOWNTO 0 );
          Rs_bit            : IN  std_logic;
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          result            : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY pp_row_32;
