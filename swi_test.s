.include "../Programming/COL216/swi_instr.s"

    .text
    mov r0, #STDOUT
    ldr r1, =HWL
    swi SWI_Leg_PrStr
    ldr r1, =EAN
    swi SWI_Leg_PrStr
    mov r0, #STDIN
    swi SWI_Leg_RdInt

    mov r2, r0
    mov r0, #STDOUT
    ldr r1, =NUE
    swi SWI_Leg_PrStr
    mov r1, r2
    swi SWI_Leg_PrInt
    ldr r1, =NL
    swi SWI_Leg_PrStr

    @ TODO find out how to print to stdout from Angel SWI
    @ mov r0, #SWI_Ang_Write
    @ ldr r1, =APP
    @ swi SWI_Ang_Write

    swi SWI_Leg_Exit

    .data
HWL: .asciz "Hello World, from Legacy!\n"
EAN: .asciz "Enter a number: "
NUE: .asciz "The number you entered was "
NL:  .asciz "\n"
HWA: .asciz "Hello World, from Angel!\n"
    .end
