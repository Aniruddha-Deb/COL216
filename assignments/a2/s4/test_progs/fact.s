@ fact.s
@ factorial calculation

    .text
    mov r0, #1 @ factorial stored here
    mov r1, #0 @ multiplicand
    mov r2, #0 @ multiplication counter
    mov r3, #6 @ factorial num to be found
    mov r4, #1 @ factorial counter
fact:
    cmp r3, r4
    beq end
    mov r1, r0
    mov r2, r4
    mult:
        cmp r2, #1
        addgt r0, r1
        subgt r2, #1
        bgt mult
    add r4, #1
    b fact    
end:

    .end