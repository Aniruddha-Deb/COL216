library ieee;
use ieee.std_logic_1164.all;
use work.MyTypes.all;

entity reg is
    generic (size : integer := 32 );
    port (
        data_in  : in std_logic_vector((size-1) downto 0);
        data_out : out std_logic_vector((size-1) downto 0);
        clock    : in std_logic;
        w_en     : in std_logic
    );
end reg;

architecture reg_arc of reg is
begin
    set: process(clock)
    begin
        if rising_edge(clock) and w_en = '1' then
            data_out <= data_in;
        end if;
    end process set;
end reg_arc;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity mux is
    generic (
        size : integer := 4;
        select_signal_size: integer := 2
    );
    port (
        input: in signal_array((size-1) downto 0);
        output: out std_logic_vector(31 downto 0);
        sel: in std_logic_vector((select_signal_size-1) downto 0)
    );
end mux;

architecture mux_arc of mux is
begin
    output <= input(to_integer(unsigned(sel)));
end mux_arc;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity mux_2 is
    generic (
        size: integer := 32
    );
    port (
        in_0: in std_logic_vector((size-1) downto 0);
        in_1: in std_logic_vector((size-1) downto 0);
        output: out std_logic_vector((size-1) downto 0);
        sel: in std_logic
    );
end mux_2;

architecture mux_2_arc of mux_2 is
begin
    output <= in_0 when sel = '0' else in_1;
end mux_2_arc;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity sign_extender is
    generic (in_size: integer := 12; out_size: integer := 32);
    port (
        data_in: in std_logic_vector((in_size-1) downto 0);
        data_out: out std_logic_vector((out_size-1) downto 0)
    );
end sign_extender;

architecture sign_extender_arc of sign_extender is
begin
    data_out <= std_logic_vector(resize(signed(data_in), out_size));
end sign_extender_arc;