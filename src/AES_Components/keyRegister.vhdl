library ieee;
use ieee.std_logic_1164.all;

entity key_register is
    port(
        clk         : in  std_logic;
        rst         : in  std_logic;
        load_init   : in  std_logic;                      -- Em '1', carrega a chave-mestra
        init_key    : in  std_logic_vector(255 downto 0); -- A chave-mestra oriunda do mundo exterior
        next_state  : in  std_logic_vector(255 downto 0); 
        lrkey       : out std_logic_vector(255 downto 0)  
    );
end entity key_register;

architecture behavior of key_register is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            lrkey <= (others => '0');
        elsif rising_edge(clk) then
            if load_init = '1' then
                lrkey <= init_key;
            else
                lrkey <= next_state;
            end if;
        end if;
    end process;
end architecture behavior;