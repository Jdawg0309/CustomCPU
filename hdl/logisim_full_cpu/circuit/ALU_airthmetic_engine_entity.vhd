--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : ALU_airthmetic_engine                                        ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY ALU_airthmetic_engine IS
   PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
          B                 : IN  std_logic_vector( 31 DOWNTO 0 );
          Cflag             : IN  std_logic;
          Cin_sel           : IN  std_logic_vector( 1 DOWNTO 0 );
          a_inversion       : IN  std_logic;
          b_inversion       : IN  std_logic;
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          unused            : IN  std_logic;
          Cout              : OUT std_logic;
          Result            : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY ALU_airthmetic_engine;
