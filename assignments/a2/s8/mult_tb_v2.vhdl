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
    signal input_data: word;
    signal memory: mem(127 downto 0) := (
        0 => X"E3A0EC01",
        1 => X"E6000011",
        2 => X"EA000000",
        3 => X"00000000",
        4 => X"E3A0000C",
        5 => X"E5900000",
        6 => X"E6000011",
        64 => X"E3A00003",
        65 => X"E3A01002",
        66 => X"E0020091",
        67 => X"E0230192",
        68 => X"E3A0020F",
        69 => X"E3A01004",
        70 => X"E0823091",
        71 => X"E0A23091",
        72 => X"E3E00001",
        73 => X"E0C23091",
        74 => X"E0E23091",
        others => X"00000000" );
begin
    uut: entity work.cpu generic map (memory) port map (clock, input_data);

    clock <= not clock after clock_period/2;

end cpu_tb_arc;