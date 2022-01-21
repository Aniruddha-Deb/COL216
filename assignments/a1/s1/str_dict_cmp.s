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
    bl str_dict_cmp

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

@ compares two strings in dictionary order
@ r0: address of first string
@ r1: address of second string
@ r2: comparision mode (1 for ignore case, 0 for not)
@ r3: used for computation
str_dict_cmp: 
    cmp r2, #0
    stmfd sp!, {r0-r1, lr}
    beq str_cmp_cs
    bl to_upper_case
    mov r3, r0
    mov r0, r1
    bl to_upper_case
    mov r1, r0
    mov r0, r3
    b str_cmp_char
str_cmp_cs:
    ldrb r0, [r0]
    ldrb r1, [r1]
str_cmp_char:
    cmp r0, r1
    beq chr_eq
    bgt chr_gt
    blt chr_lt

chr_eq:
    @ check if the string is over
    cmp r0, #0
    beq str_eq
    @ if not, then recurse
    ldmfd sp!, {r0-r1, lr}
    add r0, r0, #1
    add r1, r1, #1
    b str_dict_cmp
    
chr_gt:
    @ r0 is larger
    ldmfd sp!, {r0-r1, lr}
    mov r0, #1
    bx lr

chr_lt:
    @ r1 is larger
    ldmfd sp!, {r0-r1, lr}
    mov r0, #-1
    bx lr

str_eq:
    ldmfd sp!, {r0-r1, lr}
    mov r0, #0
    bx lr

to_uc_test:
    mov r0, #0
    ldr r1, =char
    mov r2, #4
    swi SWI_RdStr
    mov r0, r1
    bl to_upper_case
    mov r0, #0
    strb r0, [r1,#1]
    mov r0, #1
    swi SWI_PrStr
    ldr r1, =newline
    swi SWI_PrStr
    swi SWI_Exit

is_alph_test:
    mov r0, #0
    ldr r1, =char
    mov r2, #4
    swi SWI_RdStr
    ldrb r0, [r1]
    bl is_alph 
    cmp r0, #1
    beq m1
    bne m2
m1: mov r0, #1
    ldr r1, =str_alph
    swi SWI_PrStr
    b n1
m2: mov r0, #1
    ldr r1, =str_not_alph
    swi SWI_PrStr
    b n1
n1: swi SWI_Exit

@ if the letter at the address pointed to by r0 is an alphabet, convert it to 
@ upper case and store at the same address
to_upper_case:
    stmfd sp!, {r1}
    mov r1, r0
    ldrb r0, [r1]
    ldmfd sp!, {r1}
    @ push lr to stack!
    stmfd sp!, {r0, lr}
    bl is_alph
    cmp r0, #1
    ldmfd sp!, {r0, lr}
    bxne lr
    cmp r0, #97
    bxlt lr
    sub r0, r0, #32
    bx lr

@ if r0 is an alphabet
is_alph:
    cmp r0, #90
    ble le90
    cmp r0, #97
    blt not_alph
    cmp r0, #122
    bgt not_alph
    b alph

le90: 
    cmp r0, #65
    blt not_alph
    b alph

not_alph:
    mov r0, #0
    bx lr

alph:
    mov r0, #1
    bx lr

    .data
char: .space 4
str1: .space 100
str2: .space 100
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

