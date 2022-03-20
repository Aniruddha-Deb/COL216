@ idx_test.s
@ tests preindexing, postindexing, and writeback
@ the following types of data transfer operators exist in ARM
@ 
@ 1. [<Rn>, #+/-<offset_12>]
@ 2. [<Rn>, +/-<Rm>]
@ 3. [<Rn>, +/-<Rm>, <shift> #<shift_imm>]
@ 4. [<Rn>, #+/-<offset_12>]!
@ 5. [<Rn>, +/-<Rm>]!
@ 6. [<Rn>, +/-<Rm>, <shift> #<shift_imm>]!
@ 7. [<Rn>], #+/-<offset_12>
@ 8. [<Rn>], +/-<Rm>
@ 9. [<Rn>], +/-<Rm>, <shift> #<shift_imm>
@ 1-3 were tested previously, here we test 4-9

    .text

    mov r0, #96 @ byte address 24
    mov r1, #0xAD
    orr r1, #0xDE00
    orr r1, #0xFE0000
    orr r1, #0xCA000000
    mov r2, #4

    str r1, [r0, #4]! @ store at 25, r0 = 100
    str r1, [r0, r2]! @ store at 26, r0 = 104
    str r1, [r0, -r2, lsl #1]! @ store at 24, r0 = 96 again

    add r0, #12
    str r1, [r0], #4 @ store at 27, r0 = 108
    str r1, [r0], r2, lsl #1 @ store at 28, r0 = 116

    .end
