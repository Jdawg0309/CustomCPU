--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : Multiplexer_16                                               ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY Multiplexer_16 IS
   PORT ( enable   : IN  std_logic;
          muxIn_0  : IN  std_logic;
          muxIn_1  : IN  std_logic;
          muxIn_10 : IN  std_logic;
          muxIn_11 : IN  std_logic;
          muxIn_12 : IN  std_logic;
          muxIn_13 : IN  std_logic;
          muxIn_14 : IN  std_logic;
          muxIn_15 : IN  std_logic;
          muxIn_2  : IN  std_logic;
          muxIn_3  : IN  std_logic;
          muxIn_4  : IN  std_logic;
          muxIn_5  : IN  std_logic;
          muxIn_6  : IN  std_logic;
          muxIn_7  : IN  std_logic;
          muxIn_8  : IN  std_logic;
          muxIn_9  : IN  std_logic;
          sel      : IN  std_logic_vector( 3 DOWNTO 0 );
          muxOut   : OUT std_logic );
END ENTITY Multiplexer_16;
