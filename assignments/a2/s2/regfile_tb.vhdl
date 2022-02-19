library ieee;
use ieee.std_logic_1164.all;

entity regfile_tb is
end regfile_tb;

architecture regfile_tb_bvr of regfile_tb is

    signal r_addr_1: std_logic_vector(3 downto 0);
    signal r_addr_2: std_logic_vector(3 downto 0);
    signal w_addr: std_logic_vector(3 downto 0);
    signal data_in: std_logic_vector(31 downto 0);
    signal w_en: std_logic;
    signal clk: std_logic := '0';
    signal out_1: std_logic_vector(31 downto 0);
    signal out_2: std_logic_vector(31 downto 0);

    constant clk_period: time := 5 ns;

begin

    uut: entity work.regfile port map(r_addr_1, r_addr_2, w_addr, data_in, w_en, clk, out_1, out_2);

    clk <= not clk after clk_period/2;

    test: process
    begin
        w_addr <= "0000";
        data_in <= x"0000BABA";
        w_en <= '1';

        wait for clk_period;

        w_addr <= "0001";
        data_in <= x"0000DEBA";
        w_en <= '1';

        wait for clk_period/2;

        r_addr_1 <= "0001";
        r_addr_2 <= "0000";

        wait for clk_period/2;

        w_addr <= "0101";
        data_in <= x"CAFEBABE";
        w_en <= '1';

        wait for clk_period/2;

        r_addr_1 <= "0101";
        r_addr_2 <= "0001";
        
        wait for clk_period/2;

    end process test;

end regfile_tb_bvr;