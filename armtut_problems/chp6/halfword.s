    .equ SWI_Exit, 0x11

    .text
    ldr r4, =LIST
    ldrb r0, [r4, #0]
    and r0, r0, #0x0F
    ldrb r1, [r4, #1]
    and r1, r1, #0x0F
    ldrb r2, [r4, #2]
    and r2, r2, #0x0F
    ldrb r3, [r4, #3]
    and r3, r3, #0x0F
    add r3, r3, r2, lsl #4
    add r3, r3, r1, lsl #8
    add r3, r3, r0, lsl #12
    swi SWI_Exit

    .data
LIST: .byte 0x5C, 0x62, 0x86, 0xA9
