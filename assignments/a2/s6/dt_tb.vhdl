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
        0 => X"E3A00078",
        1 => X"E3A010AD",
        2 => X"E3811CDE",
        3 => X"E38118FE",
        4 => X"E38114CA",
        5 => X"E5801000",
        6 => X"E1C010B4",
        7 => X"E1C010B6",
        8 => X"E5C01008",
        9 => X"E5C01009",
        10 => X"E5C0100A",
        11 => X"E5C0100B",
        12 => X"E5902000",
        13 => X"E1D020B0",
        14 => X"E1D020F0",
        15 => X"E1D020B2",
        16 => X"E1D020F2",
        17 => X"E5D02000",
        18 => X"E1D020D0",
        19 => X"E5D02001",
        20 => X"E1D020D1",
        21 => X"E5D02002",
        22 => X"E1D020D2",
        23 => X"E5D02003",
        24 => X"E1D020D3",
        25 => X"00000000",
        26 => X"00000000",
        27 => X"00000000",
        28 => X"00000000",
        29 => X"00000000",
        others => X"00000000" );
begin
    uut: entity work.cpu generic map (memory) port map (clock);

    clock <= not clock after clock_period/2;

end cpu_tb_arc;
