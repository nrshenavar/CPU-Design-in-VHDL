library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is
    Port (
        opcode      : in  STD_LOGIC_VECTOR(5 downto 0);
        RegWrite    : out STD_LOGIC;
        MemRead     : out STD_LOGIC;
        MemWrite    : out STD_LOGIC;
        ALUSrcA     : out STD_LOGIC;
        ALUSrcB     : out STD_LOGIC;
        PCSource    : out STD_LOGIC_VECTOR(1 downto 0)
    );
end control_unit;

architecture Behavioral of control_unit is
begin
    process(opcode)
    begin
        -- Default control signals
        RegWrite <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        ALUSrcA <= '0';
        ALUSrcB <= '0';
        PCSource <= "00";

        case opcode is
            when "000000" =>  -- R-type instructions
                RegWrite <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= '0';
                PCSource <= "00";
            when "100011" =>  -- lw
                RegWrite <= '1';
                MemRead <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '1';
                PCSource <= "00";
            when "101011" =>  -- sw
                MemWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '1';
                PCSource <= "00";
            when "000100" =>  -- beq
                PCSource <= "01";
            when others =>
                -- Handle other opcodes as needed
                null;
        end case;
    end process;
end Behavioral;