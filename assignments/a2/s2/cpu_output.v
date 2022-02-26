module condition_checker
  (input  [3:0] condition,
   input  [3:0] cpsr_reg,
   output valid);
  wire n425_o;
  wire n426_o;
  wire n427_o;
  wire n428_o;
  wire n431_o;
  wire n432_o;
  wire n433_o;
  wire n434_o;
  wire n435_o;
  wire n438_o;
  wire n439_o;
  assign valid = n428_o;
  /* cpu.vhdl:31:34  */
  assign n425_o = condition == 4'b0000;
  /* cpu.vhdl:31:55  */
  assign n426_o = cpsr_reg[1];
  /* cpu.vhdl:31:43  */
  assign n427_o = n425_o & n426_o;
  /* cpu.vhdl:31:18  */
  assign n428_o = n427_o ? 1'b1 : n435_o;
  /* cpu.vhdl:32:34  */
  assign n431_o = condition == 4'b0001;
  /* cpu.vhdl:32:55  */
  assign n432_o = cpsr_reg[1];
  /* cpu.vhdl:32:59  */
  assign n433_o = ~n432_o;
  /* cpu.vhdl:32:43  */
  assign n434_o = n431_o & n433_o;
  /* cpu.vhdl:31:66  */
  assign n435_o = n434_o ? 1'b1 : n439_o;
  /* cpu.vhdl:33:33  */
  assign n438_o = condition == 4'b1110;
  /* cpu.vhdl:32:66  */
  assign n439_o = n438_o ? 1'b1 : 1'b0;
endmodule

module data_mem
  (input  [5:0] r_addr,
   input  [5:0] w_addr,
   input  [3:0] w_en,
   input  [31:0] data_in,
   input  clk,
   output [31:0] output);
  wire n380_o;
  wire [7:0] n383_o;
  wire n386_o;
  wire [7:0] n389_o;
  wire n392_o;
  wire [7:0] n395_o;
  wire n398_o;
  wire [7:0] n401_o;
  wire [7:0] n413_data; // mem_rd
  wire [7:0] n414_data; // mem_rd
  wire [7:0] n415_data; // mem_rd
  wire [7:0] n416_data; // mem_rd
  wire [31:0] n417_o;
  assign output = n417_o;
  /* mem.vhdl:58:20  */
  assign n380_o = w_en[0];
  /* mem.vhdl:59:73  */
  assign n383_o = data_in[7:0];
  /* mem.vhdl:61:20  */
  assign n386_o = w_en[1];
  /* mem.vhdl:62:74  */
  assign n389_o = data_in[15:8];
  /* mem.vhdl:64:20  */
  assign n392_o = w_en[2];
  /* mem.vhdl:65:75  */
  assign n395_o = data_in[23:16];
  /* mem.vhdl:67:20  */
  assign n398_o = w_en[3];
  /* mem.vhdl:68:75  */
  assign n401_o = data_in[31:24];
  /* mem.vhdl:44:9  */
  reg [7:0] ram_n1[63:0] ; // memory
  assign n413_data = ram_n1[r_addr];
  always @(posedge clk)
    if (n380_o)
      ram_n1[w_addr] <= n383_o;
  /* mem.vhdl:73:19  */
  reg [7:0] ram_n2[63:0] ; // memory
  assign n414_data = ram_n2[r_addr];
  always @(posedge clk)
    if (n386_o)
      ram_n2[w_addr] <= n389_o;
  /* alu.vhdl:29:60  */
  reg [7:0] ram_n3[63:0] ; // memory
  assign n415_data = ram_n3[r_addr];
  always @(posedge clk)
    if (n392_o)
      ram_n3[w_addr] <= n395_o;
  /* mem.vhdl:68:21  */
  reg [7:0] ram_n4[63:0] ; // memory
  assign n416_data = ram_n4[r_addr];
  always @(posedge clk)
    if (n398_o)
      ram_n4[w_addr] <= n401_o;
  /* mem.vhdl:73:19  */
  /* mem.vhdl:65:21  */
  /* mem.vhdl:62:21  */
  /* mem.vhdl:59:21  */
  /* mem.vhdl:55:5  */
  assign n417_o = {n416_data, n415_data, n414_data, n413_data};
  /* mem.vhdl:59:21  */
  /* mem.vhdl:62:21  */
  /* mem.vhdl:65:21  */
  /* mem.vhdl:68:21  */
