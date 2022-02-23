library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity cpu_multicycle_datapath is
    port (
        clock : in std_logic;

        ctrl_alu_opcode : in std_logic_vector(3 downto 0);
        ctrl_alu_c_in : in std_logic;
        ctrl_regfile_w_en : in std_logic;
        ctrl_regfile_w_data : in std_logic;
        ctrl_regfile_r_addr_2 : in std_logic;
        ctrl_mem_w_en : in std_logic_vector(3 downto 0);
        ctrl_ir_write : in std_logic;
        ctrl_dr_write : in std_logic;
        ctrl_res_write : in std_logic;
        ctrl_pc_write : in std_logic;
        ctrl_a_write : in std_logic;
        ctrl_b_write : in std_logic;
        ctrl_flag_set : in std_logic;
        ctrl_predict_cond : in std_logic_vector(3 downto 0);
        ctrl_mem_ad_mux : in std_logic;
        ctrl_reg_wd_mux : in std_logic;
        ctrl_alu_op_mux : in std_logic;
        ctrl_alu_shift_op_mux : in std_logic_vector(1 downto 0);

        instr_copy: out std_logic_vector(31 downto 0);
        prediction: out std_logic
    );
end cpu_multicycle_datapath;

architecture cpu_multicycle_datapath_arc of cpu_multicycle_datapath is

    signal pc_in: word; 
    signal pc_out: word;

    signal mem_ad: word;
    signal mem_wd: word;
    signal mem_output: word;

    signal dr_output: word;

    signal regfile_rd_addr_1: std_logic_vector(3 downto 0);
    signal regfile_rd_addr_2: std_logic_vector(3 downto 0);
    signal regfile_data_in: word;
    signal regfile_out_1: word;
    signal regfile_out_2: word;

    signal A_out: word;

    signal alu_shift_op: word;
    signal alu_op: word;
    signal alu_ans: word;
    signal alu_flags: std_logic_vector(3 downto 0);

    signal imm_op_ext: word;
    signal branch_ext: word;

    signal flag_reg_out: std_logic_vector(3 downto 0);
    signal res_out: word;

    signal instruction: word;

begin
    pc: entity work.reg port map (pc_in, pc_out, clock, ctrl_pc_write);
    
    mem_address_mux: entity work.mux_2 port map (pc_out, res_out, mem_ad, ctrl_mem_ad_mux);
    mem: entity work.memory port map (clock, mem_ad, mem_wd, ctrl_mem_w_en, mem_output);
    
    ir: entity work.reg port map (mem_output, instruction, clock, ctrl_ir_write);
    dr: entity work.reg port map (mem_output, dr_output, clock, ctrl_dr_write);
    
    rd_addr_2_mux: entity work.mux_2 generic map (4) port map (instruction(3 downto 0), 
            instruction(15 downto 12), regfile_rd_addr_2, ctrl_regfile_r_addr_2);
    regfile_data_in_mux: entity work.mux_2 port map (res_out, dr_output, regfile_data_in, ctrl_regfile_w_data);
    regfile: entity work.regfile port map (instruction(19 downto 16), 
            regfile_rd_addr_2, instruction(15 downto 12), regfile_data_in, 
            ctrl_regfile_w_en, clock, regfile_out_1, regfile_out_2);
    
    A: entity work.reg port map (regfile_out_1, A_out, clock, ctrl_a_write);
    B: entity work.reg port map (regfile_out_2, mem_wd, clock, ctrl_b_write);

    op_mux: entity work.mux_2 port map (pc_out, A_out, alu_op, ctrl_alu_op_mux);
    imm_extender: entity work.sign_extender generic map (12, 32) port map (instruction(11 downto 0), imm_op_ext);
    branch_extender: entity work.sign_extender generic map (24, 32) port map (instruction(23 downto 0), branch_ext);

    shift_op_mux: entity work.mux port map (input(0) => mem_wd, input(1) => x"00000004", input(2) => imm_op_ext, input(3) => branch_ext,
        output => alu_shift_op, sel => ctrl_alu_shift_op_mux);

    ALU: entity work.alu port map (alu_shift_op, alu_op, ctrl_alu_c_in, ctrl_alu_opcode, alu_ans, alu_flags);

    flags: entity work.reg generic map (4) port map (alu_flags, flag_reg_out, clock, ctrl_flag_set);
    predicator: entity work.predicator port map (ctrl_predict_cond, flag_reg_out, prediction);

    result: entity work.reg port map (alu_ans, res_out, clock, ctrl_res_write);

    instr_copy <= instruction;

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
        ctrl_regfile_w_en : out std_logic;
        ctrl_regfile_w_data : out std_logic;
        ctrl_regfile_r_addr_2 : out std_logic;
        ctrl_mem_w_en : out std_logic_vector(3 downto 0);
        ctrl_ir_write : out std_logic;
        ctrl_dr_write : out std_logic;
        ctrl_res_write : out std_logic;
        ctrl_pc_write : out std_logic;
        ctrl_a_write : out std_logic;
        ctrl_b_write : out std_logic;
        ctrl_flag_set : out std_logic;
        ctrl_predict_cond : out std_logic_vector(3 downto 0);
        ctrl_mem_ad_mux : out std_logic;
        ctrl_reg_wd_mux : out std_logic;
        ctrl_alu_op_mux : out std_logic;
        ctrl_alu_shift_op_mux : out std_logic_vector(1 downto 0);

        instr_copy: in std_logic_vector(31 downto 0);
        prediction: in std_logic        
    );
end cpu_multicycle_controller;

architecture cpu_multicycle_controller_arc of cpu_multicycle_controller is

    type fsm_state is (fetch, decode, execute_dp, writeback_dp, execute_dt, 
        writeback_dt_str, writeback_dt_ldr, execute_b);

    signal curr_state: fsm_state := fetch;
begin

    transition: process(clock)
    begin

        -- while transitioning to a state, the FSM needs to set the signals to 
        -- that of the next state, rather than that of the current state 
        -- actually, this doesn't matter much, eh.

        -- should I define the values of _all_ the signals in each case? there 
        -- are like 20 of them. Hmmm....
        if rising_edge(clock) then

            case fsm_state is
            when fetch => 
                ctrl_pc_write <= '1';
                ctrl_mem_ad_mux <= '0';
                ctrl_ir_write <= '1';
                ctrl_alu_op_mux <= '0';
                ctrl_alu_shift_op_mux <= "01";
                ctrl_alu_opcode <= "0100"; -- add. Hmm, should really make this an enum
                ctrl_c_in <= '0';
                ctrl_res_write <= '0';
                curr_state <= decode;
            when decode => 
                ctrl_a_write <= '1';
                ctrl_b_write <= '1';
                if instruction()



            end case;
        end if;
    end process transition;

end cpu_multicycle_controller_arc;


