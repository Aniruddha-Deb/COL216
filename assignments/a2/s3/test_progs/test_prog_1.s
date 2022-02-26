@ as given in the assignment
    .text
    mov r0, #40
    mov r1, #5
    str r1, [r0]
    add r1, r1, #2
    str r1, [r0, #4]
    ldr r2, [r0]
    ldr r3, [r0, #4]
    sub r4, r3, r2
    .end

@
@ 0 => X"E3A00028",
@ 1 => X"E3A01005",
@ 2 => X"E5801000",
@ 3 => X"E2811002",
@ 4 => X"E5801004",
@ 5 => X"E5902000",
@ 6 => X"E5903004",
@ 7 => X"E0434002",
@ others => X"00000000"
@