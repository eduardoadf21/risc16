library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity alu is
port(  alu_control : in std_logic_vector(3 downto 0);
	   zero 	   : out std_logic;
	   a, b		   : in std_logic_vector(16 downto 0);
	   alu_out 	   : out std_logic_vector(16 downto 0));
end alu;

architecture bhv of alu is

signal slt : std_logic;

begin

	slt_setter : process(a,b) is
		begin
			if a > b then slt <= '1';
			elsif a < b then slt <= '0';
			else slt <= 'Z';
			end if;
	end process slt_setter;


	with alu_output select
		zero <= '1' when 16#00;
				'0' when others;


	with alu_control select
		alu_out <= a + b    when "0000";
				   a nand b when "0001";
				   a and b  when "0010";
				   a - b    when "0110";
				   slt      when "0111";
				   a nor b  when "1100";

end bhv;
