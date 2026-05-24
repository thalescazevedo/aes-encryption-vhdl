library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity AES_BC is

	port(
        -- top level--
		clk        : in  std_logic;     -- clk
		init       : in  std_logic;     -- iniciar
        rst_a      : in  std_logic;
        done       : out std_logic;   
        -- para o bo --
        round_counter : out std_logic_vector(3 downto 0);
        rp            : out std_logic;      -- signal de ativaçao do registrador da matriz parcial
        i10           : out std_logic;      -- diz que já está no round 10 ou nao
        i0            : out std_logic      -- diz se está no round 0 ou nao
	);
end entity AES_BC;

architecture behavior of AES_BC is
    Type estado is (S0,S1,Scalc,Sverif,Sresult);
    signal EAtual: estado;
    signal PEstado: estado;
    
    signal s_counter : unsigned(3 downto 0);
begin

    round_counter <= std_logic_vector(s_counter);

 CRG: process (clk, rst_a)
    BEGIN
    
        if rst_a = '1' then
            EAtual <= S0;
            s_counter <= "0000";
        
        elsif rising_edge(clk) then
            EAtual <= PEstado;

            if EAtual = S0 then 
                s_counter <= "0000";
            elsif EAtual = S1 then
                s_counter <= "0001";
            
            elsif EAtual = Scalc then
                s_counter <= s_counter + 1;
            
            end if;
        end if;
    end process;
        
LPE: process (EAtual, init, s_counter)
    BEGIN
        CASE EAtual is
            when S0 =>
                if init = '1' then
                    PEstado <= S1;
                else PEstado <= s0;
                END IF;
            
            when S1 =>
                PEstado <= Scalc;
            
            when Scalc =>
                PEstado <= Sverif;
            
            when Sverif =>
                if s_counter <= 10 then
                    PEstado <= Scalc;
                else PEstado <= Sresult;
                end if;
            
            when Sresult => 
                PEstado <= S0;
            
            when others => 
                PEstado <= S0;
        end case;     
    end process;
    
    LS: process (EAtual,s_counter)
    BEGIN
    
        rp      <= '0';
        done    <= '0';
        i0      <= '0';
        i10     <= '0';
        
        CASE EAtual is
            when S0 => null;
            
            when S1 => 
                i0 <= '1';
                rp <= '1';
            
            when Scalc => 
                rp <= '1';
                if s_counter = 10 then
                    i10 <= '1';
                end if;
            
            when Sverif => null;
            
            when Sresult => 
                done <= '1';
               
        end case;    
    end process;
    

end architecture behavior; 


