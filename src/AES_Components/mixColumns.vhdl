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
	function xtime(b : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable result : std_logic_vector(7 downto 0);
begin
    result := b(6 downto 0) & '0';
    if b(7) = '1' then
        result := result xor "00011011";
    end if;
    return result;
end function;

begin 
	
end architecture behavior; 
