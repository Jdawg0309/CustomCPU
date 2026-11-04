-- Testbench for the VHDL that Logisim-evolution exports from `main`
-- (tools/vhdl_export.py).  Nothing in the CPU is modelled here: the clock
-- comes from Logisim's own exported LogisimClockComponent, wired the way its
-- FPGA top-level shell wires it, and `main` is the exported entity, untouched.
--
-- Clocking: one fast global clock.  LogisimClockComponent turns it into the
-- 5-bit clock bus the design expects -- bit 4 the global clock, bit 2 a
-- one-cycle "rising tick" (registers), bit 3 a "falling tick" (the RAM, which
-- the design triggers on the falling edge).  The exported RAM is an FPGA-style
-- registered RAM with a 3-stage tick pipeline, so each CPU half-cycle must be
-- several global cycles long; HALF_TICKS sets that.
--
-- This file only drives clock and reset and decides when to stop.  Register
-- and RAM contents are read afterwards from the VCD waveform GHDL records
-- (tests/vhdl_run.py), so nothing here reaches inside the design.
--
-- Output: one line, "CYCLES <n> HALT <0|1>".
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity tb_main is
  generic (MAX_CYCLES : integer := 3000;
           HALF_TICKS : integer := 8);
end entity tb_main;

architecture sim of tb_main is
  signal gclk     : std_logic := '0';
  signal clockBus : std_logic_vector(4 downto 0);
  signal rst      : std_logic := '1';
  signal halt     : std_logic;
  signal running  : boolean := true;
begin
  gclk <= not gclk after 5 ns when running else gclk;

  clk : entity work.LogisimClockComponent
    generic map (highTicks => HALF_TICKS, lowTicks => HALF_TICKS, nrOfBits => 5, phase => 1)
    port map (clockTick => '1', globalClock => gclk, clockBus => clockBus);

  dut : entity work.main
    port map (logisimClockTree0 => clockBus, rst => rst, halt => halt);

  control : process
    variable l : line;
    variable cycles : integer := 0;
    variable halted : boolean := false;
  begin
    -- two full CPU cycles in reset
    for i in 1 to 2 loop
      wait until rising_edge(gclk) and clockBus(2) = '1';
    end loop;
    rst <= '0';
    -- halt is sampled mid-cycle, at the falling tick, and the run stops before
    -- the next rising tick -- like Logisim's `--tty halt`, the halting
    -- instruction's own clock edge never happens.
    while cycles < MAX_CYCLES loop
      wait until rising_edge(gclk) and clockBus(3) = '1';
      cycles := cycles + 1;
      if halt = '1' then
        halted := true;
        exit;
      end if;
    end loop;
    -- let a write already in the RAM's 3-stage pipeline land; fewer than
    -- HALF_TICKS global cycles, so no further rising tick occurs
    for i in 1 to 4 loop
      wait until rising_edge(gclk);
    end loop;
    write(l, string'("CYCLES ") & integer'image(cycles) & " HALT "
             & integer'image(boolean'pos(halted)));
    writeline(output, l);
    running <= false;
    wait;
  end process;
end architecture sim;
