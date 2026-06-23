library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity lastroundkey is
	port(
		aes_type    : in  std_logic_vector(1 downto 0);
        lrkey       : in  std_logic_vector(255 downto 0); 
        ksr         : in  std_logic_vector(127 downto 0); 
        next_state  : in  std_logic_vector(255 downto 0); 
		new_lrkey   : out std_logic_vector(255 downto 0)  
	);
end entity lastroundkey;

architecture behavior OF lastroundkey is
begin
    process(aes_type, lrkey, ksr, next_state)
    begin
        -- Repassa o estado de janela calculado de forma limpa
        new_lrkey <= next_state;
    end process;
end architecture behavior;