library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prog_mem is 
    port (
        addr: in std_logic_vector(5 downto 0);
        data: out std_logic_vector(31 downto 0)
    );
end prog_mem;

architecture prog_mem_df of prog_mem is

    type mem is array(63 downto 0) of std_logic_vector(31 downto 0);
    signal rom: mem := (
0 => x"E3A00001",
1 => x"E3A01001",
2 => x"E1500001",
3 => x"0A000001",
4 => x"E1500001",
5 => x"1A000001",
6 => x"E2411001",
7 => x"EAFFFFFB",
8 => x"E2400001",
9 => x"E1510000",
others => x"00000000"
                       ); 

begin
    data <= rom(to_integer(unsigned(addr)));
end prog_mem_df;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is
    port (
        r_addr : in std_logic_vector(5 downto 0);
        w_addr : in std_logic_vector(5 downto 0);
        w_en   : in std_logic_vector(3 downto 0); -- one hot byte write encoding
        data_in: in std_logic_vector(31 downto 0);
        clk    : in std_logic;
        output : out std_logic_vector(31 downto 0)
    );
end data_mem;

architecture data_mem_bvr of data_mem is
    
    type mem is array(63 downto 0) of std_logic_vector(31 downto 0);
    signal ram: mem; 

begin

    write: process(clk, w_en) 
    begin
        if rising_edge(clk) then
            if w_en(0) = '1' then
                ram(to_integer(unsigned(w_addr)))(7 downto 0) <= data_in(7 downto 0);
            end if;
            if w_en(1) = '1' then
                ram(to_integer(unsigned(w_addr)))(15 downto 8) <= data_in(15 downto 8);
            end if;
            if w_en(2) = '1' then
                ram(to_integer(unsigned(w_addr)))(23 downto 16) <= data_in(23 downto 16);
            end if;
            if w_en(3) = '1' then
                ram(to_integer(unsigned(w_addr)))(31 downto 24) <= data_in(31 downto 24);
            end if;
        end if;
    end process write;

    output <= ram(to_integer(unsigned(r_addr)));

end data_mem_bvr;
