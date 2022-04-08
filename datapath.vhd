library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity datapath is
	port( clk  		: in std_logic;
		  reset     : in std_logic;
		  instruction : in std_logic_vector(15 downto 0);
		  RegWrite  : in std_logic;
		  RegDst    : in std_logic;
		  ALUSrc    : in std_logic);
--		  ALUop		: in std_logic;
--		  MemWrite  : in std_logic;
--		  MemRead	: in std_logic;
--		  MemtoReg  : in std_logic);
end datapath;


architecture bhv of datapath is 


--signal instruction : std_logic_vector(15 downto 0);
signal opcode, regA_address, regB_address, regC_address : std_logic_vector(2 downto 0);
signal imm7 			     : std_logic_vector(6 downto 0);
signal extended_imm7 		 : std_logic_vector(15 downto 0);
signal imm10				 : std_logic_vector(9 downto 0);
signal alu_control 			 : std_logic_vector(3 downto 0);
signal mux_regDst_out 		 : std_logic_vector(2 downto 0);
signal data_to_register 	 : std_logic_vector(15 downto 0);
signal zero			 		 : std_logic;
signal alu_out 				 : std_logic_vector(15 downto 0);
signal data1_from_registers  : std_logic_vector(15 downto 0); 
signal data2_from_mux_to_alu : std_logic_vector(15 downto 0);
signal data2_from_registers  : std_logic_vector(15 downto 0);

signal fake_data_memory : std_logic_vector(15 downto 0);


component registers
port( clk        : in std_logic;
	  reset      : in std_logic;
	  RegWrite 	 : in std_logic;
	  rs_address : in std_logic_vector(2 downto 0);
	  rt_address : in std_logic_vector(2 downto 0);
	  rd_address : in std_logic_vector(2 downto 0);
	  write_data : in std_logic_vector(15 downto 0);
	  data_1	 : out std_logic_vector(15 downto 0);
	  data_2	 : out std_logic_vector(15 downto 0));
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

begin

--sinal instruction é alimentado pela instruction memory
--que é acessada por pc...
--mas nessa implementação instructioon é uma entrada alimentada pelo testbench
opcode 	   	   <= instruction(15 downto 13);
regA_address   <= instruction(12 downto 10);
regB_address   <= instruction(9 downto 7);
regC_address   <= instruction(2 downto 0);
imm7   		   <= instruction(6 downto 0);
imm10  		   <= instruction(9 downto 0);

mux_to_rd_source : nbitsmux 
	generic map (N => 3) 
	port map ( sel => RegDst, 
			   a   => regC_address,
			   b   => regA_address,
			   mux_out => mux_regDst_out 
	);

risc16_registers : registers
	port map ( clk 		  => clk,
			   reset 	  => reset,
			   RegWrite   => RegWrite,
			   rs_address => regC_address,
			   rt_address => regB_address,
			   rd_address => regA_address,
			   write_data => data_to_register,
			   data_1     => data1_from_registers,
			   data_2     => data2_from_registers
	);

--sign extension
--extended_imm7  <= resize(signed(imm7),16)

mux_to_alu_source : nbitsmux
	generic map (N => 16)
	port map ( sel => ALUSrc,
			   a   => data2_from_registers,
			   b   => extended_imm7,
			   mux_out => data2_from_mux_to_alu
	);

alu_main : alu
	port map( alu_control => alu_control, 
			  zero 		  => zero,	
		      a			  => data1_from_registers,
			  b 		  => data2_from_mux_to_alu,
			  alu_out     => alu_out
	);

data_to_register <= alu_out;

--opcode define a função da ula
with opcode select
	alu_control  <= "0000" when "000", --add 
					"0000" when "001", --addi
					"0001" when "010", --nand
					"0000" when "011", --lui
					"0000" when "100", --sw
					"0000" when "101", --lw
					"0101" when "110", --beq
					"0000" when "111", --jalr
					"0000" when others;

end bhv;

			


