library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity cpu_multicycle_datapath is
    generic (
        memory_defaults: mem(127 downto 0)
    );
    port (
        clock : in std_logic;

        ctrl_alu_opcode : in std_logic_vector(3 downto 0);
        ctrl_alu_c_in : in std_logic;
        ctrl_alu_op_mux : in std_logic;
        ctrl_alu_shift_op_mux : in std_logic_vector(1 downto 0);

        ctrl_regfile_w_en : in std_logic;
        ctrl_regfile_w_data : in std_logic;
        ctrl_regfile_r_addr_1 : in std_logic;
        ctrl_regfile_r_addr_2 : in std_logic;

        ctrl_shift_amt : in std_logic;
        ctrl_shifter_in : in std_logic;
        ctrl_rot_imm : in std_logic;
        ctrl_shifter_carry_in : in std_logic;
        ctrl_shift_type : in std_logic_vector(1 downto 0);
        ctrl_offset_type : in std_logic;

        ctrl_pmc_instr : in DT_type;
        ctrl_pmc_en : in std_logic;

        ctrl_mem_ad_mux : in std_logic;
        
        ctrl_ir_write : in std_logic;
        ctrl_dr_write : in std_logic;
        ctrl_res_write : in std_logic;
        ctrl_pc_write : in std_logic;
        ctrl_a_write : in std_logic;
        ctrl_b_write : in std_logic;
        ctrl_preindex : in std_logic;
        ctrl_w_addr : in std_logic;
        
        ctrl_flag_set : in std_logic;
        ctrl_flags : in std_logic_vector(3 downto 0);
        ctrl_predict_cond : in std_logic_vector(3 downto 0);

        instr_copy: out std_logic_vector(31 downto 0);
        shifter_carry_out : out std_logic;
        alu_flags_out: out std_logic_vector(3 downto 0); -- TODO fix flags
        prediction: out std_logic;
        flags: out std_logic_vector(3 downto 0)
    );
end cpu_multicycle_datapath;

architecture cpu_multicycle_datapath_arc of cpu_multicycle_datapath is

    signal pc_in: word := x"00000000"; 
    signal pc_out: word := x"00000000";
    signal pc_shift_out: word;

    signal mem_ad: word;
    signal mem_wd: word;
    signal mem_w_en: std_logic_vector(3 downto 0);
    signal mem_output: word;

    signal dr_input: word;
    signal dr_output: word;

    signal regfile_rd_addr_1: std_logic_vector(3 downto 0);
    signal regfile_rd_addr_2: std_logic_vector(3 downto 0);
    signal regfile_data_in: word;
    signal regfile_out_1: word;
    signal regfile_out_2: word;

    signal shifter_in: word;
    signal shift_amt: byte;
    signal shifter_out: word;
    signal shift_imm_ext_out: byte;
    signal shift_imm_ext_in: std_logic_vector(4 downto 0);

    signal A_out: word;
    signal B_out: word;

    signal alu_shift_op: word;
    signal alu_op: word;
    signal alu_ans: word := x"00000000";
    signal branch_addr_shift: word;
    signal offset: word;

    signal shift_op_ext: word;
    signal branch_ext: word;
    signal offset_op_ext: word;
    signal offset_8_ext: word;
    signal regfile_w_addr: std_logic_vector(3 downto 0);

    signal flag_reg_out: std_logic_vector(3 downto 0);
    signal res_out: word;
    signal computed_address: word;

    signal instruction: word;
    signal rot_imm: std_logic_vector(4 downto 0);

