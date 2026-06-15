library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity lastroundkey is

	port(
		aes_type    : in  std_logic_vector(1 downto 0);
        lrkey       : in  std_logic_vector(255 downto 0); -- chave do ultimo round
        ksr         : in  std_logic_vector(127 downto 0); -- key schedule result ou round 0
		new_lrkey   : out std_logic_vector(255 downto 0)  -- dado armazenado
	);
end entity lastroundkey;

architecture behavior OF lastroundkey is
begin

    process(aes_type, lrkey, ksr)
        begin
            -- Devido à complexidade de gerenciar a janela deslizante de 6 a 8 palavras 
            -- para AES-192 e AES-256 com inputs de apenas 4 palavras por rodada,
            -- este registrador agora apenas repassa a chave base constante,
            -- delegando a expansão unrolled combinacional para o AES_PACK.
            new_lrkey <= lrkey;
    end process;
    
end architecture behavior;
