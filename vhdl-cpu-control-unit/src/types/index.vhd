library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Define various types and constants used throughout the project
package types is

    -- Define control signal types
    type control_signals is record
        RegWrite : std_logic;
        MemRead  : std_logic;
        MemWrite : std_logic;
        ALUSrcA  : std_logic;
        ALUSrcB  : std_logic;
        PCSource  : std_logic_vector(1 downto 0);
    end record;

    -- Define instruction formats
    type instruction_format is record
        opcode : std_logic_vector(5 downto 0);
        rs     : std_logic_vector(4 downto 0);
        rt     : std_logic_vector(4 downto 0);
        rd     : std_logic_vector(4 downto 0);
        shamt   : std_logic_vector(4 downto 0);
        funct   : std_logic_vector(5 downto 0);
        immediate : std_logic_vector(15 downto 0);
        address : std_logic_vector(25 downto 0);
    end record;

    -- Define constants for opcodes
    constant OPCODE_ADD : std_logic_vector(5 downto 0) := "000000";
    constant OPCODE_SUB : std_logic_vector(5 downto 0) := "000001";
    constant OPCODE_AND : std_logic_vector(5 downto 0) := "000010";
    constant OPCODE_OR  : std_logic_vector(5 downto 0) := "000011";
    constant OPCODE_LW  : std_logic_vector(5 downto 0) := "000100";
    constant OPCODE_SW  : std_logic_vector(5 downto 0) := "000101";
    constant OPCODE_BEQ : std_logic_vector(5 downto 0) := "000110";

end types;