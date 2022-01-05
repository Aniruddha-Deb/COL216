# this file uses the MIPS32 ISA
# compile/run with spim
.text
main:
	addi $t0, $zero, 100
	addi $t1, $zero, 15
	add  $s0, $t0, $t1
