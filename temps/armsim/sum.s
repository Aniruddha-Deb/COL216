    .equ SWI_Exit, 0x11
    .text
    mov r1, #0       @ initialize r1 to 0
    ldr r3, =AA      @ load memory address at AA into r3
    add r6, r3, #400 @ add 400 to the value of r3 and store in r6 (last num)
L:  ldr r5, [r3, #0] @ load the value stored at address pointed to by r3 into r5
    add r1, r1, r5   @ add value in r5 to r1
    add r3, r3, #4   @ shift r3 forward by a word
    cmp r3, r6       @ compare r3 to r6
    blt L            @ branch back to L if r3 is less than r6
    swi SWI_Exit     @ exit
    .data
AA: .space 400
    .end
