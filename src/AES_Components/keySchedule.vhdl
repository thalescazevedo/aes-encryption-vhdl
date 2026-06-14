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
                variable w0, w1, w2, w3 : word;
                variable w4, w5, w6, w7 : word;
        variable nw0, nw1, nw2, nw3 : word;
        variable rcon_w  : word;
        variable rcon_idx : integer range 1 to 10;
        variable temp_matrix : matriz_4x4;
    begin
                -- Limpa a palavra de Rcon antes de preenchê-la.
                rcon_w := (others => (others => '0'));

                -- Lê somente a janela útil da chave conforme o tipo de AES.
                case aes_type is
                        when "00" =>
                                w0 := getKeyWord(last_round_key, 0, 4);
                                w1 := getKeyWord(last_round_key, 1, 4);
                                w2 := getKeyWord(last_round_key, 2, 4);
                                w3 := getKeyWord(last_round_key, 3, 4);

                        when "01" =>
                                w0 := getKeyWord(last_round_key, 0, 6);
                                w1 := getKeyWord(last_round_key, 1, 6);
                                w2 := getKeyWord(last_round_key, 2, 6);
                                w3 := getKeyWord(last_round_key, 3, 6);
                                w4 := getKeyWord(last_round_key, 4, 6);
                                w5 := getKeyWord(last_round_key, 5, 6);

                        when "10" =>
                                w0 := getKeyWord(last_round_key, 0, 8);
                                w1 := getKeyWord(last_round_key, 1, 8);
                                w2 := getKeyWord(last_round_key, 2, 8);
                                w3 := getKeyWord(last_round_key, 3, 8);
                                w4 := getKeyWord(last_round_key, 4, 8);
                                w5 := getKeyWord(last_round_key, 5, 8);
                                w6 := getKeyWord(last_round_key, 6, 8);
                                w7 := getKeyWord(last_round_key, 7, 8);

                        when others =>
                                w0 := getKeyWord(last_round_key, 0, 4);
                                w1 := getKeyWord(last_round_key, 1, 4);
                                w2 := getKeyWord(last_round_key, 2, 4);
                                w3 := getKeyWord(last_round_key, 3, 4);
                end case;
 
                -- O índice de Rcon para a próxima rodada é a rodada atual + 1.
        if to_integer(unsigned(round_counter)) < 10 then
                rcon_idx := to_integer(unsigned(round_counter)) + 1;
        else
                rcon_idx := 10;
        end if;
 
                -- Monta a palavra de Rcon: somente o primeiro byte é diferente de zero.
        rcon_w(0) := RCON(rcon_idx);
        rcon_w(1) := x"00";
        rcon_w(2) := x"00";
        rcon_w(3) := x"00";
 
                -- Gera somente as 4 palavras da próxima chave de rodada.
                case aes_type is
                        when "00" =>
                                nw0 := XorWord(w0, XorWord(SubWord(RotWord(w3)), rcon_w));
                                nw1 := XorWord(w1, nw0);
                                nw2 := XorWord(w2, nw1);
                                nw3 := XorWord(w3, nw2);

                        when "01" =>
                                nw0 := XorWord(w0, XorWord(SubWord(RotWord(w5)), rcon_w));
                                nw1 := XorWord(w1, nw0);
                                nw2 := XorWord(w2, nw1);
                                nw3 := XorWord(w3, nw2);

                        when "10" =>
                                nw0 := XorWord(w0, XorWord(SubWord(RotWord(w7)), rcon_w));
                                nw1 := XorWord(w1, nw0);
                                nw2 := XorWord(w2, nw1);
                                nw3 := XorWord(w3, nw2);

                        when others =>
                                nw0 := XorWord(w0, XorWord(SubWord(RotWord(w3)), rcon_w));
                                nw1 := XorWord(w1, nw0);
                                nw2 := XorWord(w2, nw1);
                                nw3 := XorWord(w3, nw2);
                end case;
        
        
                temp_matrix := (others => (others => x"00")); -- inicializa a matriz de saída
        
        temp_matrix := setWord(temp_matrix, 0, nw0);
        temp_matrix := setWord(temp_matrix, 1, nw1);
        temp_matrix := setWord(temp_matrix, 2, nw2);
        temp_matrix := setWord(temp_matrix, 3, nw3);
        
        out_matrix <= temp_matrix;

    end process;
-- SBOX e RCON já estão em Commons/roms_package


end architecture behavior; 
