library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity AES_BO is
    port(
        -- toplevel--
        clk         : in  std_logic;     -- clk
        rst_a       : in  std_logic;     -- reset assíncrono
        user_key    : in  std_logic_vector(255 downto 0); 
        user_text   : in  std_logic_vector(127 downto 0); 
        cipher_text : out std_logic_vector(127 downto 0);  
        aes_type    : in  std_logic_vector(1 downto 0);
        load_init   : in  std_logic;     -- Vem do Bloco de Controle

        -- bloco de controle --
        round_counter   : in std_logic_vector(3 downto 0);
        rp              : in std_logic;      
        ilr             : in std_logic;      
        i0              : in std_logic       
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
    
    -- Sinais de gerenciamento da chave limpos
    signal current_key_state                : std_logic_vector(255 downto 0); 
    signal ks_next_state                    : std_logic_vector(255 downto 0); 
    signal roundKey_bits                    : std_logic_vector(127 downto 0);

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

    M1: entity work.mux2x1(behavior) 
        port map (  sel         => ilr,
                    in_0        => partial_cipher_mixcolumns,
                    in_1        => partial_cipher_shiftrows,
                    y           => in_partial_cipher_addroundkey
        );

    ------------- key schedule e afins  -------------------------------------------
    
    KS: entity work.keySchedule(behavior) 
        port map (  
            round_counter   => round_counter,
            last_round_key  => current_key_state, -- Usa a chave armazenada atualmente
            aes_type        => aes_type,        
            out_matrix      => roundKey,         
            next_state      => ks_next_state 
        );

    roundKey_bits <= matriz_4x4_to_128bits(roundKey);

    -- Instanciação do registrador síncrono de hardware (Substitui M2 e RLK)
    LRK: entity work.key_register(behavior) 
        port map (  
            clk         => clk,            
            rst         => rst_a,          -- Ligado ao reset correto
            load_init   => load_init,      -- Sinal vindo do BC
            init_key    => user_key,       -- A chave injetada de fora
            next_state  => ks_next_state,  -- O cálculo da próxima rodada vindo do KS
            lrkey       => current_key_state -- Saída alimenta o KS no próximo clock
        );

    ARK: entity work.addRoundKey(behavior)
        port map (  in_matriz       => in_partial_cipher_addroundkey,
                    in_keySchedule  => roundKey,
                    out_matriz      => partial_cipher_addroundkey
        );
        
    M0: entity work.mux2x1(behavior) 
        port map (  sel         => i0,
                    in_0        => partial_cipher_addroundkey,
                    in_1        => round0_cipher,
                    y           => round_partial_cipher
        );

    RN: entity work.matriz4x4_register(behavior) 
        port map (  clk     => clk,
                    rst_a   => rst_a,
                    enable  => rp,
                    d       => round_partial_cipher,
                    q       => partial_cipher
        );

    cipher_text <= matriz_4x4_to_128bits(partial_cipher);

end architecture behavior;