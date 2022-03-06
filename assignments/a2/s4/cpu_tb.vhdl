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
        0 => X"E3A00028",
1 => X"E3A01005",
2 => X"E5801000",
3 => X"E2811002",
4 => X"E5801004",
5 => X"E5902000",
6 => X"E5903004",
7 => X"E0434002", others => X"00000000");
begin
    uut: entity work.cpu generic map (memory) port map (clock);

    clock <= not clock after clock_period/2;

end cpu_tb_arc;