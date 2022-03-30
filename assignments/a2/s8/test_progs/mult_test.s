@ mult_test.s
@ testing multiplier operations
@
@
    .text
    mov r0, #3
    mov r1, #2
    mul r2, r1, r0
    mla r3, r2, r1, r0 @ r3 = r2 * r1 + r0

    mov r0, #0xF0000000
    mov r1, #0x00000004
    umull r3, r2, r1, r0
    umlal r3, r2, r1, r0
    mov r0, #-2
    smull r3, r2, r1, r0 @ -8
    smlal r3, r2, r1, r0 @ -16

    .end
