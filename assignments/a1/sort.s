    .equ SWI_Exit, 0x11
    .equ SWI_PrChr, 0x00
    .equ SWI_PrStr, 0x69
    .equ SWI_RdStr, 0x6a

    .text

@ compares two strings in dictionary order
@ r0: address of first string
@ r1: address of second string
@ r2: comparision mode (1 for ignore case, 0 for not)
@str_dict_cmp: @ compares two strings in dictionary order
@    sub r3, r1, r0 @ delta
@    cmp r2, #0
@    beq @ ignore case
@    cmp r0, #0 @ check if string 0 is over
@    beq @ end; r0 < r1 
@    cmp r1, #0 @ check if string 1 is over
@    beq @ recurse one down
@
    @ not ignoring case:
    @ if string 0 and string 1 both are over, then both are equal
    @ else if string 0 or string 1 are over, then the shorter one is smaller
    @ else compare the current character of both string 0 and string 1
    @   if this character is smaller for string 0, then string 0 is smaller
    @   if this character is smaller for string 1, then string 1 is smaller
    @   if both are equal, increment r0 and r1 and recurse
    @
    @ ignoring case:
    @ get the difference of both characters. If it equals 97-65 (or the other 
    @ way around), both are equal. Otherwise, same process as before. 

to_uc_test:
    mov r0, #0
    ldr r1, =char
    mov r2, #4
    swi SWI_RdStr
    ldr r0, [r1]
    bl to_upper_case
    ldr r1, =char
    str r0, [r1]
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
    ldr r0, [r1]
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

@ if r0 is an alphabet, convert to upper case and store back
to_upper_case:
    mov r1, r0
    @ push lr to stack!
    stmfd sp!, {lr}
    bl is_alph
    ldmfd sp!, {lr}
    cmp r0, #1
    mov r0, r1
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
newline: .asciz "\n"
str_not_alph: .asciz " is not an alphabet\n"
    .align
str_alph: .asciz " is an alphabet\n"
    .end

