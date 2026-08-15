--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : Multiplexer_bus_16                                           ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY Multiplexer_bus_16 IS
   GENERIC ( nrOfBits : INTEGER );
   PORT ( enable   : IN  std_logic;
          muxIn_0  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_1  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_10 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_11 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_12 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_13 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_14 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_15 : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_2  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_3  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_4  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_5  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_6  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_7  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_8  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          muxIn_9  : IN  std_logic_vector( (nrOfBits - 1) DOWNTO 0 );
          sel      : IN  std_logic_vector( 3 DOWNTO 0 );
          muxOut   : OUT std_logic_vector( (nrOfBits - 1) DOWNTO 0 ) );
END ENTITY Multiplexer_bus_16;
