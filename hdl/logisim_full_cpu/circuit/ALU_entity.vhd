--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : ALU                                                          ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY ALU IS
   PORT ( A                 : IN  std_logic_vector( 31 DOWNTO 0 );
          B                 : IN  std_logic_vector( 31 DOWNTO 0 );
          Cflag             : IN  std_logic;
          a_inv             : IN  std_logic;
          b_inv             : IN  std_logic;
          cin_sel           : IN  std_logic_vector( 1 DOWNTO 0 );
          engine_sel        : IN  std_logic_vector( 1 DOWNTO 0 );
          logic_sel         : IN  std_logic_vector( 2 DOWNTO 0 );
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          unused            : IN  std_logic;
          write_enable      : IN  std_logic;
          C                 : OUT std_logic;
          N                 : OUT std_logic;
          V                 : OUT std_logic;
          Z                 : OUT std_logic;
          result            : OUT std_logic_vector( 31 DOWNTO 0 );
          write_enable_out  : OUT std_logic );
END ENTITY ALU;
