@ ret_test.s
@
@ tests if the return instruction is actually compiled by arm

    .text
main:
    mov r0, #5
    bl fun
    mov r2, #3

fun:
    mov r1, #2
    ret

    .end