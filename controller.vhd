library ieee;
use ieee.std_logic_1164.all;
use work.risc16_package.all;

entity controller is
	port( opcode    : in std_logic_vector(2 downto 0);
		  RegWrite  : out std_logic;
		  ALUSrc    : out std_logic;
		  ExtSrc    : out std_logic;
          MemWrite  : out std_logic;
		  MemRead	: out std_logic;
		  MemtoReg  : out std_logic;
		  Branch    : out std_logic;
		  JumpL     : out std_logic);
end controller;

architecture bhv of controller is

begin

 process (opcode)
 begin 	
	case opcode is

		when ADD  => RegWrite <= '1';
					 ALUSrc   <= '0';
					 ExtSrc   <= 'X';
					 MemWrite <= '0';
					 MemRead  <= '0';
					 MemtoReg <= '1';
					 Branch   <= '0';
					 JumpL    <= '0';
	
		when ADDI => RegWrite <= '1';
				     ALUSrc   <= '1';
					 ExtSrc   <= '0';
					 MemWrite <= '0';
					 MemRead  <= '0';
					 MemtoReg <= '1';
					 Branch   <= '0';
					 JumpL    <= '0';

		when NANDi=> RegWrite <= '1';
				     ALUSrc   <= '0';
					 ExtSrc   <= '0';
					 MemWrite <= '0';
					 MemRead  <= '0';
					 MemtoReg <= '1';
					 Branch   <= '0';
					 JumpL    <= '0';

		when LUI =>  RegWrite <= '1';
					 ALUSrc   <= '1';
					 ExtSrc   <= '1';
					 MemWrite <= '0';
					 MemRead  <= '0';
					 MemtoReg <= '1';
					 Branch   <= '0';
					 JumpL    <= '0';

		when SW  =>  RegWrite <= '0';
					 ALUSrc   <= '1';
					 ExtSrc   <= '0';
					 MemWrite <= '1';
					 MemRead  <= '0';
					 MemtoReg <= 'X';
					 Branch   <= '0';
					 JumpL    <= '0';
					 
		when LW  =>  RegWrite <= '1';
					 ALUSrc   <= '1';
					 ExtSrc   <= '0';
					 MemWrite <= '0';
					 MemRead  <= '1';
					 MemtoReg <= '0';
					 Branch   <= '0';
					 JumpL    <= '0';

		when BEQ  => RegWrite <= '0';
					 ALUSrc   <= '0';
					 ExtSrc   <= '0';
					 MemWrite <= '0';
					 MemRead  <= '0';
					 MemtoReg <= 'X';
					 Branch   <= '1';
					 JumpL    <= '0';

		when JALR => RegWrite <= '0';
					 ALUSrc   <= '0';
					 ExtSrc   <= '0';
					 MemWrite <= '0';
					 MemRead  <= '0';
					 MemtoReg <= 'X';
					 Branch   <= '1';
					 JumpL    <= '1';

		when others => JumpL <= '0';
					   Branch <= '0';		
	end case;
   end process;

end bhv;
