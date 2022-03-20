library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity shifter is
    port (
        shifter_in : in word;
        shifter_out: out word;
        carry_in: in std_logic;
        carry_out: out std_logic;
        shift_type: in bit_pair;
        shift_amt: in byte
        -- taking shift amount from register requires that we take the LSB, as
        -- shift amounts from register may be greater than 32 (ref: ARMARM)
        -- also see https://www.keil.com/support/man/docs/armasm/armasm_dom1361289852998.htm
        -- small details go a long way in making a compliant processor
    );
end shifter;

architecture shifter_arc of shifter is
begin
    upd_shifter: process(shifter_in, shift_amt, shift_type) 
        variable shift: integer;
    begin
        shift := to_integer(unsigned(shift_amt));

        if shift_type = "00" then
            shifter_out <= std_logic_vector(shift_left(unsigned(shifter_in), shift));
            if shift = 0 then
                carry_out <= carry_in;
            elsif (shift > 0) and (shift < 32) then
                carry_out <= shifter_in(32-shift);
            else
                carry_out <= '0';
            end if;
        elsif shift_type = "01" then
            shifter_out <= std_logic_vector(shift_right(unsigned(shifter_in), shift));
            if shift = 0 then 
                carry_out <= carry_in;
            elsif shift < 32 then
                carry_out <= shifter_in(shift-1);
            else
                carry_out <= '0';
            end if;
        elsif shift_type = "10" then
            shifter_out <= std_logic_vector(shift_right(signed(shifter_in), to_integer(unsigned(shift_amt))));
            if shift = 0 then
                carry_out <= carry_in;
            elsif shift < 32 then 
                carry_out <= shifter_in(shift-1);
            else
                carry_out <= shifter_in(31);
            end if;
        elsif shift_type = "11" then
            if shift = 0 then
                -- RRX is supposed to come in here ideally, however the way we've 
                -- structured our datapath, RRX will need some restructuring
                -- (namely the ability to distinguish between register shifts
                -- and immediate shifts by the shifter itself). for now, we'll 
                -- just implement ROR for register shift here and implement 
                -- RRX later
                shifter_out <= shifter_in; -- no shift 
                carry_out <= carry_in; -- pass on carry
            elsif shifter_in(4 downto 0) = "00000" then
                shifter_out <= shifter_in; -- shift is 0 modulo 32, so this works
                carry_out <= shifter_in(31); -- we still need to update carry tho
            elsif shift < 32 then
                shifter_out <= std_logic_vector(unsigned(shifter_in) ror to_integer(unsigned(shift_amt)));
                carry_out <= shifter_in(shift-1);
            else
                shifter_out <= std_logic_vector(unsigned(shifter_in) ror to_integer(unsigned(shift_amt)));
                carry_out <= shifter_in(31);
            end if;
        else
            -- just pass the values on - if shift_type is xx or something else
            shifter_out <= shifter_in;
            carry_out <= carry_in;
        end if;

    end process upd_shifter;

end shifter_arc;

--00 - logical left
--01 - logical right
--10 - arithmetic right
--11 - rotate right