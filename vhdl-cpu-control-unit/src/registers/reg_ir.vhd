library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_ir is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(31 downto 0);
           load : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(31 downto 0));
end reg_ir;

architecture Behavioral of reg_ir is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                data_out <= data_in;
            end if;
        end if;
    end process;
end Behavioral;