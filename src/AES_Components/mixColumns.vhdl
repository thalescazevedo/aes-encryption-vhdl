library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;
-- não mexa na declaracao da entidade!!!!!
entity mixColumns is

	port(
        in_matriz  : in  matriz_4x4;
        out_matriz : out  matriz_4x4
	);
end entity mixColumns;

architecture behavior of mixColumns is
	

begin 
	
end architecture behavior; 
