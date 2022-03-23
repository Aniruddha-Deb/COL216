VHDLC := ghdl
SRC := $(shell find . -name '*.vhdl')

all: 
	@ghdl -a mytypes.vhdl
	@ghdl -a commons.vhdl
	@ghdl -a regfile.vhdl
	@ghdl -a mem.vhdl
	@ghdl -a predicator.vhdl
	@ghdl -a shifter.vhdl
	@ghdl -a pmconnect.vhdl
	@ghdl -a instr_decoder.vhdl
	@ghdl -a alu.vhdl
	@ghdl -a cpu_datapath.vhdl
	@ghdl -a cpu_controller.vhdl
	@ghdl -a cpu.vhdl

test:
	#@./test_progs/gentest test_progs/test_prog_2.s basic_tb_2.vhdl
	@ghdl -a basic_tb.vhdl
	@ghdl -r cpu_tb --stop-time=300ns --wave=waves/basic_tb_2.ghw

clean:
	rm work-obj93.cf

%.vhdl:
	ghdl -a $@ 