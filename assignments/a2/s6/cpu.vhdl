library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity cpu is
    generic (
        memory_defaults : mem(127 downto 0)
    );
    port (
        clock: in std_logic
    );
end cpu;

architecture cpu_multicycle_arch of cpu is

    signal ctrl_alu_opcode : std_logic_vector(3 downto 0);
    signal ctrl_alu_c_in : std_logic;
    signal ctrl_alu_op_mux : std_logic;
    signal ctrl_alu_shift_op_mux : std_logic_vector(1 downto 0);

    signal ctrl_regfile_w_en : std_logic;
    signal ctrl_regfile_w_data : std_logic;
    signal ctrl_regfile_r_addr_1 : std_logic;
    signal ctrl_regfile_r_addr_2 : std_logic;

    signal ctrl_shift_amt : std_logic;
    signal ctrl_shifter_in : std_logic;
    signal ctrl_rot_imm : std_logic;
    signal ctrl_shifter_carry_in : std_logic;
    signal ctrl_shift_type : std_logic_vector(1 downto 0);
    signal ctrl_offset_type : std_logic;

    signal ctrl_pmc_instr : DT_type;
    signal ctrl_pmc_en : std_logic;

    signal ctrl_mem_ad_mux : std_logic;
    
    signal ctrl_ir_write : std_logic;
    signal ctrl_dr_write : std_logic;
    signal ctrl_res_write : std_logic;
    signal ctrl_pc_write : std_logic;
    signal ctrl_a_write : std_logic;
    signal ctrl_b_write : std_logic;
    signal ctrl_preindex : std_logic;
    signal ctrl_w_addr : std_logic;

    signal ctrl_flag_set : std_logic;
    signal ctrl_flags : std_logic_vector(3 downto 0);
    signal ctrl_predict_cond : std_logic_vector(3 downto 0);

    signal instruction: std_logic_vector(31 downto 0);
    signal shifter_carry_out : std_logic;
    signal alu_flags_out: std_logic_vector(3 downto 0); -- TODO fix flags
    signal prediction: std_logic;
    signal flags: std_logic_vector(3 downto 0);

begin
    cpu_multicycle_datapath: entity work.cpu_multicycle_datapath 
    generic map (
        memory_defaults
    )
    port map (
        clock,

        ctrl_alu_opcode,
        ctrl_alu_c_in,
        ctrl_alu_op_mux,
        ctrl_alu_shift_op_mux,

        ctrl_regfile_w_en,
        ctrl_regfile_w_data,
        ctrl_regfile_r_addr_1,
        ctrl_regfile_r_addr_2,

        ctrl_shift_amt,
        ctrl_shifter_in,
        ctrl_rot_imm,
        ctrl_shifter_carry_in,
        ctrl_shift_type,
        ctrl_offset_type,

        ctrl_pmc_instr,
        ctrl_pmc_en,

        ctrl_mem_ad_mux,
        
        ctrl_ir_write,
        ctrl_dr_write,
        ctrl_res_write,
        ctrl_pc_write,
        ctrl_a_write,
        ctrl_b_write,
        ctrl_preindex,
        ctrl_w_addr,
        
        ctrl_flag_set,
        ctrl_flags,
        ctrl_predict_cond,

        instruction,
        shifter_carry_out,
        alu_flags_out,
        prediction,
        flags
    );

    cpu_multicycle_controller: entity work.cpu_multicycle_controller port map (
        clock,

        ctrl_alu_opcode,
        ctrl_alu_c_in,
        ctrl_alu_op_mux,
        ctrl_alu_shift_op_mux,

        ctrl_regfile_w_en,
        ctrl_regfile_w_data,
        ctrl_regfile_r_addr_1,
        ctrl_regfile_r_addr_2,

        ctrl_shift_amt,
        ctrl_shifter_in,
        ctrl_rot_imm,
        ctrl_shifter_carry_in,
        ctrl_shift_type,
        ctrl_offset_type,

        ctrl_pmc_instr,
        ctrl_pmc_en,

        ctrl_mem_ad_mux,
        
        ctrl_ir_write,
        ctrl_dr_write,
        ctrl_res_write,
        ctrl_pc_write,
        ctrl_a_write,
        ctrl_b_write,
        ctrl_preindex,
        ctrl_w_addr,
        
        ctrl_flag_set,
        ctrl_flags,
        ctrl_predict_cond,

        instruction,
        shifter_carry_out,
        alu_flags_out,
        prediction,
        flags
    );
end cpu_multicycle_arch;
