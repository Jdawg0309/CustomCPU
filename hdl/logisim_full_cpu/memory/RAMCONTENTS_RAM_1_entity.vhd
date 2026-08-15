--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : RAMCONTENTS_RAM_1                                            ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY RAMCONTENTS_RAM_1 IS
   PORT ( address : IN  std_logic_vector( 7 DOWNTO 0 );
          clock   : IN  std_logic;
          dataIn  : IN  std_logic_vector( 31 DOWNTO 0 );
          oe      : IN  std_logic;
          tick    : IN  std_logic;
          we      : IN  std_logic;
          dataOut : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY RAMCONTENTS_RAM_1;
