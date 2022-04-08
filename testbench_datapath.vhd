-- FORÇAR SAÍDA DE PC E SAÍDA DE INSTRUCTION MEMORY 
-- FORÇAR TODOS OS SINAIS DE CONTROLE
library ieee;
use ieee.std_logic_1164.all;

entity testbench_datapath is
end testbench_datapath;

architecture bhv of testbench_datapath is

component datapath
	port( clk  		: in std_logic;
		  reset     : in std_logic;
		  instruction : in std_logic_vector(15 downto 0);
		  RegWrite  : in std_logic;
		  RegDst    : in std_logic;
		  ALUSrc    : in std_logic);
--		  ALUop		: in std_logic;
--        MemWrite  : in std_logic;
--		  MemRead	: in std_logic;
--		  MemtoReg  : in std_logic);
end component;

signal clk 			:  std_logic := '1'; 
signal reset 	    :  std_logic := '0';
signal finished     :  std_logic := '0';
signal instruction  :  std_logic_vector(15 downto 0);
signal RegWrite 	:  std_logic;
signal RegDst		:  std_logic;
signal ALUSrc 	 	:  std_logic;


begin

datapath_0 : datapath 
	port map(clk,reset,instruction,RegWrite,RegDst,ALUSrc);

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
	wait;  -- suspense o processo em definitivo
end process;

process
 begin
 	wait for 120 ns;	
	--				 op rA rB   -rC
 	instruction <= "0000010100000011"; --$A = $B + $C 
	RegWrite <= '1';
	RegDst   <= '1';
	ALUSrc   <= '0';
	wait for 120 ns;
	finished <= '1';
	wait;
end process;



end bhv;



	
