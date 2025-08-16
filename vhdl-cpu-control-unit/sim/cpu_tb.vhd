library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
end cpu_tb;

architecture behavior of cpu_tb is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal mem_output : std_logic_vector(31 downto 0);
    
    -- Instantiate the CPU design here
    -- signal declarations for registers, ALU, control unit, etc.

begin
    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Reset process
    reset_process : process
    begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        -- Load instructions from mem_input.txt
        -- Initialize the CPU and start the simulation
    end process;

    -- Output capturing process
    output_process : process
    begin
        wait until rising_edge(clk);
        -- Capture the output from the CPU
        -- Write to mem_output.txt
    end process;

end behavior;