begin
    pc_in <= alu_ans(29 downto 0)&"00";
    pc: entity work.reg port map (pc_in, pc_out, clock, ctrl_pc_write);
    
    mem_address_mux: entity work.mux_2 port map (pc_out, computed_address, mem_ad, ctrl_mem_ad_mux);
    preindex_mux: entity work.mux_2 port map (res_out, regfile_out_1, computed_address, ctrl_preindex);
    mem: entity work.memory generic map (memory_defaults) port map (clock, mem_ad, mem_wd, mem_w_en, mem_output);
    
    ir: entity work.reg port map (mem_output, instruction, clock, ctrl_ir_write);
    dr: entity work.reg port map (dr_input, dr_output, clock, ctrl_dr_write);
    
    rd_addr_1_mux: entity work.mux_2 generic map (4) port map (instruction(19 downto 16), 
            instruction(11 downto 8), regfile_rd_addr_1, ctrl_regfile_r_addr_1);
    rd_addr_2_mux: entity work.mux_2 generic map (4) port map (instruction(3 downto 0), 
            instruction(15 downto 12), regfile_rd_addr_2, ctrl_regfile_r_addr_2);
    regfile_data_in_mux: entity work.mux_2 port map (res_out, dr_output, regfile_data_in, ctrl_regfile_w_data);
    regfile_w_addr_mux: entity work.mux_2 generic map (4) port map (instruction(15 downto 12), instruction(19 downto 16), regfile_w_addr, ctrl_w_addr);
    regfile: entity work.regfile port map (regfile_rd_addr_1, 
            regfile_rd_addr_2, regfile_w_addr, regfile_data_in, 
            ctrl_regfile_w_en, clock, regfile_out_1, regfile_out_2);


    offset_8_ext <= x"000000" & instruction(11 downto 8) & instruction(3 downto 0);
    offset_mux: entity work.mux_2 port map (offset_op_ext, offset_8_ext, offset, ctrl_offset_type);

    shift_imm_ext_out <= "000"&shift_imm_ext_in;
    rot_imm <= (instruction(11 downto 7) and "11110");
    shifter_in_mux: entity work.mux_2 port map (regfile_out_2, shift_op_ext, shifter_in, ctrl_shifter_in);
    shift_imm_mux: entity work.mux_2 generic map (5) port map (instruction(11 downto 7), rot_imm, shift_imm_ext_in, ctrl_rot_imm);
    shift_amt_mux: entity work.mux_2 generic map (8) port map (regfile_out_1(7 downto 0), shift_imm_ext_out, shift_amt, ctrl_shift_amt);
    shifter: entity work.shifter port map (shifter_in, shifter_out, ctrl_shifter_carry_in, shifter_carry_out, ctrl_shift_type, shift_amt);

    pmconnect: entity work.pmconnect port map (regfile_out_2, dr_input, ctrl_pmc_instr, ctrl_pmc_en, res_out(1 downto 0), mem_wd, mem_output, mem_w_en);
    
    A: entity work.reg port map (regfile_out_1, A_out, clock, ctrl_a_write);
    B: entity work.reg port map (shifter_out, B_out, clock, ctrl_b_write);

    pc_shift_out <= "00"&pc_out(31 downto 2);
    op_mux: entity work.mux_2 port map (pc_shift_out, A_out, alu_op, ctrl_alu_op_mux);
    shift_op_ext <= std_logic_vector(resize(unsigned(instruction(7 downto 0)), 32));
    offset_extender: entity work.sign_extender generic map (12, 32) port map (instruction(11 downto 0), offset_op_ext);
    branch_extender: entity work.sign_extender generic map (24, 32) port map (instruction(23 downto 0), branch_ext);


    shift_op_mux: entity work.mux port map (input(0) => B_out, input(1) => x"00000000", input(2) => branch_ext, input(3) => offset,
        output => alu_shift_op, sel => ctrl_alu_shift_op_mux);

    ALU: entity work.alu port map (alu_shift_op, alu_op, ctrl_alu_c_in, ctrl_alu_opcode, alu_ans, alu_flags_out);

    flag_reg: entity work.reg generic map (4) port map (ctrl_flags, flag_reg_out, clock, ctrl_flag_set);
    predicator: entity work.predicator port map (ctrl_predict_cond, flag_reg_out, prediction);

    result: entity work.reg port map (alu_ans, res_out, clock, ctrl_res_write);

    instr_copy <= instruction;
    flags <= flag_reg_out;

