library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity keySchedule is

	port(
        in_matriz       : in  matriz_4x4;
        round_counter   : std_logic_vector(3 downto 0);
        out_matriz      : in  matriz_4x4
	);
end entity keySchedule;

architecture behavior of keySchedule is

begin




end architecture behavior; 
