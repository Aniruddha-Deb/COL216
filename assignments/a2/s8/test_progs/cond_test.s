@ cond_test.s
@
@ checking conditional execution of ARM programs via flags

    .text
    mov r0, #5
    cmp r0, #5
    @ flags should be set now
    mvneq r1, #4
    mvnne r2, #10
    adds r0, r1
    .end