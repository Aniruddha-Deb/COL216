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
	@ghdl -a multiplier.vhdl
	@ghdl -a alu.vhdl
	@ghdl -a cpu_datapath.vhdl
	@ghdl -a cpu_controller.vhdl
	@ghdl -a cpu.vhdl

asm:
	@./test_progs/gentest test_progs/swi_test.s swi_tb.vhdl

test:
	@ghdl -a swi_tb.vhdl
	@ghdl -r cpu_tb --stop-time=120ns --wave=waves/swi_tb.ghw

clean:
	rm work-obj93.cf

%.vhdl:
	ghdl -a $@ 