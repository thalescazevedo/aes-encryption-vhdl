library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;
use work.roms_package.all; -- já está importando o pacote de roms
-- não mexa na declaracao da entidade!!!!!

-- ESSA KEYSCHEDULE NÃO É IDEAL PARA DECRIPTAR 

entity keySchedule is

	port(
        round_counter   : in std_logic_vector(3 downto 0);
        last_round_key  : in std_logic_vector(255 downto 0); -- chave do ultimo round completa. a depender do aes
        -- r0 pra usar em r1: aes 128: (X,X,X,X,W3,W2,W1,W0), -- aes 192: (X,X,W5,W4,W3,W2,W1,W0), -- aes 256: (W7,W6,W5,W4,W3,W2,W1,W0)
        -- r1 pra usar em r2: aes 128: (X,X,X,X,W7,W6,W5,W4), -- aes 192: (X,X,W9,W8,W7,W6,W5,W4), -- aes 256: (W11,W10,W9,W8,W7,W6,W5,W4)
        aes_type        : in std_logic_vector(1 downto 0);
        out_matrix      : out  matriz_4x4
	);
end entity keySchedule;

architecture behavior of keySchedule is

begin

process(last_round_key, round_counter, aes_type)
    begin
        -- Toda a sintese da chave para as rodadas foi movida para pacote AES_PACK
        -- Isso suporta AES-192 e AES-256 combinacionalmente sem necessitar armazenar janelas no buffer lastroundkey
        out_matrix <= expand_round_key(last_round_key, aes_type, to_integer(unsigned(round_counter)));
    end process;
-- SBOX e RCON já estão em Commons/roms_package


end architecture behavior;
