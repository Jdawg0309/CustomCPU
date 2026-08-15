--==============================================================================
--== Logisim-evolution goes FPGA automatic generated VHDL code                ==
--== https://github.com/logisim-evolution/                                    ==
--==                                                                          ==
--==                                                                          ==
--== Project   : sandbox_armv4t                                               ==
--== Component : Multiplexer_bus_16                                           ==
--==                                                                          ==
--==============================================================================

ARCHITECTURE platformIndependent OF Multiplexer_bus_16 IS 

BEGIN

   makeMux : PROCESS(enable,
                     muxIn_0,
                     muxIn_1,
                     muxIn_2,
                     muxIn_3,
                     muxIn_4,
                     muxIn_5,
                     muxIn_6,
                     muxIn_7,
                     muxIn_8,
                     muxIn_9,
                     muxIn_10,
                     muxIn_11,
                     muxIn_12,
                     muxIn_13,
                     muxIn_14,
                     muxIn_15,
                     sel) IS
   BEGIN
      IF (enable = '0') THEN
         muxOut <= (OTHERS => '0');
                        ELSE
         CASE (sel) IS
            WHEN X"0" => muxOut <= muxIn_0;
            WHEN X"1" => muxOut <= muxIn_1;
            WHEN X"2" => muxOut <= muxIn_2;
            WHEN X"3" => muxOut <= muxIn_3;
            WHEN X"4" => muxOut <= muxIn_4;
            WHEN X"5" => muxOut <= muxIn_5;
            WHEN X"6" => muxOut <= muxIn_6;
            WHEN X"7" => muxOut <= muxIn_7;
            WHEN X"8" => muxOut <= muxIn_8;
            WHEN X"9" => muxOut <= muxIn_9;
            WHEN X"A" => muxOut <= muxIn_10;
            WHEN X"B" => muxOut <= muxIn_11;
            WHEN X"C" => muxOut <= muxIn_12;
            WHEN X"D" => muxOut <= muxIn_13;
            WHEN X"E" => muxOut <= muxIn_14;
            WHEN OTHERS  => muxOut <= muxIn_15;
         END CASE;
      END IF;
   END PROCESS makeMux;

END platformIndependent;
