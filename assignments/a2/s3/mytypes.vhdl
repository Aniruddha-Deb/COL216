library IEEE;
use IEEE.STD_LOGIC_1164.all;

package MyTypes is
    subtype word is std_logic_vector (31 downto 0);
    subtype hword is std_logic_vector (15 downto 0);
    subtype byte is std_logic_vector (7 downto 0);
    subtype nibble is std_logic_vector (3 downto 0);
    subtype bit_pair is std_logic_vector (1 downto 0);

    constant cpsr_N: integer := 0;
    constant cpsr_Z: integer := 1;
    constant cpsr_C: integer := 2;
    constant cpsr_V: integer := 3;    

    type optype is (andop, eor, sub, rsb, add, adc, sbc, rsc,
        tst, teq, cmp, cmn, orr, mov, bic, mvn);
    type instr_class_type is (DP, DT, MUL, BRN, none);
    type DP_subclass_type is (arith, logic, comp, test, none);
    type DP_operand_src_type is (reg, imm);
    type load_store_type is (load, store);
    type DT_offset_sign_type is (plus, minus);

    type signal_array is array(integer range <>) of std_logic_vector(31 downto 0);
end MyTypes;

package body MyTypes is
end MyTypes;
