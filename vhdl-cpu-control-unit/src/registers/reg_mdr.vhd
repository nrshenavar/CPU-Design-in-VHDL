library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reg_mdr is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        data_in : in std_logic_vector(31 downto 0);
        load    : in std_logic;
        data_out : out std_logic_vector(31 downto 0)
    );
end entity reg_mdr;

architecture behavioral of reg_mdr is
    signal mdr_reg : std_logic_vector(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            mdr_reg <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                mdr_reg <= data_in;
            end if;
        end if;
    end process;

    data_out <= mdr_reg;
end architecture behavioral;