end cpu_multicycle_datapath_arc;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity cpu_multicycle_controller is
    port (        
        clock : in std_logic;

        ctrl_alu_opcode : out std_logic_vector(3 downto 0);
        ctrl_alu_c_in : out std_logic;
        ctrl_alu_op_mux : out std_logic;
        ctrl_alu_shift_op_mux : out std_logic_vector(1 downto 0);

        ctrl_regfile_w_en : out std_logic;
        ctrl_regfile_w_data : out std_logic;
        ctrl_regfile_r_addr_1 : out std_logic;
        ctrl_regfile_r_addr_2 : out std_logic;

        ctrl_shift_amt : out std_logic;
        ctrl_shifter_in : out std_logic;
        ctrl_rot_imm : out std_logic;
        ctrl_shifter_carry_in : out std_logic;
        ctrl_shift_type : out std_logic_vector(1 downto 0);
        ctrl_offset_type : out std_logic;

        ctrl_pmc_instr : out DT_type;
        ctrl_pmc_en : out std_logic;

        ctrl_mem_ad_mux : out std_logic;
        
        ctrl_ir_write : out std_logic;
        ctrl_dr_write : out std_logic;
        ctrl_res_write : out std_logic;
        ctrl_pc_write : out std_logic;
        ctrl_a_write : out std_logic;
        ctrl_b_write : out std_logic;
        ctrl_preindex : out std_logic;
        ctrl_w_addr : out std_logic;
       
        ctrl_flag_set : out std_logic;
        ctrl_flags : out std_logic_vector(3 downto 0);
        ctrl_predict_cond : out std_logic_vector(3 downto 0);

        instruction: in std_logic_vector(31 downto 0);
        shifter_carry_out : in std_logic;
        alu_flags_out: in std_logic_vector(3 downto 0); -- TODO fix flags
        prediction: in std_logic;
        flags: in std_logic_vector(3 downto 0)
    );
end cpu_multicycle_controller;

architecture cpu_multicycle_controller_arc of cpu_multicycle_controller is

    type fsm_state is (fetch, decode, shift, execute_dp, writeback_dp, execute_dt, 
        writeback_dt_str, load_dt_ldr, writeback_dt_ldr, execute_b);

    signal curr_state: fsm_state := fetch;
