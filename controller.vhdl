-- Source: https://github.com/nrshenavar/CPU-Design-in-VHDL/
-- Controller completed per the provided control-signal table (attached image).
-- NOTE: Your image shows PCSource as 2 bits, but the entity defines it as 1 bit.
--       I kept the existing 1-bit interface and used:
--         PCSource="0" -> select ALU result (e.g., PC+4)
--         PCSource="1" -> select ALUOut   (e.g., branch target)
--       If you later widen PCSource to 2 bits, add a third case for "10" (e.g., Jump).

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
    PCSource    : out STD_LOGIC_VECTOR (0 downto 0); -- NOTE: 1-bit in repo; table shows 2-bit.
    ALUOp       : out STD_LOGIC_VECTOR (3 downto 0);
    LoadFromFile: out STD_LOGIC;
    SaveToFile  : out STD_LOGIC;
    CLK         : in  STD_LOGIC
  );
end Controlerl;

architecture Behavioral of Controlerl is
  -- Multi-cycle controller states
  TYPE STATE IS (SETUP, S0, S1, S2, S3, S4, S5, S6, Termination); -- You can add new states based on your design.
  SIGNAL CURRENT_STATE, NEXT_STATE : STATE := SETUP;

  -- Helper: decode simple R-type ALU ops from RISC-V encodings
  -- We only drive ALU with: AND="0000", OR="0001", ADD="0010", SUB="0110"
  function ALU_OP_FROM_FUNCTS(f7 : STD_LOGIC_VECTOR(6 downto 0);
                              f3 : STD_LOGIC_VECTOR(2 downto 0)) return STD_LOGIC_VECTOR is
  begin
    if    (f3 = "111") then return "0000"; -- AND
    elsif (f3 = "110") then return "0001"; -- OR
    elsif (f3 = "000" and f7 = "0000000") then return "0010"; -- ADD
    elsif (f3 = "000" and f7 = "0100000") then return "0110"; -- SUB
    else
      return "0010"; -- default to ADD
    end if;
  end function;

  -- Defaulting procedure to avoid inferred latches
  procedure drive_defaults is
  begin
    PCWriteCond <= '0';
    PCWrite     <= '0';
    IorD        <= "0";
    MemRead     <= '0';
    MemWrite    <= '0';
    MemtoReg    <= "0";  -- 0: ALU/ALUOut, 1: Memory
    IRWrite     <= '0';
    RegWrite    <= '0';
    ALUSrcA     <= "0";
    ALUSrcB     <= "00";
    PCSource    <= "0";  -- see note at top
    ALUOp       <= "0010"; -- default ADD
    LoadFromFile<= '0';
    SaveToFile  <= '0';
  end procedure;

