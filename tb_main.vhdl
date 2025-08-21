-- Testbench for CPU-Design-in-VHDL
-- This testbench drives the main processor, loads mem_input, 
-- and writes mem_output as described in the assignment.
-- Put your encoded instructions (8-bit per line, four lines per instruction) 
-- inside mem_input before simulation.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_main is
end tb_main;

architecture behavior of tb_main is

    -- Component Declaration for the Unit Under Test (UUT)
    component main
        Port (
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC
        );
    end component;

    -- Clock and reset signals
    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: main
        Port map (
            clk   => clk,
            reset => reset
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- hold reset state for 50 ns.
        reset <= '1';
        wait for 50 ns;  
        reset <= '0';

        -- run long enough to execute all instructions
        wait for 2000 ns;  

        -- stop simulation
        assert false report "Simulation finished." severity failure;
    end process;

end behavior;
