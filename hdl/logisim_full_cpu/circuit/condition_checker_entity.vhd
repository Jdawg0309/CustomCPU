--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : condition_checker                                            ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY condition_checker IS
   PORT ( C                 : IN  std_logic;
          N                 : IN  std_logic;
          V                 : IN  std_logic;
          Z                 : IN  std_logic;
          cond              : IN  std_logic_vector( 3 DOWNTO 0 );
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          Output_1          : OUT std_logic );
END ENTITY condition_checker;
