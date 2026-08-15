--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : partial_products                                             ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY partial_products IS
   PORT ( Rm                : IN  std_logic_vector( 31 DOWNTO 0 );
          Rs                : IN  std_logic_vector( 31 DOWNTO 0 );
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          p0                : OUT std_logic_vector( 31 DOWNTO 0 );
          p1                : OUT std_logic_vector( 31 DOWNTO 0 );
          p10               : OUT std_logic_vector( 31 DOWNTO 0 );
          p11               : OUT std_logic_vector( 31 DOWNTO 0 );
          p12               : OUT std_logic_vector( 31 DOWNTO 0 );
          p13               : OUT std_logic_vector( 31 DOWNTO 0 );
          p14               : OUT std_logic_vector( 31 DOWNTO 0 );
          p15               : OUT std_logic_vector( 31 DOWNTO 0 );
          p16               : OUT std_logic_vector( 31 DOWNTO 0 );
          p17               : OUT std_logic_vector( 31 DOWNTO 0 );
          p18               : OUT std_logic_vector( 31 DOWNTO 0 );
          p19               : OUT std_logic_vector( 31 DOWNTO 0 );
          p2                : OUT std_logic_vector( 31 DOWNTO 0 );
          p20               : OUT std_logic_vector( 31 DOWNTO 0 );
          p21               : OUT std_logic_vector( 31 DOWNTO 0 );
          p22               : OUT std_logic_vector( 31 DOWNTO 0 );
          p23               : OUT std_logic_vector( 31 DOWNTO 0 );
          p24               : OUT std_logic_vector( 31 DOWNTO 0 );
          p25               : OUT std_logic_vector( 31 DOWNTO 0 );
          p26               : OUT std_logic_vector( 31 DOWNTO 0 );
          p27               : OUT std_logic_vector( 31 DOWNTO 0 );
          p28               : OUT std_logic_vector( 31 DOWNTO 0 );
          p29               : OUT std_logic_vector( 31 DOWNTO 0 );
          p3                : OUT std_logic_vector( 31 DOWNTO 0 );
          p30               : OUT std_logic_vector( 31 DOWNTO 0 );
          p31               : OUT std_logic_vector( 31 DOWNTO 0 );
          p4                : OUT std_logic_vector( 31 DOWNTO 0 );
          p5                : OUT std_logic_vector( 31 DOWNTO 0 );
          p6                : OUT std_logic_vector( 31 DOWNTO 0 );
          p7                : OUT std_logic_vector( 31 DOWNTO 0 );
          p8                : OUT std_logic_vector( 31 DOWNTO 0 );
          p9                : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY partial_products;
