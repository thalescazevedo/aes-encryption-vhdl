library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity matriz4x4_register is

	port(
		clk, enable : in  std_logic;  -- clock (clk) e carga (enable)
		d           : in  matriz_4x4; -- dado de entrada
		q           : out matriz_4x4  -- dado armazenado
	);
end matriz4x4_register;

architecture behavior OF matriz4x4_register is
    signal salvar : matriz_4x4; 
begin
     process(clk)
        BEGIN
            IF (rising_edge(clk)) THEN
                IF (enable = '1') THEN
                    salvar <= d;
                END IF;
            END IF; 
    END PROCESS;

    q <= salvar;
    
end architecture behavior;