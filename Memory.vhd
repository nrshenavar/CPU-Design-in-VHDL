library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;


entity Memory is
    GENERIC( DATA_WIDTH : INTEGER := 32;
             ADDRESS_WIDTH : INTEGER := 32);
    Port ( Write_DATA    : in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
           Address       : in  STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
           MEMRead       : in  STD_LOGIC;
           MEMWrite      : in  STD_LOGIC;
           LoadFromFile  : in  STD_LOGIC;  
           SaveToFile    : in  STD_LOGIC;  
           MEMData       : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));
end Memory;

architecture Behavioral of Memory is
    TYPE WORD_ARRAY_T IS ARRAY(0 to 32*32 - 1) OF STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
    SIGNAL MEM_BLOCKS : WORD_ARRAY_T := (others => (others => '0'));
begin
    PROCESS(MEMWrite, MEMRead, LoadFromFile, SaveToFile)
        VARIABLE index : INTEGER;
        FILE file_in  : TEXT OPEN READ_MODE IS "mem_input.txt";
        FILE file_out : TEXT OPEN WRITE_MODE IS "mem_output.txt";
        VARIABLE line_buf : LINE;
        VARIABLE temp_data : STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
    BEGIN
        IF LoadFromFile = '1' THEN
            FOR i IN 0 TO 32*32-1 LOOP
                IF NOT ENDFILE(file_in) THEN
                    READLINE(file_in, line_buf);
                    READ(line_buf, temp_data);
                    MEM_BLOCKS(i) <= temp_data;
                END IF;
            END LOOP;
        ELSIF SaveToFile = '1' THEN
            FOR i IN 0 TO 32*32-1 LOOP
                WRITE(line_buf, MEM_BLOCKS(i));
                WRITELINE(file_out, line_buf);
            END LOOP;
        ELSIF MEMWrite = '1' THEN
            index := TO_INTEGER(UNSIGNED(Address));
            MEM_BLOCKS(index) <= Write_DATA(7 DOWNTO 0);
			MEM_BLOCKS(index+1) <= Write_DATA(15 DOWNTO 8);
			MEM_BLOCKS(index+2) <= Write_DATA(23 DOWNTO 16);
			MEM_BLOCKS(index+3) <= Write_DATA(31 DOWNTO 24);
		ELSIF MEMRead = '1' THEN
            index := TO_INTEGER(UNSIGNED(Address));
            MEMData <= MEM_BLOCKS(index + 3) & MEM_BLOCKS(index + 2) & MEM_BLOCKS(index + 1) & MEM_BLOCKS(index);
        END IF;
    END PROCESS;

end Behavioral;
