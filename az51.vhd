library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterBank is
    Port (
        clk           : in  STD_LOGIC;
        RegWrite      : in  STD_LOGIC;
        ReadRegister1 : in  STD_LOGIC_VECTOR(4 downto 0);
        ReadRegister2 : in  STD_LOGIC_VECTOR(4 downto 0);
        WriteRegister : in  STD_LOGIC_VECTOR(4 downto 0);
        WriteData     : in  STD_LOGIC_VECTOR(31 downto 0);
        ReadData1     : out STD_LOGIC_VECTOR(31 downto 0);
        ReadData2     : out STD_LOGIC_VECTOR(31 downto 0)
    );
end RegisterBank;

architecture Behavioral of RegisterBank is
    type reg_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal Registers : reg_array := (others => (others => '0'));
begin

    -- Combinational read
    process(ReadRegister1, ReadRegister2, Registers)
    begin
        ReadData1 <= Registers(to_integer(unsigned(ReadRegister1)));
        ReadData2 <= Registers(to_integer(unsigned(ReadRegister2)));
    end process;

    -- Synchronous write
    process(clk)
    begin
        if rising_edge(clk) then
            if RegWrite = '1' then
                if WriteRegister /= "00000" then  -- Register 0 remains zero
                    Registers(to_integer(unsigned(WriteRegister))) <= WriteData;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
