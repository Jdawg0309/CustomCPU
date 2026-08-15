--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : main                                                         ==
--==                                                                          ==
--==============================================================================


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY main IS
   PORT ( Input_1                 : IN  std_logic;
          logisimClockTree0       : IN  std_logic_vector( 4 DOWNTO 0 );
          Output_1                : OUT std_logic;
          Output_bus_1            : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_10           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_11           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_12           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_13           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_14           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_15           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_16           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_17           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_18           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_19           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_2            : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_20           : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_3            : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_4            : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_5            : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_6            : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_7            : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_8            : OUT std_logic_vector( 31 DOWNTO 0 );
          Output_bus_9            : OUT std_logic_vector( 31 DOWNTO 0 );
          RD_A                    : OUT std_logic_vector( 31 DOWNTO 0 );
          bl_taken                : OUT std_logic;
          branch_taken            : OUT std_logic;
          condition_pass          : OUT std_logic;
          is_BL                   : OUT std_logic;
          is_BX                   : OUT std_logic;
          is_LDR                  : OUT std_logic;
          is_STR                  : OUT std_logic;
          ldr_reg_we              : OUT std_logic;
          mem_class               : OUT std_logic;
          mem_offset              : OUT std_logic_vector( 31 DOWNTO 0 );
          memory_address          : OUT std_logic_vector( 31 DOWNTO 0 );
          memory_offset_effective : OUT std_logic_vector( 31 DOWNTO 0 );
          normal_reg_WE           : OUT std_logic );
END ENTITY main;
