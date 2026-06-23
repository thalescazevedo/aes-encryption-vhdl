library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;
use work.roms_package.all;

entity keySchedule is
    port(
        round_counter   : in std_logic_vector(3 downto 0);
        last_round_key  : in std_logic_vector(255 downto 0); 
        aes_type        : in std_logic_vector(1 downto 0);
        out_matrix      : out matriz_4x4;
        next_state      : out std_logic_vector(255 downto 0)
    );
end entity keySchedule;

architecture behavior of keySchedule is
    type word_array is array (0 to 11) of word;
begin

process(last_round_key, round_counter, aes_type)
    variable W          : word_array;
    variable prev1      : word;
    variable prevNk     : word;
    variable rcon_w     : word;
    variable temp       : word;
    
    variable r          : integer range 0 to 15;
    variable nk         : integer range 4 to 8;
    variable start_loop : integer range 4 to 8;
    variable end_loop   : integer range 7 to 11;
    variable g          : integer range 0 to 127; -- Margem de segurança
    variable rcon_idx   : integer range 0 to 31;
    variable g_mod_nk   : integer range 0 to 7;
    
    variable ns         : std_logic_vector(255 downto 0);
begin
    r := to_integer(unsigned(round_counter));
    ns := (others => '0');

    -- Mapeia as 8 palavras contidas no registrador atual (256 bits)
    W(0) := (last_round_key(127 downto 120), last_round_key(119 downto 112), last_round_key(111 downto 104), last_round_key(103 downto 96));
    W(1) := (last_round_key(95 downto 88),   last_round_key(87 downto 80),   last_round_key(79 downto 72),   last_round_key(71 downto 64));
    W(2) := (last_round_key(63 downto 56),   last_round_key(55 downto 48),   last_round_key(47 downto 40),   last_round_key(39 downto 32));
    W(3) := (last_round_key(31 downto 24),   last_round_key(23 downto 16),   last_round_key(15 downto 8),    last_round_key(7 downto 0));
    W(4) := (last_round_key(255 downto 248), last_round_key(247 downto 240), last_round_key(239 downto 232), last_round_key(231 downto 224));
    W(5) := (last_round_key(223 downto 216), last_round_key(215 downto 208), last_round_key(207 downto 200), last_round_key(199 downto 192));
    W(6) := (last_round_key(191 downto 184), last_round_key(183 downto 176), last_round_key(175 downto 168), last_round_key(167 downto 160));
    W(7) := (last_round_key(159 downto 152), last_round_key(151 downto 144), last_round_key(143 downto 136), last_round_key(135 downto 128));

    -- Inicializa as posições de cálculo avançadas para evitar latches inferidos no hardware
    W(8)  := (x"00", x"00", x"00", x"00");
    W(9)  := (x"00", x"00", x"00", x"00");
    W(10) := (x"00", x"00", x"00", x"00");
    W(11) := (x"00", x"00", x"00", x"00");

    -- Configura os limites dinâmicos de expansão baseados no tipo do AES
    if aes_type = "00" then     -- AES-128
        nk         := 4;
        start_loop := 4;
        end_loop   := 7;
    elsif aes_type = "01" then  -- AES-192
        nk         := 6;
        start_loop := 6;
        end_loop   := 9;
    else                        -- AES-256
        nk         := 8;
        start_loop := 8;
        end_loop   := 11;
    end if;

    -- Executa a expansão APENAS se não for a rodada inicial (Evita o index out of bounds em r=0)
    if r > 0 then
        -- O limite do for MUST ser estático (constante) para o sintetizador. 
        for i in 4 to 11 loop
            if i >= start_loop and i <= end_loop then
                g      := (4 * r) - 4 + i;
                prev1  := W(i - 1);
                prevNk := W(i - nk);
                
                -- Resolve o problema de divisão e módulo forçando constantes
                if aes_type = "00" then
                    g_mod_nk := g mod 4;
                    rcon_idx := g / 4;
                elsif aes_type = "01" then
                    g_mod_nk := g mod 6;
                    rcon_idx := g / 6;
                else
                    g_mod_nk := g mod 8;
                    rcon_idx := g / 8;
                end if;
                
                if g_mod_nk = 0 then
                    rcon_w(0) := RCON(rcon_idx);
                    rcon_w(1) := x"00";
                    rcon_w(2) := x"00";
                    rcon_w(3) := x"00";
                    temp      := XorWord(SubWord(RotWord(prev1)), rcon_w);
                    W(i)      := XorWord(prevNk, temp);
                elsif aes_type = "10" and g_mod_nk = 4 then 
                    temp      := SubWord(prev1);
                    W(i)      := XorWord(prevNk, temp);
                else
                    W(i)      := XorWord(prevNk, prev1);
                end if;
            end if;
        end loop;
    end if;

    -- Multiplexador essencial para injetar a chave correta no inicio (Round 0)
    for col in 0 to 3 loop
        if r = 0 then
            out_matrix(0, col) <= W(col)(0);
            out_matrix(1, col) <= W(col)(1);
            out_matrix(2, col) <= W(col)(2);
            out_matrix(3, col) <= W(col)(3);
        else
            out_matrix(0, col) <= W(4 + col)(0);
            out_matrix(1, col) <= W(4 + col)(1);
            out_matrix(2, col) <= W(4 + col)(2);
            out_matrix(3, col) <= W(4 + col)(3);
        end if;
    end loop;

    -- Desloca a janela em exatamente 4 palavras (128 bits) 
    ns(127 downto 96) := W(4)(0) & W(4)(1) & W(4)(2) & W(4)(3);
    ns(95 downto 64)  := W(5)(0) & W(5)(1) & W(5)(2) & W(5)(3);
    ns(63 downto 32)  := W(6)(0) & W(6)(1) & W(6)(2) & W(6)(3);
    ns(31 downto 0)   := W(7)(0) & W(7)(1) & W(7)(2) & W(7)(3);
    
    -- Completa a janela apenas para os casos aplicáveis (evitando latches inferidos)
    if end_loop >= 8 then
        ns(255 downto 224):= W(8)(0) & W(8)(1) & W(8)(2) & W(8)(3);
        ns(223 downto 192):= W(9)(0) & W(9)(1) & W(9)(2) & W(9)(3);
    end if;

    if end_loop >= 10 then
        ns(191 downto 160):= W(10)(0) & W(10)(1) & W(10)(2) & W(10)(3);
        ns(159 downto 128):= W(11)(0) & W(11)(1) & W(11)(2) & W(11)(3);
    end if;

    next_state <= ns;
end process;

end architecture behavior;