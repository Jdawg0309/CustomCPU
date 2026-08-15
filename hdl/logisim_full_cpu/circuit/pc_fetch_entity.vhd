--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : pc_fetch                                                     ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY pc_fetch IS
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
END ENTITY pc_fetch;