endmodule

module cpsr_reg
  (input  [3:0] cpsr_in,
   input  update,
   input  clock,
   output [3:0] cpsr_out);
  wire [3:0] n375_o;
  reg [3:0] n376_q;
  assign cpsr_out = n376_q;
  /* cpu.vhdl:15:25  */
  assign n375_o = update ? cpsr_in : n376_q;
  /* cpu.vhdl:15:25  */
  always @(posedge clock)
    n376_q <= n375_o;
endmodule

module regfile
  (input  [3:0] r_addr_1,
   input  [3:0] r_addr_2,
   input  [3:0] w_addr,
   input  [31:0] data_in,
   input  w_en,
   input  clk,
   output [31:0] out_1,
   output [31:0] out_2);
  wire [31:0] n368_data; // mem_rd
  wire [31:0] n369_data; // mem_rd
  assign out_1 = n369_data;
  assign out_2 = n368_data;
  /* regfile.vhdl:23:9  */
  reg [31:0] regs[15:0] ; // memory
  assign n368_data = regs[r_addr_2];
  assign n369_data = regs[r_addr_1];
  always @(posedge clk)
    if (w_en)
      regs[w_addr] <= data_in;
  /* regfile.vhdl:42:19  */
  /* regfile.vhdl:41:19  */
  /* regfile.vhdl:37:18  */
endmodule

module alu
  (input  [31:0] shift_op,
   input  [31:0] op,
   input  carry_in,
   input  [3:0] opcode,
   output carry_out,
   output [31:0] ans);
  wire [32:0] temp_ans;
  wire [31:0] n350_o;
  wire n351_o;
  assign carry_out = n351_o;
  assign ans = n350_o;
  /* alu.vhdl:17:12  */
  assign temp_ans = 33'bX; // (signal)
  /* alu.vhdl:36:20  */
  assign n350_o = temp_ans[31:0];
  /* alu.vhdl:37:26  */
  assign n351_o = temp_ans[32];
endmodule

