.include "swi_instr.s"

    .text
    ldr r0, =VALUE
    ldr r2, =RESULT
    ldr r1, [r0]
    str r1, [r2]
    ldr r1, [r0, #4]
    str r1, [r2, #4] 
    swi SWI_Leg_Exit

    .data
VALUE:  .quad 0x3E2042A121F260A0
RESULT: .space 8
    .end
