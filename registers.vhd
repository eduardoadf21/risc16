library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity registers is
port( clk        : in std_logic;
	  reset      : in std_logic;
	  RegWrite 	 : in std_logic;
	  rs_address : in std_logic_vector(2 downto 0);
	  rt_address : in std_logic_vector(2 downto 0);
	  rd_address : in std_logic_vector(2 downto 0);
	  write_data : in std_logic_vector(15 downto 0);
	  data_1	 : out std_logic_vector(15 downto 0);
	  data_2	 : out std_logic_vector(15 downto 0);
	  data_rd    : out std_logic_vector(15 downto 0));
end registers;

architecture bhv of registers is

type BANKREG is array(0 to 7) of std_logic_vector(15 downto 0);

signal bank_register : BANKREG;

begin

data_1 <= bank_register(conv_integer(rs_address));
data_2 <= bank_register(conv_integer(rt_address));
data_rd <= bank_register(conv_integer(rd_address));

write_bank_register : process (clk,RegWrite,reset)
	begin
		if reset = '1' then
			bank_register(0) <= "0000000000000000"; -- r0 constante
			bank_register(1) <= "0000000000000100"; -- r1
			bank_register(2) <= "0000000000000010"; -- r2 
			bank_register(3) <= "0000000000010000"; -- r3 
			bank_register(4) <= "0000000000000000"; -- r4 
			bank_register(5) <= "0000000000000000"; -- r5 
			bank_register(6) <= "0000000000000000"; -- r6 
			bank_register(7) <= "0000000000000000"; -- r7
		elsif ((clk'event and clk ='1') and (RegWrite = '1')) then
			if (rd_address(2 downto 0) = 0) then
				bank_register(0) <= "0000000000000000";
			else
				bank_register(conv_integer(rd_address(2 downto 0))) <= write_data;
			end if;
		end if;
	end process write_bank_register;

end bhv;

-- reads to register 0 always returns 0
	
