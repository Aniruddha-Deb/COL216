@ Merge Sort and String library
@
@ Unless attributed, all the functions in this library have been written by 
@ Aniruddha Deb (cs1200869@iitd.ac.in)
@
@ For more information and testing instructions, check the README.txt file 
@ attached with this source
    .global strlen
    .global strcpy
    .global strupc
    .global strcmp

    .text

@ Function template:
@ fnName: fnDescrip
@
@ Usage:
@
@ Input parameter(s):
@
@ Result:
@
@
@fnName:
@    stmfd sp!, {}
@
@    ldmfd sp!, {}
@    bx lr

@ strlen: compute length of a null-terminated ASCII string
@
@ Usage:
@   r0 = strlen(r0)
@ Input parameter:
@   r0: the address of a null-terminated ASCII string
@ Result:
@   r0: the length of the string (excluding the null byte at the end)
@ Author:
@   RN Horspool (taken with credit from the UsefulFunctions.s library)
@
strlen:
	stmfd	sp!, {r1-r3,lr}
	mov	r1, #0
	mov	r3, r0
1:	ldrb	r2, [r3], #1
	cmp	r2, #0
	bne	1b
	sub	r0, r3, r0
	ldmfd	sp!, {r1-r3,lr} @ initial impl had pc in place of lr: a closer look
	                        @ at ARMARM says that this is bad practice
	bx lr

@ strlen_mult: compute length of a 

@ strcpy: copy the string to the given memory location
@
@ Usage:
@   strcpy(r0, r1)
@ Input parameter:
@   r0: source register 
@   r1: destination register
@ 
strcpy:
    stmfd sp!, {r0-r2}
1:  ldrb r2, [r0], #1
    cmp r2, #0
    beq 2f
    strb r2, [r1], #1
    b 1b
2:  strb r2, [r1]
    ldmfd sp!, {r0-r2}
    bx lr

@ strupc: convert the case of the given string to uppercase
@
@ Usage:
@   strupc(r0)
@ Input parameter:
@   r0: pointer to string
@
strupc:
    stmfd sp!, {r0,r1}
1:  ldrb r1, [r0], #1
    cmp r1, #0
    beq 2f
    cmp r1, #97
    blt 1b
    cmp r1, #122
    bgt 1b
    sub r1, #32
    strb r1, [r0, #-1]
    b 1b
2:  ldmfd sp!, {r0,r1}
    bx lr

@ strcmp: compare two strings
@
@ Usage:
@    r0 = strcmp(r0, r1, r2)
@ Input parameters:
@    r0: the address of the first null-terminated ASCII string
@    r1: the address of the second null-terminated ASCII string
@    r2: ignore case flag (set to 1 to ignore case, 0 otherwise)
@ Result:
@    r0: the result of the comparision (-1 if r0 < r1, 0 if r0=r1 and 1 otherwise)
@
strcmp:
    stmfd sp!, {r1-r4,lr}
    mov r3, r0
    mov r4, r1
    ldr r1, =t1
    bl strcpy
    mov r0, r4
    ldr r1, =t2
    bl strcpy
    cmp r2, #1
    bne 1f
    ldr r0, =t1
    bl strupc
    ldr r0, =t2
    bl strupc
1:  ldr r3, =t1
    ldr r4, =t2
2:  ldrb r0, [r3], #1
    ldrb r1, [r4], #1
    cmp r0, r1
    blt lt
    bgt gt
    cmp r0, #0
    beq eq
    b 2b
lt: mov r0, #-1
    b 3f
gt: mov r0, #1
    b 3f
eq: mov r0, #0
3:  ldmfd sp!, {r1-r4,lr}
    bx lr

@ strlist: create a string array given a string
@
@ Usage:
@   strlist(r0, r1, r2, r3)
@ Input parameter(s):
@   r0: position of target string list
@   r1: position of list of input strings, separated by null characters
@   r2: number of strings in list
@   r3: 1 to store descending (for a stack) or ascending (for a mem. loc)
@
strlist:
    stmfd sp!, {r0-r3, lr}
    mov r3, r0
1:  mov r0, r1
    cmp r2, #0
    ble 2f
    str r1, [r3], #4
    bl strlen
    add r0, #1
    add r1, r0
    sub r2, #1
    b 1b
2:  ldmfd sp!, {r0-r3, lr}
    bx lr

@ merge: merge two consecutive sorted lists of strings of different lengths 
@        in place
@ 
@ Usage:
@   r0 = merge(r0, r1, r2, r3, r4)
@ Input parameters:
@   r0: start address of string list
@   r1: length of first string list
@   r2: length of second string list
@   r3: parameters (bit0 - 1 for ignore case, 0 otherwise, bit1 - 1 for skip 
@                   duplicates, 0 otherwise)
@ Result:
@   r0: length of resulting string list
@
merge:
    stmfd lr, 



    .data
t1: .skip 256
t2: .skip 256
