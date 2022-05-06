    .equ SWI_Exit, 0x11

    .text
    ldr r0, =VALUE
    ldr r0, [r0]
    mov r0, r0, asr #3
    swi SWI_Exit

    .data
VALUE: .word 0x415D7834
    .end
