VHDLC := ghdl
SRC := $(shell find . -name '*.vhdl')

all: 
	@ghdl -a mytypes.vhdl
	@ghdl -a commons.vhdl
	@ghdl -a regfile.vhdl
	@ghdl -a mem.vhdl
	@ghdl -a predicator.vhdl
	@ghdl -a alu.vhdl
	@ghdl -a cpu_multicycle.vhdl
	@ghdl -a cpu.vhdl
	@ghdl -a fact_tb.vhdl
	@ghdl -r cpu_tb --stop-time=1000ns --wave=waves/test_fact.ghw

clean:
	rm work-obj93.cf

%.vhdl:
	ghdl -a $@ 