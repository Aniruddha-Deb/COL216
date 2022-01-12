    .equ SWI_Exit, 0x11
    .equ SWI_PrStr, 0x69
    .equ SWI_PrInt, 0x6b
    .equ Stdout, 1
    
    .text
    mov r0,#Stdout
    ldr r1, =HW
    swi SWI_PrStr
    mov r1, #57
    swi SWI_PrInt
    swi SWI_Exit

    .data
HW: .asciz "Hello, World!"
    .end

