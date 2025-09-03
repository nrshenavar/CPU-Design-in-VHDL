library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.TOP_PACKAGE.all;

entity controller is
    Port ( OPCODE : in  STD_LOGIC_VECTOR (6 downto 0);
			  FUNCT67 : in  STD_LOGIC_VECTOR (6 downto 0);
			  FUNCT3 : in STD_LOGIC_VECTOR (2 downto 0);
           PCWriteCond : out  STD_LOGIC;
           PCWrite : out  STD_LOGIC;
           IorD : out  STD_LOGIC_VECTOR (0 downto 0);
           MemRead : out  STD_LOGIC;
           MemWrite : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC_VECTOR (0 downto 0);
           IRWrite : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ALUSrcA : out  STD_LOGIC_VECTOR (0 downto 0);
           ALUSrcB : out  STD_LOGIC_VECTOR (1 downto 0);
           PCSource : out  STD_LOGIC_VECTOR (0 downto 0);
           ALUOp : out  STD_LOGIC_VECTOR (3 downto 0);
			  LoadFromFile  : out  STD_LOGIC;
           SaveToFile    : out  STD_LOGIC;
			  CLK : in STD_LOGIC);
end controller;

-- ...existing code...

architecture Behavioral of controller is
    TYPE STATE IS (SETUP,S0,S1,S2,S3,S4,S5,S6,Termination);
    SIGNAL CURRENT_STATE, NEXT_STATE : STATE := SETUP;

    -- Define opcode constants (replace with your actual values)
    constant OPCODE_LW  : STD_LOGIC_VECTOR(6 downto 0) := "0000011";
    constant OPCODE_SW  : STD_LOGIC_VECTOR(6 downto 0) := "0100011";
    constant OPCODE_BEQ : STD_LOGIC_VECTOR(6 downto 0) := "1100011";
    constant OPCODE_R   : STD_LOGIC_VECTOR(6 downto 0) := "0110011";

begin
    p1 : PROCESS(CLK) BEGIN
        IF CLK'EVENT and CLK = '1' THEN
            CURRENT_STATE <= NEXT_STATE;
        END IF;
    END PROCESS;

    p2 : PROCESS(CURRENT_STATE, OPCODE, FUNCT3) BEGIN
        -- Default values for all signals
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
        NEXT_STATE  <= CURRENT_STATE;

        CASE CURRENT_STATE IS
            WHEN SETUP =>
                LoadFromFile <= '1';
                SaveToFile   <= '0';
                NEXT_STATE   <= S0;

            WHEN Termination =>
                SaveToFile   <= '1';
                LoadFromFile <= '0';

            WHEN S0 =>
                -- Instruction Fetch
                MemRead   <= '1';
                IRWrite   <= '1';
                PCWrite   <= '1';
                ALUSrcA   <= "0";
                ALUSrcB   <= "01"; -- PC + 4
                ALUOp     <= "0000"; -- ADD
                PCSource  <= "0";
                NEXT_STATE<= S1;

            WHEN S1 =>
                -- Instruction Decode
                ALUSrcA   <= "0";
                ALUSrcB   <= "11"; -- Immediate
                ALUOp     <= "0000";
                IF OPCODE = OPCODE_BEQ THEN
                    NEXT_STATE <= S3;
                ELSIF OPCODE = OPCODE_SW THEN
                    NEXT_STATE <= S2;
                ELSIF OPCODE = OPCODE_LW THEN
                    NEXT_STATE <= S2;
                ELSIF OPCODE = OPCODE_R THEN
                    NEXT_STATE <= S4;
                ELSE
                    NEXT_STATE <= Termination;
                END IF;

            WHEN S2 =>
                -- Memory Address Calculation for LW/SW
                ALUSrcA   <= "1";
                ALUSrcB   <= "10"; -- Immediate
                ALUOp     <= "0000"; -- ADD
                IF OPCODE = OPCODE_LW THEN
                    NEXT_STATE <= S5;
                ELSIF OPCODE = OPCODE_SW THEN
                    NEXT_STATE <= S6;
                END IF;

            WHEN S3 =>
                -- Branch (BEQ)
                ALUSrcA      <= "1";
                ALUSrcB      <= "00";
                ALUOp        <= "0110"; -- SUB for BEQ
                PCSource     <= "1";
                PCWriteCond  <= '1';
                NEXT_STATE   <= S0;


            WHEN S4 =>
                -- R-type (ADD, SUB, AND, OR)
                ALUSrcA   <= "1";
                ALUSrcB   <= "00";
                CASE FUNCT3 IS
                    WHEN "000" =>  -- ADD/SUB
                        IF FUNCT67 = "0100000" THEN
                            ALUOp <= "0110"; -- SUB
                        ELSE
                            ALUOp <= "0010"; -- ADD
                        END IF;
                    WHEN "111" => 
                        ALUOp <= "0000"; -- AND
                    WHEN "110" => 
                        ALUOp <= "0001"; -- OR
                    WHEN OTHERS => 
                        ALUOp <= "0010"; -- Default to ADD
                END CASE;
                NEXT_STATE <= S5;



            WHEN S5 =>
                -- Write-back for LW and R-type
                IF OPCODE = OPCODE_LW THEN
                    RegWrite  <= '1';
                    MemtoReg  <= "1";
                ELSIF OPCODE = OPCODE_R THEN
                    RegWrite  <= '1';
                    MemtoReg  <= "0";
                END IF;
                NEXT_STATE <= S0;

            WHEN S6 =>
                -- SW: Memory Write
                MemWrite   <= '1';
                NEXT_STATE <= S0;

        END CASE;
    END PROCESS;

end Behavioral;