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

entity regfile is 
    port (
        r_addr_1: in std_logic_vector(3 downto 0);
        r_addr_2: in std_logic_vector(3 downto 0);
        w_addr: in std_logic_vector(3 downto 0);
        data_in: in std_logic_vector(31 downto 0);
        w_en: in std_logic;
        clk: in std_logic;
        out_1: out std_logic_vector(31 downto 0);
        out_2: out std_logic_vector(31 downto 0)
    );
end regfile;

architecture regfile_bvr of regfile is

    type memfile is array(15 downto 0) of std_logic_vector(31 downto 0);
    signal regs: memfile;

begin

    write: process(clk, w_en)
    begin
        if rising_edge(clk) and w_en = '1' then
            regs(to_integer(unsigned(w_addr))) <= data_in;
        end if;
    end process write;

    read_1: process(r_addr_1) 
    begin
        out_1 <= regs(to_integer(unsigned(r_addr_1)));
    end process read_1;

    read_2: process(r_addr_2)
    begin
        out_2 <= regs(to_integer(unsigned(r_addr_2)));
    end process read_2;

end regfile_bvr;
