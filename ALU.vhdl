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

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Dout : out  STD_LOGIC_VECTOR (7 downto 0);
           Status : inout  STD_LOGIC_VECTOR (4 downto 0);
           Opcode : in  STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is

component transfer 
	port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
			 F : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component and_mud 
	port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
			 B : in  STD_LOGIC_VECTOR (7 downto 0);
			 F : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component xor_mud 
	port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
			 B : in  STD_LOGIC_VECTOR (7 downto 0);
			 F : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component or_mud
	port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
			 B : in  STD_LOGIC_VECTOR (7 downto 0);
			 F : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component not_mud 
	port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
			 F : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

begin
case (opcode)
	
inst_transfer : transfer port map (
	A => A,
	F => Dout );
	
inst_and_mud : and_mud port map (
	A => A,
	B => B,
	F => Dout );

inst_xor_mud : xor_mud port map (
	A => A,
	B => B,
	F => Dout );
	
inst_or_mud : or_mud port map (
	A => A,
	B => B,
	F => Dout );
	
inst_not_mud : not_mud port map (
	A => A,
	F => Dout );

end Behavioral;

