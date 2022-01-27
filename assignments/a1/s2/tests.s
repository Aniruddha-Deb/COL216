    .equ SWI_Exit, 0x11
    .equ SWI_PrChr, 0x00
    .equ SWI_PrStr, 0x69
    .equ SWI_RdStr, 0x6a
    .equ SWI_RdInt, 0x6c

    .text
main:
    mov r0, #1
    ldr r1, =str1_prompt
    swi SWI_PrStr
    mov r0, #0
    ldr r1, =str1
    mov r2, #48
    swi SWI_RdStr
    mov r0, #1
    ldr r1, =str2_prompt
    swi SWI_PrStr
    mov r0, #0
    ldr r1, =str2
    mov r2, #48
    swi SWI_RdStr
    mov r0, #1
    ldr r1, =case_prompt
    swi SWI_PrStr
    mov r0, #0
    swi SWI_RdInt
    mov r2, r0
    ldr r0, =str1
    ldr r1, =str2
    bl strcmp

    cmp r0, #-1
    beq print_lt
    cmp r0, #0
    beq print_eq
    b print_gt

print_lt:
    mov r0, #0
    ldr r1, =str_cmp_lt
    swi SWI_PrStr
    swi SWI_Exit

print_eq:
    mov r0, #0
    ldr r1, =str_cmp_eq
    swi SWI_PrStr
    swi SWI_Exit

print_gt:
    mov r0, #0
    ldr r1, =str_cmp_gt
    swi SWI_PrStr
    swi SWI_Exit

    .data
str1: .space 256
str2: .space 256
newline: .asciz "\n" 
    .align
str1_prompt: .asciz "str1: " 
    .align
str2_prompt: .asciz "str2: " 
    .align
case_prompt: .asciz "case (1 to ignore case, 0 otherwise): " 
    .align
str_cmp_lt: .asciz "str1 is less than str2\n" 
    .align
str_cmp_eq: .asciz "str1 and str2 are equal\n" 
    .align
str_cmp_gt: .asciz "str1 is greater than str2\n" 
    .align
str_not_alph: .asciz " is not an alphabet\n" 
    .align
str_alph: .asciz " is an alphabet\n"
    .end

