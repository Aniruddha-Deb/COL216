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
        0 => X"E3A00005",
        1 => X"E3A01006",
        2 => X"E3A02000",
        3 => X"E3510001",
        4 => X"C0822000",
        5 => X"C2411001",
        6 => X"CAFFFFFB",
        others => X"00000000" );
begin
    uut: entity work.cpu generic map (memory) port map (clock);

    clock <= not clock after clock_period/2;

end cpu_tb_arc;
