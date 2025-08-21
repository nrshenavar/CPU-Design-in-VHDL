-- Controller.vhdl
-- Cleaned version: now uses symbolic names from TOP_PACKAGE.vhdl
-- No entity changes (only internal improvements for clarity)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.TOP_PACKAGE.all;

entity Controlerl is
  Port (
    OPCODE     : in  STD_LOGIC_VECTOR (6 downto 0);
    FUNCT67    : in  STD_LOGIC_VECTOR (6 downto 0);
    FUNCT3     : in  STD_LOGIC_VECTOR (2 downto 0);

    PCWriteCond : out STD_LOGIC;
    PCWrite     : out STD_LOGIC;
    IorD        : out STD_LOGIC_VECTOR (0 downto 0);
    MemRead     : out STD_LOGIC;
    MemWrite    : out STD_LOGIC;
    MemtoReg    : out STD_LOGIC_VECTOR (0 downto 0);
    IRWrite     : out STD_LOGIC;
    RegWrite    : out STD_LOGIC;
    ALUSrcA     : out STD_LOGIC_VECTOR (0 downto 0);
    ALUSrcB     : out STD_LOGIC_VECTOR (1 downto 0);
    PCSource    : out STD_LOGIC_VECTOR (0 downto 0); -- NOTE: repo uses 1-bit, table shows 2 bits
    ALUOp       : out STD_LOGIC_VECTOR (3 downto 0);
    LoadFromFile: out STD_LOGIC;
    SaveToFile  : out STD_LOGIC;
    CLK         : in  STD_LOGIC
  );
end Controlerl;

architecture Behavioral of Controlerl is
  -- FSM states
  TYPE STATE IS (SETUP, S0, S1, S2, S3, S4, S5, S6, Termination);
  SIGNAL CURRENT_STATE, NEXT_STATE : STATE := SETUP;

  -- ALU control decoder (R-type)
  function ALU_OP_FROM_FUNCTS(f7 : STD_LOGIC_VECTOR(6 downto 0);
                              f3 : STD_LOGIC_VECTOR(2 downto 0)) return STD_LOGIC_VECTOR is
  begin
    if    (f3 = "111") then return ALU_AND;
    elsif (f3 = "110") then return ALU_OR;
    elsif (f3 = "000" and f7 = "0000000") then return ALU_ADD;
    elsif (f3 = "000" and f7 = "0100000") then return ALU_SUB;
    else
      return ALU_ADD; -- default
    end if;
  end function;

  -- Safe defaults
  procedure drive_defaults is
  begin
    PCWriteCond <= '0';
    PCWrite     <= '0';
    IorD        <= "0";
    MemRead     <= '0';
    MemWrite    <= '0';
    MemtoReg    <= "0";
    IRWrite     <= '0';
    RegWrite    <= '0';
    ALUSrcA     <= "0";
    ALUSrcB     <= SRCB_REG;
    PCSource    <= "0";  -- NOTE: only 1-bit in repo (0=ALU,1=ALUOut)
    ALUOp       <= ALU_ADD;
    LoadFromFile<= '0';
    SaveToFile  <= '0';
  end procedure;

begin
  -- State register
  p1 : PROCESS(CLK)
  BEGIN
    IF rising_edge(CLK) THEN
      CURRENT_STATE <= NEXT_STATE;
    END IF;
  END PROCESS;

  -- Next-state and outputs
  p2 : PROCESS(CURRENT_STATE, OPCODE, FUNCT67, FUNCT3)
  BEGIN
    drive_defaults;

    CASE CURRENT_STATE IS

      WHEN SETUP =>
        LoadFromFile <= '1';
        NEXT_STATE   <= S0;

      WHEN Termination =>
        SaveToFile   <= '1';
        NEXT_STATE   <= Termination;

      --------------------------------------------------------------------
      -- S0: Instruction Fetch
      --------------------------------------------------------------------
      WHEN S0 =>
        MemRead  <= '1';
        IorD     <= "0";      -- from PC
        IRWrite  <= '1';
        ALUSrcA  <= "0";      -- from PC
        ALUSrcB  <= SRCB_FOUR;-- +4
        ALUOp    <= ALU_ADD;
        PCSource <= "0";      -- select ALU
        PCWrite  <= '1';
        NEXT_STATE <= S1;

      --------------------------------------------------------------------
      -- S1: Decode
      --------------------------------------------------------------------
      WHEN S1 =>
        ALUSrcA  <= "0";
        ALUSrcB  <= SRCB_IMM_SH; -- PC + (imm<<2)
        ALUOp    <= ALU_ADD;

        IF OPCODE = BEQ THEN
          NEXT_STATE <= S2;
        ELSIF OPCODE = SW THEN
          NEXT_STATE <= S2;
        ELSIF OPCODE = LW THEN
          NEXT_STATE <= S2;
        ELSIF OPCODE = R THEN
          NEXT_STATE <= S4;
        ELSE
          NEXT_STATE <= Termination;
        END IF;

      --------------------------------------------------------------------
      -- S2: Addr Calc / Branch
      --------------------------------------------------------------------
      WHEN S2 =>
        IF OPCODE = LW OR OPCODE = SW THEN
          ALUSrcA  <= "1";       -- reg A
          ALUSrcB  <= SRCB_IMM;  -- + immediate
          ALUOp    <= ALU_ADD;

          IF OPCODE = LW THEN
            NEXT_STATE <= S3;
          ELSE
            NEXT_STATE <= S5;
          END IF;

        ELSIF OPCODE = BEQ THEN
          ALUSrcA     <= "1";
          ALUSrcB     <= SRCB_REG;
          ALUOp       <= ALU_SUB;
          PCSource    <= "1";   -- ALUOut
          PCWriteCond <= '1';
          NEXT_STATE  <= S0;

        ELSE
          NEXT_STATE <= Termination;
        END IF;

      --------------------------------------------------------------------
      -- S3: Memory Read (LW)
      --------------------------------------------------------------------
      WHEN S3 =>
        MemRead <= '1';
        IorD    <= "1"; -- from ALUOut
        NEXT_STATE <= S6;

      --------------------------------------------------------------------
      -- S4: R-type execute
      --------------------------------------------------------------------
      WHEN S4 =>
        ALUSrcA <= "1";
        ALUSrcB <= SRCB_REG;
        ALUOp   <= ALU_OP_FROM_FUNCTS(FUNCT67, FUNCT3);
        NEXT_STATE <= S6;

      --------------------------------------------------------------------
      -- S5: Memory Write (SW)
      --------------------------------------------------------------------
      WHEN S5 =>
        MemWrite <= '1';
        IorD     <= "1";
        NEXT_STATE <= S0;

      --------------------------------------------------------------------
      -- S6: Write-back
      --------------------------------------------------------------------
      WHEN S6 =>
        RegWrite <= '1';
        if OPCODE = LW then
          MemtoReg <= "1"; -- from memory
        else
          MemtoReg <= "0"; -- from ALU
        end if;
        NEXT_STATE <= S0;

    END CASE;
  END PROCESS;

end Behavioral;
