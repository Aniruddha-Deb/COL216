@ as given in the assignment

    .text
    mov r0, #0
    mov r1, #0
Loop: add r0, r0, r1
    add r1, r1, #1
    cmp r1, #5
    bne Loop
    .end

@
@ 0 => X"E3A00000",
@ 1 => X"E3A01000",
@ 2 => X"E0800001",
@ 3 => X"E2811001",
@ 4 => X"E3510005",
@ 5 => X"1AFFFFFB",
@ others => X"00000000"
@ 