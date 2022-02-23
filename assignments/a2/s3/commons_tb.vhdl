library ieee;
use ieee.std_logic_1164.all;

entity mux_tb is
end mux_tb;

architecture mux_tb_arc of mux_tb is

    signal clock : std_logic;
    signal sig1: std_logic_vector(31 downto 0);
    signal sig2: std_logic_vector(31 downto 0);
    signal output: std_logic_vector(31 downto 0);
    signal sel: std_logic_vector(0 downto 0);

begin

    uut: entity work.mux port map (input(0) => sig1, input(1) => sig2, output => output, sel => sel);

    test: process
    begin
        sig1 <= x"00000000";
        sig2 <= x"FFFFFFFF";
        sel <= "1";

        wait for 5 ns;

        sel <= "0";

        wait for 5 ns;
    end process test;

end mux_tb_arc;