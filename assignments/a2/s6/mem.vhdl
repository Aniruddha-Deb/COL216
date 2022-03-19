library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity memory is
    generic (
        memory_defaults : mem(127 downto 0) := (others => x"00000000")
    );
    port (
        clock : std_logic;
        addr : in word; -- byte addressed
        data_in: in word;
        w_en   : in std_logic_vector(3 downto 0); -- one hot byte write encoding
        data_out : out word
    );
end memory;

architecture memory_arc of memory is
    signal ram: mem(127 downto 0) := memory_defaults;
begin
    read: process(addr)
        variable word_addr: integer;
    begin
        word_addr := to_integer(unsigned(addr(8 downto 2)));
--        if addr(1 downto 0) = "00" then
            data_out <= ram(word_addr); 
            -- Big Endian ordering: LSB at largest mem position
            -- you can think of the memory arrangement as a list of vectors:
            --  31  ...  00 31  ...  00 31  ...  00 31  ...  00 31  ...  00 
            -- |    W01    |    W02    |    W03    |    W04    |    W05    | -> 
--        else
--            data_out <= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"; -- bad / unaligned addressing
--        end if;
    end process read;

    write: process(clock, w_en)
        variable word_addr: integer;
    begin
        word_addr := to_integer(unsigned(addr(8 downto 2)));
        -- the write enable tells which bits to write to the vector
        if rising_edge(clock) then
            if w_en(0) = '1' then
                ram(word_addr)(7 downto 0) <= data_in(7 downto 0);
            end if;
            if w_en(1) = '1' then
                ram(word_addr)(15 downto 8) <= data_in(15 downto 8);
            end if;
            if w_en(2) = '1' then
                ram(word_addr)(23 downto 16) <= data_in(23 downto 16);
            end if;
            if w_en(3) = '1' then
                ram(word_addr)(31 downto 24) <= data_in(31 downto 24);
            end if;
        end if;
    end process write;

end memory_arc;
