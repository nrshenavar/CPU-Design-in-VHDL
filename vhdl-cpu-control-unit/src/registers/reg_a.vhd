library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_a is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           write_enable : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(31 downto 0);
           data_out : out STD_LOGIC_VECTOR(31 downto 0));
end reg_a;

architecture Behavioral of reg_a is
    signal reg_a_value : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg_a_value <= (others => '0');
        elsif rising_edge(clk) then
            if write_enable = '1' then
                reg_a_value <= data_in;
            end if;
        end if;
    end process;

    data_out <= reg_a_value;
end Behavioral;