begin

    state_change: process(curr_state, instruction)
    begin
        case curr_state is
        when fetch => 
            ctrl_alu_opcode <= "0101";
            ctrl_alu_c_in <= '1';
            ctrl_alu_op_mux <= '0';
            ctrl_alu_shift_op_mux <= "01";

            ctrl_regfile_w_en <= '0';
            ctrl_regfile_w_data <= '0';
            ctrl_regfile_r_addr_1 <= '0';
            ctrl_regfile_r_addr_2 <= '0';

            ctrl_mem_ad_mux <= '0';
            ctrl_pmc_en <= '0';

            ctrl_ir_write <= '1';
            ctrl_dr_write <= '0';
            ctrl_res_write <= '0';
            ctrl_pc_write <= '1';
            ctrl_a_write <= '0';
            ctrl_b_write <= '0';
            ctrl_preindex <= '0';
            ctrl_w_addr <= '0';

            ctrl_flag_set <= '0';
            ctrl_flags <= "0000";
            ctrl_predict_cond <= "0000";
        -- in the current implementation, 'decode' is a misnomer; because the 
        -- register encoding shift amount is mapped to out_1 of regfile, we 
        -- need to do the shift preemptively before the decode. Which is what
        -- we do here. the 'shift' state simply loads in the actual register 
        -- into A. 
        --
        -- We can't do this in reverse, because A would then store an incorrect 
        -- value (the value of Rs, the shift register) before going into the 
        -- execution step.
        -- 
        -- Actually, we can: simply store A, and then store B.
        -- I am a dum dum
        when decode => 
            ctrl_alu_opcode <= "0000";
            ctrl_alu_c_in <= '0';
            ctrl_alu_op_mux <= '0';
            ctrl_alu_shift_op_mux <= "00";

            ctrl_regfile_w_en <= '0';
            ctrl_regfile_w_data <= '0';
            ctrl_regfile_r_addr_1 <= '1';

            ctrl_b_write <= '1';
            if instruction(27 downto 26) = "00" then
                -- TODO pass 0 to shifter if shifting via 
                -- WARNING: 11-8 is SBZ (Should be zero), not neccessarily zero. 
                ctrl_a_write <= '0';
                ctrl_regfile_r_addr_2 <= '0';
                ctrl_shifter_carry_in <= flags(cpsr_C);

                -- I now see the utility of an instruction decoder: would've made
                -- life _amazingly_ simple. Alas, I neither implemented one nor 
                -- used the one provided. Can also not refactor, because am neck
                -- deep in assignments.

                if instruction(27 downto 25) = "000" and instruction(7) = '1' and instruction(4) = '1' and instruction(22) = '0' then
                    ctrl_shifter_in <= '1';
                    ctrl_shift_amt <= '1';
                    ctrl_rot_imm <= '1'; -- branch offsets
                elsif instruction(25) = '1' then
                    ctrl_shift_type <= "11"; -- rotate right
                    -- 8 bit immediate w/ 4 bit rotate
                    ctrl_shifter_in <= '1';
                    ctrl_shift_amt <= '1';
                    ctrl_rot_imm <= '1';
                else
                    ctrl_shift_type <= instruction(6 downto 5);
                    if instruction(4) = '0' then
                        -- immediate shift
                        ctrl_shifter_in <= '0';
                        ctrl_shift_amt <= '1';
                        ctrl_rot_imm <= '0';
                    else
                        -- register shift
                        ctrl_shifter_in <= '0';
                        ctrl_shift_amt <= '0';
                        ctrl_rot_imm <= '0'; -- don't care
                    end if;
                end if;
            elsif instruction(27 downto 26) = "01" then
                ctrl_regfile_r_addr_2 <= '0';
                ctrl_shifter_in <= '0';
                if instruction(25) = '0' then
                    -- immediate offset/index; next state will be execute_dt
                    ctrl_a_write <= '1';
                    -- handle in execute_dt
                else
                    if instruction(11 downto 4) = x"00" then
                        -- register offset/index
                        ctrl_a_write <= '1';
                        -- handle in execute_dt
                    else
                        -- scaled register offset/index
                        ctrl_shift_type <= instruction(6 downto 5);
                        ctrl_a_write <= '0';
                        ctrl_shift_amt <= '1';
                        ctrl_rot_imm <= '0';
                    end if;
                end if;
            else
                ctrl_a_write <= '1';
                ctrl_regfile_r_addr_2 <= '0'; -- branch 
            end if;

            ctrl_ir_write <= '0';
            ctrl_dr_write <= '0';
            ctrl_res_write <= '0';
            ctrl_pc_write <= '0';
            ctrl_flag_set <= '0';
            ctrl_predict_cond <= instruction(31 downto 28);
            ctrl_mem_ad_mux <= '0';


        when shift =>
            ctrl_regfile_r_addr_1 <= '0';
            ctrl_a_write <= '1';
            ctrl_b_write <= '0';
            -- shift stuff here

        when execute_dp =>
            ctrl_alu_opcode <= instruction(24 downto 21);
            ctrl_alu_c_in <= flags(cpsr_C);
            ctrl_regfile_w_en <= '0';
            ctrl_regfile_w_data <= '0';
            ctrl_regfile_r_addr_2 <= '0';
            ctrl_ir_write <= '0';
            ctrl_dr_write <= '0';
            ctrl_res_write <= '1';
            ctrl_pc_write <= '0';
            ctrl_a_write <= '0';
            ctrl_b_write <= '0';
            ctrl_flag_set <= instruction(20);
            ctrl_predict_cond <= instruction(31 downto 28);
            ctrl_mem_ad_mux <= '0';
            ctrl_alu_op_mux <= '1';

        when writeback_dp =>
            ctrl_alu_opcode <= "0000";
            ctrl_alu_c_in <= '0';
            if (instruction(24) and (not instruction(23))) = '1' then
                ctrl_regfile_w_en <= '0';
            else
                ctrl_regfile_w_en <= '1';
            end if;
            ctrl_regfile_w_data <= '0';
            ctrl_regfile_r_addr_2 <= '0';
            ctrl_ir_write <= '0';
            ctrl_dr_write <= '0';
            ctrl_res_write <= '0';
            ctrl_pc_write <= '0';
            ctrl_a_write <= '0';
            ctrl_b_write <= '0';
            ctrl_flag_set <= '0';
            ctrl_predict_cond <= instruction(31 downto 28);
            ctrl_mem_ad_mux <= '0';
            ctrl_alu_op_mux <= '0';
            ctrl_alu_shift_op_mux <= "00";

        when execute_dt =>
            if instruction(23) = '1' then
                ctrl_alu_opcode <= "0100";
            else
                ctrl_alu_opcode <= "0010";
            end if;
            ctrl_alu_c_in <= '0';
            ctrl_regfile_w_en <= '0';
            ctrl_regfile_w_data <= '0';
            ctrl_regfile_r_addr_2 <= '0';
            ctrl_ir_write <= '0';
            ctrl_dr_write <= '0';
            ctrl_res_write <= '1';
            ctrl_pc_write <= '0';
            ctrl_a_write <= '0';
            ctrl_b_write <= '0';
            ctrl_flag_set <= '0';
            ctrl_predict_cond <= instruction(31 downto 28);
            ctrl_mem_ad_mux <= '0';
            ctrl_alu_op_mux <= '1';
            -- decide register or immediate
            if instruction(27 downto 25) = "010" then
                -- immediate offset/index
                ctrl_alu_shift_op_mux <= "11";
                ctrl_offset_type <= '0';
            elsif instruction(27 downto 25) = "000" and instruction(7) = '1' and instruction(4) = '1' and instruction(22) = '1' then
                ctrl_offset_type <= '1';
                ctrl_alu_shift_op_mux <= "11";
            else
                ctrl_alu_shift_op_mux <= "00";
            end if;

        ------------------------------------------------------------------------
        --
        -- TODO
        -- decoding load/store instructions is the main problem here. 
        -- The new load/store ones break the old logic (similar structure to DP
        -- instructions, and can't be differentiated by the 2 bits 27-26). What
        -- to do now? Hmmm
        --
        ------------------------------------------------------------------------


        when writeback_dt_str =>
            ctrl_alu_opcode <= "0000";
            ctrl_alu_c_in <= '0';
            ctrl_regfile_w_en <= '0';
            ctrl_regfile_w_data <= '0';
            ctrl_regfile_r_addr_2 <= '1';

            ctrl_pmc_en <= '1';
            if instruction(27 downto 25) = "010" then
                if instruction(22) = '0' then
                    ctrl_pmc_instr <= str;
                else
                    ctrl_pmc_instr <= strb;
                end if;
            elsif instruction(27 downto 25) = "000" and instruction(7) = '1' and instruction(4) = '1' then
                ctrl_pmc_instr <= strh;
            end if;

            -- preindex addressing
            if instruction(24) = '0' then 
                ctrl_preindex <= '1';
            end if;
            -- writeback
            if instruction(21) = '1' or (instruction(24) = '0' and instruction(21) = '0') then
                ctrl_w_addr <= '1';
                ctrl_regfile_w_data <= '0';
                ctrl_regfile_w_en <= '1';
            end if;

            ctrl_ir_write <= '0';
            ctrl_dr_write <= '0';
            ctrl_res_write <= '0';
            ctrl_pc_write <= '0';
            ctrl_a_write <= '0';
            ctrl_b_write <= '0';
            ctrl_flag_set <= '0';
            ctrl_predict_cond <= instruction(31 downto 28);
            ctrl_mem_ad_mux <= '1';
            ctrl_alu_op_mux <= '0';
            ctrl_alu_shift_op_mux <= "00";

        when load_dt_ldr =>
            ctrl_alu_opcode <= "0000";
            ctrl_alu_c_in <= '0';
            ctrl_regfile_w_en <= '0';
            ctrl_regfile_w_data <= '0';
            ctrl_regfile_r_addr_2 <= '0';

            if instruction(27 downto 25) = "010" then
                if instruction(22) = '0' then
                    ctrl_pmc_instr <= ldr;
                else
                    ctrl_pmc_instr <= ldrb;
                end if;
            elsif instruction(27 downto 25) = "000" and instruction(7) = '1' and instruction(4) = '1' then
                if instruction(6) =  '1' then -- signed
                    if instruction(5) = '1' then -- halfword
                        ctrl_pmc_instr <= ldrsh;
                    else
                        ctrl_pmc_instr <= ldrsb;
                    end if;
                elsif instruction(5) = '1' then
                    ctrl_pmc_instr <= ldrh;
                end if;
            end if;
            
            -- preindex
            if instruction(24) = '0' then 
                ctrl_preindex <= '1';
            end if;
            -- writeback
            if instruction(21) = '1' then
                ctrl_w_addr <= '1';
                ctrl_regfile_w_data <= '0';
                ctrl_regfile_w_en <= '1';
            end if;

            ctrl_ir_write <= '0';
            ctrl_dr_write <= '1';
            ctrl_res_write <= '0';
            ctrl_pc_write <= '0';
            ctrl_a_write <= '0';
            ctrl_b_write <= '0';
            ctrl_flag_set <= '0';
            ctrl_predict_cond <= instruction(31 downto 28);
            ctrl_mem_ad_mux <= '1';
            ctrl_alu_op_mux <= '0';
            ctrl_alu_shift_op_mux <= "00";

        when writeback_dt_ldr =>
            ctrl_alu_opcode <= "0000";
            ctrl_alu_c_in <= '0';
            ctrl_regfile_w_en <= '1';
            ctrl_regfile_w_data <= '1';
            ctrl_regfile_r_addr_2 <= '0';

            ctrl_ir_write <= '0';
            ctrl_dr_write <= '0';
            ctrl_res_write <= '0';
            ctrl_pc_write <= '0';
            ctrl_a_write <= '0';
            ctrl_b_write <= '0';
            ctrl_flag_set <= '0';
            ctrl_predict_cond <= instruction(31 downto 28);
            ctrl_mem_ad_mux <= '0';
            ctrl_alu_op_mux <= '0';
            ctrl_alu_shift_op_mux <= "00";

        when execute_b => 
            ctrl_alu_opcode <= "0101";
            ctrl_alu_c_in <= '1';
            ctrl_regfile_w_en <= '0';
            ctrl_regfile_w_data <= '0';
            ctrl_regfile_r_addr_2 <= '0';
            ctrl_ir_write <= '0';
            ctrl_dr_write <= '0';
            ctrl_res_write <= '0';
            if prediction = '1' then
                ctrl_pc_write <= '1';
            else 
                ctrl_pc_write <= '0';
            end if;
            ctrl_a_write <= '0';
            ctrl_b_write <= '0';
            ctrl_flag_set <= '0';
            ctrl_predict_cond <= instruction(31 downto 28);
            ctrl_mem_ad_mux <= '0';
            ctrl_alu_op_mux <= '0';
            ctrl_alu_shift_op_mux <= "10";
        end case;
    end process state_change;

    transition: process(clock)
    begin
        if rising_edge(clock) then
            case curr_state is
            when fetch => 
                curr_state <= decode;
            when decode => 
                -- tweak state that we move to here.
                if instruction(27 downto 26) = "00" then
                    -- all instructions require a shift/rotate here
                    if instruction(27 downto 25) = "000" and instruction(7) = '1' and instruction(4) = '1' then
                        -- how do we differentiate between immediate and 
                        if (instruction(22) = '0') then
                            -- register offset
                            curr_state <= shift;
                        else
                            curr_state <= execute_dt;
                        end if;
                    else
                        curr_state <= shift;
                    end if;

                elsif instruction(27 downto 26) = "01" then
                    if instruction(25) = '0' then
                        curr_state <= execute_dt;
                    else
                        curr_state <= shift;
                    end if;
                else 
                    curr_state <= execute_b;
                end if;
            when shift =>
                if instruction(27 downto 26) = "00" then
                    curr_state <= execute_dp;
                else
                    curr_state <= execute_dt;
                end if;
            when execute_dp =>
                curr_state <= writeback_dp;
            when writeback_dp =>
                curr_state <= fetch;
            when execute_dt =>
                if instruction(20) = '1' then 
                    curr_state <= load_dt_ldr;
                else 
                    curr_state <= writeback_dt_str;
                end if;
            when writeback_dt_str =>
                curr_state <= fetch;
            when load_dt_ldr =>
                curr_state <= writeback_dt_ldr;
            when writeback_dt_ldr =>
                curr_state <= fetch;
            when execute_b => 
                curr_state <= fetch;
            end case;
        end if;
    end process transition;

end cpu_multicycle_controller_arc;


