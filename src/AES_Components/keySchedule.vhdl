library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;
use work.roms_package.all; -- já está importando o pacote de roms
-- não mexa na declaracao da entidade!!!!!

-- ESSA KEYSCHEDULE NÃO É IDEAL PARA DECRIPTAR 

entity keySchedule is

	port(
        in_matrix       : in  matriz_4x4;
        round_counter   : in std_logic_vector(3 downto 0);
        user_key        : in std_logic_vector(255 downto 0); -- passando a chave completa
        aes_type        : in std_logic_vector(1 downto 0);
        out_matrix      : out  matriz_4x4
	);
end entity keySchedule;

architecture behavior of keySchedule is

begin

process(in_matrix, round_counter)
        variable w0, w1, w2, w3 : word;
        variable nw0, nw1, nw2, nw3 : word;
        variable rcon_w  : word;
        variable rcon_idx : integer range 1 to 10;
        variable temp_matrix : matriz_4x4;
    begin
        -- Unpack the four current-round-key words from the input matrix columns
        w0 := getWord(in_matrix, 0);
        w1 := getWord(in_matrix, 1);
        w2 := getWord(in_matrix, 2);
        w3 := getWord(in_matrix, 3);
 
        -- RCON index for the NEXT round is current round + 1
        if to_integer(unsigned(round_counter)) < 10 then
                rcon_idx := to_integer(unsigned(round_counter)) + 1;
        else
                rcon_idx := 10;
        end if;
 
        -- Build the Rcon word: only the first byte is non-zero (FIPS 197 sect. 5.2)
        rcon_w(0) := RCON(rcon_idx);
        rcon_w(1) := x"00";
        rcon_w(2) := x"00";
        rcon_w(3) := x"00";
 
        -- Derive the four next-round words (Algorithm 2, lines 7-16)
        nw0 := XorWord(w0, XorWord(SubWord(RotWord(w3)), rcon_w));
        nw1 := XorWord(w1, nw0);
        nw2 := XorWord(w2, nw1);
        nw3 := XorWord(w3, nw2);
        
        
        temp_matrix := (others => (others => x"00")); -- inicializar
        
        temp_matrix := setWord(temp_matrix, 0, nw0);
        temp_matrix := setWord(temp_matrix, 1, nw1);
        temp_matrix := setWord(temp_matrix, 2, nw2);
        temp_matrix := setWord(temp_matrix, 3, nw3);
        
        out_matrix <= temp_matrix;

    end process;
--SBOX e RCON ja ta feito em Commons/roms_package


end architecture behavior; 
