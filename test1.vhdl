----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:40:38 02/26/2024 
-- Design Name: 
-- Module Name:    test1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Fixed 32-bit ALU with proper ADD/SUB operations
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test1 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : buffer  STD_LOGIC_VECTOR (31 downto 0);
           Cin : in STD_LOGIC;
           zero : out  STD_LOGIC;
           Opcode : in  STD_LOGIC_VECTOR (3 downto 0));
end test1;

architecture Behavioral of test1 is

component and_mud 
    port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           opcode : in STD_LOGIC_VECTOR (3 downto 0);
           F : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
signal and_out : STD_LOGIC_VECTOR (31 downto 0);

component or_mud
    port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           opcode : in STD_LOGIC_VECTOR (3 downto 0);
           F : out  STD_LOGIC_VECTOR (31 downto 0));
end component;
signal or_out : STD_LOGIC_VECTOR (31 downto 0);

signal add_result : STD_LOGIC_VECTOR (31 downto 0);
signal sub_result : STD_LOGIC_VECTOR (31 downto 0);
signal temp_result : STD_LOGIC_VECTOR (31 downto 0);

begin

inst_and_mud : and_mud port map (
    A => A,
    B => B,
    opcode => opcode,
    F => and_out );

inst_or_mud : or_mud port map (
    A => A,
    B => B,
    opcode => opcode,
    F => or_out );

-- Addition: A + B + Cin
process(A, B, Cin)
    variable temp_sum : unsigned(32 downto 0);  -- 33 bits to handle carry
begin
    temp_sum := unsigned('0' & A) + unsigned('0' & B);
    if Cin = '1' then
        temp_sum := temp_sum + 1;
    end if;
    add_result <= std_logic_vector(temp_sum(31 downto 0));
end process;

-- Subtraction: A - B (with borrow handling if needed)
process(A, B, Cin)
    variable temp_diff : signed(32 downto 0);  -- 33 bits to handle borrow
begin
    temp_diff := signed('0' & A) - signed('0' & B);
    if Cin = '1' then
        temp_diff := temp_diff - 1;  -- Handle borrow
    end if;
    sub_result <= std_logic_vector(temp_diff(31 downto 0));
end process;

-- Output multiplexer
with opcode select
    temp_result <= and_out    when "0000",  -- AND
                   or_out     when "0001",  -- OR  
                   add_result when "0010",  -- ADD
                   sub_result when "0110",  -- SUB
                   (others => '0') when others;

-- Assign output
Dout <= temp_result;

-- Zero flag: set when all bits of output are '0'
zero <= '1' when Dout = x"00000000" else '0';

end Behavioral;
