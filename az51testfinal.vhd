library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterBank_tb is
end RegisterBank_tb;

architecture Behavioral of RegisterBank_tb is

    -- Component Declaration
    component RegisterBank is
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
    end component;

    -- Signals to connect to the UUT
    signal clk           : STD_LOGIC := '0';
    signal RegWrite      : STD_LOGIC := '0';
    signal ReadRegister1 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal ReadRegister2 : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal WriteRegister : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal WriteData     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ReadData1     : STD_LOGIC_VECTOR(31 downto 0);
    signal ReadData2     : STD_LOGIC_VECTOR(31 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: RegisterBank
        Port map (
            clk           => clk,
            RegWrite      => RegWrite,
            ReadRegister1 => ReadRegister1,
            ReadRegister2 => ReadRegister2,
            WriteRegister => WriteRegister,
            WriteData     => WriteData,
            ReadData1     => ReadData1,
            ReadData2     => ReadData2
        );

    -- Clock generation
    clk_process :process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Wait for global reset
        wait for 20 ns;

        -- Write 0xA5A5A5A5 to register 5
        WriteRegister <= "00101";
        WriteData     <= x"A5A5A5A5";
        RegWrite      <= '1';
        wait for clk_period;

        -- Disable write
        RegWrite <= '0';
        wait for clk_period;

        -- Read from register 5 and 0
        ReadRegister1 <= "00101";
        ReadRegister2 <= "00000"; -- Should remain 0
        wait for clk_period;

        -- Write to register 0 (should not change)
        WriteRegister <= "00000";
        WriteData     <= x"FFFFFFFF";
        RegWrite      <= '1';
        wait for clk_period;

        RegWrite <= '0';
        wait for clk_period;

        -- Read again to verify register 0 is still 0
        ReadRegister1 <= "00000";
        ReadRegister2 <= "00101";
        wait for clk_period;

        -- End simulation
        wait;
    end process;

end Behavioral;
