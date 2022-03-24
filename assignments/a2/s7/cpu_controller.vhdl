library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.MyTypes.all;

entity cpu_controller is
    generic (
        memory_defaults: mem(127 downto 0) := (others => x"00000000")
    );
    port (

        clock: in std_logic;

        -- alu;
        alu_shift_op : out word;
        alu_op : out word;
        alu_flags_in : out flags_t;
        alu_opcode : out DP_opcode_t;
        alu_ans : in word;
        alu_flags_out : in flags_t;

        -- multiplier;
        mult_op_m1: out word;
        mult_op_m2: out word;
        mult_op_a: out dword;
        mult_opcode: out mul_t;
        mult_flags_in: out flags_t;
        mult_flags_out: in flags_t;
        mult_ans: in dword;

        -- regfile;
        regfile_r_addr_1 : out nibble;
        regfile_r_addr_2 : out nibble;
        regfile_w_addr : out nibble;
        regfile_data_in : out word;
        regfile_w_en : out std_logic;
        regfile_out_1 : in word;
        regfile_out_2 : in word;

        -- memory;
        memory_addr : out word;
        memory_data_in : out word;
        memory_w_en : out nibble;
        memory_data_out : in word;

        -- pmconnect;
        pmconnect_Rout : out word;
        pmconnect_Rin : in word;
        pmconnect_dt_opcode : out DT_opcode_t;
        pmconnect_enable : out std_logic;
        pmconnect_adr : out bit_pair;
        pmconnect_Min : in word;
        pmconnect_Mout : out word;
        pmconnect_MW : in nibble;

        -- shifter;
        shifter_shifter_in : out word;
        shifter_shifter_out : in word;
        shifter_carry_in : out std_logic;
        shifter_carry_out : in std_logic;
        shifter_shift_type : out shift_t;
        shifter_shift_amt : out byte;

        -- predicator;
        predicator_condition : out condition_t;
        predicator_flags_in : out flags_t;
        predicator_p : in std_logic;

        -- instr_decoder;
        instr_decoder_instruction : out word;
        instr_decoder_instruction_class : in instruction_t;
        instr_decoder_DP_opcode : in DP_opcode_t;
        instr_decoder_condition : in condition_t;
        instr_decoder_DT_opcode : in DT_opcode_t;
        instr_decoder_mul_opcode: in mul_t;
        instr_decoder_shift : in shift_t
    );
end cpu_controller;

architecture cpu_controller_arc of cpu_controller is

    signal instruction: word;
    signal flags: flags_t;

    type regdata is record
        r_in: word;
        r_out: word;
        en: std_logic;
    end record;

    signal dr, ir, a, b, res_hi, res: regdata;
    signal pc: regdata := (r_in => x"00000000", r_out => x"00000000", en => '0');

    type fsm_state is (fetch, decode, shift, execute_dp, writeback_dp, 
        execute_dt, execute_b, writeback_dt_ldr, load_dt_ldr, writeback_dt_str,
        execute_mul, writeback_mul32, writeback_mul64_hi, writeback_mul64_lo);

    signal curr_state: fsm_state := fetch;

