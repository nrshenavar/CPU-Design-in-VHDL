library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port (
        A       : in  STD_LOGIC_VECTOR(31 downto 0);
        B       : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUOp   : in  STD_LOGIC_VECTOR(2 downto 0);
        Result   : out STD_LOGIC_VECTOR(31 downto 0);
        Zero    : out STD_LOGIC
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(A, B, ALUOp)
    begin
        case ALUOp is
            when "000" =>  -- ADD
                Result <= A + B;
            when "001" =>  -- SUB
                Result <= A - B;
            when "010" =>  -- AND
                Result <= A and B;
            when "011" =>  -- OR
                Result <= A or B;
            when others =>
                Result <= (others => '0');  -- Default case
        end case;

        -- Set Zero flag
        if Result = (others => '0') then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
    end process;
end Behavioral;