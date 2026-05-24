library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity AES is

	port(
		clk        : in  std_logic;     -- ck
		rst_a      : in  std_logic;     -- reset
		init       : in  std_logic;     -- iniciar
		user_key   : in  std_logic_vector(127 downto 0); -- chave de 128 bits (16 bytes)(estamos fazendo AES-128, se fosse outros, devereriamos usar generic)
        user_text  : in  std_logic_vector(127 downto 0); -- texto plano de 128 bits
        cipher_text: out std_logic_vector(127 downto 0);  -- texto cifrado de 128 bits
        done       : out std_logic      -- sinal de conclusão
	);
end entity AES;

architecture behavior of AES is

    signal s_round_counter : std_logic_vector(3 downto 0);
    signal s_rp            : std_logic;
    signal s_i10           : std_logic;
    signal s_i0            : std_logic;

begin

    inst_AES_BC: entity work.AES_BC
        port map(
            clk           => clk,
            init          => init,
            rst_a         => rst_a,
            done          => done,
            round_counter => s_round_counter,
            rp            => s_rp,
            i10           => s_i10,
            i0            => s_i0
        );

    inst_AES_BO: entity work.AES_BO
        port map(
            clk           => clk,
            user_key      => user_key,
            user_text     => user_text,
            cipher_text   => cipher_text,
            round_counter => s_round_counter,
            rp            => s_rp,
            i10           => s_i10,
            i0            => s_i0
        );

end architecture behavior;