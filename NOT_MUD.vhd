----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:01:27 03/02/2024 
-- Design Name: 
-- Module Name:    not_mud - Behavioral 
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

entity not_mud is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           F : out  STD_LOGIC_VECTOR (7 downto 0);
			  opcode : in STD_LOGIC_VECTOR (3 downto 0));
end not_mud;
architecture Behavioral of not_mud is
signal x : STD_LOGIC;
begin
x <= (opcode(0) and opcode(1)) and (not(opcode(3)) and opcode(2));
F(0) <= not(A(0)) and x;
F(1) <= not(A(1)) and x;
F(2) <= not(A(2)) and x;
F(3) <= not(A(3)) and x;
F(4) <= not(A(4)) and x;
F(5) <= not(A(5)) and x;
F(6) <= not(A(6)) and x;
F(7) <= not(A(7)) and x;

end Behavioral;