module decoder
  (input  [31:0] instruction,
   output [2:0] instr_class,
   output [3:0] operation,
   output [2:0] dp_subclass,
   output dp_operand_src,
   output load_store,
   output dt_offset_sign);
  wire [1:0] n177_o;
  wire n180_o;
  wire n183_o;
  wire n186_o;
  wire [2:0] n188_o;
  reg [2:0] n189_o;
  wire [3:0] n190_o;
  wire [3:0] n193_o;
  wire [2:0] n197_o;
  wire n200_o;
  wire n202_o;
  wire n203_o;
  wire n205_o;
  wire n206_o;
  wire n209_o;
  wire n211_o;
  wire n212_o;
  wire n214_o;
  wire n215_o;
  wire n218_o;
  wire [2:0] n220_o;
  reg [2:0] n221_o;
  wire n223_o;
  wire n224_o;
  wire n225_o;
  wire n228_o;
  wire n229_o;
  wire n232_o;
  wire n233_o;
  wire [3:0] n236_data; // mem_rd
  assign instr_class = n189_o;
  assign operation = n236_data;
  assign dp_subclass = n221_o;
  assign dp_operand_src = n225_o;
  assign load_store = n229_o;
  assign dt_offset_sign = n233_o;
  /* decoder.vhdl:26:22  */
  assign n177_o = instruction[27:26];
  /* decoder.vhdl:27:27  */
  assign n180_o = n177_o == 2'b00;
  /* decoder.vhdl:28:16  */
  assign n183_o = n177_o == 2'b01;
  /* decoder.vhdl:29:17  */
  assign n186_o = n177_o == 2'b10;
  assign n188_o = {n186_o, n183_o, n180_o};
  /* decoder.vhdl:26:5  */
  always @*
    case (n188_o)
      3'b100: n189_o <= 3'b011;
      3'b010: n189_o <= 3'b001;
      3'b001: n189_o <= 3'b000;
    endcase
  /* decoder.vhdl:32:25  */
  assign n190_o = instruction[24:21];
  /* decoder.vhdl:31:30  */
  assign n193_o = 4'b1111 - n190_o;
  /* decoder.vhdl:34:22  */
  assign n197_o = instruction[24:22];
  /* decoder.vhdl:35:30  */
  assign n200_o = n197_o == 3'b001;
  /* decoder.vhdl:35:41  */
  assign n202_o = n197_o == 3'b010;
  /* decoder.vhdl:35:41  */
  assign n203_o = n200_o | n202_o;
  /* decoder.vhdl:35:49  */
  assign n205_o = n197_o == 3'b011;
  /* decoder.vhdl:35:49  */
  assign n206_o = n203_o | n205_o;
  /* decoder.vhdl:36:15  */
  assign n209_o = n197_o == 3'b000;
  /* decoder.vhdl:36:26  */
  assign n211_o = n197_o == 3'b110;
  /* decoder.vhdl:36:26  */
  assign n212_o = n209_o | n211_o;
  /* decoder.vhdl:36:34  */
  assign n214_o = n197_o == 3'b111;
  /* decoder.vhdl:36:34  */
  assign n215_o = n212_o | n214_o;
  /* decoder.vhdl:37:14  */
  assign n218_o = n197_o == 3'b101;
  assign n220_o = {n218_o, n215_o, n206_o};
  /* decoder.vhdl:34:5  */
  always @*
    case (n220_o)
      3'b100: n221_o <= 3'b010;
      3'b010: n221_o <= 3'b001;
      3'b001: n221_o <= 3'b000;
    endcase
  /* decoder.vhdl:40:44  */
  assign n223_o = instruction[25];
  /* decoder.vhdl:40:49  */
  assign n224_o = ~n223_o;
  /* decoder.vhdl:40:27  */
  assign n225_o = n224_o ? 1'b0 : 1'b1;
  /* decoder.vhdl:42:41  */
  assign n228_o = instruction[20];
  /* decoder.vhdl:42:24  */
  assign n229_o = n228_o ? 1'b0 : 1'b1;
  /* decoder.vhdl:44:45  */
  assign n232_o = instruction[23];
  /* decoder.vhdl:44:28  */
  assign n233_o = n232_o ? 1'b0 : 1'b1;
  /* decoder.vhdl:16:5  */
  reg [3:0] n235[15:0] ; // memory
  initial begin
    n235[15] = 4'b0000;
    n235[14] = 4'b0001;
    n235[13] = 4'b0010;
    n235[12] = 4'b0011;
    n235[11] = 4'b0100;
    n235[10] = 4'b0101;
    n235[9] = 4'b0110;
    n235[8] = 4'b0111;
    n235[7] = 4'b1000;
    n235[6] = 4'b1001;
    n235[5] = 4'b1010;
    n235[4] = 4'b1011;
    n235[3] = 4'b1100;
    n235[2] = 4'b1101;
    n235[1] = 4'b1110;
    n235[0] = 4'b1111;
    end
  assign n236_data = n235[n193_o];
  /* decoder.vhdl:31:31  */
endmodule

