library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR_MUD is
    Port (
        A      : in  STD_LOGIC_VECTOR(31 downto 0);
        B      : in  STD_LOGIC_VECTOR(31 downto 0);
        opcode : in  STD_LOGIC_VECTOR(3 downto 0);
        F      : out STD_LOGIC_VECTOR(31 downto 0)
    );
end OR_MUD;

architecture Behavioral of OR_MUD is
begin
    -- Perform bitwise OR only when opcode is "0001"
    F <= A or B when opcode = "0001" else (others => '0');
end Behavioral;
