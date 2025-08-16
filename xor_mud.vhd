----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:49:15 02/26/2024 
-- Design Name: 
-- Module Name:    xor_mud - Behavioral 
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

entity xor_mud is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
			  opcode : in STD_LOGIC_VECTOR (3 downto 0);
           F : out  STD_LOGIC_VECTOR (7 downto 0));
end xor_mud;

architecture Behavioral of xor_mud is
signal x : STD_LOGIC;
begin
x <= (opcode(0) nor opcode(3)) and (opcode(1) and opcode(2));
F(0) <= (A(0) xor B(0)) and x;
F(1) <= (A(1) xor B(1)) and x;
F(2) <= (A(2) xor B(2)) and x;
F(3) <= (A(3) xor B(3)) and x;
F(4) <= (A(4) xor B(4)) and x;
F(5) <= (A(5) xor B(5)) and x;
F(6) <= (A(6) xor B(6)) and x;
F(7) <= (A(7) xor B(7)) and x;

end Behavioral;

