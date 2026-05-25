library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package AES_pack is

    type matriz_4x4 is array(0 to 3, 0 to 3) of std_logic_vector(7 downto 0); -- matriz de 4x4 bytes (128 bits)(16 bytes)
    
    type word is array(0 to 3) of std_logic_vector(7 downto 0); -- tipo para representar uma palavra de 4 bytes (32 bits) (Linha da matriz)

    function RotWord(input : word) return word; -- funcao que rotaciona uma palavra para a esquerda (ex: [a0, a1, a2, a3] vira [a1, a2, a3, a0])
    
    function SubWord(input : word) return word; -- funcao que aplica a SBOX em cada byte da palavra (ex: [a0, a1, a2, a3] vira [SBOX[a0], SBOX[a1], SBOX[a2], SBOX[a3]])

    function vetor128bits_to_matriz_4x4(input : std_logic_vector(127 downto 0)) return matriz_4x4; -- funcao que converte o vetor para matriz,
        -- com a ressalva de que o preenchimento e feito por colunas
    
    function xtime(b : std_logic_vector(7 downto 0)) return std_logic_vector; -- funcao de multiplicar por 2 e evitar overflow com xor (nicolas usa essa tambem)
    
    function matriz_4x4_to_128bits(input: matriz_4x4) return std_logic_vector(127 downto 0);

end package AES_pack;


package body AES_pack is

    function RotWord(input : word) return word is
        variable output : word;
    begin
        output(0) := input(1);
        output(1) := input(2);
        output(2) := input(3);
        output(3) := input(0);
        return output;
    end function;

    function SubWord(input : word) return word is
        variable output : word;
    begin
        for i in 0 to 3 loop
            output(i) := SBOX(to_integer(unsigned(input(i))));
        end loop;
        return output;
    end function;

    function vetor128bits_to_matriz_4x4(input : std_logic_vector(127 downto 0)) return matriz_4x4 is
        variable output : matriz_4x4;
    begin
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                output(i, j) := input((127 - (i + j*4)*8) downto (120 - (i + j*4)*8));
            end loop;
        end loop;
        return output;
    end function;

    function xtime(b : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable result : std_logic_vector(7 downto 0);
    begin
        result := b(6 downto 0) & '0';
        if b(7) = '1' then
            result := result xor "00011011";
        end if;
        return result;
    end function;

    function matriz_4x4_to_128bits(input: matriz_4x4) return std_logic_vector(127 downto 0) is
        variable output : std_logic_vector(127 downto 0);
    begin
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                output((127 - (i + j*4)*8) downto (120 - (i + j*4)*8)) := input(i, j);
            end loop;
        end loop;
        return output;
    end function;

end package body AES_pack;
