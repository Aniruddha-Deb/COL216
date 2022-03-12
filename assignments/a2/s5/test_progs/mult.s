@ mult.s
@ multiplication via addition

    .text
    mov r0, #5
    mov r1, #6
    mov r2, #0
mult:
l:  cmp r1, #1
    addgt r2, r0
    subgt r1, #1
    bgt l

    .end