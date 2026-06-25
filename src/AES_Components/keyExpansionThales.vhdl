library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

-- a geracao das chaves de rodada ocorrerá uma vez só. Geraremos todas as chaves no estado s2, previo a scalc.

entity keyExpansionThales is
	port(
		aes_type    : in  std_logic_vector(1 downto 0);
        lrkey       : in  std_logic_vector(255 downto 0); 
        ksr         : in  std_logic_vector(127 downto 0); 
        next_state  : in  std_logic_vector(255 downto 0); 
		new_lrkey   : out std_logic_vector(255 downto 0)  
	);
end entity keyExpansionThales;

architecture behavior OF keyExpansionThales is


    begin
    
end architecture behavior;