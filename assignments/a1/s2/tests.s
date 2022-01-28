    .equ SWI_Exit, 0x11
    .equ SWI_PrChr, 0x00
    .equ SWI_PrStr, 0x69
    .equ SWI_RdStr, 0x6a
    .equ SWI_PrInt, 0x6b
    .equ SWI_RdInt, 0x6c

    .text

merge_test:
    ldr r1, =l1
    bl prStr
    bl rdInt
    mov r3, r0
    mov r4, #1
    ldr r5, =strl
1:  cmp r4, r3
    bgt 2f
    ldr r1, =l2
    bl prStr
    mov r1, r4
    bl prInt
    ldr r1, =l3
    bl prStr
    mov r1, r5
    bl rdStr
    add r5, r0
    add r4, #1
    b 1b  

2:  ldr r1, =l1
    bl prStr
    bl rdInt
    mov r4, r0
    mov r5, #1
    ldr r6, =strl1
3:  cmp r5, r4
    bgt 4f
    ldr r1, =l2
    bl prStr
    mov r1, r5
    bl prInt
    ldr r1, =l3
    bl prStr
    mov r1, r6
    bl rdStr
    add r6, r0
    add r5, #1
    b 3b

4:  ldr r1, =l4
    bl prStr
    bl rdInt
    mov r7, r0
    ldr r1, =case_prompt
    bl prStr
    bl rdInt
    mov r8, r0
    ldr r0, =strarr
    ldr r1, =strl
    mov r2, r3
    bl strlist
    ldr r0, =strarr1
    ldr r1, =strl1
    mov r2, r4
    bl strlist
    ldr r0, =strarr
    ldr r1, =strarr1
    mov r2, r8
    mov r5, r7
    bl merge
    ldr r3, =mdata
    add r3, r0, lsl #2
    ldr r2, =mdata
5:  cmp r2, r3
    bge 6f
    ldr r1, [r2], #4
    bl prStr
    ldr r1, =space
    bl prStr
    b 5b
6:  ldr r1, =nl
    bl prStr
    swi SWI_Exit

strlen_test:
    ldr r1, =l2
    bl prStr
    ldr r1, =l3
    bl prStr
    ldr r1, =strl
    mov r2, #100
    bl rdStr
    ldr r0, =strl
    bl strlen
    mov r1, r0
    bl prInt
    swi SWI_Exit

strlist_test:
    ldr r1, =l1
    bl prStr
    bl rdInt
    mov r3, r0
    mov r4, #1
    ldr r5, =strl
1:  cmp r4, r3
    bgt 2f
    ldr r1, =l2
    bl prStr
    mov r1, r4
    bl prInt
    ldr r1, =l3
    bl prStr
    mov r1, r5
    bl rdStr
    add r5, r0
    add r4, #1
    b 1b
2:  
    ldr r0, =strarr
    ldr r1, =strl
    mov r2, r3
    bl strlist
    ldr r3, =strarr
    add r3, r2, lsl #2
    ldr r2, =strarr
3:  cmp r2, r3
    bge 4f
    ldr r1, [r2], #4
    bl prStr
    ldr r1, =space
    bl prStr
    b 3b
4:  ldr r1, =nl
    bl prStr
    swi SWI_Exit
l1: .asciz "length of list: " 
    .align
l2: .asciz "String " 
    .align
l3: .asciz ": " 
    .align
nl: .asciz "\n" 
    .align
space: .asciz " "
    .align
l4: .asciz "duplicate removal (1 to remove, 0 otherwise): "
    .align

prStr:
    mov r0, #0
    swi SWI_PrStr
    bx lr

prInt:
    mov r0, #1
    swi SWI_PrInt
    bx lr

rdInt:
    mov r0, #0
    swi SWI_RdInt
    bx lr

rdStr:
    mov r0, #0
    mov r2, #48
    swi SWI_RdStr
    bx lr

strcmp_test:
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

    blt print_lt
    beq print_eq
    bgt print_gt

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
strl: .space 1000
strl1: .space 1000
strarr: .space 400
strarr1: .space 400
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

