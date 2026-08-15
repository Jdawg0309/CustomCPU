--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : pg_cell                                                      ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY pg_cell IS
   PORT ( G                 : IN  std_logic;
          G_prev            : IN  std_logic;
          P                 : IN  std_logic;
          P_Prev            : IN  std_logic;
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          G_out             : OUT std_logic;
          P_out             : OUT std_logic );
END ENTITY pg_cell;