module prog_mem
  (input  [5:0] addr,
   output [31:0] data);
  reg [2047:0] rom;
  wire [31:0] n170_data; // mem_rd
  assign data = n170_data;
  /* mem.vhdl:15:12  */
  always @*
    rom = "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011100001010100010000000000000000111000100100000000000000000000011110101011111111111111111111101111100010010000010001000000000001000110100000000000000000000000011110000101010000000000000000000100001010000000000000000000000001111000010101000000000000000000011110001110100000000100000000000111100011101000000000000000000001"; // (isignal)
  initial
    rom <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011100001010100010000000000000000111000100100000000000000000000011110101011111111111111111111101111100010010000010001000000000001000110100000000000000000000000011110000101010000000000000000000100001010000000000000000000000001111000010101000000000000000000011110001110100000000100000000000111100011101000000000000000000001";
  /* mem.vhdl:8:9  */
  reg [31:0] n169[63:0] ; // memory
  initial begin
    n169[63] = 32'b00000000000000000000000000000000;
    n169[62] = 32'b00000000000000000000000000000000;
    n169[61] = 32'b00000000000000000000000000000000;
    n169[60] = 32'b00000000000000000000000000000000;
    n169[59] = 32'b00000000000000000000000000000000;
    n169[58] = 32'b00000000000000000000000000000000;
    n169[57] = 32'b00000000000000000000000000000000;
    n169[56] = 32'b00000000000000000000000000000000;
    n169[55] = 32'b00000000000000000000000000000000;
    n169[54] = 32'b00000000000000000000000000000000;
    n169[53] = 32'b00000000000000000000000000000000;
    n169[52] = 32'b00000000000000000000000000000000;
    n169[51] = 32'b00000000000000000000000000000000;
    n169[50] = 32'b00000000000000000000000000000000;
    n169[49] = 32'b00000000000000000000000000000000;
    n169[48] = 32'b00000000000000000000000000000000;
    n169[47] = 32'b00000000000000000000000000000000;
    n169[46] = 32'b00000000000000000000000000000000;
    n169[45] = 32'b00000000000000000000000000000000;
    n169[44] = 32'b00000000000000000000000000000000;
    n169[43] = 32'b00000000000000000000000000000000;
    n169[42] = 32'b00000000000000000000000000000000;
    n169[41] = 32'b00000000000000000000000000000000;
    n169[40] = 32'b00000000000000000000000000000000;
    n169[39] = 32'b00000000000000000000000000000000;
    n169[38] = 32'b00000000000000000000000000000000;
    n169[37] = 32'b00000000000000000000000000000000;
    n169[36] = 32'b00000000000000000000000000000000;
    n169[35] = 32'b00000000000000000000000000000000;
    n169[34] = 32'b00000000000000000000000000000000;
    n169[33] = 32'b00000000000000000000000000000000;
    n169[32] = 32'b00000000000000000000000000000000;
    n169[31] = 32'b00000000000000000000000000000000;
    n169[30] = 32'b00000000000000000000000000000000;
    n169[29] = 32'b00000000000000000000000000000000;
    n169[28] = 32'b00000000000000000000000000000000;
    n169[27] = 32'b00000000000000000000000000000000;
    n169[26] = 32'b00000000000000000000000000000000;
    n169[25] = 32'b00000000000000000000000000000000;
    n169[24] = 32'b00000000000000000000000000000000;
    n169[23] = 32'b00000000000000000000000000000000;
    n169[22] = 32'b00000000000000000000000000000000;
    n169[21] = 32'b00000000000000000000000000000000;
    n169[20] = 32'b00000000000000000000000000000000;
    n169[19] = 32'b00000000000000000000000000000000;
    n169[18] = 32'b00000000000000000000000000000000;
    n169[17] = 32'b00000000000000000000000000000000;
    n169[16] = 32'b00000000000000000000000000000000;
    n169[15] = 32'b00000000000000000000000000000000;
    n169[14] = 32'b00000000000000000000000000000000;
    n169[13] = 32'b00000000000000000000000000000000;
    n169[12] = 32'b00000000000000000000000000000000;
    n169[11] = 32'b00000000000000000000000000000000;
    n169[10] = 32'b00000000000000000000000000000000;
    n169[9] = 32'b11100001010100010000000000000000;
    n169[8] = 32'b11100010010000000000000000000001;
    n169[7] = 32'b11101010111111111111111111111011;
    n169[6] = 32'b11100010010000010001000000000001;
    n169[5] = 32'b00011010000000000000000000000001;
    n169[4] = 32'b11100001010100000000000000000001;
    n169[3] = 32'b00001010000000000000000000000001;
    n169[2] = 32'b11100001010100000000000000000001;
    n169[1] = 32'b11100011101000000001000000000001;
    n169[0] = 32'b11100011101000000000000000000001;
    end
  assign n170_data = n169[addr];
  /* mem.vhdl:30:17  */
endmodule

