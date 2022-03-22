library ieee;
use ieee.std_logic_1164.all;
use work.MyTypes.all;

entity predicator is
    port (
        condition: in condition_t;
        flags_in: in flags_t;
        p: out std_logic
    );
end predicator;

architecture predicator_arc of predicator is
begin
    p <= '1' when (condition = EQ and flags_in.zero = '1') else
         '1' when (condition = NE and flags_in.zero = '0') else
         '1' when (condition = HS and flags_in.carry = '1') else
         '1' when (condition = LO and flags_in.carry = '0') else
         '1' when (condition = MI and flags_in.negative = '1') else
         '1' when (condition = PL and flags_in.negative = '0') else
         '1' when (condition = VS and flags_in.overflow = '1') else
         '1' when (condition = VC and flags_in.overflow = '0') else
         '1' when (condition = HI and flags_in.carry = '1' and flags_in.zero = '0')  else
         '1' when (condition = LS and (flags_in.carry = '0' or flags_in.zero = '1')) else
         '1' when (condition = GE and flags_in.negative = flags_in.overflow) else
         '1' when (condition = LT and flags_in.negative /= flags_in.overflow) else
         '1' when (condition = GT and flags_in.zero = '0' and flags_in.negative = flags_in.overflow) else
         '1' when (condition = LE and not (flags_in.zero = '0' and flags_in.negative = flags_in.overflow)) else
         '1' when (condition = AL) else
         '0';
end predicator_arc;
