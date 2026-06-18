library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity shiftRows_tb is
end entity shiftRows_tb;

architecture behavior of shiftRows_tb is

    component shiftRows is
        port(
            in_matriz  : in  matriz_4x4;
            out_matriz : out matriz_4x4
        );
    end component;

    signal teste_in_matriz  : matriz_4x4;
    signal teste_out_matriz : matriz_4x4;

begin

  
    SRteste: shiftRows port map (
        in_matriz  => teste_in_matriz,
        out_matriz => teste_out_matriz
    );

    dados_teste: process
    begin
  --TESTE : 
        -- Matriz de entrada preenchida linha por linha:
        -- Linha 0: 10, 11, 12, 13
        -- Linha 1: 20, 21, 22, 23
        -- Linha 2: 30, 31, 32, 33
        -- Linha 3: 40, 41, 42, 43
        

        -- O resultado esperado em teste_out_matriz para o TESTE:
        -- Linha 0 (Shift 0): 10, 11, 12, 13
        -- Linha 1 (Shift 1): 21, 22, 23, 20
        -- Linha 2 (Shift 2): 32, 33, 30, 31
        -- Linha 3 (Shift 3): 43, 40, 41, 42

        
        -- Linha 0
       teste_in_matriz(0, 0) <= x"10"; teste_in_matriz(0, 1) <= x"11"; teste_in_matriz(0, 2) <= x"12"; teste_in_matriz(0, 3) <= x"13";
       

        -- Linha 1
        teste_in_matriz(1, 0) <= x"20"; teste_in_matriz(1, 1) <= x"21"; teste_in_matriz(1, 2) <= x"22"; teste_in_matriz(1, 3) <= x"23";
        

        -- Linha 2
        teste_in_matriz(2, 0) <= x"30"; teste_in_matriz(2, 1) <= x"31"; teste_in_matriz(2, 2) <= x"32"; teste_in_matriz(2, 3) <= x"33";
        


        -- Linha 3
        teste_in_matriz(3, 0) <= x"40"; teste_in_matriz(3, 1) <= x"41"; teste_in_matriz(3, 2) <= x"42"; teste_in_matriz(3, 3) <= x"43";

      --é pra ser automatico por que é combinacional, coloquei por padrao.
        wait for 20 ns;


        wait;
    end process;

end architecture behavior;
