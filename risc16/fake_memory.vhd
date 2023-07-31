library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity fake_memory is

	port( clk	   : in std_logic;
		  reset	   : in std_logic;
		  MemWrite : in std_logic;
		  MemRead  : in std_logic;
		  addr     : in std_logic_vector(15 downto 0);
		  write	   : in std_logic_vector(15 downto 0);
		  read	   : out std_logic_vector(15 downto 0));
end fake_memory;


architecture bhv of fake_memory is

signal single_register : std_logic_vector(15 downto 0);

begin

write_memory : process(MemWrite,addr,clk,reset)
	--nao faz uso de addr, escreve sempre no mesmo registrador
	begin
		if reset = '1' then
			single_register <= "0000000000000000";
		elsif ((clk'event  and clk='1') and (MemWrite='1')) then
			single_register <= write;
		end if;
	end process write_memory;

read_memory : process(MemRead)
	begin
		if MemRead ='1' then
			read <= single_register;
		end if;
	end process read_memory;


end bhv;










