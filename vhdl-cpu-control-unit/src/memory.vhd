library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memory is
    Port ( clk : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR(7 downto 0);
           data_in : in STD_LOGIC_VECTOR(31 downto 0);
           mem_read : in STD_LOGIC;
           mem_write : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(31 downto 0));
end memory;

architecture Behavioral of memory is
    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem : memory_array := (others => (others => '0'));
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write = '1' then
                mem(to_integer(unsigned(addr))) <= data_in;
            end if;
            if mem_read = '1' then
                data_out <= mem(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;

end Behavioral;