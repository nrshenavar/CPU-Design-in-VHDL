library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity register_file is
    port (
        clk         : in std_logic;
        reg_write   : in std_logic;
        reg_read_a  : in std_logic_vector(2 downto 0);
        reg_read_b  : in std_logic_vector(2 downto 0);
        reg_write_addr : in std_logic_vector(2 downto 0);
        reg_write_data : in std_logic_vector(31 downto 0);
        reg_a_out   : out std_logic_vector(31 downto 0);
        reg_b_out   : out std_logic_vector(31 downto 0)
    );
end entity register_file;

architecture behavioral of register_file is
    type reg_array is array (0 to 7) of std_logic_vector(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reg_write = '1' then
                registers(to_integer(unsigned(reg_write_addr))) <= reg_write_data;
            end if;
        end if;
    end process;

    reg_a_out <= registers(to_integer(unsigned(reg_read_a)));
    reg_b_out <= registers(to_integer(unsigned(reg_read_b)));
end architecture behavioral;