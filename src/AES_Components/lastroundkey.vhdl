library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity lastroundkey is

	port(
		aes_type    : in  std_logic_vector(1 downto 0);
        lrkey       : in  std_logic_vector(255 downto 0); -- chave do ultimo round
        ksr         : in  std_logic_vector(127 downto 0); -- key schedule result ou round 0
		new_lrkey   : out std_logic_vector(255 downto 0)  -- dado armazenado
	);
end entity lastroundkey;

architecture behavior OF lastroundkey is
    signal partial : std_logic_vector(255 downto 0); 
begin

    process(aes_type, lrkey, ksr)
        begin
            CASE aes_type is
                when "00" => 
                    partial(127 downto 0)   <= ksr;
                    partial(255 downto 128) <= (others => '0');

                when "01" => 
                    partial(63 downto 0)    <= lrkey(191 downto 128);
                    partial(191 downto 64)  <= ksr;
                    partial(255 downto 192) <= (others => '0');

                when "10" => 
                    partial(127 downto 0)   <= lrkey(255 downto 128);
                    partial(255 downto 128) <= ksr;

                when others => partial <= (others => '0');   
            end case; 
    end process;
    new_lrkey <= partial;
    
end architecture behavior;