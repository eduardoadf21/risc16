library ieee;
use ieee.std_logic_1164.all;

package risc16_package is

constant INITIAL_VALUE:std_logic_vector(15 downto 0) := "0000000000000000";

constant ADD    : std_logic_vector(2 downto 0):= "000";
constant ADDI   : std_logic_vector(2 downto 0):= "001";
constant NANDi  : std_logic_vector(2 downto 0):= "010";
constant LUI    : std_logic_vector(2 downto 0):= "011";
constant SW     : std_logic_vector(2 downto 0):= "100";
constant LW     : std_logic_vector(2 downto 0):= "101";
constant BEQ    : std_logic_vector(2 downto 0):= "110";
constant JALR   : std_logic_vector(2 downto 0):= "111";

constant R0 : std_logic_vector(2 downto 0):= "000";
constant R1 : std_logic_vector(2 downto 0):= "001";
constant R2 : std_logic_vector(2 downto 0):= "010";
constant R3 : std_logic_vector(2 downto 0):= "011";
constant R4 : std_logic_vector(2 downto 0):= "100";
constant R5 : std_logic_vector(2 downto 0):= "101";
constant R6 : std_logic_vector(2 downto 0):= "110";
constant R7 : std_logic_vector(2 downto 0):= "111";

component datapath
	port( clk  		: in std_logic;
		  reset     : in std_logic;
		  instruction : in std_logic_vector(15 downto 0);
		  RegWrite  : in std_logic;
		  ALUSrc    : in std_logic;
		  ExtSrc    : in std_logic;
          MemWrite  : in std_logic;
		  MemRead	: in std_logic;
		  MemtoReg  : in std_logic;
		  Branch    : in std_logic;
		  JumpL     : in std_logic);
end component;

component controller is
	port( opcode    : in std_logic_vector(2 downto 0);
		  RegWrite  : out std_logic;
		  ALUSrc    : out std_logic;
		  ExtSrc    : out std_logic;
          MemWrite  : out std_logic;
		  MemRead	: out std_logic;
		  MemtoReg  : out std_logic;
		  Branch    : out std_logic;
		  JumpL     : out std_logic);
end component;


component registers
port( clk        : in std_logic;
	  reset      : in std_logic;
	  RegWrite 	 : in std_logic;
	  rs_address : in std_logic_vector(2 downto 0);
	  rt_address : in std_logic_vector(2 downto 0);
	  rd_address : in std_logic_vector(2 downto 0);
	  write_data : in std_logic_vector(15 downto 0);
	  data_1	 : out std_logic_vector(15 downto 0);
	  data_2	 : out std_logic_vector(15 downto 0);
	  data_rd 	 : out std_logic_vector(15 downto 0));
end component;

component alu 
port(  alu_control : in std_logic_vector(3 downto 0);
	   zero 	   : out std_logic;
	   a, b		   : in std_logic_vector(15 downto 0);
	   alu_out 	   : out std_logic_vector(15 downto 0));
end component;

component nbitsmux is
	generic (N: integer:=8);
    port(  sel 	   : in std_logic;
 		   a, b	   : in std_logic_vector(N-1 downto 0);
		   mux_out : out std_logic_vector(N-1 downto 0));
end component;

component fake_memory is
	port( clk	   : in std_logic;
		  reset	   : in std_logic;
		  MemWrite : in std_logic;
		  MemRead  : in std_logic;
		  addr     : in std_logic_vector(15 downto 0);
		  write	   : in std_logic_vector(15 downto 0);
		  read	   : out std_logic_vector(15 downto 0));
end component;

end package risc16_package;
