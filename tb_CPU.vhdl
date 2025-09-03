-- filepath: c:\Users\ASUS\Documents\GitHub\CPU-Design-in-VHDL\tb_CPU.vhdl

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_CPU is
end tb_CPU;

architecture Behavioral of tb_CPU is

    signal CLK   : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';

    component CPU
        Port (
            CLK   : in  STD_LOGIC;
            RESET : in  STD_LOGIC
        );
    end component;

begin

    UUT: CPU
        port map (
            CLK   => CLK,
            RESET => RESET
        );

    -- Clock generation: 10ns period
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initial reset
        RESET <= '1';
        wait for 20 ns;
        RESET <= '0';

        -- Wait for enough cycles for CPU to process instructions
        wait for 2000 ns; -- Increase if needed for your program

        -- Print message to simulator console
        report "Simulation finished. Please check mem_output.txt for results.";

        -- End simulation
        wait;
    end process;

end Behavioral;