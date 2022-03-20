-- Register File:
-- - Array of 16 std_logic_vectors of 32 bits each
-- - Two read addresses
-- - One write address
-- - One data input
-- - One write enable
-- - Clock
-- - Two Data outputs

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity regfile is 
    port (
        r_addr_1: in nibble;
        r_addr_2: in nibble;
        w_addr: in nibble;
        data_in: in word;
        w_en: in std_logic;
        clk: in std_logic;
        out_1: out word;
        out_2: out word
    );
end regfile;

architecture regfile_bvr of regfile is

    type memfile is array(15 downto 0) of word;
    signal regs: memfile;

begin

    write: process(clk, w_en)
    begin
        if rising_edge(clk) and w_en = '1' then
            regs(to_integer(unsigned(w_addr))) <= data_in;
        end if;
    end process write;

    out_1 <= regs(to_integer(unsigned(r_addr_1)));
    out_2 <= regs(to_integer(unsigned(r_addr_2)));

end regfile_bvr;
