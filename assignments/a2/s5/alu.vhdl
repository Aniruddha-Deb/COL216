library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity alu is 
    port (
        shift_op: in std_logic_vector(31 downto 0);
        op: in std_logic_vector(31 downto 0); 
        carry_in: in std_logic;
        opcode: in std_logic_vector(3 downto 0);
        ans: out std_logic_vector(31 downto 0);
        flags: out std_logic_vector(3 downto 0)
    );
end alu;

architecture alu_bvr of alu is
    signal temp_ans: std_logic_vector(32 downto 0);
begin
    temp_ans <= '0' & (op and shift_op) when opcode = "0000" else 
                '0' & (op xor shift_op) when opcode = "0001" else 
                std_logic_vector(resize(unsigned(op),33) - resize(unsigned(shift_op),33)) when opcode = "0010" else 
                std_logic_vector(resize(unsigned(shift_op),33) - resize(unsigned(op),33)) when opcode = "0011" else 
                std_logic_vector(resize(unsigned(shift_op),33) + resize(unsigned(op),33)) when opcode = "0100" else 
                std_logic_vector(resize(unsigned(shift_op),33) + resize(unsigned(op),33) + unsigned'('0'&carry_in)) when opcode = "0101" else 
                std_logic_vector(resize(unsigned(op),33) - resize(unsigned(shift_op),33) - unsigned'('0'&(not carry_in))) when opcode = "0110" else 
                std_logic_vector(resize(unsigned(shift_op),33) - resize(unsigned(op),33) - unsigned'('0'&(not carry_in))) when opcode = "0111" else 
                '0' & (op and shift_op) when opcode = "1000" else 
                '0' & (op xor shift_op) when opcode = "1001" else 
                std_logic_vector(resize(unsigned(op),33) - resize(unsigned(shift_op),33)) when opcode = "1010" else 
                std_logic_vector(resize(unsigned(shift_op),33) + resize(unsigned(op),33)) when opcode = "1011" else 
                '0' & (op or shift_op) when opcode = "1100" else 
                '0' & shift_op when opcode = "1101" else 
                '0' & (op and (not shift_op)) when opcode = "1110" else 
                '0' & (not shift_op) when opcode = "1111" else
                '0' & x"00000000";

    ans <= temp_ans(31 downto 0);
    flags(cpsr_N) <= temp_ans(31);
    flags(cpsr_Z) <= '1' when temp_ans(31 downto 0) = x"00000000" else '0';
    flags(cpsr_C) <= temp_ans(32);
    flags(cpsr_V) <= (shift_op(31) and op(31) and (not temp_ans(31))) or ((not shift_op(31)) and (not op(31)) and temp_ans(31));

end alu_bvr;