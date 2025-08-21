library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package TOP_PACKAGE is

    -- =========================
    -- Opcode definitions
    -- =========================
    constant LW   : std_logic_vector(6 downto 0) := "0000011"; -- load word
    constant SW   : std_logic_vector(6 downto 0) := "0100011"; -- store word
    constant BEQ  : std_logic_vector(6 downto 0) := "1100011"; -- branch equal
    constant R    : std_logic_vector(6 downto 0) := "0110011"; -- R-type

    -- =========================
    -- ALU operations (4-bit ALUOp)
    -- =========================
    constant ALU_AND : std_logic_vector(3 downto 0) := "0000";
    constant ALU_OR  : std_logic_vector(3 downto 0) := "0001";
    constant ALU_ADD : std_logic_vector(3 downto 0) := "0010";
    constant ALU_SUB : std_logic_vector(3 downto 0) := "0110";

    -- =========================
    -- ALUSrcB control encoding
    -- =========================
    -- 00: Register B
    -- 01: Constant 4
    -- 10: Sign-extended immediate
    -- 11: Sign-extended immediate << 2
    --
    constant SRCB_REG     : std_logic_vector(1 downto 0) := "00";
    constant SRCB_FOUR    : std_logic_vector(1 downto 0) := "01";
    constant SRCB_IMM     : std_logic_vector(1 downto 0) := "10";
    constant SRCB_IMM_SH  : std_logic_vector(1 downto 0) := "11";

    -- =========================
    -- PCSource encoding
    -- =========================
    -- (your entity currently has only 1 bit, but table shows 2 bits)
    -- 00: ALU result (PC+4)
    -- 01: ALUOut (branch target)
    -- 10: Jump address (not implemented here, but useful later)
    --
    constant PCS_ALU      : std_logic_vector(1 downto 0) := "00";
    constant PCS_ALUOUT   : std_logic_vector(1 downto 0) := "01";
    constant PCS_JUMP     : std_logic_vector(1 downto 0) := "10";

end TOP_PACKAGE;

package body TOP_PACKAGE is
end TOP_PACKAGE;
