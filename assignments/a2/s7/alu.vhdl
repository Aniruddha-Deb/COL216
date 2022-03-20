library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity alu is
    port (
        shift_op: in word;
        op: in word; 
        flags_in: in flags;
        opcode: in DP_opcode_t;
        ans: out word;
        flags_out: out flags
    );
end alu;

architecture alu_bvr of alu is
    signal temp_ans: std_logic_vector(32 downto 0);
begin
    temp_ans <= '0' & (op and shift_op) when opcode = ANDOP else 
                '0' & (op xor shift_op) when opcode = EOR else 
                std_logic_vector(resize(unsigned(op),33) - resize(unsigned(shift_op),33)) when opcode = SUB else 
                std_logic_vector(resize(unsigned(shift_op),33) - resize(unsigned(op),33)) when opcode = RSB else 
                std_logic_vector(resize(unsigned(shift_op),33) + resize(unsigned(op),33)) when opcode = ADD else 
                std_logic_vector(resize(unsigned(shift_op),33) + resize(unsigned(op),33) + unsigned'('0'&flags_in.carry)) when opcode = ADC else 
                std_logic_vector(resize(unsigned(op),33) - resize(unsigned(shift_op),33) - unsigned'('0'&(not flags_in.carry))) when opcode = SBC else 
                std_logic_vector(resize(unsigned(shift_op),33) - resize(unsigned(op),33) - unsigned'('0'&(not flags_in.carry))) when opcode = RSC else 
                '0' & (op and shift_op) when opcode = TST else 
                '0' & (op xor shift_op) when opcode = TEQ else 
                std_logic_vector(resize(unsigned(op),33) - resize(unsigned(shift_op),33)) when opcode = CMP else 
                std_logic_vector(resize(unsigned(shift_op),33) + resize(unsigned(op),33)) when opcode = CMN else 
                '0' & (op or shift_op) when opcode = ORR else 
                '0' & shift_op when opcode = MOV else 
                '0' & (op and (not shift_op)) when opcode = BIC else 
                '0' & (not shift_op) when opcode = MVN else
                '0' & x"00000000";

    ans <= temp_ans(31 downto 0);
    flags_out.negative <= temp_ans(31);
    flags_out.zero     <= '1' when temp_ans(31 downto 0) = x"00000000" else '0';
    flags_out.carry    <= temp_ans(32);
    flags_out.overflow <= (shift_op(31) and op(31) and (not temp_ans(31))) or ((not shift_op(31)) and (not op(31)) and temp_ans(31));

end alu_bvr;