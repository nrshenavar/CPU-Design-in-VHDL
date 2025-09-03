library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
    Port (
        CLK   : in  STD_LOGIC;
        RESET : in  STD_LOGIC
    );
end CPU;

architecture Structural of CPU is

    -- Component declarations
    component Controller
        Port (
            OPCODE      : in  STD_LOGIC_VECTOR(6 downto 0);
            FUNCT67     : in  STD_LOGIC_VECTOR(6 downto 0);
            FUNCT3      : in  STD_LOGIC_VECTOR(2 downto 0);
            PCWriteCond : out STD_LOGIC;
            PCWrite     : out STD_LOGIC;
            IorD        : out STD_LOGIC_VECTOR(0 downto 0);
            MemRead     : out STD_LOGIC;
            MemWrite    : out STD_LOGIC;
            MemtoReg    : out STD_LOGIC_VECTOR(0 downto 0);
            IRWrite     : out STD_LOGIC;
            RegWrite    : out STD_LOGIC;
            ALUSrcA     : out STD_LOGIC_VECTOR(0 downto 0);
            ALUSrcB     : out STD_LOGIC_VECTOR(1 downto 0);
            PCSource    : out STD_LOGIC_VECTOR(0 downto 0);
            ALUOp       : out STD_LOGIC_VECTOR(3 downto 0);
            LoadFromFile: out STD_LOGIC;
            SaveToFile  : out STD_LOGIC;
            CLK         : in  STD_LOGIC
        );
    end component;

    component Memory
        Generic ( DATA_WIDTH : INTEGER := 32;
                  ADDRESS_WIDTH : INTEGER := 32);
        Port ( Write_DATA   : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
               Address      : in  STD_LOGIC_VECTOR(ADDRESS_WIDTH-1 downto 0);
               MEMRead      : in  STD_LOGIC;
               MEMWrite     : in  STD_LOGIC;
               LoadFromFile : in  STD_LOGIC;
               SaveToFile   : in  STD_LOGIC;
               MEMData      : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0));
    end component;

    component ALU
        Port (
            A      : in  STD_LOGIC_VECTOR(31 downto 0);
            B      : in  STD_LOGIC_VECTOR(31 downto 0);
            Dout   : buffer STD_LOGIC_VECTOR(31 downto 0);
            Cin    : in STD_LOGIC;
            zero   : out STD_LOGIC;
            Opcode : in STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component RegisterBank
        Port (
            clk           : in  STD_LOGIC;
            RegWrite      : in  STD_LOGIC;
            ReadRegister1 : in  STD_LOGIC_VECTOR(4 downto 0);
            ReadRegister2 : in  STD_LOGIC_VECTOR(4 downto 0);
            WriteRegister : in  STD_LOGIC_VECTOR(4 downto 0);
            WriteData     : in  STD_LOGIC_VECTOR(31 downto 0);
            ReadData1     : out STD_LOGIC_VECTOR(31 downto 0);
            ReadData2     : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- Internal signals
    signal Instruction : STD_LOGIC_VECTOR(31 downto 0);
    signal PC          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ALUResult   : STD_LOGIC_VECTOR(31 downto 0);
    signal RegData1    : STD_LOGIC_VECTOR(31 downto 0);
    signal RegData2    : STD_LOGIC_VECTOR(31 downto 0);
    signal MemRead     : STD_LOGIC;
    signal MemWrite    : STD_LOGIC;
    signal LoadFromFile: STD_LOGIC;
    signal SaveToFile  : STD_LOGIC;
    signal RegWrite    : STD_LOGIC;
    signal ALUOp       : STD_LOGIC_VECTOR(3 downto 0);
    signal Zero        : STD_LOGIC;
    signal ALUCin      : STD_LOGIC := '0'; -- Default carry-in

begin

    -- Controller instance
    UUT_CTRL: Controller
        port map (
            OPCODE      => Instruction(6 downto 0),
            FUNCT67     => Instruction(31 downto 25),
            FUNCT3      => Instruction(14 downto 12),
            PCWriteCond => open,
            PCWrite     => open,
            IorD        => open,
            MemRead     => MemRead,
            MemWrite    => MemWrite,
            MemtoReg    => open,
            IRWrite     => open,
            RegWrite    => RegWrite,
            ALUSrcA     => open,
            ALUSrcB     => open,
            PCSource    => open,
            ALUOp       => ALUOp,
            LoadFromFile=> LoadFromFile,
            SaveToFile  => SaveToFile,
            CLK         => CLK
        );

    -- Memory instance
    UUT_MEM: Memory
        generic map (
            DATA_WIDTH => 32,
            ADDRESS_WIDTH => 32
        )
        port map (
            Write_DATA   => RegData2,         -- Data to write to memory (for SW)
            Address      => PC,               -- Address to read/write (for LW/SW)
            MEMRead      => MemRead,
            MEMWrite     => MemWrite,
            LoadFromFile => LoadFromFile,
            SaveToFile   => SaveToFile,
            MEMData      => Instruction       -- Instruction fetched from memory
        );

    -- RegisterBank instance
    UUT_REG: RegisterBank
        port map (
            clk           => CLK,
            RegWrite      => RegWrite,
            ReadRegister1 => Instruction(19 downto 15), -- rs1
            ReadRegister2 => Instruction(24 downto 20), -- rs2
            WriteRegister => Instruction(11 downto 7),  -- rd
            WriteData     => ALUResult,                 -- Always write ALU result (for ADD)
            ReadData1     => RegData1,
            ReadData2     => RegData2
        );

    -- ALU instance
    UUT_ALU: ALU
        port map (
            A      => RegData1,
            B      => RegData2,
            Dout   => ALUResult,
            Cin    => ALUCin,
            zero   => Zero,
            Opcode => ALUOp
        );

    -- PC update logic: increment PC by 4 every clock cycle
    process(CLK, RESET)
    begin
        if RESET = '1' then
            PC <= (others => '0');
        elsif rising_edge(CLK) then
            PC <= std_logic_vector(unsigned(PC) + 4);
        end if;
    end process;

end Structural;