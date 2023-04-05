library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.risc16_package.all;


entity datapath is
	port( clk  		: in std_logic;
		  reset     : in std_logic;
		  instruction : in std_logic_vector(15 downto 0);
		  RegWrite  : in std_logic;
		  ALUSrc    : in std_logic;
		  ExtSrc    : in std_logic;
		  MemWrite  : in std_logic;
		  MemRead	: in std_logic;
		  MemtoReg  : in std_logic;
		  Branch 	: in std_logic; 
		  JumpL     : in std_logic);
end datapath;


architecture bhv of datapath is 


signal opcode, regA_address, regB_address, regC_address : std_logic_vector(2 downto 0);
signal imm7 			     : std_logic_vector(6 downto 0);
signal imm10				 : std_logic_vector(9 downto 0);
signal extended_imm7 		 : std_logic_vector(15 downto 0);
signal extended_imm10		 : std_logic_vector(15 downto 0);
signal extended_imm			 : std_logic_vector(15 downto 0);
signal alu_control 			 : std_logic_vector(3 downto 0);
signal data_to_register 	 : std_logic_vector(15 downto 0);
signal data_to_register_final: std_logic_vector(15 downto 0);
signal zero			 		 : std_logic;
signal alu_out 				 : std_logic_vector(15 downto 0);
signal data1_from_registers  : std_logic_vector(15 downto 0); 
signal data2_from_mux_to_alu : std_logic_vector(15 downto 0);
signal data2_from_registers  : std_logic_vector(15 downto 0);
signal data_from_rd   : std_logic_vector(15 downto 0);
signal alu_input2 : std_logic_vector(15 downto 0);

signal data_from_memory : std_logic_vector(15 downto 0);

signal PC_register : std_logic_vector(15 downto 0) := INITIAL_VALUE;
signal from_mux_to_pc : std_logic_vector(15 downto 0);
signal from_mux_to_pc_final : std_logic_vector(15 downto 0);
signal PC_add1_out : std_logic_vector(15 downto 0);
signal PC_add_imm_out : std_logic_vector(15 downto 0);
signal PCSrc	   : std_logic := '0';


begin

--sinal instruction é alimentado pela instruction memory
--que é acessada por PC
--mas nessa implementação instruction é uma entrada alimentada pelo testbench
opcode 	   	   <= instruction(15 downto 13);
regA_address   <= instruction(12 downto 10);
regB_address   <= instruction(9 downto 7);
regC_address   <= instruction(2 downto 0);
imm7   		   <= instruction(6 downto 0);
imm10  		   <= instruction(9 downto 0);



risc16_registers : registers
	port map ( clk 		  => clk,
			   reset 	  => reset,
			   RegWrite   => RegWrite,
			   rs_address => regB_address,
			   rt_address => regC_address,
			   rd_address => regA_address,
			   write_data => data_to_register_final,
			   data_1     => data1_from_registers,
			   data_2     => data2_from_registers,
			   data_rd    => data_from_rd
	);

--sign extension
extended_imm7  <= std_logic_vector(resize(signed(imm7), extended_imm7'length)); 

extended_imm10 <= std_logic_vector(resize(signed(imm10), extended_imm10'length));

mux_to_extended : nbitsmux
	generic map (N => 16)
	port map ( sel => ExtSrc,
			   a   => extended_imm7,
			   b   => extended_imm10,
			   mux_out => extended_imm
	);

mux_to_alu_source : nbitsmux
	generic map (N => 16)
	port map ( sel => ALUSrc,
			   a   => data2_from_registers,
			   b   => extended_imm,
			   mux_out => data2_from_mux_to_alu
	);

mux_to_alu : nbitsmux
	generic map (N => 16)
	port map (  sel => Branch,
				a  => data2_from_mux_to_alu,
				b  => data_from_rd,
				mux_out => alu_input2
	);

alu_main : alu
	port map( alu_control => alu_control, 
			  zero 		  => zero,	
		      a			  => data1_from_registers,
			  b 		  => alu_input2,
			  alu_out     => alu_out
	);


PC_add1 : alu
	port map (alu_control => "0000",
			  a           => PC_register,
			  b			  => "0000000000000001",
			  alu_out     => PC_add1_out
	);

PC_add_imm : alu
	port map (alu_control => "0000",
			  a	=> PC_add1_out,
			  b => extended_imm,
			  alu_out => PC_add_imm_out
	);

with alu_out select
	zero <= '1' when "0000000000000000",
			'0' when others;

PCSrc <= Branch and zero;

mux_to_PC : nbitsmux
	generic map (N => 16)
	port map ( sel => PCSrc,
			   a   => PC_add1_out,
			   b   => PC_add_imm_out,
			   mux_out => from_mux_to_pc
	);

mux_to_JumpL : nbitsmux
	generic map (N => 16)
	port map ( sel => JumpL,
			   a => from_mux_to_pc,
			   b => data1_from_registers,
			   mux_out => from_mux_to_pc_final
	);


write_PC : process(clk)
	begin
		if(clk'event and clk='1') then
		  PC_register <= from_mux_to_pc_final;
		end if;
	end process;



--data_to_register <= alu_out;
mux_data_src_ALUxMEM : nbitsmux
	generic map (N => 16)
	port map ( sel => MemToReg,
			   a   => data_from_memory,
			   b   => alu_out,
			   mux_out => data_to_register
	);

mux_data_to_registers : nbitsmux
	generic map (N => 16)
	port map ( sel => JumpL,
			   a => data_to_register,
			   b => PC_add1_out,
			   mux_out => data_to_register_final 
	);



memory : fake_memory
	port map ( clk => clk,
			   reset => reset,
			   MemWrite => MemWrite,
			   MemRead => MemRead,
			   addr => alu_out,
			   write => data_from_rd,
			   read  => data_from_memory
	);



--opcode define a função da ula
with opcode select
	alu_control  <= "0000" when "000", --add 
					"0000" when "001", --addi
					"0001" when "010", --nand
					"1000" when "011", --lui
					"0000" when "100", --sw
					"0000" when "101", --lw
					"0101" when "110", --beq
					"0000" when "111", --jalr
					"0000" when others;

end bhv;

			


