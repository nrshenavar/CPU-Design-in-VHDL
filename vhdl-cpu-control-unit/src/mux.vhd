library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux is
    Port ( 
        sel : in STD_LOGIC_VECTOR(1 downto 0);
        a : in STD_LOGIC_VECTOR(31 downto 0);
        b : in STD_LOGIC_VECTOR(31 downto 0);
        c : in STD_LOGIC_VECTOR(31 downto 0);
        d : in STD_LOGIC_VECTOR(31 downto 0);
        y : out STD_LOGIC_VECTOR(31 downto 0)
    );
end mux;

architecture Behavioral of mux is
begin
    process(sel, a, b, c, d)
    begin
        case sel is
            when "00" =>
                y <= a;
            when "01" =>
                y <= b;
            when "10" =>
                y <= c;
            when "11" =>
                y <= d;
            when others =>
                y <= (others => '0'); -- Default case
        end case;
    end process;
end Behavioral;