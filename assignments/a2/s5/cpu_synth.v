module predicator
  (input  [3:0] condition,
   input  [3:0] flags,
   output p);
  wire n638_o;
  wire n639_o;
  wire n640_o;
  wire n641_o;
  wire n644_o;
  wire n645_o;
  wire n646_o;
  wire n647_o;
  wire n648_o;
  wire n651_o;
  wire n652_o;
  assign p = n641_o;
  /* predicator.vhdl:15:30  */
  assign n638_o = condition == 4'b0000;
  /* predicator.vhdl:15:48  */
  assign n639_o = flags[1];
  /* predicator.vhdl:15:39  */
  assign n640_o = n638_o & n639_o;
  /* predicator.vhdl:15:14  */
  assign n641_o = n640_o ? 1'b1 : n648_o;
  /* predicator.vhdl:16:30  */
  assign n644_o = condition == 4'b0001;
  /* predicator.vhdl:16:48  */
  assign n645_o = flags[1];
  /* predicator.vhdl:16:57  */
  assign n646_o = ~n645_o;
  /* predicator.vhdl:16:39  */
  assign n647_o = n644_o & n646_o;
  /* predicator.vhdl:15:64  */
  assign n648_o = n647_o ? 1'b1 : n652_o;
  /* predicator.vhdl:17:29  */
  assign n651_o = condition == 4'b1110;
  /* predicator.vhdl:16:64  */
  assign n652_o = n651_o ? 1'b1 : 1'b0;
endmodule

module reg_4
  (input  [3:0] data_in,
   input  clock,
   input  w_en,
   output [3:0] data_out);
  wire [3:0] n633_o;
  reg [3:0] n634_q;
  assign data_out = n634_q;
  /* commons.vhdl:19:9  */
  assign n633_o = w_en ? data_in : n634_q;
  /* commons.vhdl:19:9  */
  always @(posedge clock)
    n634_q <= n633_o;
  initial
    n634_q <= 4'b0000;
endmodule

