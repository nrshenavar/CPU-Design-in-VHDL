----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:46:58 02/26/2024 
-- Design Name: 
-- Module Name:    and - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity and_mud is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           F : out  STD_LOGIC_VECTOR (31 downto 0);
			  opcode : in STD_LOGIC_VECTOR (3 downto 0));
end and_mud;

architecture Behavioral of and_mud is
signal x : STD_LOGIC;
begin
x <= (not(opcode(0) or opcode(1))) and (not(opcode(3))and opcode(2));
F(0) <= A(0) and B(0) and x;
F(1) <= A(1) and B(1) and x;
F(2) <= A(2) and B(2) and x;
F(3) <= A(3) and B(3) and x;
F(4) <= A(4) and B(4) and x;
F(5) <= A(5) and B(5) and x;
F(6) <= A(6) and B(6) and x;
F(7) <= A(7) and B(7) and x;
F(8) <= A(8) and B(8) and x;
F(9) <= A(9) and B(9) and x;
F(10) <= A(10) and B(10) and x;
F(11) <= A(11) and B(11) and x;
F(12) <= A(12) and B(12) and x;
F(13) <= A(13) and B(13) and x;
F(14) <= A(14) and B(14) and x;
F(15) <= A(15) and B(15) and x;
F(16) <= A(16) and B(16) and x;
F(17) <= A(17) and B(17) and x;
F(18) <= A(18) and B(18) and x;
F(19) <= A(19) and B(19) and x;
F(20) <= A(20) and B(20) and x;
F(21) <= A(21) and B(21) and x;
F(22) <= A(22) and B(22) and x;
F(23) <= A(23) and B(23) and x;
F(24) <= A(24) and B(24) and x;
F(25) <= A(25) and B(25) and x;
F(26) <= A(26) and B(26) and x;
F(27) <= A(27) and B(27) and x;
F(28) <= A(28) and B(28) and x;
F(29) <= A(29) and B(29) and x;
F(30) <= A(30) and B(30) and x;
F(31) <= A(31) and B(31) and x;
end Behavioral;

