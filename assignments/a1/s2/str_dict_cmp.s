    .global str_dict_cmp
    .global to_upper_case
    .global is_alph
    .text

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

    .end
