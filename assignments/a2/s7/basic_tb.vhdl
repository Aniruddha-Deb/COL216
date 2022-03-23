-- TESTCASE AUTOGENERATED by gentest
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity cpu_tb is
end cpu_tb;

architecture cpu_tb_arc of cpu_tb is
    signal clock: std_logic := '0';
    constant clock_period: time := 2 ns;
    signal memory: mem(127 downto 0) := (
        0 => X"E3A01008",
        1 => X"E3A02F8D",
        2 => X"E3A0020C",
        3 => X"E1A00202",
        4 => X"E1A00112",
        5 => X"E1A00222",
        6 => X"E1A00132",
        7 => X"E1A00242",
        8 => X"E1A00152",
        9 => X"E1A00262",
        10 => X"E1A00172",
        11 => X"E3A01038",
        12 => X"E1A00112",
        13 => X"E1A00132",
        14 => X"E1A00152",
        15 => X"E1A00172",
        16 => X"E3E02AFF",
        17 => X"E1A00442",
        18 => X"E1A00152",
        19 => X"E3A0102A",
        20 => X"E3A02008",
        21 => X"E3A00074",
        22 => X"E5801004",
        23 => X"E7801002",
        24 => X"E7801222",
        25 => X"E5903004",
        26 => X"E7904002",
        27 => X"E7905222",
        28 => X"00000000",
        29 => X"00000000",
        30 => X"00000000",
        31 => X"00000000",
        32 => X"00000000",
        others => X"00000000");

begin
    uut: entity work.cpu generic map (memory) port map (clock);

    clock <= not clock after clock_period/2;

end cpu_tb_arc;
