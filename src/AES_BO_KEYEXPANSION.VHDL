library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;
use work.roms_package.all;

entity AES_BO_KEYEXPANSION is
    port(
  
        clk         : in  std_logic;     -- clk
        rst_a       : in  std_logic;     -- reset assíncrono
        user_key    : in  std_logic_vector(255 downto 0);  
        aes_type    : in  std_logic_vector(1 downto 0);
        load_init   : in  std_logic;     -- Vem do Bloco de Controle, autoriza este BO a funcionar e fazer o calculo.
        allRoundKeysOut : out allKeys
    );
end entity AES_BO_KEYEXPANSION;

architecture behavior of AES_BO_KEYEXPANSION is

    signal saida_keyExpansion:      allkeys;

BEGIN


    CALC: entity work.keyExpansionThales(behavior)
        port map (  

        );

    REGI: entity work.keys_register(behavior)
        port map(   clk => clk, 
                    enable => load_init,
		            rst_a => rst_a, 
		            d => saida_keyExpansion,  
		            q => allRoundKeysOut   

        );


end behavior;