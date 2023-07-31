library ieee;
use ieee.std_logic_1164.all;
use work.risc16_package.all;

entity testbench_datapath is
end testbench_datapath;

architecture bhv of testbench_datapath is

signal clk 			:  std_logic := '0'; 
signal reset 	    :  std_logic := '0';
signal finished     :  std_logic := '0';
signal instruction  :  std_logic_vector(15 downto 0);
signal RegWrite 	:  std_logic;
signal ALUSrc 	 	:  std_logic;
signal ExtSrc 		:  std_logic;
signal MemWrite		:  std_logic;
signal MemRead		:  std_logic;
signal MemtoReg		:  std_logic;
signal Branch 		:  std_logic;
signal JumpL 		:  std_logic;
signal opcode       :  std_logic_vector(2 downto 0);

begin

opcode <= instruction(15 downto 13);

risc_datapath : datapath 
	port map(clk,reset,instruction,RegWrite,ALUSrc,ExtSrc,MemWrite,MemRead,MemtoReg,Branch,JumpL);


risc_controller : controller
	port map (opcode,RegWrite,ALUSrc,ExtSrc,MemWrite,MemRead,MemtoReg,Branch,JumpL);


process(clk)
 begin
 	clk <= not clk after 60 ns when finished /= '1' else '0';
end process;

process
 begin
 	wait for 30 ns;
	reset <= '1';
	wait for 30 ns;
	reset <= '0';
	wait;  -- suspende o processo em definitivo
end process;

process
 begin
 	wait for 180 ns;	
	-- (RRR) op rA rB "0000" rC
	-- (RRI) op rA rB imm7
	-- (RI)  op rA imm10

	--R0=0 R1=4 R2=2 R3=16 R4-R7=0

	instruction <= SW&R2&R0&"0000000";
	wait for 120 ns;

	instruction <= LW&R6&R0&"0000000";
	wait for 120 ns;

	instruction <= ADD&R7&R6&"0000"&R2;
	wait for 120 ns;

	instruction <= BEQ&R0&R5&"0010000";
	wait for 120 ns;

	instruction <= JALR&R1&R0&"0000000";
	wait for 120 ns;

	instruction <= LUI&R2&"1111111111";
	wait for 120 ns;

	instruction <= SW&R2&R7&"1111111";
	wait for 120 ns;

	instruction <= LW&R6&R0&"0100000";
	wait for 120 ns;

	instruction <= ADD&R1&R2&"0000"&R3;
    wait for 120 ns; 

	instruction <= ADDI&R1&R2&"0100000"; 
	wait for 120 ns;

	instruction <= NANDi&R2&R5&"0000"&R6; 
	wait for 120 ns;

	instruction <= BEQ&R0&R7&"0100000";
	wait for 120 ns;

	instruction <= LUI&R4&"1011011011";
	wait for 120 ns;
/*
	instruction <= JALR&R7&R1&"0000000";	
	wait for 120 ns;

	instruction <= NANDi&R2&R5&"0000"&R6; 
	wait for 120 ns;

	instruction <= SW&R7&R0&"1111111";
	wait for 120 ns;

	instruction <= ADD&R3&R7&"0000"&R1;
    wait for 120 ns; 

	instruction <= LW&R6&R0&"0100000";
	wait for 120 ns;
*/
	finished <= '1';
	wait;
	
end process;

end bhv;



	