module cpu
  (input  clock);
  reg [5:0] pc;
  wire [5:0] pc_in;
  wire [5:0] pc_plus1;
  wire [5:0] pc_branch;
  reg b;
  reg rw;
  reg rsrc;
  reg asrc;
  reg m2r;
  wire [3:0] mw;
  reg cond_true;
  wire [2:0] instr_class;
  wire [3:0] operation;
  wire dp_operand_src;
  wire load_store;
  wire dt_offset_sign;
  wire [31:0] shift_op;
  wire [31:0] op;
  wire [3:0] opcode;
  wire carry_out;
  wire [31:0] ans;
  wire [3:0] r_addr_2;
  wire [31:0] data_in;
  wire [31:0] out_2;
  wire [3:0] cpsr_in;
  wire [3:0] cpsr_out;
  wire update_flags;
  wire [31:0] data_mem_out;
  wire [31:0] instruction;
  wire [31:0] prog_mem_data;
  wire [2:0] decoder_instr_class;
  wire [3:0] decoder_operation;
  wire [2:0] decoder_dp_subclass;
  wire decoder_dp_operand_src;
  wire decoder_load_store;
  wire decoder_dt_offset_sign;
  wire alu_carry_out;
  wire [31:0] alu_ans;
  wire n14_o;
  wire [31:0] regfile_out_1;
  wire [31:0] regfile_out_2;
  wire [3:0] n17_o;
  wire [3:0] n18_o;
  wire [3:0] cpsr_reg_cpsr_out;
  wire [31:0] data_mem_output;
  wire [5:0] n22_o;
  wire [5:0] n23_o;
  wire condition_checker_valid;
  wire [3:0] n25_o;
  wire n29_o;
  wire n30_o;
  wire n31_o;
  wire n35_o;
  wire n37_o;
  wire n38_o;
  wire n40_o;
  wire n41_o;
  wire n43_o;
  wire n45_o;
  wire n46_o;
  wire n47_o;
  wire n48_o;
  wire n52_o;
  wire n54_o;
  wire n55_o;
  wire n57_o;
  wire n58_o;
  wire n59_o;
  wire n63_o;
  wire n65_o;
  wire n66_o;
  wire n67_o;
  wire n71_o;
  wire n73_o;
  wire n74_o;
  wire [3:0] n75_o;
  wire n79_o;
  wire n81_o;
  wire n82_o;
  wire n83_o;
  wire n86_o;
  wire n88_o;
  wire n89_o;
  wire n90_o;
  wire [3:0] n92_o;
  wire [3:0] n93_o;
  wire [3:0] n94_o;
  wire n95_o;
  wire [31:0] n96_o;
  wire [11:0] n97_o;
  wire [31:0] n99_o;
  wire n101_o;
  wire n102_o;
  wire n103_o;
  wire [31:0] n104_o;
  wire [11:0] n105_o;
  wire [31:0] n107_o;
  wire n109_o;
  wire n110_o;
  wire n111_o;
  wire n112_o;
  wire [31:0] n113_o;
  wire [9:0] n114_o;
  wire [31:0] n116_o;
  wire n118_o;
  wire n119_o;
  wire n120_o;
  wire [31:0] n121_o;
  wire [9:0] n122_o;
  wire [31:0] n124_o;
  wire [3:0] n125_o;
  wire n127_o;
  wire [3:0] n128_o;
  wire n131_o;
  wire n133_o;
  wire n134_o;
  wire [3:0] n135_o;
  wire n137_o;
  wire n140_o;
  wire n141_o;
  wire n143_o;
  wire n144_o;
  wire n145_o;
  wire n146_o;
  wire n147_o;
  wire [31:0] n148_o;
  wire [5:0] n150_o;
  wire [5:0] n152_o;
  wire [5:0] n153_o;
  wire [5:0] n154_o;
  wire [5:0] n155_o;
  reg [5:0] n158_q;
  wire [3:0] n161_o;
  /* cpu.vhdl:49:12  */
  always @*
    pc = n158_q; // (isignal)
  initial
    pc <= 6'b000000;
  /* cpu.vhdl:50:12  */
  assign pc_in = n155_o; // (signal)
  /* cpu.vhdl:51:12  */
  assign pc_plus1 = n150_o; // (signal)
  /* cpu.vhdl:52:12  */
  assign pc_branch = n154_o; // (signal)
  /* cpu.vhdl:55:12  */
  always @*
    b = n31_o; // (isignal)
  initial
    b <= 1'b0;
  /* cpu.vhdl:55:15  */
  always @*
    rw = n48_o; // (isignal)
  initial
    rw <= 1'b0;
  /* cpu.vhdl:55:19  */
  always @*
    rsrc = n67_o; // (isignal)
  initial
    rsrc <= 1'b0;
  /* cpu.vhdl:55:25  */
  always @*
    asrc = n59_o; // (isignal)
  initial
    asrc <= 1'b0;
  /* cpu.vhdl:55:31  */
  always @*
    m2r = n83_o; // (isignal)
  initial
    m2r <= 1'b0;
  /* cpu.vhdl:56:12  */
  assign mw = n75_o; // (signal)
  /* cpu.vhdl:57:12  */
  always @*
    cond_true = condition_checker_valid; // (isignal)
  initial
    cond_true <= 1'b0;
  /* cpu.vhdl:60:12  */
  assign instr_class = decoder_instr_class; // (signal)
  /* cpu.vhdl:61:12  */
  assign operation = decoder_operation; // (signal)
  /* cpu.vhdl:63:12  */
  assign dp_operand_src = decoder_dp_operand_src; // (signal)
  /* cpu.vhdl:64:12  */
  assign load_store = decoder_load_store; // (signal)
  /* cpu.vhdl:65:12  */
  assign dt_offset_sign = decoder_dt_offset_sign; // (signal)
  /* cpu.vhdl:68:12  */
  assign shift_op = regfile_out_1; // (signal)
  /* cpu.vhdl:69:12  */
  assign op = n96_o; // (signal)
  /* cpu.vhdl:71:12  */
  assign opcode = n128_o; // (signal)
  /* cpu.vhdl:72:12  */
  assign carry_out = alu_carry_out; // (signal)
  /* cpu.vhdl:73:12  */
  assign ans = alu_ans; // (signal)
  /* cpu.vhdl:76:12  */
  assign r_addr_2 = n93_o; // (signal)
  /* cpu.vhdl:78:12  */
  assign data_in = n148_o; // (signal)
  /* cpu.vhdl:79:12  */
  assign out_2 = regfile_out_2; // (signal)
  /* cpu.vhdl:82:12  */
  assign cpsr_in = n161_o; // (signal)
  /* cpu.vhdl:82:21  */
  assign cpsr_out = cpsr_reg_cpsr_out; // (signal)
  /* cpu.vhdl:83:12  */
  assign update_flags = n90_o; // (signal)
  /* cpu.vhdl:87:12  */
  assign data_mem_out = data_mem_output; // (signal)
  /* cpu.vhdl:93:12  */
  assign instruction = prog_mem_data; // (signal)
  /* cpu.vhdl:97:5  */
  prog_mem prog_mem (
    .addr(pc),
    .data(prog_mem_data));
  /* cpu.vhdl:98:5  */
  decoder decoder (
    .instruction(instruction),
    .instr_class(decoder_instr_class),
    .operation(decoder_operation),
    .dp_subclass(),
    .dp_operand_src(decoder_dp_operand_src),
    .load_store(decoder_load_store),
    .dt_offset_sign(decoder_dt_offset_sign));
  /* cpu.vhdl:99:5  */
  alu alu (
    .shift_op(op),
    .op(shift_op),
    .carry_in(n14_o),
    .opcode(opcode),
    .carry_out(alu_carry_out),
    .ans(alu_ans));
  /* cpu.vhdl:99:58  */
  assign n14_o = cpsr_out[2];
  /* cpu.vhdl:100:5  */
  regfile regfile (
    .r_addr_1(n17_o),
    .r_addr_2(r_addr_2),
    .w_addr(n18_o),
    .data_in(data_in),
    .w_en(rw),
    .clk(clock),
    .out_1(regfile_out_1),
    .out_2(regfile_out_2));
  /* cpu.vhdl:100:55  */
  assign n17_o = instruction[19:16];
  /* cpu.vhdl:100:92  */
  assign n18_o = instruction[15:12];
  /* cpu.vhdl:101:5  */
  cpsr_reg cpsr_reg (
    .cpsr_in(cpsr_in),
    .update(update_flags),
    .clock(clock),
    .cpsr_out(cpsr_reg_cpsr_out));
  /* cpu.vhdl:102:5  */
  data_mem data_mem (
    .r_addr(n22_o),
    .w_addr(n23_o),
    .w_en(mw),
    .data_in(out_2),
    .clk(clock),
    .output(data_mem_output));
  /* cpu.vhdl:102:49  */
  assign n22_o = ans[5:0];
  /* cpu.vhdl:102:66  */
  assign n23_o = ans[5:0];
  /* cpu.vhdl:103:5  */
  condition_checker condition_checker (
    .condition(n25_o),
    .cpsr_reg(cpsr_out),
    .valid(condition_checker_valid));
  /* cpu.vhdl:103:75  */
  assign n25_o = instruction[31:28];
  /* cpu.vhdl:106:55  */
  assign n29_o = instr_class == 3'b011;
  /* cpu.vhdl:106:38  */
  assign n30_o = cond_true & n29_o;
  /* cpu.vhdl:106:14  */
  assign n31_o = n30_o ? 1'b1 : 1'b0;
  /* cpu.vhdl:107:31  */
  assign n35_o = operation == 4'b0100;
  /* cpu.vhdl:107:50  */
  assign n37_o = operation == 4'b0010;
  /* cpu.vhdl:107:37  */
  assign n38_o = n35_o | n37_o;
  /* cpu.vhdl:107:69  */
  assign n40_o = operation == 4'b1101;
  /* cpu.vhdl:107:56  */
  assign n41_o = n38_o | n40_o;
  /* cpu.vhdl:107:92  */
  assign n43_o = instr_class == 3'b001;
  /* cpu.vhdl:107:114  */
  assign n45_o = load_store == 1'b0;
  /* cpu.vhdl:107:98  */
  assign n46_o = n43_o & n45_o;
  /* cpu.vhdl:107:75  */
  assign n47_o = n41_o | n46_o;
  /* cpu.vhdl:107:15  */
  assign n48_o = n47_o ? 1'b1 : 1'b0;
  /* cpu.vhdl:108:36  */
  assign n52_o = instr_class == 3'b000;
  /* cpu.vhdl:108:60  */
  assign n54_o = dp_operand_src == 1'b1;
  /* cpu.vhdl:108:41  */
  assign n55_o = n52_o & n54_o;
  /* cpu.vhdl:108:83  */
  assign n57_o = instr_class == 3'b001;
  /* cpu.vhdl:108:67  */
  assign n58_o = n55_o | n57_o;
  /* cpu.vhdl:108:17  */
  assign n59_o = n58_o ? 1'b1 : 1'b0;
  /* cpu.vhdl:109:36  */
  assign n63_o = instr_class == 3'b001;
  /* cpu.vhdl:109:58  */
  assign n65_o = load_store == 1'b1;
  /* cpu.vhdl:109:42  */
  assign n66_o = n63_o & n65_o;
  /* cpu.vhdl:109:17  */
  assign n67_o = n66_o ? 1'b1 : 1'b0;
  /* cpu.vhdl:110:37  */
  assign n71_o = instr_class == 3'b001;
  /* cpu.vhdl:110:59  */
  assign n73_o = load_store == 1'b1;
  /* cpu.vhdl:110:43  */
  assign n74_o = n71_o & n73_o;
  /* cpu.vhdl:110:18  */
  assign n75_o = n74_o ? 4'b1111 : 4'b0000;
  /* cpu.vhdl:111:35  */
  assign n79_o = instr_class == 3'b001;
  /* cpu.vhdl:111:57  */
  assign n81_o = load_store == 1'b0;
  /* cpu.vhdl:111:41  */
  assign n82_o = n79_o & n81_o;
  /* cpu.vhdl:111:16  */
  assign n83_o = n82_o ? 1'b1 : 1'b0;
  /* cpu.vhdl:112:42  */
  assign n86_o = instruction[20];
  /* cpu.vhdl:112:69  */
  assign n88_o = instr_class == 3'b000;
  /* cpu.vhdl:112:53  */
  assign n89_o = n86_o & n88_o;
  /* cpu.vhdl:112:25  */
  assign n90_o = n89_o ? 1'b1 : 1'b0;
  /* cpu.vhdl:115:28  */
  assign n92_o = instruction[15:12];
  /* cpu.vhdl:115:43  */
  assign n93_o = rsrc ? n92_o : n94_o;
  /* cpu.vhdl:115:75  */
  assign n94_o = instruction[3:0];
  /* cpu.vhdl:120:27  */
  assign n95_o = ~asrc;
  /* cpu.vhdl:120:17  */
  assign n96_o = n95_o ? out_2 : n104_o;
  /* cpu.vhdl:121:34  */
  assign n97_o = instruction[11:0];
  /* cpu.vhdl:121:21  */
  assign n99_o = {20'b11111111111111111111, n97_o};
  /* cpu.vhdl:121:66  */
  assign n101_o = instr_class == 3'b000;
  /* cpu.vhdl:121:85  */
  assign n102_o = instruction[11];
  /* cpu.vhdl:121:70  */
  assign n103_o = n101_o & n102_o;
  /* cpu.vhdl:120:33  */
  assign n104_o = n103_o ? n99_o : n113_o;
  /* cpu.vhdl:122:34  */
  assign n105_o = instruction[11:0];
  /* cpu.vhdl:122:21  */
  assign n107_o = {20'b00000000000000000000, n105_o};
  /* cpu.vhdl:122:66  */
  assign n109_o = instr_class == 3'b000;
  /* cpu.vhdl:122:85  */
  assign n110_o = instruction[11];
  /* cpu.vhdl:122:90  */
  assign n111_o = ~n110_o;
  /* cpu.vhdl:122:70  */
  assign n112_o = n109_o & n111_o;
  /* cpu.vhdl:121:97  */
  assign n113_o = n112_o ? n107_o : n121_o;
  /* cpu.vhdl:123:41  */
  assign n114_o = instruction[11:2];
  /* cpu.vhdl:123:28  */
  assign n116_o = {22'b1111111111111111111111, n114_o};
  /* cpu.vhdl:123:73  */
  assign n118_o = instr_class == 3'b001;
  /* cpu.vhdl:123:92  */
  assign n119_o = instruction[11];
  /* cpu.vhdl:123:77  */
  assign n120_o = n118_o & n119_o;
  /* cpu.vhdl:122:97  */
  assign n121_o = n120_o ? n116_o : n124_o;
  /* cpu.vhdl:124:41  */
  assign n122_o = instruction[11:2];
  /* cpu.vhdl:124:28  */
  assign n124_o = {22'b0000000000000000000000, n122_o};
  /* cpu.vhdl:127:26  */
  assign n125_o = instruction[24:21];
  /* cpu.vhdl:127:58  */
  assign n127_o = instr_class == 3'b000;
  /* cpu.vhdl:127:41  */
  assign n128_o = n127_o ? n125_o : n135_o;
  /* cpu.vhdl:128:40  */
  assign n131_o = instr_class == 3'b001;
  /* cpu.vhdl:128:64  */
  assign n133_o = dt_offset_sign == 1'b0;
  /* cpu.vhdl:128:45  */
  assign n134_o = n131_o & n133_o;
  /* cpu.vhdl:127:63  */
  assign n135_o = n134_o ? 4'b0100 : 4'b0010;
  /* cpu.vhdl:132:22  */
  assign n137_o = ans[31];
  /* cpu.vhdl:134:32  */
  assign n140_o = ans == 32'b00000000000000000000000000000000;
  /* cpu.vhdl:134:23  */
  assign n141_o = n140_o ? 1'b1 : 1'b0;
  /* cpu.vhdl:138:28  */
  assign n143_o = shift_op[31];
  /* cpu.vhdl:138:38  */
  assign n144_o = op[31];
  /* cpu.vhdl:138:33  */
  assign n145_o = n143_o | n144_o;
  /* cpu.vhdl:138:51  */
  assign n146_o = ans[31];
  /* cpu.vhdl:138:44  */
  assign n147_o = n145_o ^ n146_o;
  /* cpu.vhdl:141:29  */
  assign n148_o = m2r ? data_mem_out : ans;
  /* cpu.vhdl:144:44  */
  assign n150_o = pc + 6'b000001;
  /* cpu.vhdl:145:46  */
  assign n152_o = pc + 6'b000010;
  /* cpu.vhdl:145:70  */
  assign n153_o = instruction[5:0];
  /* cpu.vhdl:145:50  */
  assign n154_o = n152_o + n153_o;
  /* cpu.vhdl:146:24  */
  assign n155_o = b ? pc_branch : pc_plus1;
  /* cpu.vhdl:147:17  */
  always @(posedge clock)
    n158_q <= pc_in;
  initial
    n158_q <= 6'b000000;
  assign n161_o = {n147_o, carry_out, n141_o, n137_o};
endmodule

