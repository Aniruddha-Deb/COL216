library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity memory is
    port (
        clock : std_logic;
        addr : in word; -- byte addressed
        write_data: in word;
        w_en   : in std_logic_vector(3 downto 0); -- one hot byte write encoding
        output : out word
    );
end memory;

architecture memory_arc of memory is
    type mem is array(127 downto 0) of word; -- word organized for easier static program loading
    signal ram: mem;
begin
    read: process(addr)
        variable word_addr: integer;
    begin
        word_addr := to_integer(unsigned(addr(8 downto 2)));
        if addr(1 downto 0) = "00" then
            output(7 downto 0) <= ram(word_addr)(7 downto 0);
            output(15 downto 8) <= ram(word_addr)(15 downto 8);
            output(23 downto 16) <= ram(word_addr)(23 downto 16);
            output(31 downto 24) <= ram(word_addr)(31 downto 24); -- little endian ordering: LSB at smallest mem position
        else
            output <= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"; -- bad / unaligned addressing
        end if;
    end process read;

    write: process(clock, w_en)
        variable word_addr: integer;
    begin
        word_addr := to_integer(unsigned(addr(8 downto 2)));
        if rising_edge(clock) and addr(1 downto 0) = "00" then
            if w_en(0) = '1' then
                ram(word_addr)(7 downto 0) <= write_data(7 downto 0);
            end if;
            if w_en(1) = '1' then
                ram(word_addr)(15 downto 8) <= write_data(15 downto 8);
            end if;
            if w_en(2) = '1' then
                ram(word_addr)(23 downto 16) <= write_data(23 downto 16);
            end if;
            if w_en(3) = '1' then
                ram(word_addr)(31 downto 24) <= write_data(31 downto 24);
            end if;
        end if;
    end process write;

end memory_arc;
