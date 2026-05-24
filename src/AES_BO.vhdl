library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity AES_BO is

	port(
        -- toplevel--
		clk        : in  std_logic;     -- clk
		user_key   : in  std_logic_vector(127 downto 0); -- chave de 128 bits (16 bytes)(estamos fazendo AES-128, se fosse outros, devereriamos usar generic)
        user_text  : in  std_logic_vector(127 downto 0); -- texto plano de 128 bits
        cipher_text: out std_logic_vector(127 downto 0);  -- texto cifrado de 128 bits

        -- bloco de controle --
        round_counter   : in std_logic_vector(3 downto 0);
        rp              : in std_logic;      -- signal de ativaçao do registrador da matriz parcial
        i10             : in std_logic;      -- diz que já está no round 10 ou nao
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
    signal last_roundKey_mux                : matriz_4x4;
    signal last_roundKey                    : matriz_4x4;
    signal in_1_m2                          : matriz_4x4;

begin

    -- Primeiro passo: Colocar a primeira chave da rodada fazendo um xor entre user key e user text.
    round0_cipher <= vetor128bits_to_matriz_4x4(user_key xor user_text);
    
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

    M1: entity work.mux_2to1(behavior) -- mux que ve se esta na ultima rodada pra pular ou nao mix columns
        port map (  sel         => i10,
                    in_0        => partial_cipher_mixcolumns,
                    in_1        => partial_cipher_shiftrows,
                    y           => in_partial_cipher_addroundkey
        );

    in_1_m2 <= vetor128bits_to_matriz_4x4(user_key);

    M2: entity work.mux_2to1(behavior) -- mux pra definir se a entrada de keySchedule é a chave da rodada anterior a ou a do usuario
        port map (  sel         => i0, 
                    in_0        => roundKey,
                    in_1        => in_1_m2,
                    y           => last_roundKey_mux
        );

    RLK: entity work.matriz4x4_register(behavior) -- salva a chave da última rodada
        port map (  clk     => clk,
                    enable  => rp,
                    d       => last_roundKey_mux,
                    q       => last_roundKey
        );

    KS: entity work.keySchedule(behavior) -- entra com a chave da ultima rodada, contador de rodada e devolve a nova chave de rodada
        port map (  in_matriz       => last_roundKey,
                    round_counter   => round_counter,
                    out_matriz      => roundKey
        );

    ARK: entity work.addRoundKey(behavior)
        port map (  in_matriz       => in_partial_cipher_addroundkey,
                    in_keySchedule  => roundKey,
                    out_matriz      => partial_cipher_addroundkey
        );

    M0: entity work.mux_2to1(behavior) -- determina se o parcial é o xor do usuario ou o calculado
        port map (  sel         => i0, -- ESSE SIGNAL tem que ser negado no bc
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