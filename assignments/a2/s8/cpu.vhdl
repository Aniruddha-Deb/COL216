library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity cpu is
    generic (
        memory_defaults : mem(127 downto 0)
    );
    port (
        clock: in std_logic;
        memory_input_data: in word
    );
end cpu;

architecture cpu_multicycle_arch of cpu is

    -- alu;
    signal alu_shift_op : word;
    signal alu_op : word;
    signal alu_flags_in : flags_t;
    signal alu_opcode : DP_opcode_t;
    signal alu_ans : word;
    signal alu_flags_out : flags_t;

    -- multiplier;
    signal mult_op_m1 : word;
    signal mult_op_m2 : word;
    signal mult_op_a : dword;
    signal mult_opcode : mul_t;
    signal mult_flags_in : flags_t;
    signal mult_flags_out : flags_t;
    signal mult_ans : dword;

    -- regfile;
    signal regfile_r_addr_1 : nibble;
    signal regfile_r_addr_2 : nibble;
    signal regfile_w_addr : nibble;
    signal regfile_data_in : word;
    signal regfile_w_en : std_logic;
    signal regfile_out_1 : word;
    signal regfile_out_2 : word;

    -- memory;
    signal memory_addr : word;
    signal memory_data_in : word;
    signal memory_w_en : nibble;
    signal memory_data_out : word;

    -- pmconnect;
    signal pmconnect_Rout : word;
    signal pmconnect_Rin : word;
    signal pmconnect_dt_opcode : DT_opcode_t;
    signal pmconnect_enable : std_logic;
    signal pmconnect_adr : bit_pair;
    signal pmconnect_Min : word;
    signal pmconnect_Mout : word;
    signal pmconnect_MW : nibble;

    -- shifter;
    signal shifter_shifter_in : word;
    signal shifter_shifter_out : word;
    signal shifter_carry_in : std_logic;
    signal shifter_carry_out : std_logic;
    signal shifter_shift_type : shift_t;
    signal shifter_shift_amt : byte;

    -- predicator;
    signal predicator_condition : condition_t;
    signal predicator_flags_in : flags_t;
    signal predicator_p : std_logic;

    -- instr_decoder;
    signal instr_decoder_instruction : word;
    signal instr_decoder_instruction_class : instruction_t;
    signal instr_decoder_DP_opcode : DP_opcode_t;
    signal instr_decoder_condition : condition_t;
    signal instr_decoder_DT_opcode : DT_opcode_t;
    signal instr_decoder_mul_opcode : mul_t;
    signal instr_decoder_shift : shift_t;
begin

    datapath: entity work.cpu_datapath generic map (memory_defaults) port map (
        clock,

        -- alu;
        alu_shift_op,
        alu_op,
        alu_flags_in,
        alu_opcode,
        alu_ans,
        alu_flags_out,

        -- multiplier;
        mult_op_m1,
        mult_op_m2,
        mult_op_a,
        mult_opcode,
        mult_flags_in,
        mult_flags_out,
        mult_ans,

        -- regfile;
        regfile_r_addr_1,
        regfile_r_addr_2,
        regfile_w_addr,
        regfile_data_in,
        regfile_w_en,
        regfile_out_1,
        regfile_out_2,

        -- memory;
        memory_addr,
        memory_input_data,
        memory_data_in,
        memory_w_en,
        memory_data_out,

        -- pmconnect;
        pmconnect_Rout,
        pmconnect_Rin,
        pmconnect_dt_opcode,
        pmconnect_enable,
        pmconnect_adr,
        pmconnect_Min,
        pmconnect_Mout,
        pmconnect_MW,

        -- shifter;
        shifter_shifter_in,
        shifter_shifter_out,
        shifter_carry_in,
        shifter_carry_out,
        shifter_shift_type,
        shifter_shift_amt,

        -- predicator;
        predicator_condition,
        predicator_flags_in,
        predicator_p,

        -- instr_decoder;
        instr_decoder_instruction,
        instr_decoder_instruction_class,
        instr_decoder_DP_opcode,
        instr_decoder_condition,
        instr_decoder_DT_opcode,
        instr_decoder_mul_opcode,
        instr_decoder_shift
    );

    controller: entity work.cpu_controller port map (
        clock,

        -- alu;
        alu_shift_op,
        alu_op,
        alu_flags_in,
        alu_opcode,
        alu_ans,
        alu_flags_out,

        -- multiplier;
        mult_op_m1,
        mult_op_m2,
        mult_op_a,
        mult_opcode,
        mult_flags_in,
        mult_flags_out,
        mult_ans,

        -- regfile;
        regfile_r_addr_1,
        regfile_r_addr_2,
        regfile_w_addr,
        regfile_data_in,
        regfile_w_en,
        regfile_out_1,
        regfile_out_2,

        -- memory;
        memory_addr,
        memory_data_in,
        memory_w_en,
        memory_data_out,

        -- pmconnect;
        pmconnect_Rout,
        pmconnect_Rin,
        pmconnect_dt_opcode,
        pmconnect_enable,
        pmconnect_adr,
        pmconnect_Min,
        pmconnect_Mout,
        pmconnect_MW,

        -- shifter;
        shifter_shifter_in,
        shifter_shifter_out,
        shifter_carry_in,
        shifter_carry_out,
        shifter_shift_type,
        shifter_shift_amt,

        -- predicator;
        predicator_condition,
        predicator_flags_in,
        predicator_p,

        -- instr_decoder;
        instr_decoder_instruction,
        instr_decoder_instruction_class,
        instr_decoder_DP_opcode,
        instr_decoder_condition,
        instr_decoder_DT_opcode,
        instr_decoder_mul_opcode,
        instr_decoder_shift
    );

end cpu_multicycle_arch;
