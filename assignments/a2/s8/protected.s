.text
mov lr, #0x100 @0
@ rte @4
.space 4
b swi_isr @8
.space 4 @reg loc

swi_isr: 
mov r0, #0x0C
ldr r0, [r0]
@ rte
.end