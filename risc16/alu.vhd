library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity alu is
port(  alu_control : in std_logic_vector(3 downto 0);
	   zero 	   : out std_logic;
	   a		   : in std_logic_vector(15 downto 0);
	   b		   : in std_logic_vector(15 downto 0);
	   alu_out 	   : out std_logic_vector(15 downto 0));
end alu;

architecture bhv of alu is

signal slt : std_logic;
signal alu_out_sig : std_logic_vector(15 downto 0);

begin

	alu_out <= alu_out_sig;


	slt_setter : process(a,b) is
		begin
			if (conv_integer(a) > conv_integer(b)) then 
				slt <= '1';
			elsif (conv_integer(a) < conv_integer(b)) then 
				slt <= '0';
			else
				slt <= 'Z';
			end if;
	end process slt_setter;

	with alu_out_sig select

		zero <= '1' when "0000000000000000",
				'0' when others;


	with alu_control select
		alu_out_sig <= a + b    when "0000",
				       a nand b when "0001",
				       a and b  when "0010",
				       a - b    when "0101",
				       "000000000000000"&slt when "0111",
					   b(15 downto 6) & "000000" when "1000", -- lui
				       a when others;

end bhv;