module alu
  (input  [31:0] shift_op,
   input  [31:0] op,
   input  carry_in,
   input  [3:0] opcode,
   output [31:0] ans,
   output [3:0] flags);
  wire [32:0] temp_ans;
  wire [31:0] n491_o;
  wire [32:0] n493_o;
  wire n495_o;
  wire [32:0] n496_o;
  wire [31:0] n497_o;
  wire [32:0] n499_o;
  wire n501_o;
  wire [32:0] n502_o;
  wire [32:0] n503_o;
  wire [32:0] n504_o;
  wire [32:0] n505_o;
  wire n507_o;
  wire [32:0] n508_o;
  wire [32:0] n509_o;
  wire [32:0] n510_o;
  wire [32:0] n511_o;
  wire n513_o;
  wire [32:0] n514_o;
  wire [32:0] n515_o;
  wire [32:0] n516_o;
  wire [32:0] n517_o;
  wire n519_o;
  wire [32:0] n520_o;
  wire [32:0] n521_o;
  wire [32:0] n522_o;
  wire [32:0] n523_o;
  wire [1:0] n525_o;
  wire [32:0] n526_o;
  wire [32:0] n527_o;
  wire n529_o;
  wire [32:0] n530_o;
  wire [32:0] n531_o;
  wire [32:0] n532_o;
  wire [32:0] n533_o;
  wire n534_o;
  wire [1:0] n536_o;
  wire [32:0] n537_o;
  wire [32:0] n538_o;
  wire n540_o;
  wire [32:0] n541_o;
  wire [32:0] n542_o;
  wire [32:0] n543_o;
  wire [32:0] n544_o;
  wire n545_o;
  wire [1:0] n547_o;
  wire [32:0] n548_o;
  wire [32:0] n549_o;
  wire n551_o;
  wire [32:0] n552_o;
  wire [31:0] n553_o;
  wire [32:0] n555_o;
  wire n557_o;
  wire [32:0] n558_o;
  wire [31:0] n559_o;
  wire [32:0] n561_o;
  wire n563_o;
  wire [32:0] n564_o;
  wire [32:0] n565_o;
  wire [32:0] n566_o;
  wire [32:0] n567_o;
  wire n569_o;
  wire [32:0] n570_o;
  wire [32:0] n571_o;
  wire [32:0] n572_o;
  wire [32:0] n573_o;
  wire n575_o;
  wire [32:0] n576_o;
  wire [31:0] n577_o;
  wire [32:0] n579_o;
  wire n581_o;
  wire [32:0] n582_o;
  wire [32:0] n584_o;
  wire n586_o;
  wire [32:0] n587_o;
  wire [31:0] n588_o;
  wire [31:0] n589_o;
  wire [32:0] n591_o;
  wire n593_o;
  wire [32:0] n594_o;
  wire [31:0] n595_o;
  wire [32:0] n597_o;
  wire n599_o;
  wire [32:0] n600_o;
  wire [31:0] n602_o;
  wire n603_o;
  wire [31:0] n605_o;
  wire n607_o;
  wire n608_o;
  wire n610_o;
  wire n611_o;
  wire n612_o;
  wire n613_o;
  wire n614_o;
  wire n615_o;
  wire n616_o;
  wire n617_o;
  wire n618_o;
  wire n619_o;
  wire n620_o;
  wire n621_o;
  wire n622_o;
  wire n623_o;
  wire n624_o;
  wire [3:0] n625_o;
  assign ans = n602_o;
  assign flags = n625_o;
  /* alu.vhdl:96:12  */
  assign temp_ans = n496_o; // (signal)
  /* alu.vhdl:98:27  */
  assign n491_o = op & shift_op;
  /* alu.vhdl:98:21  */
  assign n493_o = {1'b0, n491_o};
  /* alu.vhdl:98:53  */
  assign n495_o = opcode == 4'b0000;
  /* alu.vhdl:98:41  */
  assign n496_o = n495_o ? n493_o : n502_o;
  /* alu.vhdl:99:27  */
  assign n497_o = op ^ shift_op;
  /* alu.vhdl:99:21  */
  assign n499_o = {1'b0, n497_o};
  /* alu.vhdl:99:53  */
  assign n501_o = opcode == 4'b0001;
  /* alu.vhdl:98:62  */
  assign n502_o = n501_o ? n499_o : n508_o;
  /* alu.vhdl:100:34  */
  assign n503_o = {1'b0, op};  //  uext
  /* alu.vhdl:100:60  */
  assign n504_o = {1'b0, shift_op};  //  uext
  /* alu.vhdl:100:58  */
  assign n505_o = n503_o - n504_o;
  /* alu.vhdl:100:103  */
  assign n507_o = opcode == 4'b0010;
  /* alu.vhdl:99:62  */
  assign n508_o = n507_o ? n505_o : n514_o;
  /* alu.vhdl:101:34  */
  assign n509_o = {1'b0, shift_op};  //  uext
  /* alu.vhdl:101:66  */
  assign n510_o = {1'b0, op};  //  uext
  /* alu.vhdl:101:64  */
  assign n511_o = n509_o - n510_o;
  /* alu.vhdl:101:103  */
  assign n513_o = opcode == 4'b0011;
  /* alu.vhdl:100:112  */
  assign n514_o = n513_o ? n511_o : n520_o;
  /* alu.vhdl:102:34  */
  assign n515_o = {1'b0, shift_op};  //  uext
  /* alu.vhdl:102:66  */
  assign n516_o = {1'b0, op};  //  uext
  /* alu.vhdl:102:64  */
  assign n517_o = n515_o + n516_o;
  /* alu.vhdl:102:103  */
  assign n519_o = opcode == 4'b0100;
  /* alu.vhdl:101:112  */
  assign n520_o = n519_o ? n517_o : n530_o;
  /* alu.vhdl:103:34  */
  assign n521_o = {1'b0, shift_op};  //  uext
  /* alu.vhdl:103:66  */
  assign n522_o = {1'b0, op};  //  uext
  /* alu.vhdl:103:64  */
  assign n523_o = n521_o + n522_o;
  /* alu.vhdl:103:105  */
  assign n525_o = {1'b0, carry_in};
  /* alu.vhdl:103:90  */
  assign n526_o = {31'b0, n525_o};  //  uext
  /* alu.vhdl:103:90  */
  assign n527_o = n523_o + n526_o;
  /* alu.vhdl:103:129  */
  assign n529_o = opcode == 4'b0101;
  /* alu.vhdl:102:112  */
  assign n530_o = n529_o ? n527_o : n541_o;
  /* alu.vhdl:104:34  */
  assign n531_o = {1'b0, op};  //  uext
  /* alu.vhdl:104:60  */
  assign n532_o = {1'b0, shift_op};  //  uext
  /* alu.vhdl:104:58  */
  assign n533_o = n531_o - n532_o;
  /* alu.vhdl:104:107  */
  assign n534_o = ~carry_in;
  /* alu.vhdl:104:105  */
  assign n536_o = {1'b0, n534_o};
  /* alu.vhdl:104:90  */
  assign n537_o = {31'b0, n536_o};  //  uext
  /* alu.vhdl:104:90  */
  assign n538_o = n533_o - n537_o;
  /* alu.vhdl:104:135  */
  assign n540_o = opcode == 4'b0110;
  /* alu.vhdl:103:138  */
  assign n541_o = n540_o ? n538_o : n552_o;
  /* alu.vhdl:105:34  */
  assign n542_o = {1'b0, shift_op};  //  uext
  /* alu.vhdl:105:66  */
  assign n543_o = {1'b0, op};  //  uext
  /* alu.vhdl:105:64  */
  assign n544_o = n542_o - n543_o;
  /* alu.vhdl:105:107  */
  assign n545_o = ~carry_in;
  /* alu.vhdl:105:105  */
  assign n547_o = {1'b0, n545_o};
  /* alu.vhdl:105:90  */
  assign n548_o = {31'b0, n547_o};  //  uext
  /* alu.vhdl:105:90  */
  assign n549_o = n544_o - n548_o;
  /* alu.vhdl:105:135  */
  assign n551_o = opcode == 4'b0111;
  /* alu.vhdl:104:144  */
  assign n552_o = n551_o ? n549_o : n558_o;
  /* alu.vhdl:106:27  */
  assign n553_o = op & shift_op;
  /* alu.vhdl:106:21  */
  assign n555_o = {1'b0, n553_o};
  /* alu.vhdl:106:53  */
  assign n557_o = opcode == 4'b1000;
  /* alu.vhdl:105:144  */
  assign n558_o = n557_o ? n555_o : n564_o;
  /* alu.vhdl:107:27  */
  assign n559_o = op ^ shift_op;
  /* alu.vhdl:107:21  */
  assign n561_o = {1'b0, n559_o};
  /* alu.vhdl:107:53  */
  assign n563_o = opcode == 4'b1001;
  /* alu.vhdl:106:62  */
  assign n564_o = n563_o ? n561_o : n570_o;
  /* alu.vhdl:108:34  */
  assign n565_o = {1'b0, op};  //  uext
  /* alu.vhdl:108:60  */
  assign n566_o = {1'b0, shift_op};  //  uext
  /* alu.vhdl:108:58  */
  assign n567_o = n565_o - n566_o;
  /* alu.vhdl:108:103  */
  assign n569_o = opcode == 4'b1010;
  /* alu.vhdl:107:62  */
  assign n570_o = n569_o ? n567_o : n576_o;
  /* alu.vhdl:109:34  */
  assign n571_o = {1'b0, shift_op};  //  uext
  /* alu.vhdl:109:66  */
  assign n572_o = {1'b0, op};  //  uext
  /* alu.vhdl:109:64  */
  assign n573_o = n571_o + n572_o;
  /* alu.vhdl:109:103  */
  assign n575_o = opcode == 4'b1011;
  /* alu.vhdl:108:112  */
  assign n576_o = n575_o ? n573_o : n582_o;
  /* alu.vhdl:110:27  */
  assign n577_o = op | shift_op;
  /* alu.vhdl:110:21  */
  assign n579_o = {1'b0, n577_o};
  /* alu.vhdl:110:52  */
  assign n581_o = opcode == 4'b1100;
  /* alu.vhdl:109:112  */
  assign n582_o = n581_o ? n579_o : n587_o;
  /* alu.vhdl:111:21  */
  assign n584_o = {1'b0, shift_op};
  /* alu.vhdl:111:44  */
  assign n586_o = opcode == 4'b1101;
  /* alu.vhdl:110:61  */
  assign n587_o = n586_o ? n584_o : n594_o;
  /* alu.vhdl:112:32  */
  assign n588_o = ~shift_op;
  /* alu.vhdl:112:27  */
  assign n589_o = op & n588_o;
  /* alu.vhdl:112:21  */
  assign n591_o = {1'b0, n589_o};
  /* alu.vhdl:112:59  */
  assign n593_o = opcode == 4'b1110;
  /* alu.vhdl:111:53  */
  assign n594_o = n593_o ? n591_o : n600_o;
  /* alu.vhdl:113:24  */
  assign n595_o = ~shift_op;
  /* alu.vhdl:113:21  */
  assign n597_o = {1'b0, n595_o};
  /* alu.vhdl:113:50  */
  assign n599_o = opcode == 4'b1111;
  /* alu.vhdl:112:68  */
  assign n600_o = n599_o ? n597_o : 33'b000000000000000000000000000000000;
  /* alu.vhdl:116:20  */
  assign n602_o = temp_ans[31:0];
  /* alu.vhdl:117:30  */
  assign n603_o = temp_ans[31];
  /* alu.vhdl:118:39  */
  assign n605_o = temp_ans[31:0];
  /* alu.vhdl:118:53  */
  assign n607_o = n605_o == 32'b00000000000000000000000000000000;
  /* alu.vhdl:118:26  */
  assign n608_o = n607_o ? 1'b1 : 1'b0;
  /* alu.vhdl:119:30  */
  assign n610_o = temp_ans[32];
  /* alu.vhdl:120:31  */
  assign n611_o = shift_op[31];
  /* alu.vhdl:120:42  */
  assign n612_o = op[31];
  /* alu.vhdl:120:36  */
  assign n613_o = n611_o & n612_o;
  /* alu.vhdl:120:64  */
  assign n614_o = temp_ans[31];
  /* alu.vhdl:120:52  */
  assign n615_o = ~n614_o;
  /* alu.vhdl:120:47  */
  assign n616_o = n613_o & n615_o;
  /* alu.vhdl:120:88  */
  assign n617_o = shift_op[31];
  /* alu.vhdl:120:76  */
  assign n618_o = ~n617_o;
  /* alu.vhdl:120:105  */
  assign n619_o = op[31];
  /* alu.vhdl:120:99  */
  assign n620_o = ~n619_o;
  /* alu.vhdl:120:94  */
  assign n621_o = n618_o & n620_o;
  /* alu.vhdl:120:123  */
  assign n622_o = temp_ans[31];
  /* alu.vhdl:120:111  */
  assign n623_o = n621_o & n622_o;
  /* alu.vhdl:120:71  */
  assign n624_o = n616_o | n623_o;
  assign n625_o = {n624_o, n610_o, n608_o, n603_o};
endmodule

module mux_4_2
  (input  [127:0] in,
   input  [1:0] sel,
   output [31:0] out);
  wire [31:0] n483_o;
  wire [31:0] n484_o;
  wire [31:0] n485_o;
  wire [31:0] n486_o;
  wire [1:0] n487_o;
  reg [31:0] n488_o;
  assign out = n488_o;
  /* commons.vhdl:37:9  */
  assign n483_o = in[31:0];
  /* commons.vhdl:44:21  */
  assign n484_o = in[63:32];
  /* regfile.vhdl:37:18  */
  assign n485_o = in[95:64];
  /* regfile.vhdl:34:5  */
  assign n486_o = in[127:96];
  /* commons.vhdl:44:20  */
  assign n487_o = sel[1:0];
  /* commons.vhdl:44:20  */
  always @*
    case (n487_o)
      2'b00: n488_o <= n483_o;
      2'b01: n488_o <= n484_o;
      2'b10: n488_o <= n485_o;
      2'b11: n488_o <= n486_o;
    endcase
endmodule

module sign_extender_24_32
  (input  [23:0] data_in,
   output [31:0] data_out);
  wire [31:0] n478_o;
  assign data_out = n478_o;
  /* commons.vhdl:84:34  */
  assign n478_o = {{8{data_in[23]}}, data_in}; // sext
endmodule

module sign_extender_12_32
  (input  [11:0] data_in,
   output [31:0] data_out);
  wire [31:0] n476_o;
  assign data_out = n476_o;
  /* commons.vhdl:84:34  */
  assign n476_o = {{20{data_in[11]}}, data_in}; // sext
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
  wire [31:0] n472_data; // mem_rd
  wire [31:0] n473_data; // mem_rd
  assign out_1 = n473_data;
  assign out_2 = n472_data;
  /* regfile.vhdl:23:9  */
  reg [31:0] regs[15:0] ; // memory
  assign n472_data = regs[r_addr_2];
  assign n473_data = regs[r_addr_1];
  always @(posedge clk)
    if (w_en)
      regs[w_addr] <= data_in;
  /* regfile.vhdl:42:19  */
  /* regfile.vhdl:41:19  */
  /* regfile.vhdl:37:18  */
endmodule

module mux_2_4
  (input  [3:0] in_0,
   input  [3:0] in_1,
   input  sel,
   output [3:0] out);
  wire n454_o;
  wire [3:0] n455_o;
  assign out = n455_o;
  /* commons.vhdl:66:29  */
  assign n454_o = ~sel;
  /* commons.vhdl:66:20  */
  assign n455_o = n454_o ? in_0 : in_1;
endmodule

module memory
  (input  clock,
   input  [31:0] addr,
   input  [31:0] write_data,
   input  [3:0] w_en,
   output [31:0] out);
  wire [6:0] n379_o;
  wire [30:0] n380_o;
  wire [1:0] n382_o;
  wire n384_o;
  wire [6:0] n385_o;
  wire [6:0] n388_o;
  wire [6:0] n391_o;
  wire [6:0] n394_o;
  wire [31:0] n397_o;
  wire [31:0] n399_o;
  wire [6:0] n403_o;
  wire [30:0] n404_o;
  wire [1:0] n407_o;
  wire n409_o;
  wire n411_o;
  wire [6:0] n412_o;
  wire [7:0] n414_o;
  wire n417_o;
  wire [6:0] n418_o;
  wire [7:0] n420_o;
  wire n423_o;
  wire [6:0] n424_o;
  wire [7:0] n426_o;
  wire n429_o;
  wire [6:0] n430_o;
  wire [7:0] n432_o;
  wire n437_o;
  wire n439_o;
  wire n441_o;
  wire n443_o;
  wire [7:0] n445_data; // mem_rd
  wire [7:0] n446_data; // mem_rd
  wire [7:0] n447_data; // mem_rd
  wire [7:0] n448_data; // mem_rd
  assign out = n399_o;
  /* mem.vhdl:27:46  */
  assign n379_o = addr[8:2];
  /* mem.vhdl:27:22  */
  assign n380_o = {24'b0, n379_o};  //  uext
  /* mem.vhdl:28:16  */
  assign n382_o = addr[1:0];
  /* mem.vhdl:28:29  */
  assign n384_o = n382_o == 2'b00;
  /* mem.vhdl:29:38  */
  assign n385_o = n380_o[6:0];  // trunc
  /* mem.vhdl:30:39  */
  assign n388_o = n380_o[6:0];  // trunc
  /* mem.vhdl:31:40  */
  assign n391_o = n380_o[6:0];  // trunc
  /* mem.vhdl:32:40  */
  assign n394_o = n380_o[6:0];  // trunc
  assign n397_o = {n445_data, n446_data, n447_data, n448_data};
  /* mem.vhdl:28:9  */
  assign n399_o = n384_o ? n397_o : 32'bXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
  /* mem.vhdl:41:46  */
  assign n403_o = addr[8:2];
  /* mem.vhdl:41:22  */
  assign n404_o = {24'b0, n403_o};  //  uext
  /* mem.vhdl:42:39  */
  assign n407_o = addr[1:0];
  /* mem.vhdl:42:52  */
  assign n409_o = n407_o == 2'b00;
  /* mem.vhdl:43:20  */
  assign n411_o = w_en[0];
  /* mem.vhdl:44:20  */
  assign n412_o = n404_o[6:0];  // trunc
  /* mem.vhdl:44:57  */
  assign n414_o = write_data[7:0];
  /* mem.vhdl:46:20  */
  assign n417_o = w_en[1];
  /* mem.vhdl:47:20  */
  assign n418_o = n404_o[6:0];  // trunc
  /* mem.vhdl:47:58  */
  assign n420_o = write_data[15:8];
  /* mem.vhdl:49:20  */
  assign n423_o = w_en[2];
  /* mem.vhdl:50:20  */
  assign n424_o = n404_o[6:0];  // trunc
  /* mem.vhdl:50:59  */
  assign n426_o = write_data[23:16];
  /* mem.vhdl:52:20  */
  assign n429_o = w_en[3];
  /* mem.vhdl:53:20  */
  assign n430_o = n404_o[6:0];  // trunc
  /* mem.vhdl:53:59  */
  assign n432_o = write_data[31:24];
  /* mem.vhdl:42:52  */
  assign n437_o = n429_o & n409_o;
  /* mem.vhdl:42:52  */
  assign n439_o = n423_o & n409_o;
  /* mem.vhdl:42:52  */
  assign n441_o = n417_o & n409_o;
  /* mem.vhdl:42:52  */
  assign n443_o = n411_o & n409_o;
  /* mem.vhdl:16:9  */
  reg [7:0] ram_n1[127:0] ; // memory
  assign n448_data = ram_n1[n385_o];
  always @(posedge clock)
    if (n443_o)
      ram_n1[n412_o] <= n414_o;
  reg [7:0] ram_n2[127:0] ; // memory
  assign n447_data = ram_n2[n388_o];
  always @(posedge clock)
    if (n441_o)
      ram_n2[n418_o] <= n420_o;
  /* mem.vhdl:42:31  */
  reg [7:0] ram_n3[127:0] ; // memory
  assign n446_data = ram_n3[n391_o];
  always @(posedge clock)
    if (n439_o)
      ram_n3[n424_o] <= n426_o;
  /* mem.vhdl:41:9  */
  reg [7:0] ram_n4[127:0] ; // memory
  assign n445_data = ram_n4[n394_o];
  always @(posedge clock)
    if (n437_o)
      ram_n4[n430_o] <= n432_o;
  /* mem.vhdl:32:41  */
  /* mem.vhdl:31:41  */
  /* mem.vhdl:30:40  */
  /* mem.vhdl:29:39  */
  /* mem.vhdl:44:21  */
  /* mem.vhdl:47:21  */
  /* mem.vhdl:50:21  */
  /* mem.vhdl:53:21  */
endmodule

module mux_2_32
  (input  [31:0] in_0,
   input  [31:0] in_1,
   input  sel,
   output [31:0] out);
  wire n374_o;
  wire [31:0] n375_o;
  assign out = n375_o;
  /* commons.vhdl:66:29  */
  assign n374_o = ~sel;
  /* commons.vhdl:66:20  */
  assign n375_o = n374_o ? in_0 : in_1;
endmodule

module reg_32
  (input  [31:0] data_in,
   input  clock,
   input  w_en,
   output [31:0] data_out);
  wire [31:0] n371_o;
  reg [31:0] n372_q;
  assign data_out = n372_q;
  /* commons.vhdl:19:9  */
  assign n371_o = w_en ? data_in : n372_q;
  /* commons.vhdl:19:9  */
  always @(posedge clock)
    n372_q <= n371_o;
  initial
    n372_q <= 32'b00000000000000000000000000000000;
endmodule

module cpu_multicycle_controller
  (input  clock,
   input  [31:0] instruction,
   input  prediction,
   input  [3:0] flags,
   output [3:0] ctrl_alu_opcode,
   output ctrl_alu_c_in,
   output ctrl_regfile_w_en,
   output ctrl_regfile_w_data,
   output ctrl_regfile_r_addr_2,
   output [3:0] ctrl_mem_w_en,
   output ctrl_ir_write,
   output ctrl_dr_write,
   output ctrl_res_write,
   output ctrl_pc_write,
   output ctrl_a_write,
   output ctrl_b_write,
   output ctrl_flag_set,
   output [3:0] ctrl_predict_cond,
   output ctrl_mem_ad_mux,
   output ctrl_reg_wd_mux,
   output ctrl_alu_op_mux,
   output [1:0] ctrl_alu_shift_op_mux);
  reg [3:0] curr_state;
  wire n84_o;
  wire [3:0] n85_o;
  wire [1:0] n86_o;
  wire n88_o;
  wire [1:0] n89_o;
  wire n91_o;
  wire n94_o;
  wire n96_o;
  wire n98_o;
  wire [3:0] n99_o;
  wire n100_o;
  wire n101_o;
  wire [3:0] n102_o;
  wire n103_o;
  wire [1:0] n106_o;
  wire n108_o;
  wire n109_o;
  wire n110_o;
  wire n111_o;
  wire n112_o;
  wire n115_o;
  wire [3:0] n116_o;
  wire n118_o;
  wire n119_o;
  wire [3:0] n122_o;
  wire [3:0] n123_o;
  wire n125_o;
  wire [3:0] n126_o;
  wire n128_o;
  wire [3:0] n129_o;
  wire n131_o;
  wire [3:0] n132_o;
  wire n134_o;
  wire n137_o;
  wire [3:0] n138_o;
  wire n140_o;
  wire [8:0] n141_o;
  reg [3:0] n150_o;
  reg n160_o;
  reg n170_o;
  reg n181_o;
  reg n191_o;
  reg [3:0] n202_o;
  reg n213_o;
  reg n224_o;
  reg n235_o;
  reg n245_o;
  reg n256_o;
  reg n267_o;
  reg n277_o;
  reg [3:0] n280_o;
  reg n291_o;
  reg n302_o;
  reg [1:0] n312_o;
  localparam n314_o = 1'b0;
  wire n319_o;
  wire [1:0] n320_o;
  wire n322_o;
  wire [1:0] n323_o;
  wire n325_o;
  wire [3:0] n328_o;
  wire [3:0] n330_o;
  wire n332_o;
  wire n334_o;
  wire n336_o;
  wire n337_o;
  wire [3:0] n340_o;
  wire n342_o;
  wire n344_o;
  wire n346_o;
  wire n348_o;
  wire n350_o;
  wire [8:0] n351_o;
  reg [3:0] n360_o;
  reg [3:0] n363_q;
  assign ctrl_alu_opcode = n150_o;
  assign ctrl_alu_c_in = n160_o;
  assign ctrl_regfile_w_en = n170_o;
  assign ctrl_regfile_w_data = n181_o;
  assign ctrl_regfile_r_addr_2 = n191_o;
  assign ctrl_mem_w_en = n202_o;
  assign ctrl_ir_write = n213_o;
  assign ctrl_dr_write = n224_o;
  assign ctrl_res_write = n235_o;
  assign ctrl_pc_write = n245_o;
  assign ctrl_a_write = n256_o;
  assign ctrl_b_write = n267_o;
  assign ctrl_flag_set = n277_o;
  assign ctrl_predict_cond = n280_o;
  assign ctrl_mem_ad_mux = n291_o;
  assign ctrl_reg_wd_mux = n314_o;
  assign ctrl_alu_op_mux = n302_o;
  assign ctrl_alu_shift_op_mux = n312_o;
  /* cpu_multicycle.vhdl:149:12  */
  always @*
    curr_state = n363_q; // (isignal)
  initial
    curr_state <= 4'b0000;
  /* cpu_multicycle.vhdl:155:9  */
  assign n84_o = curr_state == 4'b0000;
  /* cpu_multicycle.vhdl:187:45  */
  assign n85_o = instruction[31:28];
  /* cpu_multicycle.vhdl:193:27  */
  assign n86_o = instruction[27:26];
  /* cpu_multicycle.vhdl:193:42  */
  assign n88_o = n86_o == 2'b00;
  /* cpu_multicycle.vhdl:195:30  */
  assign n89_o = instruction[27:26];
  /* cpu_multicycle.vhdl:195:45  */
  assign n91_o = n89_o == 2'b01;
  /* cpu_multicycle.vhdl:195:13  */
  assign n94_o = n91_o ? 1'b1 : 1'b0;
  /* cpu_multicycle.vhdl:193:13  */
  assign n96_o = n88_o ? 1'b0 : n94_o;
  /* cpu_multicycle.vhdl:174:9  */
  assign n98_o = curr_state == 4'b0001;
  /* cpu_multicycle.vhdl:201:43  */
  assign n99_o = instruction[24:21];
  /* cpu_multicycle.vhdl:202:35  */
  assign n100_o = flags[2];
  /* cpu_multicycle.vhdl:213:41  */
  assign n101_o = instruction[20];
  /* cpu_multicycle.vhdl:214:45  */
  assign n102_o = instruction[31:28];
  /* cpu_multicycle.vhdl:219:27  */
  assign n103_o = instruction[25];
  /* cpu_multicycle.vhdl:219:13  */
  assign n106_o = n103_o ? 2'b10 : 2'b00;
  /* cpu_multicycle.vhdl:200:9  */
  assign n108_o = curr_state == 4'b0010;
  /* cpu_multicycle.vhdl:228:28  */
  assign n109_o = instruction[24];
  /* cpu_multicycle.vhdl:228:53  */
  assign n110_o = instruction[23];
  /* cpu_multicycle.vhdl:228:38  */
  assign n111_o = ~n110_o;
  /* cpu_multicycle.vhdl:228:33  */
  assign n112_o = n109_o & n111_o;
  /* cpu_multicycle.vhdl:228:13  */
  assign n115_o = n112_o ? 1'b0 : 1'b1;
  /* cpu_multicycle.vhdl:243:45  */
  assign n116_o = instruction[31:28];
  /* cpu_multicycle.vhdl:225:9  */
  assign n118_o = curr_state == 4'b0011;
  /* cpu_multicycle.vhdl:250:27  */
  assign n119_o = instruction[23];
  /* cpu_multicycle.vhdl:250:13  */
  assign n122_o = n119_o ? 4'b0100 : 4'b0010;
  /* cpu_multicycle.vhdl:267:45  */
  assign n123_o = instruction[31:28];
  /* cpu_multicycle.vhdl:249:9  */
  assign n125_o = curr_state == 4'b0100;
  /* cpu_multicycle.vhdl:287:45  */
  assign n126_o = instruction[31:28];
  /* cpu_multicycle.vhdl:273:9  */
  assign n128_o = curr_state == 4'b0101;
  /* cpu_multicycle.vhdl:307:45  */
  assign n129_o = instruction[31:28];
  /* cpu_multicycle.vhdl:293:9  */
  assign n131_o = curr_state == 4'b0110;
  /* cpu_multicycle.vhdl:327:45  */
  assign n132_o = instruction[31:28];
  /* cpu_multicycle.vhdl:313:9  */
  assign n134_o = curr_state == 4'b0111;
  /* cpu_multicycle.vhdl:343:13  */
  assign n137_o = prediction ? 1'b1 : 1'b0;
  /* cpu_multicycle.vhdl:351:45  */
  assign n138_o = instruction[31:28];
  /* cpu_multicycle.vhdl:333:9  */
  assign n140_o = curr_state == 4'b1000;
  assign n141_o = {n140_o, n134_o, n131_o, n128_o, n125_o, n118_o, n108_o, n98_o, n84_o};
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n150_o <= 4'b0101;
      9'b010000000: n150_o <= 4'b0000;
      9'b001000000: n150_o <= 4'b0000;
      9'b000100000: n150_o <= 4'b0000;
      9'b000010000: n150_o <= n122_o;
      9'b000001000: n150_o <= 4'b0000;
      9'b000000100: n150_o <= n99_o;
      9'b000000010: n150_o <= 4'b0000;
      9'b000000001: n150_o <= 4'b0101;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n160_o <= 1'b1;
      9'b010000000: n160_o <= 1'b0;
      9'b001000000: n160_o <= 1'b0;
      9'b000100000: n160_o <= 1'b0;
      9'b000010000: n160_o <= 1'b0;
      9'b000001000: n160_o <= 1'b0;
      9'b000000100: n160_o <= n100_o;
      9'b000000010: n160_o <= 1'b0;
      9'b000000001: n160_o <= 1'b1;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n170_o <= 1'b0;
      9'b010000000: n170_o <= 1'b1;
      9'b001000000: n170_o <= 1'b0;
      9'b000100000: n170_o <= 1'b0;
      9'b000010000: n170_o <= 1'b0;
      9'b000001000: n170_o <= n115_o;
      9'b000000100: n170_o <= 1'b0;
      9'b000000010: n170_o <= 1'b0;
      9'b000000001: n170_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n181_o <= 1'b0;
      9'b010000000: n181_o <= 1'b1;
      9'b001000000: n181_o <= 1'b0;
      9'b000100000: n181_o <= 1'b0;
      9'b000010000: n181_o <= 1'b0;
      9'b000001000: n181_o <= 1'b0;
      9'b000000100: n181_o <= 1'b0;
      9'b000000010: n181_o <= 1'b0;
      9'b000000001: n181_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n191_o <= 1'b0;
      9'b010000000: n191_o <= 1'b0;
      9'b001000000: n191_o <= 1'b0;
      9'b000100000: n191_o <= 1'b1;
      9'b000010000: n191_o <= 1'b0;
      9'b000001000: n191_o <= 1'b0;
      9'b000000100: n191_o <= 1'b0;
      9'b000000010: n191_o <= n96_o;
      9'b000000001: n191_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n202_o <= 4'b0000;
      9'b010000000: n202_o <= 4'b0000;
      9'b001000000: n202_o <= 4'b0000;
      9'b000100000: n202_o <= 4'b1111;
      9'b000010000: n202_o <= 4'b0000;
      9'b000001000: n202_o <= 4'b0000;
      9'b000000100: n202_o <= 4'b0000;
      9'b000000010: n202_o <= 4'b0000;
      9'b000000001: n202_o <= 4'b0000;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n213_o <= 1'b0;
      9'b010000000: n213_o <= 1'b0;
      9'b001000000: n213_o <= 1'b0;
      9'b000100000: n213_o <= 1'b0;
      9'b000010000: n213_o <= 1'b0;
      9'b000001000: n213_o <= 1'b0;
      9'b000000100: n213_o <= 1'b0;
      9'b000000010: n213_o <= 1'b0;
      9'b000000001: n213_o <= 1'b1;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n224_o <= 1'b0;
      9'b010000000: n224_o <= 1'b0;
      9'b001000000: n224_o <= 1'b1;
      9'b000100000: n224_o <= 1'b0;
      9'b000010000: n224_o <= 1'b0;
      9'b000001000: n224_o <= 1'b0;
      9'b000000100: n224_o <= 1'b0;
      9'b000000010: n224_o <= 1'b0;
      9'b000000001: n224_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n235_o <= 1'b0;
      9'b010000000: n235_o <= 1'b0;
      9'b001000000: n235_o <= 1'b0;
      9'b000100000: n235_o <= 1'b0;
      9'b000010000: n235_o <= 1'b1;
      9'b000001000: n235_o <= 1'b0;
      9'b000000100: n235_o <= 1'b1;
      9'b000000010: n235_o <= 1'b0;
      9'b000000001: n235_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n245_o <= n137_o;
      9'b010000000: n245_o <= 1'b0;
      9'b001000000: n245_o <= 1'b0;
      9'b000100000: n245_o <= 1'b0;
      9'b000010000: n245_o <= 1'b0;
      9'b000001000: n245_o <= 1'b0;
      9'b000000100: n245_o <= 1'b0;
      9'b000000010: n245_o <= 1'b0;
      9'b000000001: n245_o <= 1'b1;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n256_o <= 1'b0;
      9'b010000000: n256_o <= 1'b0;
      9'b001000000: n256_o <= 1'b0;
      9'b000100000: n256_o <= 1'b0;
      9'b000010000: n256_o <= 1'b0;
      9'b000001000: n256_o <= 1'b0;
      9'b000000100: n256_o <= 1'b0;
      9'b000000010: n256_o <= 1'b1;
      9'b000000001: n256_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n267_o <= 1'b0;
      9'b010000000: n267_o <= 1'b0;
      9'b001000000: n267_o <= 1'b0;
      9'b000100000: n267_o <= 1'b0;
      9'b000010000: n267_o <= 1'b0;
      9'b000001000: n267_o <= 1'b0;
      9'b000000100: n267_o <= 1'b0;
      9'b000000010: n267_o <= 1'b1;
      9'b000000001: n267_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n277_o <= 1'b0;
      9'b010000000: n277_o <= 1'b0;
      9'b001000000: n277_o <= 1'b0;
      9'b000100000: n277_o <= 1'b0;
      9'b000010000: n277_o <= 1'b0;
      9'b000001000: n277_o <= 1'b0;
      9'b000000100: n277_o <= n101_o;
      9'b000000010: n277_o <= 1'b0;
      9'b000000001: n277_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n280_o <= n138_o;
      9'b010000000: n280_o <= n132_o;
      9'b001000000: n280_o <= n129_o;
      9'b000100000: n280_o <= n126_o;
      9'b000010000: n280_o <= n123_o;
      9'b000001000: n280_o <= n116_o;
      9'b000000100: n280_o <= n102_o;
      9'b000000010: n280_o <= n85_o;
      9'b000000001: n280_o <= 4'b0000;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n291_o <= 1'b0;
      9'b010000000: n291_o <= 1'b0;
      9'b001000000: n291_o <= 1'b1;
      9'b000100000: n291_o <= 1'b1;
      9'b000010000: n291_o <= 1'b0;
      9'b000001000: n291_o <= 1'b0;
      9'b000000100: n291_o <= 1'b0;
      9'b000000010: n291_o <= 1'b0;
      9'b000000001: n291_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n302_o <= 1'b0;
      9'b010000000: n302_o <= 1'b0;
      9'b001000000: n302_o <= 1'b0;
      9'b000100000: n302_o <= 1'b0;
      9'b000010000: n302_o <= 1'b1;
      9'b000001000: n302_o <= 1'b0;
      9'b000000100: n302_o <= 1'b1;
      9'b000000010: n302_o <= 1'b0;
      9'b000000001: n302_o <= 1'b0;
    endcase
  /* cpu_multicycle.vhdl:154:9  */
  always @*
    case (n141_o)
      9'b100000000: n312_o <= 2'b11;
      9'b010000000: n312_o <= 2'b00;
      9'b001000000: n312_o <= 2'b00;
      9'b000100000: n312_o <= 2'b00;
      9'b000010000: n312_o <= 2'b10;
      9'b000001000: n312_o <= 2'b00;
      9'b000000100: n312_o <= n106_o;
      9'b000000010: n312_o <= 2'b00;
      9'b000000001: n312_o <= 2'b01;
    endcase
  /* cpu_multicycle.vhdl:369:13  */
  assign n319_o = curr_state == 4'b0000;
  /* cpu_multicycle.vhdl:372:31  */
  assign n320_o = instruction[27:26];
  /* cpu_multicycle.vhdl:372:46  */
  assign n322_o = n320_o == 2'b00;
  /* cpu_multicycle.vhdl:374:34  */
  assign n323_o = instruction[27:26];
  /* cpu_multicycle.vhdl:374:49  */
  assign n325_o = n323_o == 2'b01;
  /* cpu_multicycle.vhdl:374:17  */
  assign n328_o = n325_o ? 4'b0100 : 4'b1000;
  /* cpu_multicycle.vhdl:372:17  */
  assign n330_o = n322_o ? 4'b0010 : n328_o;
  /* cpu_multicycle.vhdl:371:13  */
  assign n332_o = curr_state == 4'b0001;
  /* cpu_multicycle.vhdl:379:13  */
  assign n334_o = curr_state == 4'b0010;
  /* cpu_multicycle.vhdl:381:13  */
  assign n336_o = curr_state == 4'b0011;
  /* cpu_multicycle.vhdl:384:31  */
  assign n337_o = instruction[20];
  /* cpu_multicycle.vhdl:384:17  */
  assign n340_o = n337_o ? 4'b0110 : 4'b0101;
  /* cpu_multicycle.vhdl:383:13  */
  assign n342_o = curr_state == 4'b0100;
  /* cpu_multicycle.vhdl:389:13  */
  assign n344_o = curr_state == 4'b0101;
  /* cpu_multicycle.vhdl:391:13  */
  assign n346_o = curr_state == 4'b0110;
  /* cpu_multicycle.vhdl:393:13  */
  assign n348_o = curr_state == 4'b0111;
  /* cpu_multicycle.vhdl:395:13  */
  assign n350_o = curr_state == 4'b1000;
  assign n351_o = {n350_o, n348_o, n346_o, n344_o, n342_o, n336_o, n334_o, n332_o, n319_o};
  /* cpu_multicycle.vhdl:368:13  */
  always @*
    case (n351_o)
      9'b100000000: n360_o <= 4'b0000;
      9'b010000000: n360_o <= 4'b0000;
      9'b001000000: n360_o <= 4'b0111;
      9'b000100000: n360_o <= 4'b0000;
      9'b000010000: n360_o <= n340_o;
      9'b000001000: n360_o <= 4'b0000;
      9'b000000100: n360_o <= 4'b0011;
      9'b000000010: n360_o <= n330_o;
      9'b000000001: n360_o <= 4'b0001;
    endcase
  /* cpu_multicycle.vhdl:367:9  */
  always @(posedge clock)
    n363_q <= n360_o;
  initial
    n363_q <= 4'b0000;
endmodule

module cpu_multicycle_datapath
  (input  clock,
   input  [3:0] ctrl_alu_opcode,
   input  ctrl_alu_c_in,
   input  ctrl_regfile_w_en,
   input  ctrl_regfile_w_data,
   input  ctrl_regfile_r_addr_2,
   input  [3:0] ctrl_mem_w_en,
   input  ctrl_ir_write,
   input  ctrl_dr_write,
   input  ctrl_res_write,
   input  ctrl_pc_write,
   input  ctrl_a_write,
   input  ctrl_b_write,
   input  ctrl_flag_set,
   input  [3:0] ctrl_predict_cond,
   input  ctrl_mem_ad_mux,
   input  ctrl_reg_wd_mux,
   input  ctrl_alu_op_mux,
   input  [1:0] ctrl_alu_shift_op_mux,
   output [31:0] instr_copy,
   output prediction,
   output [3:0] flags);
  reg [31:0] pc_in;
  reg [31:0] pc_out;
  wire [31:0] pc_shift_out;
  wire [31:0] mem_ad;
  wire [31:0] mem_wd;
  wire [31:0] mem_output;
  wire [31:0] dr_output;
  wire [3:0] regfile_rd_addr_2;
  wire [31:0] regfile_data_in;
  wire [31:0] regfile_out_1;
  wire [31:0] regfile_out_2;
  wire [31:0] a_out;
  wire [31:0] alu_shift_op;
  wire [31:0] alu_op;
  reg [31:0] alu_ans;
  wire [3:0] alu_flags;
  wire [31:0] imm_op_ext;
  wire [31:0] branch_ext;
  wire [3:0] flag_reg_out;
  wire [31:0] res_out;
  wire [31:0] instruction;
  wire [29:0] n27_o;
  wire [31:0] n29_o;
  wire [31:0] pc_data_out;
  wire [31:0] mem_address_mux_output;
  wire [31:0] mem_output;
  wire [31:0] ir_data_out;
  wire [31:0] dr_data_out;
  wire [3:0] rd_addr_2_mux_output;
  wire [3:0] n35_o;
  wire [3:0] n36_o;
  wire [31:0] regfile_data_in_mux_output;
  wire [31:0] regfile_out_1;
  wire [31:0] regfile_out_2;
  wire [3:0] n39_o;
  wire [3:0] n40_o;
  wire [31:0] a_data_out;
  wire [31:0] b_data_out;
  wire [29:0] n45_o;
  wire [31:0] n47_o;
  wire [31:0] op_mux_output;
  wire [31:0] imm_extender_data_out;
  wire [11:0] n49_o;
  wire [31:0] branch_extender_data_out;
  wire [23:0] n51_o;
  wire [31:0] shift_op_mux_output;
  wire [127:0] n54_o;
  wire [31:0] alu_ans;
  wire [3:0] alu_flags;
  wire [3:0] flag_reg_data_out;
  wire predicator_p;
  wire [31:0] result_data_out;
  assign instr_copy = instruction;
  assign prediction = predicator_p;
  assign flags = flag_reg_out;
  /* cpu_multicycle.vhdl:37:12  */
  always @*
    pc_in = n29_o; // (isignal)
  initial
    pc_in <= 32'b00000000000000000000000000000000;
  /* cpu_multicycle.vhdl:38:12  */
  always @*
    pc_out = pc_data_out; // (isignal)
  initial
    pc_out <= 32'b00000000000000000000000000000000;
  /* cpu_multicycle.vhdl:39:12  */
  assign pc_shift_out = n47_o; // (signal)
  /* cpu_multicycle.vhdl:41:12  */
  assign mem_ad = mem_address_mux_output; // (signal)
  /* cpu_multicycle.vhdl:42:12  */
  assign mem_wd = b_data_out; // (signal)
  /* cpu_multicycle.vhdl:43:12  */
  assign mem_output = mem_output; // (signal)
  /* cpu_multicycle.vhdl:45:12  */
  assign dr_output = dr_data_out; // (signal)
  /* cpu_multicycle.vhdl:48:12  */
  assign regfile_rd_addr_2 = rd_addr_2_mux_output; // (signal)
  /* cpu_multicycle.vhdl:49:12  */
  assign regfile_data_in = regfile_data_in_mux_output; // (signal)
  /* cpu_multicycle.vhdl:50:12  */
  assign regfile_out_1 = regfile_out_1; // (signal)
  /* cpu_multicycle.vhdl:51:12  */
  assign regfile_out_2 = regfile_out_2; // (signal)
  /* cpu_multicycle.vhdl:53:12  */
  assign a_out = a_data_out; // (signal)
  /* cpu_multicycle.vhdl:55:12  */
  assign alu_shift_op = shift_op_mux_output; // (signal)
  /* cpu_multicycle.vhdl:56:12  */
  assign alu_op = op_mux_output; // (signal)
  /* cpu_multicycle.vhdl:57:12  */
  always @*
    alu_ans = alu_ans; // (isignal)
  initial
    alu_ans <= 32'b00000000000000000000000000000000;
  /* cpu_multicycle.vhdl:58:12  */
  assign alu_flags = alu_flags; // (signal)
  /* cpu_multicycle.vhdl:61:12  */
  assign imm_op_ext = imm_extender_data_out; // (signal)
  /* cpu_multicycle.vhdl:62:12  */
  assign branch_ext = branch_extender_data_out; // (signal)
  /* cpu_multicycle.vhdl:64:12  */
  assign flag_reg_out = flag_reg_data_out; // (signal)
  /* cpu_multicycle.vhdl:65:12  */
  assign res_out = result_data_out; // (signal)
  /* cpu_multicycle.vhdl:67:12  */
  assign instruction = ir_data_out; // (signal)
  /* cpu_multicycle.vhdl:70:21  */
  assign n27_o = alu_ans[29:0];
  /* cpu_multicycle.vhdl:70:34  */
  assign n29_o = {n27_o, 2'b00};
  /* cpu_multicycle.vhdl:71:5  */
  reg_32 pc (
    .data_in(pc_in),
    .clock(clock),
    .w_en(ctrl_pc_write),
    .data_out(pc_data_out));
  /* cpu_multicycle.vhdl:73:5  */
  mux_2_32 mem_address_mux (
    .in_0(pc_out),
    .in_1(res_out),
    .sel(ctrl_mem_ad_mux),
    .out(mem_address_mux_output));
  /* cpu_multicycle.vhdl:74:5  */
  memory mem (
    .clock(clock),
    .addr(mem_ad),
    .write_data(mem_wd),
    .w_en(ctrl_mem_w_en),
    .out(mem_output));
  /* cpu_multicycle.vhdl:76:5  */
  reg_32 ir (
    .data_in(mem_output),
    .clock(clock),
    .w_en(ctrl_ir_write),
    .data_out(ir_data_out));
  /* cpu_multicycle.vhdl:77:5  */
  reg_32 dr (
    .data_in(mem_output),
    .clock(clock),
    .w_en(ctrl_dr_write),
    .data_out(dr_data_out));
  /* cpu_multicycle.vhdl:79:5  */
  mux_2_4 rd_addr_2_mux (
    .in_0(n35_o),
    .in_1(n36_o),
    .sel(ctrl_regfile_r_addr_2),
    .out(rd_addr_2_mux_output));
  /* cpu_multicycle.vhdl:79:75  */
  assign n35_o = instruction[3:0];
  /* cpu_multicycle.vhdl:80:24  */
  assign n36_o = instruction[15:12];
  /* cpu_multicycle.vhdl:81:5  */
  mux_2_32 regfile_data_in_mux (
    .in_0(res_out),
    .in_1(dr_output),
    .sel(ctrl_regfile_w_data),
    .out(regfile_data_in_mux_output));
  /* cpu_multicycle.vhdl:82:5  */
  regfile regfile (
    .r_addr_1(n39_o),
    .r_addr_2(regfile_rd_addr_2),
    .w_addr(n40_o),
    .data_in(regfile_data_in),
    .w_en(ctrl_regfile_w_en),
    .clk(clock),
    .out_1(regfile_out_1),
    .out_2(regfile_out_2));
  /* cpu_multicycle.vhdl:82:55  */
  assign n39_o = instruction[19:16];
  /* cpu_multicycle.vhdl:83:43  */
  assign n40_o = instruction[15:12];
  /* cpu_multicycle.vhdl:86:5  */
  reg_32 a (
    .data_in(regfile_out_1),
    .clock(clock),
    .w_en(ctrl_a_write),
    .data_out(a_data_out));
  /* cpu_multicycle.vhdl:87:5  */
  reg_32 b (
    .data_in(regfile_out_2),
    .clock(clock),
    .w_en(ctrl_b_write),
    .data_out(b_data_out));
  /* cpu_multicycle.vhdl:89:32  */
  assign n45_o = pc_out[31:2];
  /* cpu_multicycle.vhdl:89:25  */
  assign n47_o = {2'b00, n45_o};
  /* cpu_multicycle.vhdl:90:5  */
  mux_2_32 op_mux (
    .in_0(pc_shift_out),
    .in_1(a_out),
    .sel(ctrl_alu_op_mux),
    .out(op_mux_output));
  /* cpu_multicycle.vhdl:91:5  */
  sign_extender_12_32 imm_extender (
    .data_in(n49_o),
    .data_out(imm_extender_data_out));
  /* cpu_multicycle.vhdl:91:87  */
  assign n49_o = instruction[11:0];
  /* cpu_multicycle.vhdl:92:5  */
  sign_extender_24_32 branch_extender (
    .data_in(n51_o),
    .data_out(branch_extender_data_out));
  /* cpu_multicycle.vhdl:92:90  */
  assign n51_o = instruction[23:0];
  /* cpu_multicycle.vhdl:95:5  */
  mux_4_2 shift_op_mux (
    .in(n54_o),
    .sel(ctrl_alu_shift_op_mux),
    .out(shift_op_mux_output));
  assign n54_o = {branch_ext, imm_op_ext, 32'b00000000000000000000000000000000, mem_wd};
  /* cpu_multicycle.vhdl:98:5  */
  alu alu (
    .shift_op(alu_shift_op),
    .op(alu_op),
    .carry_in(ctrl_alu_c_in),
    .opcode(ctrl_alu_opcode),
    .ans(alu_ans),
    .flags(alu_flags));
  /* cpu_multicycle.vhdl:100:5  */
  reg_4 flag_reg (
    .data_in(alu_flags),
    .clock(clock),
    .w_en(ctrl_flag_set),
    .data_out(flag_reg_data_out));
  /* cpu_multicycle.vhdl:101:5  */
  predicator predicator (
    .condition(ctrl_predict_cond),
    .flags(flag_reg_out),
    .p(predicator_p));
  /* cpu_multicycle.vhdl:103:5  */
  reg_32 result (
    .data_in(alu_ans),
    .clock(clock),
    .w_en(ctrl_res_write),
    .data_out(result_data_out));
endmodule

module cpu
  (input  clock);
  wire [3:0] ctrl_alu_opcode;
  wire ctrl_alu_c_in;
  wire ctrl_regfile_w_en;
  wire ctrl_regfile_w_data;
  wire ctrl_regfile_r_addr_2;
  wire [3:0] ctrl_mem_w_en;
  wire ctrl_ir_write;
  wire ctrl_dr_write;
  wire ctrl_res_write;
  wire ctrl_pc_write;
  wire ctrl_a_write;
  wire ctrl_b_write;
  wire ctrl_flag_set;
  wire [3:0] ctrl_predict_cond;
  wire ctrl_mem_ad_mux;
  wire ctrl_reg_wd_mux;
  wire ctrl_alu_op_mux;
  wire [1:0] ctrl_alu_shift_op_mux;
  wire [31:0] instr_copy;
  wire prediction;
  wire [3:0] flags;
  wire [31:0] cpu_multicycle_datapath_instr_copy;
  wire cpu_multicycle_datapath_prediction;
  wire [3:0] cpu_multicycle_datapath_flags;
  wire [3:0] cpu_multicycle_controller_ctrl_alu_opcode;
  wire cpu_multicycle_controller_ctrl_alu_c_in;
  wire cpu_multicycle_controller_ctrl_regfile_w_en;
  wire cpu_multicycle_controller_ctrl_regfile_w_data;
  wire cpu_multicycle_controller_ctrl_regfile_r_addr_2;
  wire [3:0] cpu_multicycle_controller_ctrl_mem_w_en;
  wire cpu_multicycle_controller_ctrl_ir_write;
  wire cpu_multicycle_controller_ctrl_dr_write;
  wire cpu_multicycle_controller_ctrl_res_write;
  wire cpu_multicycle_controller_ctrl_pc_write;
  wire cpu_multicycle_controller_ctrl_a_write;
  wire cpu_multicycle_controller_ctrl_b_write;
  wire cpu_multicycle_controller_ctrl_flag_set;
  wire [3:0] cpu_multicycle_controller_ctrl_predict_cond;
  wire cpu_multicycle_controller_ctrl_mem_ad_mux;
  wire cpu_multicycle_controller_ctrl_reg_wd_mux;
  wire cpu_multicycle_controller_ctrl_alu_op_mux;
  wire [1:0] cpu_multicycle_controller_ctrl_alu_shift_op_mux;
  /* cpu.vhdl:110:12  */
  assign ctrl_alu_opcode = cpu_multicycle_controller_ctrl_alu_opcode; // (signal)
  /* cpu.vhdl:111:12  */
  assign ctrl_alu_c_in = cpu_multicycle_controller_ctrl_alu_c_in; // (signal)
  /* cpu.vhdl:112:12  */
  assign ctrl_regfile_w_en = cpu_multicycle_controller_ctrl_regfile_w_en; // (signal)
  /* cpu.vhdl:113:12  */
  assign ctrl_regfile_w_data = cpu_multicycle_controller_ctrl_regfile_w_data; // (signal)
  /* cpu.vhdl:114:12  */
  assign ctrl_regfile_r_addr_2 = cpu_multicycle_controller_ctrl_regfile_r_addr_2; // (signal)
  /* cpu.vhdl:115:12  */
  assign ctrl_mem_w_en = cpu_multicycle_controller_ctrl_mem_w_en; // (signal)
  /* cpu.vhdl:116:12  */
  assign ctrl_ir_write = cpu_multicycle_controller_ctrl_ir_write; // (signal)
  /* cpu.vhdl:117:12  */
  assign ctrl_dr_write = cpu_multicycle_controller_ctrl_dr_write; // (signal)
  /* cpu.vhdl:118:12  */
  assign ctrl_res_write = cpu_multicycle_controller_ctrl_res_write; // (signal)
  /* cpu.vhdl:119:12  */
  assign ctrl_pc_write = cpu_multicycle_controller_ctrl_pc_write; // (signal)
  /* cpu.vhdl:120:12  */
  assign ctrl_a_write = cpu_multicycle_controller_ctrl_a_write; // (signal)
  /* cpu.vhdl:121:12  */
  assign ctrl_b_write = cpu_multicycle_controller_ctrl_b_write; // (signal)
  /* cpu.vhdl:122:12  */
  assign ctrl_flag_set = cpu_multicycle_controller_ctrl_flag_set; // (signal)
  /* cpu.vhdl:123:12  */
  assign ctrl_predict_cond = cpu_multicycle_controller_ctrl_predict_cond; // (signal)
  /* cpu.vhdl:124:12  */
  assign ctrl_mem_ad_mux = cpu_multicycle_controller_ctrl_mem_ad_mux; // (signal)
  /* cpu.vhdl:125:12  */
  assign ctrl_reg_wd_mux = cpu_multicycle_controller_ctrl_reg_wd_mux; // (signal)
  /* cpu.vhdl:126:12  */
  assign ctrl_alu_op_mux = cpu_multicycle_controller_ctrl_alu_op_mux; // (signal)
  /* cpu.vhdl:127:12  */
  assign ctrl_alu_shift_op_mux = cpu_multicycle_controller_ctrl_alu_shift_op_mux; // (signal)
  /* cpu.vhdl:129:12  */
  assign instr_copy = cpu_multicycle_datapath_instr_copy; // (signal)
  /* cpu.vhdl:130:12  */
  assign prediction = cpu_multicycle_datapath_prediction; // (signal)
  /* cpu.vhdl:131:12  */
  assign flags = cpu_multicycle_datapath_flags; // (signal)
  /* cpu.vhdl:134:5  */
  cpu_multicycle_datapath cpu_multicycle_datapath (
    .clock(clock),
    .ctrl_alu_opcode(ctrl_alu_opcode),
    .ctrl_alu_c_in(ctrl_alu_c_in),
    .ctrl_regfile_w_en(ctrl_regfile_w_en),
    .ctrl_regfile_w_data(ctrl_regfile_w_data),
    .ctrl_regfile_r_addr_2(ctrl_regfile_r_addr_2),
    .ctrl_mem_w_en(ctrl_mem_w_en),
    .ctrl_ir_write(ctrl_ir_write),
    .ctrl_dr_write(ctrl_dr_write),
    .ctrl_res_write(ctrl_res_write),
    .ctrl_pc_write(ctrl_pc_write),
    .ctrl_a_write(ctrl_a_write),
    .ctrl_b_write(ctrl_b_write),
    .ctrl_flag_set(ctrl_flag_set),
    .ctrl_predict_cond(ctrl_predict_cond),
    .ctrl_mem_ad_mux(ctrl_mem_ad_mux),
    .ctrl_reg_wd_mux(ctrl_reg_wd_mux),
    .ctrl_alu_op_mux(ctrl_alu_op_mux),
    .ctrl_alu_shift_op_mux(ctrl_alu_shift_op_mux),
    .instr_copy(cpu_multicycle_datapath_instr_copy),
    .prediction(cpu_multicycle_datapath_prediction),
    .flags(cpu_multicycle_datapath_flags));
  /* cpu.vhdl:160:5  */
  cpu_multicycle_controller cpu_multicycle_controller (
    .clock(clock),
    .instruction(instr_copy),
    .prediction(prediction),
    .flags(flags),
    .ctrl_alu_opcode(cpu_multicycle_controller_ctrl_alu_opcode),
    .ctrl_alu_c_in(cpu_multicycle_controller_ctrl_alu_c_in),
    .ctrl_regfile_w_en(cpu_multicycle_controller_ctrl_regfile_w_en),
    .ctrl_regfile_w_data(cpu_multicycle_controller_ctrl_regfile_w_data),
    .ctrl_regfile_r_addr_2(cpu_multicycle_controller_ctrl_regfile_r_addr_2),
    .ctrl_mem_w_en(cpu_multicycle_controller_ctrl_mem_w_en),
    .ctrl_ir_write(cpu_multicycle_controller_ctrl_ir_write),
    .ctrl_dr_write(cpu_multicycle_controller_ctrl_dr_write),
    .ctrl_res_write(cpu_multicycle_controller_ctrl_res_write),
    .ctrl_pc_write(cpu_multicycle_controller_ctrl_pc_write),
    .ctrl_a_write(cpu_multicycle_controller_ctrl_a_write),
    .ctrl_b_write(cpu_multicycle_controller_ctrl_b_write),
    .ctrl_flag_set(cpu_multicycle_controller_ctrl_flag_set),
    .ctrl_predict_cond(cpu_multicycle_controller_ctrl_predict_cond),
    .ctrl_mem_ad_mux(cpu_multicycle_controller_ctrl_mem_ad_mux),
    .ctrl_reg_wd_mux(cpu_multicycle_controller_ctrl_reg_wd_mux),
    .ctrl_alu_op_mux(cpu_multicycle_controller_ctrl_alu_op_mux),
    .ctrl_alu_shift_op_mux(cpu_multicycle_controller_ctrl_alu_shift_op_mux));
endmodule

