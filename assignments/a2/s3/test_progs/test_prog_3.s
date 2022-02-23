    .text
    mov r0, #5
    mov r1, #10
    mov r2, #15
    str r1, [r0]
    str r2, [r0, #-4] @ negative indexing test
    .end

@ I can't copy code from ARMSim via ctrl-c ctrl-v. Magnificent. Have to copy
@ it over manually
@ 
@ 0 => x"E3A00005",
@ 1 => x"E3A0100A",
@ 2 => x"E3A0200F",
@ 3 => x"E5801000",
@ 4 => x"E5002004",
@ others => x"00000000"
