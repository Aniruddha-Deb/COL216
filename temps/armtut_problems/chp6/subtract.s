    .equ SWI_Exit, 0x11

    .text
    ldr r0, =VALUE1
    ldr r0, [r0]
    ldr r1, =VALUE2
    ldr r1, [r1]
    sub r0, r1, r0
    swi SWI_Exit

    .data
VALUE1: .int 12343977
VALUE2: .int 56782182
    .end
