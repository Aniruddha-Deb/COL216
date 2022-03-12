library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.MyTypes.all;

entity shifter_tb is
end shifter_tb;

architecture shifter_tb_arc of shifter_tb is
    signal shifter_in : word;
    signal shifter_out: word;
    signal carry_in: std_logic;
    signal carry_out: std_logic;
    signal shift_type: std_logic_vector(1 downto 0);
    signal shift_amt: std_logic_vector(7 downto 0);
begin
    uut: entity work.shifter port map (shifter_in, shifter_out, carry_in, carry_out, shift_type, shift_amt);

    test: process
    begin
        shifter_in <= x"FE82948A";
        shift_type <= "00";
        shift_amt <= "00000101";

        wait for 2 ns;

        shifter_in <= x"FE82948A";
        shift_type <= "01";
        shift_amt <= "00000101";

        wait for 2 ns;

        shifter_in <= x"FE82948A";
        shift_type <= "10";
        shift_amt <= "00000101";

        wait for 2 ns;

        shifter_in <= x"FE82948A";
        shift_type <= "11";
        shift_amt <= "00000101";

        wait for 2 ns;

    end process test;
end shifter_tb_arc;