library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity benchmark is
end benchmark;

architecture behavior of benchmark is

    -- Component declaration for the Unit Under Test (UUT)
    component test1
        Port (
            A : in  STD_LOGIC_VECTOR (31 downto 0);
            B : in  STD_LOGIC_VECTOR (31 downto 0);
            Dout : buffer  STD_LOGIC_VECTOR (31 downto 0);
            Cin : in  STD_LOGIC;
            zero : out  STD_LOGIC;
            Opcode : in  STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- Signals to connect to UUT
    signal A     : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal B     : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal Dout  : STD_LOGIC_VECTOR (31 downto 0);
    signal Cin   : STD_LOGIC := '0';
    signal zero  : STD_LOGIC;
    signal Opcode: STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: test1 port map (
        A => A,
        B => B,
        Dout => Dout,
        Cin => Cin,
        zero => zero,
        Opcode => Opcode
    );

    -- Test Process
    stim_proc: process
    begin
        -- Test 1: AND Operation
        A <= x"FFFFFFFF";
        B <= x"00000000";
        Opcode <= "0000"; -- Assuming opcode "0000" triggers AND in and_mud
        wait for 10 ns;

        -- Test 2: OR Operation
        A <= x"F0F0F0F0";
        B <= x"0F0F0F0F";
        Opcode <= "0001"; -- Assuming opcode "0001" triggers OR in or_mud
        wait for 10 ns;

        -- Test 3: ADD Operation (Opcode = "0010")
        A <= x"00000010";
        B <= x"00000001";
        Cin <= '0';
        Opcode <= "0010";
        wait for 10 ns;

        -- Test 4: SUB Operation (Opcode = "0110")
        A <= x"00000005";
        B <= x"00000003";
        Cin <= '0';
        Opcode <= "0110";
        wait for 10 ns;

        -- Test 5: Zero flag check
        A <= x"00000000";
        B <= x"00000000";
        Cin <= '0';
        Opcode <= "0000"; -- AND of zero
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end behavior;

