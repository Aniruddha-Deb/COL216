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
	@ghdl -a alu.vhdl
	@ghdl -a cpu_multicycle.vhdl
	@ghdl -a cpu.vhdl

test:
	@./test_progs/gentest test_progs/dt_test.s dt_tb.vhdl
	@ghdl -a dt_tb.vhdl
	@ghdl -r cpu_tb --stop-time=300ns --wave=waves/dt_tb.ghw

clean:
	rm work-obj93.cf

%.vhdl:
	ghdl -a $@ 