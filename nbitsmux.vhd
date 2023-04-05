library ieee;
use ieee.std_logic_1164.all;


entity nbitsmux is
	generic (N: integer:=8);
    port(  sel 	   : in std_logic;
 		   a, b	   : in std_logic_vector(N-1 downto 0);
		   mux_out : out std_logic_vector(N-1 downto 0)
        );
end nbitsmux;

architecture bhv of nbitsmux is
begin

    mux_out <= a when sel = '0' else
               b;
end bhv;


