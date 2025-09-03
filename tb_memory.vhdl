-- filepath: c:\Users\ASUS\Documents\GitHub\CPU-Design-in-VHDL\tb_Memory.vhdl

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Memory is
end tb_Memory;

architecture Behavioral of tb_Memory is

    signal Write_DATA   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Address      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal MEMRead      : STD_LOGIC := '0';
    signal MEMWrite     : STD_LOGIC := '0';
    signal LoadFromFile : STD_LOGIC := '0';
    signal SaveToFile   : STD_LOGIC := '0';
    signal MEMData      : STD_LOGIC_VECTOR(31 downto 0);

    component Memory
        Generic ( DATA_WIDTH : INTEGER := 32;
                  ADDRESS_WIDTH : INTEGER := 32);
        Port ( Write_DATA   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
               Address      : in  STD_LOGIC_VECTOR(ADDRESS_WIDTH-1 downto 0);
               MEMRead      : in  STD_LOGIC;
               MEMWrite     : in  STD_LOGIC;
               LoadFromFile : in  STD_LOGIC;
               SaveToFile   : in  STD_LOGIC;
               MEMData      : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0));
    end component;

begin

    UUT: Memory
        generic map (
            DATA_WIDTH => 32,
            ADDRESS_WIDTH => 32
        )
        port map (
            Write_DATA   => Write_DATA,
            Address      => Address,
            MEMRead      => MEMRead,
            MEMWrite     => MEMWrite,
            LoadFromFile => LoadFromFile,
            SaveToFile   => SaveToFile,
            MEMData      => MEMData
        );

    stim_proc: process
    begin
        -- Load memory from file
        LoadFromFile <= '1';
        wait for 20 ns;
        LoadFromFile <= '0';

        -- Wait for some time (simulate CPU operation)
        wait for 100 ns;

        -- Save memory to file
        SaveToFile <= '1';
        wait for 20 ns;
        SaveToFile <= '0';

        report "Simulation finished. Check mem_output.txt for results.";

        wait;
    end process;

end Behavioral;