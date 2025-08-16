library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reg_pc is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        pc_in   : in std_logic_vector(31 downto 0);
        pc_out  : out std_logic_vector(31 downto 0)
    );
end entity reg_pc;

architecture behavior of reg_pc is
    signal pc_value : std_logic_vector(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_value <= (others => '0');
        elsif rising_edge(clk) then
            pc_value <= pc_in;
        end if;
    end process;

    pc_out <= pc_value;
end architecture behavior;