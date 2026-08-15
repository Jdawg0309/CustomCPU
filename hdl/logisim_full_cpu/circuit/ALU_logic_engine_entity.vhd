--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : ALU_logic_engine                                             ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY ALU_logic_engine IS
   PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
          B                 : IN  std_logic_vector( 31 DOWNTO 0 );
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          select_bit        : IN  std_logic_vector( 2 DOWNTO 0 );
          result            : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY ALU_logic_engine;
