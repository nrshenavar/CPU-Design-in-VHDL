-- ================================================================
-- ControlUnit_tb.vhd
-- Testbench for ControlUnit
-- ================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit_tb is
end;

architecture tb of ControlUnit_tb is

  -- DUT signals
  signal clk        : std_logic := '0';
  signal rst        : std_logic := '1';
  signal opcode     : std_logic_vector(5 downto 0) := (others => '0');

  signal RegWrite   : std_logic;
  signal ALUSrcA    : std_logic;
  signal MemRead    : std_logic;
  signal MemWrite   : std_logic;
  signal MemtoReg   : std_logic;
  signal IorD       : std_logic;
  signal IRWrite    : std_logic;
  signal PCWrite    : std_logic;
  signal PCWriteCond: std_logic;
  signal ALUSrcB    : std_logic_vector(1 downto 0);
  signal PCSource   : std_logic_vector(1 downto 0);
  signal ALUOp      : std_logic_vector(1 downto 0);

  -- Clock period
  constant CLK_PERIOD : time := 20 ns;

begin

  -- Instantiate DUT
  dut: entity work.ControlUnit
    port map (
      clk        => clk,
      rst        => rst,
      opcode     => opcode,
      RegWrite   => RegWrite,
      ALUSrcA    => ALUSrcA,
      MemRead    => MemRead,
      MemWrite   => MemWrite,
      MemtoReg   => MemtoReg,
      IorD       => IorD,
      IRWrite    => IRWrite,
      PCWrite    => PCWrite,
      PCWriteCond=> PCWriteCond,
      ALUSrcB    => ALUSrcB,
      PCSource   => PCSource,
      ALUOp      => ALUOp
    );

  -- Clock generator
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for CLK_PERIOD/2;
      clk <= '1';
      wait for CLK_PERIOD/2;
    end loop;
  end process;

  -- Stimulus
  stim_proc: process
  begin
    -- Reset
    rst <= '1';
    wait for 40 ns;
    rst <= '0';

    -- Test sequence of instructions
    -- Opcodes (MIPS-style):
    -- "100011" = LW
    -- "101011" = SW
    -- "000000" = R-type
    -- "000100" = BEQ
    -- "000010" = JUMP

    -- Fetch + LW
    opcode <= "100011";
    wait for 200 ns;

    -- Fetch + SW
    opcode <= "101011";
    wait for 200 ns;

    -- Fetch + R-type
    opcode <= "000000";
    wait for 200 ns;

    -- Fetch + BEQ
    opcode <= "000100";
    wait for 200 ns;

    -- Fetch + JUMP
    opcode <= "000010";
    wait for 200 ns;

    -- Finish simulation
    wait;
  end process;

end architecture;
