--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : block_transfer_control                                       ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY block_transfer_control IS
   PORT ( base_in           : IN  std_logic_vector( 31 DOWNTO 0 );
          clk               : IN  std_logic;
          is_pop            : IN  std_logic;
          logisimClockTree0 : IN  std_logic_vector( 4 DOWNTO 0 );
          reg_list_in       : IN  std_logic_vector( 15 DOWNTO 0 );
          rst               : IN  std_logic;
          start             : IN  std_logic;
          active            : OUT std_logic;
          addr              : OUT std_logic_vector( 31 DOWNTO 0 );
          done              : OUT std_logic;
          hold_pc           : OUT std_logic;
          pop_request       : OUT std_logic;
          reg_idx           : OUT std_logic_vector( 3 DOWNTO 0 );
          reg_selected      : OUT std_logic;
          transfer_address  : OUT std_logic_vector( 31 DOWNTO 0 ) );
END ENTITY block_transfer_control;
