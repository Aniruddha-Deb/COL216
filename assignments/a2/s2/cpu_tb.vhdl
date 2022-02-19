library ieee;
use ieee.std_logic_1164.all;

entity cpu_tb is
end cpu_tb;

architecture cpu_tb_arc of cpu_tb is
    signal clock: std_logic := '0';
    constant clock_period: time := 10 ns;
begin
    uut: entity work.cpu port map (clock);

    clock <= not clock after clock_period/2;
end cpu_tb_arc;