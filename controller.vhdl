library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.TOP_PACKAGE.all;

entity Controlerl is
  Port (
    OPCODE      : in  STD_LOGIC_VECTOR (6 downto 0);
    FUNCT67     : in  STD_LOGIC_VECTOR (6 downto 0);
    FUNCT3      : in  STD_LOGIC_VECTOR (2 downto 0);

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
    PCSource    : out STD_LOGIC_VECTOR (0 downto 0);
    ALUOp       : out STD_LOGIC_VECTOR (3 downto 0);

    LoadFromFile: out STD_LOGIC;
    SaveToFile  : out STD_LOGIC;

    CLK         : in  STD_LOGIC
  );
end Controlerl;

architecture Behavioral of Controlerl is
  -- You can add new states based on your design.
  TYPE STATE IS (SETUP, S0, S1, S2, S3, S4, S5, S6, Termination);
  SIGNAL CURRENT_STATE, NEXT_STATE : STATE := SETUP;

  -- convenience procedures to drive all control signals to safe defaults
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
    ALUSrcB     <= "00";
    PCSource    <= "0";
    ALUOp       <= "0000";
    LoadFromFile<= '0';
    SaveToFile  <= '0';
  end procedure;
begin

  -- state register
  p1 : PROCESS(CLK)
  BEGIN
    IF rising_edge(CLK) THEN
      CURRENT_STATE <= NEXT_STATE;
    END IF;
  END PROCESS;

  -- next-state and output logic
  p2 : PROCESS(CURRENT_STATE, OPCODE)
  BEGIN
    -- default all controls each cycle
    drive_defaults;

    CASE CURRENT_STATE IS
      ------------------------------------------------------------------
      WHEN SETUP =>
        -- Optional preload from file at reset/power-up
        LoadFromFile <= '1';
        NEXT_STATE   <= S0;

      WHEN Termination =>
        -- Optional dump to file before halting
        SaveToFile   <= '1';
        -- Stay here unless you prefer to restart:
        NEXT_STATE   <= Termination;

      ------------------------------------------------------------------
      -- S0: Instruction fetch
      WHEN S0 =>
        MemRead   <= '1';
        IRWrite   <= '1';
        IorD      <= "0";           -- use PC for memory address
        ALUSrcA   <= "0";           -- PC as A
        ALUSrcB   <= "01";          -- +4 (or +1 if byte-addressed; tune to your datapath)
        ALUOp     <= "0000";        -- ADD
        PCSource  <= "0";           -- write PC from ALU result
        PCWrite   <= '1';
        NEXT_STATE<= S1;

      ------------------------------------------------------------------
      -- S1: Decode / Reg fetch / Branch base calc
      WHEN S1 =>
        ALUSrcA   <= "0";           -- use PC
        ALUSrcB   <= "11";          -- PC + (signext(imm)<<2) precompute branch target if desired
        ALUOp     <= "0000";        -- ADD

        -- Select path by opcode
        IF    OPCODE = BEQ THEN
          NEXT_STATE <= S2;         -- branch resolution
        ELSIF OPCODE = SW  THEN
          NEXT_STATE <= S3;         -- address calc for store
        ELSIF OPCODE = LW  THEN
          NEXT_STATE <= S3;         -- address calc for load
        ELSIF OPCODE = R   THEN
          NEXT_STATE <= S3;         -- R-type execute
        ELSE
          NEXT_STATE <= Termination;-- unknown / end-of-program
        END IF;

      ------------------------------------------------------------------
      -- S2: Branch resolution (BEQ)
      WHEN S2 =>
        ALUSrcA     <= "1";         -- register A
        ALUSrcB     <= "00";        -- register B
        ALUOp       <= "0001";      -- SUB/compare (set by your ALU)
        PCSource    <= "1";         -- select branch target path
        PCWriteCond <= '1';         -- update PC if zero flag is set in datapath
        NEXT_STATE  <= S0;

      ------------------------------------------------------------------
      -- S3: Address calc for LW/SW  OR  Execute for R-type
      WHEN S3 =>
        IF (OPCODE = LW) OR (OPCODE = SW) THEN
          -- base + offset address calculation
          ALUSrcA   <= "1";         -- base register
          ALUSrcB   <= "10";        -- + sign-extended immediate
          ALUOp     <= "0000";      -- ADD
          IF OPCODE = LW THEN
            NEXT_STATE <= S4;       -- memory read
          ELSE
            NEXT_STATE <= S6;       -- memory write
          END IF;
        ELSE
          -- R-type ALU operation (FUNCT fields decoded in ALU using ALUOp)
          ALUSrcA   <= "1";
          ALUSrcB   <= "00";
          ALUOp     <= "0010";      -- "use funct" (conventional encoding)
          NEXT_STATE<= S4;          -- write-back in S4
        END IF;

      ------------------------------------------------------------------
      -- S4: Memory read (for LW)  OR  R-type write-back
      WHEN S4 =>
        IF OPCODE = LW THEN
          MemRead   <= '1';
          IorD      <= "1";         -- use ALUout/address for memory
          NEXT_STATE<= S5;          -- go write the register
        ELSE
          -- R-type register write-back
          RegWrite  <= '1';
          MemtoReg  <= "0";         -- write ALU result
          NEXT_STATE<= S0;
        END IF;

      ------------------------------------------------------------------
      -- S5: Register write-back for LW
      WHEN S5 =>
        RegWrite  <= '1';
        MemtoReg  <= "1";           -- write data from memory
        NEXT_STATE<= S0;

      ------------------------------------------------------------------
      -- S6: Memory write for SW
      WHEN S6 =>
        MemWrite  <= '1';
        IorD      <= "1";           -- use computed address
        NEXT_STATE<= S0;

    END CASE;
  END PROCESS;

end Behavioral;
