library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_aluout is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           alu_out : in STD_LOGIC_VECTOR(31 downto 0);
           reg_write : in STD_LOGIC;
           alu_out_reg : out STD_LOGIC_VECTOR(31 downto 0));
end reg_aluout;

architecture Behavioral of reg_aluout is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            alu_out_reg <= (others => '0');
        elsif rising_edge(clk) then
            if reg_write = '1' then
                alu_out_reg <= alu_out;
            end if;
        end if;
    end process;
end Behavioral;