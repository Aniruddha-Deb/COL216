library ieee;
use ieee.std_logic_1164.all;

entity cpsr_reg is
    port (
        cpsr_in: in std_logic_vector(3 downto 0);
        cpsr_out: out std_logic_vector(3 downto 0);
        update: in std_logic;
        clock : in std_logic
    );
end cpsr_reg;

architecture cpsr_reg_arc of cpsr_reg is
begin
    cpsr_out <= cpsr_in when ((rising_edge(clock)) and (update = '1'));
end cpsr_reg_arc;

library ieee;
use ieee.std_logic_1164.all;

entity condition_checker is
    port (
        condition: in std_logic_vector(3 downto 0);
        cpsr_reg: in std_logic_vector(3 downto 0);
        valid: out std_logic
    );
end condition_checker;

architecture condition_checker_arc of condition_checker is
begin
    valid <= '1' when (condition = "0000" and cpsr_reg(1) = '1') else
             '1' when (condition = "0001" and cpsr_reg(1) = '0') else
             '1' when condition = "1110" else
             '0';
end condition_checker_arc;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity cpu is
    port (
        clock: in std_logic
    );
end cpu;

architecture cpu_arch of cpu is
    signal PC: std_logic_vector(5 downto 0) := "000000";
    signal PC_in: std_logic_vector(5 downto 0);
    signal PC_plus1: std_logic_vector(5 downto 0);
    signal PC_branch: std_logic_vector(5 downto 0);

    -- control signals
    signal B, RW, Rsrc, Asrc, M2R: std_logic := '0';
    signal MW: std_logic_vector(3 downto 0);
    signal cond_true: std_logic := '0';

    -- decoder signals
    signal instr_class : instr_class_type;
    signal operation : optype;
    signal DP_subclass : DP_subclass_type;
    signal DP_operand_src : DP_operand_src_type;
    signal load_store : load_store_type;
    signal DT_offset_sign : DT_offset_sign_type;

    -- alu signals 
    signal shift_op: std_logic_vector(31 downto 0);
    signal op: std_logic_vector(31 downto 0); 
    signal carry_in: std_logic;
    signal opcode: std_logic_vector(3 downto 0);
    signal carry_out: std_logic;
    signal ans: std_logic_vector(31 downto 0);

    -- register file signals
    signal r_addr_2: std_logic_vector(3 downto 0);
    signal w_addr: std_logic_vector(3 downto 0);
    signal data_in: std_logic_vector(31 downto 0);
    signal out_2: std_logic_vector(31 downto 0);

    -- CPSR signals (NZCV)
    signal cpsr_in, cpsr_out: std_logic_vector(3 downto 0);
    signal update_flags: std_logic;

    -- data_mem signals
    signal w_en: std_logic_vector(3 downto 0);
    signal data_mem_out: std_logic_vector(31 downto 0);

    -- branch address can only be 6 bits long because program memory has 64 memory
    -- locations
    signal branch_addr: std_logic_vector(5 downto 0);

    signal instruction: std_logic_vector(31 downto 0);

begin

    prog_mem: entity work.prog_mem port map (PC, instruction);
    decoder: entity work.decoder port map (instruction, instr_class, operation, DP_subclass, DP_operand_src, load_store, DT_offset_sign);
    alu: entity work.alu port map (op, shift_op, cpsr_out(2), opcode, carry_out, ans);
    regfile: entity work.regfile port map (instruction(19 downto 16), r_addr_2, instruction(15 downto 12), data_in, RW, clock, shift_op, out_2);
    cpsr_reg: entity work.cpsr_reg port map (cpsr_in, cpsr_out, update_flags, clock);
    data_mem: entity work.data_mem port map (ans(5 downto 0), ans(5 downto 0), MW, out_2, clock, data_mem_out);
    condition_checker: entity work.condition_checker port map (instruction(31 downto 28), cpsr_out, cond_true);

    -- instruction control and flags update
    B <= '1' when ((cond_true = '1') and (instr_class = BRN)) else '0';
    RW <= '1' when (operation = add or operation = sub or operation = mov or ((instr_class = DT) and (load_store = load))) else '0';
    Asrc <= '1' when ((instr_class = DP and DP_operand_src = imm) or (instr_class = DT)) else '0';
    Rsrc <= '1' when ((instr_class = DT) and (load_store = store)) else '0';
    MW <= "1111" when ((instr_class = DT) and (load_store = store)) else "0000";
    M2R <= '1' when ((instr_class = DT) and (load_store = load)) else '0';
    update_flags <= '1' when (instruction(20) = '1' and instr_class = DP) else '0';

    -- reg file input
    r_addr_2 <= instruction(15 downto 12) when Rsrc = '1' else instruction(3 downto 0);

    -- alu input multiplexing
    -- we divide the memory address by 4 on load/store, as data memory is word 
    -- addressed.
    op <= out_2 when Asrc = '0' else 
          (x"FFFFF" & instruction(11 downto 0)) when (instr_class=DP and instruction(11) = '1') else
          (x"00000" & instruction(11 downto 0)) when (instr_class=DP and instruction(11) = '0') else
          (x"FFFFF" & "11" & instruction(11 downto 2)) when (instr_class=DT and instruction(11) = '1') else
          (x"00000" & "00" & instruction(11 downto 2));

    -- alu opcode and control
    opcode <= instruction(24 downto 21) when instr_class = DP else
              "0100" when (instr_class = DT and DT_offset_sign = plus) else
              "0010";

    -- N flag
    cpsr_in(0) <= ans(31);
    -- Z flag
    cpsr_in(1) <= '1' when ans = x"00000000" else '0';
    -- C flag
    cpsr_in(2) <= carry_out;
    -- V flag
    cpsr_in(3) <= (shift_op(31) or op(31)) xor ans(31);

    -- writeback
    data_in <= data_mem_out when M2R = '1' else ans;

    -- ? do we count PC modulo 64? will prevent overflow
    PC_plus1 <= std_logic_vector(signed(PC)+1); -- PC has word only addressing, so no need to add 4
    PC_branch <= std_logic_vector(signed(PC) + 2 + signed(instruction(5 downto 0)));
    PC_in <= PC_branch when B = '1' else PC_plus1;
    PC <= PC_in when rising_edge(clock);
    
end cpu_arch;
