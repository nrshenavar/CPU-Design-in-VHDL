library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.TOP_PACKAGE.all;

entity Controlerl is
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
end Controlerl;

architecture Behavioral of Controlerl is
	TYPE STATE IS (SETUP,S0,S1,S2,S3,S4,S5,S6,Termination);--You can add new states based on your desing.
	SIGNAL CURRENT_STATE, NEXT_STATE : STATE := SETUP;
begin
	p1 : PROCESS(CLK) BEGIN
		IF CLK'EVENT and CLK = '1' THEN
			CURRENT_STATE <= NEXT_STATE;
		END IF;
	END PROCESS;
	
	p2 : PROCESS(CURRENT_STATE) BEGIN
		CASE CURRENT_STATE IS
			WHEN SETUP =>
				LoadFromFile <= '1';
				SaveToFile <= '0';
				next_state <= S0;
			WHEN Termination =>
				SaveToFile <= '1';
				LoadFromFile <= '0';
				--- Your code starts from here --
				
				
			WHEN S0 =>
				
			WHEN S1 =>
			  
			  IF OPCODE = BEQ THEN
			  
			  ELSIF OPCODE = SW THEN
			  
			  ELSIF OPCODE = LW THEN 
			  
			  ELSIF OPCODE = R THEN
			  
			  ELSE
					NEXT_STATE <= Termination;
			  END IF;
			WHEN S2 =>
			
			WHEN S3 =>

			WHEN S4 =>

			WHEN S5 =>

			WHEN S6 =>
			
		END CASE;
	END PROCESS;

end Behavioral;

