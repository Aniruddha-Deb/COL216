    .text
    @ testing all kinds of branches
    mov r0, #1
    mov r1, #1
    cmp r0, r1
    beq equal
back:
    cmp r0, r1
    bne end
equal: 
    sub r1, #1
    b back
end:
    sub r0, #1
    cmp r1, r0
    .end

@
@ E3A00001
@ E3A01001
@ E1500001
@ 0A000001
@ E1500001
@ 1A000001
@ E2411001
@ EAFFFFFB
@ E2400001
@ E1510000