begin
  -- State register
  p1 : PROCESS(CLK)
  BEGIN
    IF CLK'EVENT and CLK = '1' THEN
      CURRENT_STATE <= NEXT_STATE;
    END IF;
  END PROCESS;

  -- Next-state and outputs
  p2 : PROCESS(CURRENT_STATE, OPCODE, FUNCT67, FUNCT3)
  BEGIN
    -- Always start with safe defaults (matches "هیچ" in your table)
    drive_defaults;

    CASE CURRENT_STATE IS

      WHEN SETUP =>
        -- Load memory from file once before running
        LoadFromFile <= '1';
        SaveToFile   <= '0';
        NEXT_STATE   <= S0;

      WHEN Termination =>
        -- Save memory out once we decide to stop
        SaveToFile   <= '1';
        LoadFromFile <= '0';
        NEXT_STATE   <= Termination;

      --------------------------------------------------------------------
      -- S0: Instruction Fetch
      -- MemRead=1, IorD=0 (use PC), IRWrite=1
      -- ALU does PC + 4: ALUSrcA=0, ALUSrcB=01, ALUOp=ADD
      -- PCWrite=1, PCSource=0 (PC <- ALU result)
      --------------------------------------------------------------------
      WHEN S0 =>
        MemRead  <= '1';
        IorD     <= "0";
        IRWrite  <= '1';
        ALUSrcA  <= "0";
        ALUSrcB  <= "01";
        ALUOp    <= "0010";  -- ADD
        PCSource <= "0";     -- select ALU (PC+4)
        PCWrite  <= '1';
        NEXT_STATE <= S1;

      --------------------------------------------------------------------
      -- S1: Instruction Decode / Register Fetch
      -- Also compute branch target: ALU does PC + (SignImm<<2)
      -- ALUSrcA=0, ALUSrcB=11, ALUOp=ADD
      -- Then branch by opcode.
      --------------------------------------------------------------------
      WHEN S1 =>
        ALUSrcA  <= "0";
        ALUSrcB  <= "11";  -- PC + (imm<<2)
        ALUOp    <= "0010"; -- ADD
        -- Decode and route to the appropriate micro-state
        IF OPCODE = BEQ THEN
          NEXT_STATE <= S2;          -- Branch compare & possible PC write
        ELSIF OPCODE = SW THEN
          NEXT_STATE <= S2;          -- Addr calc for store
        ELSIF OPCODE = LW THEN
          NEXT_STATE <= S2;          -- Addr calc for load
        ELSIF OPCODE = R THEN
          NEXT_STATE <= S4;          -- R-type ALU execute
        ELSE
          NEXT_STATE <= Termination; -- Unknown opcode
        END IF;

      --------------------------------------------------------------------
      -- S2: Address Calculation for LW/SW OR Branch completion for BEQ
      --------------------------------------------------------------------
      WHEN S2 =>
        IF OPCODE = LW OR OPCODE = SW THEN
          -- Addr calc: ALU = Reg[A] + SignImm
          ALUSrcA  <= "1";     -- take register A
          ALUSrcB  <= "10";    -- + sign-extended immediate
          ALUOp    <= "0010";  -- ADD
          -- Next: memory access (read or write)
          IF OPCODE = LW THEN
            NEXT_STATE <= S3;  -- memory read
          ELSE
            NEXT_STATE <= S5;  -- memory write
          END IF;

        ELSIF OPCODE = BEQ THEN
          -- Branch compare and conditional PC write
          -- Compare Reg[A] - Reg[B]; if Zero asserted in datapath,
          -- external AND implements PCWriteCond & Zero (per textbook).
          ALUSrcA    <= "1";
          ALUSrcB    <= "00";
          ALUOp      <= "0110"; -- SUB
          PCSource   <= "1";    -- select ALUOut (branch target)  [NOTE: 1-bit PCSource]
          PCWriteCond<= '1';
          NEXT_STATE <= S0;     -- back to fetch regardless

        ELSE
          NEXT_STATE <= Termination;
        END IF;

      --------------------------------------------------------------------
      -- S3: Memory Read for LW
      --------------------------------------------------------------------
      WHEN S3 =>
        MemRead <= '1';
        IorD    <= "1";  -- use ALUOut as address
        NEXT_STATE <= S6; -- write-back

      --------------------------------------------------------------------
      -- S4: R-type ALU Execute
      --------------------------------------------------------------------
      WHEN S4 =>
        ALUSrcA <= "1";
        ALUSrcB <= "00";
        ALUOp   <= ALU_OP_FROM_FUNCTS(FUNCT67, FUNCT3);
        NEXT_STATE <= S6; -- R-type write-back

      --------------------------------------------------------------------
      -- S5: Memory Write for SW
      --------------------------------------------------------------------
      WHEN S5 =>
        MemWrite <= '1';
        IorD     <= "1";  -- use ALUOut as address
        NEXT_STATE <= S0;

      --------------------------------------------------------------------
      -- S6: Write-back (R-type or LW)
      --------------------------------------------------------------------
      WHEN S6 =>
        RegWrite <= '1';
        if OPCODE = LW then
          MemtoReg <= "1"; -- write memory data to register
        else
          MemtoReg <= "0"; -- write ALU result to register
        end if;
        NEXT_STATE <= S0;

    END CASE;
  END PROCESS;

end Behavioral;
