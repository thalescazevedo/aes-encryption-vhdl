library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;
-- não mexa na declaracao da entidade!!!!!
entity addRoundKey is

	port(
        in_matriz         : in  matriz_4x4;
        in_keySchedule    : in matriz_4x4;
        out_matriz        : out  matriz_4x4
	);
end entity addRoundKey;

architecture behavior of addRoundKey is

begin




end architecture behavior; 
