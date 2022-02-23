library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder is
    port (
        x : in std_logic;
        y : in std_logic;
        c_in : in std_logic;
        c_out: out std_logic;
        s : out std_logic
    );
end full_adder;

architecture full_adder_arc of full_adder is
begin
    s <= x xor y xor c_in;
    c_out <= (x and y) or (y and c_in) or (x and c_in);
end full_adder_arc;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comb_alu_ctrl is
    port (
        opcode: in std_logic_vector(3 downto 0);
        c_in: in std_logic;
        x, y, z, c_zero: out std_logic;
        op: out std_logic_vector(1 downto 0)
    );
end comb_alu_ctrl;

architecture comb_alu_ctrl_arc of comb_alu_ctrl is
begin
    update: process(opcode, c_in)
        variable a: std_logic := opcode(3);
        variable b: std_logic := opcode(2);
        variable c: std_logic := opcode(1);
        variable d: std_logic := opcode(0);
    begin
        x <= not (a and b and d);
        y <= c and (not d);
        z <= c and d and ((not a) or b);
        c_zero <= (not(a or b)) or (not(b or d)) or (c_in and (not a) and b and (d or c));
        op(0) <= (b or c) and ((not a) or (not b) or (not c) or d);
        op(1) <= (b or c or d) and ((not a) or (not b) or (not c) or d);
    end process update;
end comb_alu_ctrl_arc;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_cell is
    port (
        x, y, z, c_in, a, b: in std_logic;
        c_out, s: out std_logic;
        op: in std_logic_vector(1 downto 0)
    );
end alu_cell;

architecture alu_cell_arc of alu_cell is
    signal mux_in: std_logic_vector(3 downto 0);
    signal sig_op, sig_sop: std_logic;
begin
    sig_op <= (a and x) xor z;
    sig_sop <= b xor y;

    mux_in(0) <= sig_op and sig_sop;
    mux_in(1) <= sig_op or sig_sop;
    mux_in(2) <= sig_op xor sig_sop;

    adder: entity work.full_adder port map (sig_op, sig_sop, c_in, c_out, mux_in(3));

    s <= mux_in(to_integer(unsigned(op)));
end alu_cell_arc;

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
                '0' & (not shift_op) when opcode = "1111";

    ans <= temp_ans(31 downto 0);
    flags(cpsr_N) <= temp_ans(31);
    flags(cpsr_Z) <= '1' when temp_ans = x"00000000" else '0';
    flags(cpsr_C) <= temp_ans(32);
    flags(cpsr_V) <= (shift_op(31) and op(31) and (not temp_ans(31))) or ((not shift_op(31)) and (not op(31)) and temp_ans(31));

end alu_bvr;

architecture alu_df of alu is
    signal carries: std_logic_vector(32 downto 0);
    signal x, y, z, c_zero: std_logic;
    signal operation: std_logic_vector(1 downto 0);
    signal ans_temp: std_logic_vector(31 downto 0);
begin

    alu_control: entity work.comb_alu_ctrl port map (opcode, carry_in, x, y, z, carries(0), operation);

    gen_cells : for i in 0 to 31 generate
        alu_cell_x : entity work.alu_cell port map (x, y, z, carries(i), op(i), shift_op(i), carries(i+1), ans_temp(i), operation);
    end generate gen_cells;

    flags(cpsr_N) <= ans_temp(31);
    flags(cpsr_Z) <= '1' when ans_temp = x"00000000" else '0';
    flags(cpsr_C) <= carries(32);
    flags(cpsr_V) <= carries(32) xor carries(31);

    ans <= ans_temp;

end alu_df;

configuration alu_conf of alu is
    for alu_bvr end for;
    -- surprisingly, the combinational ALU uses more LUT's than the ugly 
    -- behavioural ALU (180 sth vs 133). Maybe because mentor optimizes std_logic
    -- unsigned addition more easily?
end alu_conf;