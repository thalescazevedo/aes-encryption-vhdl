library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity AES_BO is

	port(
        -- toplevel--
		clk        : in  std_logic;     -- clk
		user_key   : in  std_logic_vector(255 downto 0); -- chave de 128 bits (16 bytes)(estamos fazendo AES-128, se fosse outros, devereriamos usar generic)
        user_text  : in  std_logic_vector(127 downto 0); -- texto plano de 128 bits
        cipher_text: out std_logic_vector(127 downto 0);  -- texto cifrado de 128 bits
        aes_type   : in  std_logic_vector(1 downto 0);

        -- bloco de controle --
        round_counter   : in std_logic_vector(3 downto 0);
        rp              : in std_logic;      -- signal de ativaçao do registrador da matriz parcial
        ilr             : in std_logic;      -- diz que já está no ultimo round ou nao
        i0              : in std_logic      -- diz se está no round 0 ou nao
	);
end entity AES_BO;

architecture behavior of AES_BO is
    signal round0_cipher                    : matriz_4x4;
    signal partial_cipher                   : matriz_4x4;
    signal partial_cipher_subbytes          : matriz_4x4;
    signal partial_cipher_shiftrows         : matriz_4x4;
    signal partial_cipher_mixcolumns        : matriz_4x4;
    signal in_partial_cipher_addroundkey    : matriz_4x4;
    signal roundKey                         : matriz_4x4;
    signal round_partial_cipher             : matriz_4x4;
    signal partial_cipher_addroundkey       : matriz_4x4;
    signal key_in_matriz                    : matriz_4x4;
    signal last_roundKey_mux                : std_logic_vector(255 downto 0);
    signal last_roundKey                    : std_logic_vector(255 downto 0);
    signal roundKey_bits                    : std_logic_vector(127 downto 0);
    signal lrkey                            : std_logic_vector(255 downto 0);

begin

    -- Primeiro passo: Colocar a primeira chave da rodada fazendo um xor entre user key e user text.
    round0_cipher <= vetor128bits_to_matriz_4x4(user_key(127 downto 0) xor user_text);

    SB: entity work.subBytes(behavior)
        port map (  in_matriz       => partial_cipher,
                    out_matriz      => partial_cipher_subbytes
        );
    
    SR: entity work.shiftrows(behavior)
        port map (  in_matriz       => partial_cipher_subbytes,
                    out_matriz      => partial_cipher_shiftrows
        );

    MC: entity work.mixColumns(behavior)
        port map (  in_matriz       => partial_cipher_shiftrows,
                    out_matriz      => partial_cipher_mixcolumns
        );

    M1: entity work.mux2x1(behavior) -- mux que ve se esta na ultima rodada pra pular ou nao mix columns
        port map (  sel         => ilr,
                    in_0        => partial_cipher_mixcolumns,
                    in_1        => partial_cipher_shiftrows,
                    y           => in_partial_cipher_addroundkey
        );

    ------------- key schedule e afins    -------------------------------------------

    KS: entity work.keySchedule(behavior) -- entra com a chave da ultima rodada, contador de rodada e devolve a nova chave de rodada
        port map (  round_counter   => round_counter,
                    last_round_key  => last_roundKey,  -- chave do ultimo round
                    aes_type        => aes_type,        -- passando o tipo de aes
                    out_matrix      => roundKey         -- matriz que faz o xor no addRound
        );
    roundKey_bits <= matriz_4x4_to_128bits(roundKey);

    LRK: entity work.LASTROUNDKEY(behavior) -- faz o chaveamento da saida de lr
        port map (  aes_type    => aes_type,
                    lrkey       => last_roundKey,    
                    ksr         => roundKey_bits,                     
                    new_lrkey   => lrkey
        );

    M2: entity work.mux2x1_stdlogic(behavior) -- mux pra definir se a entrada de keySchedule é a chave da rodada anterior a ou a do usuario
        generic map( N => 256)
        port map (  sel         => i0, 
                    in_0        => lrkey,
                    in_1        => user_key,
                    y           => last_roundKey_mux
        );

    RLK: entity work.n256bits_register(behavior) -- salva a chave da última rodada
        port map (  clk     => clk,
                    enable  => rp,
                    d       => last_roundKey_mux,
                    q       => last_roundKey
        );
    key_in_matriz <= vetor128bits_to_matriz_4x4(last_roundKey_mux(127 downto 0));
    ARK: entity work.addRoundKey(behavior)
        port map (  in_matriz       => in_partial_cipher_addroundkey,
                    in_keySchedule  => key_in_matriz,
                    out_matriz      => partial_cipher_addroundkey
        );

    M0: entity work.mux2x1(behavior) -- determina se o parcial é o xor do usuario ou o calculado
        port map (  sel         => i0,
                    in_0        => partial_cipher_addroundkey,
                    in_1        => round0_cipher,
                    y           => round_partial_cipher
        );

    RN: entity work.matriz4x4_register(behavior) -- salva o partial cipher da rodada
        port map (  clk     => clk,
                    enable  => rp,
                    d       => round_partial_cipher,
                    q       => partial_cipher
        );

    cipher_text <= matriz_4x4_to_128bits(partial_cipher);
    


end architecture behavior; 