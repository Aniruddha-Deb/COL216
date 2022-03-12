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

        ctrl_mem_w_en : in std_logic_vector(3 downto 0);
        ctrl_mem_ad_mux : in std_logic;
        
        ctrl_ir_write : in std_logic;
        ctrl_dr_write : in std_logic;
        ctrl_res_write : in std_logic;
        ctrl_pc_write : in std_logic;
        ctrl_a_write : in std_logic;
        ctrl_b_write : in std_logic;
        
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
    signal mem_output: word;

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

    signal alu_shift_op: word;
    signal alu_op: word;
    signal alu_ans: word := x"00000000";
    signal branch_addr_shift: word;

    signal shift_op_ext: word;
    signal branch_ext: word;
    signal offset_op_ext: word;

    signal flag_reg_out: std_logic_vector(3 downto 0);
    signal res_out: word;

    signal instruction: word;
    signal rot_imm: std_logic_vector(4 downto 0);

begin
    pc_in <= alu_ans(29 downto 0)&"00";
    pc: entity work.reg port map (pc_in, pc_out, clock, ctrl_pc_write);
    
    mem_address_mux: entity work.mux_2 port map (pc_out, res_out, mem_ad, ctrl_mem_ad_mux);
    mem: entity work.memory generic map (memory_defaults) port map (clock, mem_ad, regfile_out_2, ctrl_mem_w_en, mem_output);
    
    ir: entity work.reg port map (mem_output, instruction, clock, ctrl_ir_write);
    dr: entity work.reg port map (mem_output, dr_output, clock, ctrl_dr_write);
    
    rd_addr_1_mux: entity work.mux_2 generic map (4) port map (instruction(19 downto 16), 
            instruction(11 downto 8), regfile_rd_addr_1, ctrl_regfile_r_addr_1);
    rd_addr_2_mux: entity work.mux_2 generic map (4) port map (instruction(3 downto 0), 
            instruction(15 downto 12), regfile_rd_addr_2, ctrl_regfile_r_addr_2);
    regfile_data_in_mux: entity work.mux_2 port map (res_out, dr_output, regfile_data_in, ctrl_regfile_w_data);
    regfile: entity work.regfile port map (regfile_rd_addr_1, 
            regfile_rd_addr_2, instruction(15 downto 12), regfile_data_in, 
            ctrl_regfile_w_en, clock, regfile_out_1, regfile_out_2);

    shift_imm_ext_out <= "000"&shift_imm_ext_in;
    rot_imm <= (instruction(11 downto 7) and "11110");
    shifter_in_mux: entity work.mux_2 port map (regfile_out_2, shift_op_ext, shifter_in, ctrl_shifter_in);
    shift_imm_mux: entity work.mux_2 generic map (5) port map (instruction(11 downto 7), rot_imm, shift_imm_ext_in, ctrl_rot_imm);
    shift_amt_mux: entity work.mux_2 generic map (8) port map (regfile_out_1(7 downto 0), shift_imm_ext_out, shift_amt, ctrl_shift_amt);
    shifter: entity work.shifter port map (shifter_in, shifter_out, ctrl_shifter_carry_in, shifter_carry_out, ctrl_shift_type, shift_amt);
    
    A: entity work.reg port map (regfile_out_1, A_out, clock, ctrl_a_write);
    B: entity work.reg port map (shifter_out, mem_wd, clock, ctrl_b_write);

    pc_shift_out <= "00"&pc_out(31 downto 2);
    op_mux: entity work.mux_2 port map (pc_shift_out, A_out, alu_op, ctrl_alu_op_mux);
    shift_op_ext <= std_logic_vector(resize(unsigned(instruction(7 downto 0)), 32));
--    immed_extender:  entity work.sign_extender generic map (8, 32) port map (instruction(7 downto 0), shift_op_ext);
    offset_extender: entity work.sign_extender generic map (12, 32) port map (instruction(11 downto 0), offset_op_ext);
    branch_extender: entity work.sign_extender generic map (24, 32) port map (instruction(23 downto 0), branch_ext);


    shift_op_mux: entity work.mux port map (input(0) => mem_wd, input(1) => x"00000000", input(2) => branch_ext, input(3) => offset_op_ext,
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

        ctrl_mem_w_en : out std_logic_vector(3 downto 0);
        ctrl_mem_ad_mux : out std_logic;
        
        ctrl_ir_write : out std_logic;
        ctrl_dr_write : out std_logic;
        ctrl_res_write : out std_logic;
        ctrl_pc_write : out std_logic;
        ctrl_a_write : out std_logic;
        ctrl_b_write : out std_logic;
        
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

            ctrl_mem_w_en <= "0000";
            ctrl_mem_ad_mux <= '0';

            ctrl_ir_write <= '1';
            ctrl_dr_write <= '0';
            ctrl_res_write <= '0';
            ctrl_pc_write <= '1';
            ctrl_a_write <= '0';
            ctrl_b_write <= '0';

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
                ctrl_a_write <= '0';
                ctrl_regfile_r_addr_2 <= '0';
                ctrl_shifter_carry_in <= flags(cpsr_C);
                if instruction(25) = '1' then
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

            ctrl_mem_w_en <= "0000";
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
            ctrl_mem_w_en <= "0000";
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
            ctrl_mem_w_en <= "0000";
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
            ctrl_mem_w_en <= "0000";
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
            if instruction(25) = '0' then
                -- immediate offset/index
                ctrl_alu_shift_op_mux <= "11";
            else
                ctrl_alu_shift_op_mux <= "00";
            end if;

        when writeback_dt_str =>
            ctrl_alu_opcode <= "0000";
            ctrl_alu_c_in <= '0';
            ctrl_regfile_w_en <= '0';
            ctrl_regfile_w_data <= '0';
            ctrl_regfile_r_addr_2 <= '1';
            ctrl_mem_w_en <= "1111";
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
            ctrl_mem_w_en <= "0000";
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
            ctrl_mem_w_en <= "0000";
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
            ctrl_mem_w_en <= "0000";
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
                if instruction(27 downto 26) = "00" then
                    -- all instructions require a shift/rotate here
                    curr_state <= shift;
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