begin

    reg_dr: entity work.reg port map (dr.r_in, dr.r_out, dr.en, clock);
    reg_ir: entity work.reg port map (ir.r_in, ir.r_out, ir.en, clock);
    reg_a: entity work.reg port map (a.r_in, a.r_out, a.en, clock);
    reg_b: entity work.reg port map (b.r_in, b.r_out, b.en, clock);
    reg_res_hi: entity work.reg port map (res_hi.r_in, res_hi.r_out, res_hi.en, clock);
    reg_res: entity work.reg port map (res.r_in, res.r_out, res.en, clock);
    reg_pc: entity work.reg port map (pc.r_in, pc.r_out, pc.en, clock);

    -- should we take a signal oriented approach rather than a state oriented one to avoid latches?
    -- yes, implemented like this. It's cleaner

    instruction <= ir.r_out;

    alu_shift_op <= x"00000001" when curr_state = fetch else
                    std_logic_vector(resize(signed(instruction(23 downto 0)),32)) when instr_decoder_instruction_class = BRANCH else
                    x"00000"&instruction(11 downto 0) when instr_decoder_instruction_class = DT_IMM else
                    x"000000"&instruction(11 downto 8)&instruction(3 downto 0) when (instr_decoder_instruction_class = DT_HW_IMM or
                                                                                    instr_decoder_instruction_class = LDR_SIGNED_IMM) else
                    b.r_out;

    alu_op <= ("00"&pc.r_out(31 downto 2)) when (curr_state = fetch or curr_state = execute_b) else
              a.r_out;

    alu_flags_in <= (negative => '0', carry => '1', zero => '0', overflow => '0') when curr_state = execute_b else
                    flags when rising_edge(clock);

    flags <= alu_flags_out when rising_edge(clock) and curr_state = execute_dp and (instr_decoder_instruction_class = DP_IMM or instr_decoder_instruction_class = DP_REG_SHIFT or instr_decoder_instruction_class = DP_IMM_SHIFT) and instruction(20) = '1';

    alu_opcode <= ADD when (curr_state = fetch) else 
                  instr_decoder_DP_opcode when curr_state = execute_dp and 
                                               (instr_decoder_instruction_class = DP_IMM or
                                                instr_decoder_instruction_class = DP_REG_SHIFT or
                                                instr_decoder_instruction_class = DP_IMM_SHIFT) else
                  ADD when (curr_state = execute_dt and instruction(23) = '1') else
                  SUB when (curr_state = execute_dt and instruction(23) = '0') else
                  ADC when (curr_state = execute_b) else
                  MVN;

    -- multiplier;
    mult_op_m1 <= a.r_out;
    mult_op_m2 <= b.r_out;
    mult_op_a <= (regfile_out_1 & regfile_out_2) when instr_decoder_instruction_class = MUL_64 else
                 (x"00000000"&regfile_out_2) ;
    mult_opcode <= instr_decoder_mul_opcode;
    mult_flags_in <= flags when rising_edge(clock);

    -- regfile;
    regfile_r_addr_1 <= instruction(11 downto 8) when curr_state = shift else
                        instruction(11 downto 8) when curr_state = decode and (instr_decoder_instruction_class = MUL_64 or instr_decoder_instruction_class = MUL_32) else
                        instruction(19 downto 16);
    regfile_r_addr_2 <= instruction(15 downto 12) when curr_state = writeback_dt_str or curr_state = execute_mul else
                        instruction(3 downto 0);
                        -- HERE
    regfile_w_addr   <= instruction(19 downto 16) when (curr_state = writeback_dt_str or curr_state = load_dt_ldr) and (instruction(21) = '1' or (instruction(24) = '0' and instruction(21) = '0')) else
                        instruction(19 downto 16) when (curr_state = writeback_mul64_hi or curr_state = writeback_mul32) else
                        instruction(15 downto 12);
    regfile_data_in  <= dr.r_out when curr_state = writeback_dt_ldr else 
                        res_hi.r_out when curr_state = writeback_mul64_hi else
                        res.r_out;
    regfile_w_en     <= '1' when (curr_state = writeback_dt_ldr) else
                        '1' when (instr_decoder_instruction_class = DP_IMM or instr_decoder_instruction_class = DP_REG_SHIFT or instr_decoder_instruction_class = DP_IMM_SHIFT) and 
                                 (instr_decoder_DP_opcode /= CMP and instr_decoder_DP_opcode /= CMN and instr_decoder_DP_opcode /= TST and instr_decoder_DP_opcode /= TEQ) and curr_state = writeback_dp else
                        '1' when (curr_state = writeback_dt_str or curr_state = load_dt_ldr) and (instruction(21) = '1' or (instruction(24) = '0' and instruction(21) = '0')) else
                        '1' when (curr_state = writeback_mul32 or curr_state = writeback_mul64_hi or curr_state = writeback_mul64_lo) else
                        '0';

    -- memory;
    memory_addr     <= res.r_out when (curr_state = writeback_dt_str or curr_state = load_dt_ldr) and instruction(24) = '1' else
                       regfile_out_1 when (curr_state = writeback_dt_str or curr_state = load_dt_ldr) and instruction(24) = '0' else
                       pc.r_out;

    memory_data_in  <= pmconnect_Min;
    memory_w_en     <= pmconnect_MW;

    -- pmconnect;
    pmconnect_Rout   <= regfile_out_2;
    pmconnect_dt_opcode <= instr_decoder_DT_opcode;
    pmconnect_enable <= '1' when (curr_state = writeback_dt_str) else
                        '0';
    pmconnect_adr    <= res.r_out(1 downto 0);
    pmconnect_Mout   <= memory_data_out;

    -- shifter;
    shifter_shifter_in <= x"000000"&instruction(7 downto 0) when (instr_decoder_instruction_class = DP_IMM and curr_state = shift)
                          else regfile_out_2;
    shifter_carry_in <= flags.carry;
    shifter_shift_type <= instr_decoder_shift when ((instr_decoder_instruction_class = DP_IMM_SHIFT or instr_decoder_instruction_class = DP_REG_SHIFT) and curr_state = shift) else
                          instr_decoder_shift when instr_decoder_instruction_class = DT_REG else 
                          ROT_RIGHT when instr_decoder_instruction_class = DP_IMM else
                          LS_LEFT;
    shifter_shift_amt <= regfile_out_1(7 downto 0) when instr_decoder_instruction_class = DP_REG_SHIFT else
                         "000"&instruction(11 downto 7) when (instr_decoder_instruction_class = DP_IMM_SHIFT or instr_decoder_instruction_class = DT_REG) else
                         "000"&instruction(11 downto 8)&"0" when instr_decoder_instruction_class = DP_IMM else
                         x"00";

    -- predicator;
    predicator_condition <= instr_decoder_condition;
    predicator_flags_in <= flags when rising_edge(clock);

    -- instr_decoder;
    instr_decoder_instruction <= ir.r_out;

    -- registers!
    -- pc
    pc.r_in <= alu_ans(29 downto 0) & "00" ;
    pc.en <= '1' when curr_state = fetch or (curr_state = execute_b and predicator_p = '1') else '0';

    ir.r_in <= memory_data_out;
    ir.en <= '1' when curr_state = fetch else '0';

    dr.r_in <= pmconnect_Rin;
    dr.en <= '1' when curr_state = load_dt_ldr else '0';

    a.r_in <= regfile_out_1;
    a.en <= '1' when curr_state = decode else '0';

    b.r_in <= shifter_shifter_out;
    b.en <= '1' when curr_state = shift or curr_state = decode else '0';

    res_hi.r_in <= mult_ans(63 downto 32);
    res_hi.en <= '1' when curr_state = execute_mul else '0';

    res.r_in <= mult_ans(31 downto 0) when curr_state = execute_mul else alu_ans;
    res.en <= '1' when (curr_state = execute_dp or curr_state = execute_dt or curr_state = execute_mul) else '0';

    transition: process(clock)
    begin
        if rising_edge(clock) then
            if curr_state = fetch then
                curr_state <= decode;
            elsif curr_state = decode then
                if instr_decoder_instruction_class = DP_IMM_SHIFT or
                   instr_decoder_instruction_class = DP_REG_SHIFT or
                   instr_decoder_instruction_class = DP_IMM or
                   instr_decoder_instruction_class = DT_REG then
                    curr_state <= shift;
                elsif instr_decoder_instruction_class = BRANCH then
                    curr_state <= execute_b;
                elsif instr_decoder_instruction_class = MUL_64 or 
                      instr_decoder_instruction_class = MUL_32 then
                    curr_state <= execute_mul;
                else
                    curr_state <= execute_dt; -- all dp instructions require use of the shifter
                end if;
            elsif curr_state = shift then
                if instr_decoder_instruction_class = DP_IMM_SHIFT or
                   instr_decoder_instruction_class = DP_REG_SHIFT or
                   instr_decoder_instruction_class = DP_IMM then
                    curr_state <= execute_dp;
                else
                    curr_state <= execute_dt;
                end if;
            elsif curr_state = execute_dp then
                curr_state <= writeback_dp;
            elsif curr_state = execute_mul then
                if instr_decoder_instruction_class = MUL_64 then
                    curr_state <= writeback_mul64_lo;
                else
                    curr_state <= writeback_mul32;
                end if;
            elsif curr_state = writeback_mul64_lo then
                curr_state <= writeback_mul64_hi;
            elsif curr_state = execute_dt then
                if instruction(20) = '1' then
                    curr_state <= load_dt_ldr;
                else
                    curr_state <= writeback_dt_str;
                end if;
            elsif curr_state = load_dt_ldr then
                curr_state <= writeback_dt_ldr;
            else
                curr_state <= fetch;
            end if;
        end if;
    end process transition;

end cpu_controller_arc;
