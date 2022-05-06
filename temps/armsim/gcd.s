    .equ SWI_EXIT, 0x11
    .equ N, 20
    .text

    ldr r4, =AA
    ldr r2, [r4, #0]
    add r6, r4, #20

LOOP:
    mov r0, r2
    add r4, #4
    ldr r1, [r4, #0]
    bl GCD
    mov r2, r0
    cmp r4, r6
    blt LOOP
    swi SWI_EXIT

GCD:
    cmp r1, #0
    bxeq lr
    b MOD

MOD:
    cmp r0, r1
    blt SWP
    sub r0, r0, r1
    b MOD

SWP:
    mov r3, r1
    mov r1, r0
    mov r0, r3
    b GCD

    .data
AA: .int 18, 36, 9, 3, 27
    .end
