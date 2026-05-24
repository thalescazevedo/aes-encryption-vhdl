library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package AES_pack is

    type matriz_4x4 is array(0 to 3, 0 to 3) of std_logic_vector(7 downto 0); -- matriz de 4x4 bytes (128 bits)(16 bytes)

    function vetor128bits_to_matriz_4x4(input : std_logic_vector(127 downto 0)) return matriz_4x4; -- funcao que converte o vetor para matriz,
        -- com a ressalva de que o preenchimento e feito por colunas
    
    function matriz_4x4_to_128bits(input: matriz_4x4) return std_logic_vector(127 downto 0);

end package AES_pack;


package body AES_pack is

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