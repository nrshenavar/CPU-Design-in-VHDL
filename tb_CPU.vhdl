-- filepath: c:\Users\ASUS\Documents\GitHub\CPU-Design-in-VHDL\tb_cpu.vhdl

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_CPU is
end tb_CPU;

architecture Behavioral of tb_CPU is

    -- DUT signals
    signal CLK   : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';

    -- Instantiate the CPU
    component CPU
        Port (
            CLK   : in  STD_LOGIC;
            RESET : in  STD_LOGIC
        );
    end component;

begin

    -- Instantiate DUT
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
        wait for 1000 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;