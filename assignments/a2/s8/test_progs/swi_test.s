@ swi_test.s
@ check for swi interrupts

    .text
    mov r2, #0
ol: 
il: swi 0x00
    mov r1, r0, LSR #8
    cmp r1, #1
    bne il
    add r2, #1
    b ol
    .end