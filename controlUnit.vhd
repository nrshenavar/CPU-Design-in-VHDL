-- ================================================================
-- ControlUnit.vhd
-- Multi-cycle control unit aligned with your datapath spec table.
-- Outputs: RegWrite, ALUSrcA, MemRead, MemWrite, MemtoReg, IorD,
-- IRWrite, PCWrite, PCWriteCond, ALUSrcB(1:0), PCSource(1:0)
-- ================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;

    -- Instruction opcode (from IR)
    opcode    : in  std_logic_vector(5 downto 0); -- adjust width for your ISA

    -- Control signals
    RegWrite   : out std_logic;
    ALUSrcA    : out std_logic;
    MemRead    : out std_logic;
    MemWrite   : out std_logic;
    MemtoReg   : out std_logic;
    IorD       : out std_logic;
    IRWrite    : out std_logic;
    PCWrite    : out std_logic;
    PCWriteCond: out std_logic;
    ALUSrcB    : out std_logic_vector(1 downto 0);
    PCSource   : out std_logic_vector(1 downto 0);
    ALUOp      : out std_logic_vector(1 downto 0)  -- e.g. 00=ADD, 01=SUB, 10=func
  );
end entity;

architecture rtl of ControlUnit is

  -- FSM states
  type state_t is (
    S_FETCH, S_DECODE,
    S_MEMADR, S_MEMREAD, S_MEMWB,
    S_MEMWRITE,
    S_EXEC, S_ALUWB,
    S_BRANCH,
    S_JUMP
  );
  signal state, next_state : state_t;

begin

  -- Sequential state register
  process(clk, rst)
  begin
    if rst = '1' then
      state <= S_FETCH;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  -- Combinational control logic
  process(state, opcode)
  begin
    -- Default values
    RegWrite    <= '0';
    ALUSrcA     <= '0';
    MemRead     <= '0';
    MemWrite    <= '0';
    MemtoReg    <= '0';
    IorD        <= '0';
    IRWrite     <= '0';
    PCWrite     <= '0';
    PCWriteCond <= '0';
    ALUSrcB     <= "00";
    PCSource    <= "00";
    ALUOp       <= "00";

    next_state <= state;

    case state is
      -- =====================================================
      when S_FETCH =>
        MemRead  <= '1';
        IRWrite  <= '1';
        ALUSrcA  <= '0';
        ALUSrcB  <= "01";   -- ALU input = 4 (PC+4)
        ALUOp    <= "00";   -- ADD
        PCWrite  <= '1';
        PCSource <= "00";   -- ALU result
        next_state <= S_DECODE;

      -- =====================================================
      when S_DECODE =>
        ALUSrcA <= '0';
        ALUSrcB <= "11";    -- sign-extended imm << 2
        ALUOp   <= "00";    -- ADD (for branch base)
        -- Branch to next state depending on opcode
        if opcode = "100011" then      -- LW
          next_state <= S_MEMADR;
        elsif opcode = "101011" then   -- SW
          next_state <= S_MEMADR;
        elsif opcode = "000000" then   -- R-type
          next_state <= S_EXEC;
        elsif opcode = "000100" then   -- BEQ
          next_state <= S_BRANCH;
        elsif opcode = "000010" then   -- J
          next_state <= S_JUMP;
        else
          next_state <= S_FETCH;
        end if;

      -- =====================================================
      when S_MEMADR =>
        ALUSrcA <= '1';
        ALUSrcB <= "10";   -- base + offset
        ALUOp   <= "00";   -- ADD
        if opcode = "100011" then      -- LW
          next_state <= S_MEMREAD;
        else                           -- SW
          next_state <= S_MEMWRITE;
        end if;

      when S_MEMREAD =>
        MemRead <= '1';
        IorD    <= '1';
        next_state <= S_MEMWB;

      when S_MEMWB =>
        RegWrite <= '1';
        MemtoReg <= '1';
        next_state <= S_FETCH;

      when S_MEMWRITE =>
        MemWrite <= '1';
        IorD     <= '1';
        next_state <= S_FETCH;

      -- =====================================================
      when S_EXEC =>   -- R-type
        ALUSrcA <= '1';
        ALUSrcB <= "00";
        ALUOp   <= "10";   -- determined by funct field
        next_state <= S_ALUWB;

      when S_ALUWB =>
        RegWrite <= '1';
        next_state <= S_FETCH;

      -- =====================================================
      when S_BRANCH =>
        ALUSrcA     <= '1';
        ALUSrcB     <= "00";
        ALUOp       <= "01";  -- SUB for comparison
        PCWriteCond <= '1';
        PCSource    <= "01";  -- branch target
        next_state  <= S_FETCH;

      when S_JUMP =>
        PCWrite  <= '1';
        PCSource <= "10";
        next_state <= S_FETCH;

      -- =====================================================
      when others =>
        next_state <= S_FETCH;
    end case;
  end process;

end architecture;