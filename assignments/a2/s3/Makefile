VHDLC := ghdl
SRC := $(shell find . -name '*.vhdl')

all: 
	@ghdl -a cpu_multicycle.vhdl
	@ghdl -a cpu.vhdl
	@ghdl -a cpu_tb.vhdl
	@ghdl -r cpu_tb --stop-time=100ns --wave=cpu_prog_4.ghw

%.vhdl:
	ghdl -a $@ 