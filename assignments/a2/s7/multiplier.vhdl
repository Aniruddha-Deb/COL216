library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.MyTypes.all;

entity multiplier is
    port (
        op_m1: in word;
        op_m2: in word;
        op_a: in dword;
        opcode: in mul_t;
        flags_in: in flags_t;
        flags_out: out flags_t;
        ans: out dword
    );
end multiplier;

architecture multiplier_arc of multiplier is
    signal um1, um2: unsigned(31 downto 0);
    signal sm1, sm2: signed(31 downto 0);
    signal umr, uma: unsigned(63 downto 0);
    signal smr, sma: signed(63 downto 0);
begin

    um1 <= unsigned(op_m1);
    um2 <= unsigned(op_m2);
    sm1 <= signed(op_m1);
    sm2 <= signed(op_m2);
    uma <= unsigned(op_a);
    sma <= signed(op_a);

    umr <= um1*um2 when opcode = MUL or opcode = MLA or opcode = UMULL or opcode = UMLAL else (others => '0');
    smr <= sm1*sm2 when opcode = SMULL or opcode = SMLAL else (others => '0');

    -- handling carries, ugh!
    ans <= std_logic_vector(umr) when opcode = MUL or opcode = UMULL else
           std_logic_vector(umr + uma) when opcode = MLA or opcode = UMLAL else
           std_logic_vector(smr) when opcode = SMULL else
           std_logic_vector(smr + sma) when opcode = SMLAL else
           x"0000000000000000";

end multiplier_arc;