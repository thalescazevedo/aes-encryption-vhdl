library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;
 
entity tb_mixColumns is
end entity tb_mixColumns;
 
architecture behavior of tb_mixColumns is
 
    component mixColumns is
        port(
            in_matriz  : in  matriz_4x4;
            out_matriz : out matriz_4x4
        );
    end component;
 
    signal in_matriz  : matriz_4x4;
    signal out_matriz : matriz_4x4;
 
begin
    mixC : mixColumns
        port map(
            in_matriz  => in_matriz,
            out_matriz => out_matriz
        );
 
    process
    begin
 
        -- Teste 1:
        -- Entrada esperada depois do SubBytes e ShiftRows da rodada 1:
        -- coluna 0: D4 BF 5D 30
        -- coluna 1: E0 B4 52 AE
        -- coluna 2: B8 41 11 F1
        -- coluna 3: 1E 27 98 E5
        --
        -- Saida esperada apos MixColumns:
        -- coluna 0: 04 66 81 E5
        -- coluna 1: E0 CB 19 9A
        -- coluna 2: 48 F8 D3 7A
        -- coluna 3: 28 06 26 4C
 
        in_matriz(0, 0) <= x"D4";
        in_matriz(1, 0) <= x"BF";
        in_matriz(2, 0) <= x"5D";
        in_matriz(3, 0) <= x"30";
 
        in_matriz(0, 1) <= x"E0";
        in_matriz(1, 1) <= x"B4";
        in_matriz(2, 1) <= x"52";
        in_matriz(3, 1) <= x"AE";
 
        in_matriz(0, 2) <= x"B8";
        in_matriz(1, 2) <= x"41";
        in_matriz(2, 2) <= x"11";
        in_matriz(3, 2) <= x"F1";
 
        in_matriz(0, 3) <= x"1E";
        in_matriz(1, 3) <= x"27";
        in_matriz(2, 3) <= x"98";
        in_matriz(3, 3) <= x"E5";
 
        wait for 20 ns;
 
        wait;
    end process;
 
end architecture behavior;
 
