-- tb_main.vhdl
-- Testbench for controller.vhdl

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_main is
end tb_main;

architecture sim of tb_main is
  -- Clock period
  constant CLK_PERIOD : time := 10 ns;

  -- Signals
  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';

begin
  --------------------------------------------------------------------
  -- Instantiate DUT (controller is top-level)
  --------------------------------------------------------------------
  UUT : entity work.controller
    port map (
      CLK  => clk,
      RST  => reset
      -- no more ports if controller is self-contained
    );

  --------------------------------------------------------------------
  -- Clock generation
  --------------------------------------------------------------------
  clk_process : process
  begin
    while true loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
  end process;

  --------------------------------------------------------------------
  -- Stimulus
  --------------------------------------------------------------------
  stim_proc : process
  begin
    -- Reset active
    reset <= '1';
    wait for 2*CLK_PERIOD;
    reset <= '0';

    -- Run processor long enough to execute program
    wait for 2000 ns;

    assert false report "Simulation finished." severity failure;
  end process;

end sim;
