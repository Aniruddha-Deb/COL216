library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prog_mem_tb is
end prog_mem_tb;

architecture prog_mem_tb_bvr of prog_mem_tb is

    signal addr: std_logic_vector(5 downto 0);
    signal data: std_logic_vector(31 downto 0);

begin

    uut: entity work.prog_mem port map(addr, data);

    test: process
    begin
        for i in 0 to 63 loop
            addr <= std_logic_vector(to_unsigned(i,6));
            wait for 1 ns;
        end loop;

    end process test;

end prog_mem_tb_bvr;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem_tb is
end data_mem_tb;

architecture data_mem_tb_bvr of data_mem_tb is

    signal r_addr : std_logic_vector(5 downto 0);
    signal w_addr : std_logic_vector(5 downto 0);
    signal w_en   : std_logic_vector(3 downto 0); -- one hot byte write encoding
    signal data_in: std_logic_vector(31 downto 0);
    signal clk    : std_logic := '0';
    signal output : std_logic_vector(31 downto 0);

    constant clk_period: time := 1 ns;

begin

    uut: entity work.data_mem port map(r_addr, w_addr, w_en, data_in, clk, output);

    clk <= not clk after clk_period/2;

    test: process
    begin
        -- word writing
        for i in 0 to 63 loop
            w_addr <= std_logic_vector(to_unsigned(i,6));
            w_en <= "1111";
            r_addr <= std_logic_vector(to_unsigned(i,6));
            data_in <= std_logic_vector(to_unsigned((i*256),32));
            wait for clk_period;
        end loop;

        -- byte writing
        for i in 0 to 15 loop
            w_addr <= std_logic_vector(to_unsigned(i,6));
            w_en <= "0001";
            r_addr <= std_logic_vector(to_unsigned(i,6));
            data_in <= std_logic_vector(to_unsigned(i,32));
            wait for clk_period;
        end loop;

        w_en <= "0000";

        -- word reading
        -- for i in 0 to 63 loop
            -- r_addr <= std_logic_vector(to_unsigned(i,6));
            -- wait for clk_period/2;
        -- end loop;            
    end process test;

end data_mem_tb_bvr;

