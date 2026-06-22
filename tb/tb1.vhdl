library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity tb1 is
end entity tb1;

architecture sim of tb1 is
    -- Sinais de interface com o UUT (Unit Under Test)
    signal s_round_counter : std_logic_vector(3 downto 0) := (others => '0');
    signal s_last_round_key: std_logic_vector(255 downto 0) := (others => '0');
    signal s_aes_type      : std_logic_vector(1 downto 0) := "00";
    signal s_out_matrix    : matriz_4x4;
    
    -- Sinal auxiliar linearizado para facilitar a visualização e assert no ModelSim
    signal s_out_128bits   : std_logic_vector(127 downto 0);

    -- ==========================================
    -- Vetores de Teste Oficiais (FIPS 197)
    -- ==========================================
    -- Apêndice A.1: AES-128
    -- Key is placed in bits 127 downto 0 (required by the implementation)
    constant KEY_AES128 : std_logic_vector(255 downto 0) := x"00000000000000000000000000000000" & x"2b7e151628aed2a6abf7158809cf4f3c";
    
    -- Apêndice A.2: AES-192
    -- Key placed with proper alignment for word extraction
    constant KEY_AES192 : std_logic_vector(255 downto 0) := x"62f8ead2522c6b7b8e73b0f7da0e6452" & x"c810f32b809079e50000000000000000";
    
    -- Apêndice A.3: AES-256
    -- Key with proper bit alignment
    constant KEY_AES256 : std_logic_vector(255 downto 0) := x"1f352c073b6108d72d9810a30914dff4" & x"603deb1015ca71be2b73aef0857d7781";

begin

    -- Instanciação do componente keySchedule
    uut: entity work.keySchedule
        port map (
            round_counter  => s_round_counter,
            last_round_key => s_last_round_key,
            aes_type       => s_aes_type,
            out_matrix     => s_out_matrix
        );

    -- Função auxiliar do pacote para converter a matriz de saída para um vetor de 128 bits
    s_out_128bits <= matriz_4x4_to_128bits(s_out_matrix);

    stim_proc: process
    begin
        -- Aguarda o startup inicial do simulador
        wait for 20 ns;

        -- ============================================================
        -- TESTE 1: AES-128 (Aes_type = "00")
        -- ============================================================
        report ">> INICIANDO VALIDACOES: AES-128 <<";
        s_aes_type <= "00";
        s_last_round_key <= KEY_AES128;
        
        s_round_counter <= "0000"; -- W0 .. W3 (original key)
        wait for 10 ns;
        assert s_out_128bits = x"2b7e151628aed2a6abf7158809cf4f3c" 
            report "Falha AES-128 Round 0" severity error;

        s_round_counter <= "0001"; -- W4 .. W7
        wait for 10 ns;
        assert s_out_128bits = x"a0fafe1788542cb123a339392a6c7605" 
            report "Falha AES-128 Round 1" severity error;


        -- ============================================================
        -- TESTE 2: AES-192 (Aes_type = "01")
        -- ============================================================
        report ">> INICIANDO VALIDACOES: AES-192 <<";
        s_aes_type <= "01";
        s_last_round_key <= KEY_AES192;
        
        s_round_counter <= "0000"; -- W0 .. W3 (original key, first 128 bits)
        wait for 10 ns;
        assert s_out_128bits = x"c810f32b809079e500000000" & x"00000000"
            report "Falha AES-192 Round 0" severity error;

        s_round_counter <= "0001"; -- W4 .. W7  
        wait for 10 ns;
        assert s_out_128bits = x"62f8ead2522c6b7bb86fd22b" & x"38ffabce"
            report "Falha AES-192 Round 1" severity error;


        -- ============================================================
        -- TESTE 3: AES-256 (Aes_type = "10")
        -- ============================================================
        report ">> INICIANDO VALIDACOES: AES-256 <<";
        s_aes_type <= "10";
        s_last_round_key <= KEY_AES256;
        
        s_round_counter <= "0000"; -- W0 .. W3 (original key, first 128 bits)
        wait for 10 ns;
        assert s_out_128bits = x"603deb1015ca71be2b73aef0857d7781"
            report "Falha AES-256 Round 0" severity error;

        s_round_counter <= "0001"; -- W4 .. W7
        wait for 10 ns;
        assert s_out_128bits = x"1f352c073b6108d72d9810a30914dff4"
            report "Falha AES-256 Round 2" severity error;


        -- Finalização
        report ">> TESTBENCH CONCLUIDO COM SUCESSO! <<";
        wait;
    end process;

end architecture sim;
