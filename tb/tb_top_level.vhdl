library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AES_pack.all;

entity tb_top_level is
end entity tb_top_level;

architecture tb of tb_top_level is
    signal clk: std_logic := '0';
    signal rst_a: std_logic := '1';
    signal init: std_logic := '0';
    signal aes_type: std_logic_vector(1 downto 0);
    signal user_key : std_logic_vector(255 downto 0);
    signal user_text : std_logic_vector(127 downto 0);
    signal ciphertext : std_logic_vector(127 downto 0);
    signal done : std_logic;

begin
    DUV: ENTITY work.AES
    port map(
        clk => clk, init => init, aes_type => aes_type, 
        user_key => user_key, user_text => user_text,
        cipher_text => ciphertext, done => done, rst_a => rst_a
    );
    
    clk <= not clk after 5 ns;
    process
    
    begin

        ------------------------------------------------------------------
        -- AES-128
        ------------------------------------------------------------------

        -- Teste 1(AES-128) -- 
        aes_type <= "00";

        user_text <= x"EF0C3A372EE59A8D198C18FB7F515E90";

        user_key <= (127 downto 0 => '0') & x"66DFE13FBC51B9E42BA945D497B6ACF2";

        init <= '1';
        wait until rising_edge(clk);
        init <= '0';

        wait until done = '1';

        assert ciphertext = x"6B06711367D69FF47E2A007542EE3D7C"
        report "Falha AES-128(Teste 1)"
        severity error;

        report "Teste 1(AES-128) bem-sucedido" severity note;
        -- Teste 2(AES-128) -- 

        rst_a <= '1';

        wait until rising_edge(clk);
        rst_a <= '0';

        user_text <= x"24624EAB44DBADD9EC1E4CE4B348284D";

        user_key <= (127 downto 0 => '0') & x"2F276694B48725442420881363AFF7A0";

        init <= '1';
        wait until rising_edge(clk);
        init <= '0';

        wait until done = '1';

        assert ciphertext = x"E79B182EE0F35FE03E73B8B8E987DA85"
        report "Falha AES-128(Teste 2)"
        severity error;

        report "Teste 2(AES-128) bem-sucedido" severity note;
        
        -- Teste 3(AES-128) -- 
        rst_a <= '1';

        wait until rising_edge(clk);
        rst_a <= '0';
        
        user_text <= x"0DFEC537C5193D9117D74B1A8CFF57CF";

        user_key <= (127 downto 0 => '0') & x"F4175A430381DC93739118F85C4308DA";

        init <= '1';
        wait until rising_edge(clk);
        init <= '0';

        wait until done = '1';

        assert ciphertext = x"00989E03A085CCCFD5D960459F17E582"
        report "Falha AES-128(Teste 2)"
        severity error;

        report "Teste 3(AES-128) bem-sucedido" severity note;


        ------------------------------------------------------------------
        -- AES-192
        ------------------------------------------------------------------

        -- Teste 1(AES-192) -- 
        rst_a <= '1';

        wait until rising_edge(clk);
        rst_a <= '0';

        aes_type <= "01";

        user_text <= x"517FCE781CC1F2FD4B93C07C2DC4416F";

        user_key <=
        (63 downto 0 => '0') & x"AD44BBF2AE96494AE46F1CF0FEFB43395439A27770AF35CC";

        init <= '1';
        wait until rising_edge(clk);
        init <= '0';

        wait until done = '1';

        assert ciphertext = x"96C5E1D84A22A7369F3F96A056A6B9EB"
        report "Falha AES-192"
        severity error;

         report "Teste 1(AES-192) bem-sucedido" severity note;
        
        -- Teste 2(AES-192) --
        rst_a <= '1';

        wait until rising_edge(clk);
        rst_a <= '0';

        aes_type <= "01";

        user_text <= x"FCC82875E6352A8927C54AA4A9841ACB";

        user_key <=
         (63 downto 0 => '0') & x"413EB76C43996CEBB0CBBC3680B04CC9C983977321C0DB81";

        init <= '1';
        wait until rising_edge(clk);
        init <= '0';

        wait until done = '1';

        assert ciphertext = x"39928D23ECBA5DDD130995724F15D3E2"
        report "Falha AES-192"
        severity error;

        report "Teste 2(AES-192) bem-sucedido" severity note;
        -- Teste 3(AES-192)
        rst_a <= '1';

        wait until rising_edge(clk);
        rst_a <= '0';

        aes_type <= "01";

        user_text <= x"788644E650082A802ED148FD91BBD111";

        user_key <=
        (63 downto 0 => '0') & x"3CD7A5ABD438333AC745BD8EA3CDEAD95A42FE0B6AFE274F";

        init <= '1';
        wait until rising_edge(clk);
        init <= '0';

        wait until done = '1';

        assert ciphertext = x"A00FEFF6812011E15AA5F83D9E7765DF"
        report "Falha AES-192"
        severity error;

         report "Teste 3(AES-192) bem-sucedido" severity note;

        ------------------------------------------------------------------
        -- AES-256
        ------------------------------------------------------------------
        
        -- Teste 1(AES-256) -- 
        rst_a <= '1';

        wait until rising_edge(clk);
        rst_a <= '0';

        aes_type <= "10";

        user_text <= x"EB82528D98A6DC4FA41C6C548B9F60D3";

        user_key <=
         x"46BDF75D3CB4AD61B0168BA61BC1B48F4C1B92413A763CFBD21A6C39A0BA4E42";

        init <= '1';
        wait until rising_edge(clk);
        init <= '0';

        wait until done = '1';

        assert ciphertext = x"FAB7D72950825A786C62908CA4CA3868"
        report "Falha AES-256"
        severity error;

        report "Teste 1(AES-256) bem-sucedido" severity note;

        -- Teste 2(AES-256) --
        rst_a <= '1';

        wait until rising_edge(clk);
        rst_a <= '0';

        aes_type <= "10";

        user_text <=  x"9C6C97BEF86F14A95C1BB7F90D077D3F";

        user_key <=
         x"EB373222EC287FBF440C6E002A205F70A35992AB19B3C168683FCDA7F917EE82";

        init <= '1';
        wait until rising_edge(clk);
        init <= '0';

        wait until done = '1';

        assert ciphertext = x"0A740162C564D8757D044F43DABCAA7F"
        report "Falha AES-256"
        severity error;

        report "Teste 2(AES-256) bem-sucedido" severity note;

        -- Teste 3(AES-256) --
        rst_a <= '1';

        wait until rising_edge(clk);
        rst_a <= '0';

        aes_type <= "10";

        user_text <=  x"5A7ECBEA4FD86C8884FAA560559779C7";

        user_key <=
         x"26822A4EE3DBD49798BF266208401F058D5468401A7BBF2C80F0C0CFFD835CFA";

        init <= '1';
        wait until rising_edge(clk);
        init <= '0';

        wait until done = '1';

        assert ciphertext =  x"9543739CC45211E37FEDE3B6AFF27FFC"
        report "Falha AES-256"
        severity error;

        report "Teste 3(AES-256) bem-sucedido" severity note; 


        report "TODOS OS TESTES PASSARAM";

    wait;
    end process;


    
end architecture tb;