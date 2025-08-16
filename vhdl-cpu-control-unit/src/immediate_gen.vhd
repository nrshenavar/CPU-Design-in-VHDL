library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity immediate_gen is
    Port ( instruction : in STD_LOGIC_VECTOR(31 downto 0);
           immediate : out STD_LOGIC_VECTOR(15 downto 0));
end immediate_gen;

architecture Behavioral of immediate_gen is
begin
    process(instruction)
    begin
        -- Extract the immediate value from the instruction
        immediate <= instruction(15 downto 0);
    end process;
end Behavioral;