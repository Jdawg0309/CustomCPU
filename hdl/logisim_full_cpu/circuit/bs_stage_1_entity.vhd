--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : bs_stage_1                                                   ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY bs_stage_1 IS
   PORT ( enable            : IN  std_logic;
          input_32          : IN  std_logic_vector( 31 DOWNTO 0 );
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          typ_2             : IN  std_logic_vector( 1 DOWNTO 0 );
          out_1             : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY bs_stage_1;
