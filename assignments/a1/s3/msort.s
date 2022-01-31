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
    .global strlist
    .global merge
    .global mdata
    .global msort

    .text

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
	sub r3, #1
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
@    strcmp(r0, r1, r2)
@ Input parameters:
@    r0: the address of the first null-terminated ASCII string
@    r1: the address of the second null-terminated ASCII string
@    r2: ignore case flag (set to 1 to ignore case, 0 otherwise)
@ Result:
@    CPSR stores the result of the comparision 
@
strcmp:
    stmfd sp!, {r0-r4,lr}
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
3:  cmp r0, #0
    ldmfd sp!, {r0-r4,lr}
    bx lr

@ strlist: create a string array given a string
@
@ Usage:
@   strlist(r0, r1, r2)
@ Input parameter(s):
@   r0: position of target string list
@   r1: position of list of input strings, separated by null characters
@   r2: number of strings in list
@
strlist:
    stmfd sp!, {r0-r3, lr}
    mov r3, r0
    mov r0, r1
1:  cmp r2, #0
    ble 2f
    str r0, [r3], #4
    bl strlen 
    add r0, #1
    add r0, r1
    mov r1, r0
    sub r2, #1
    b 1b
2:  
    ldmfd sp!, {r0-r3, lr} 
    bx lr 

@ merge: merge two sorted lists of strings 
@ 
@ Usage:
@   r0 = merge(r0, r1, r2, r3, r4, r5)
@ Input parameters:
@   r0: start address of first string list
@   r1: start address of second string list
@   r2: ignore case (1 to ignore, 0 otherwise)
@   r3: length of first string list
@   r4: length of second string list
@   r5: ignore duplicates (1 to ignore, 0 otherwise)
@ Result:
@   r0: length of resulting string list
@   the resulting merged list is always stored in loc mdata
@
@ Register descriptions:
@   r0, r1: current list pointers
@   r2: ignore case parameter
@   r3, r4: final list pointers
@   r5: ignore duplicates
@   r6: current merge list pointer
@   r7: length
@   r8: jump table addend
@   r9: jump table address
merge:
    stmfd sp!, {r1-r9, lr}
    add r3, r0, r3, lsl #2
    add r4, r1, r4, lsl #2 
    ldr r6, =mdata
    ldr r9, =j1
    mov r7, #0
1:  mov r8, #0
    cmp r0, r3
    addlt r8, #4
    cmp r1, r4
    addlt r8, #2
    cmp r8, #6
    stmfd sp!, {r0-r1}
    ldreq r0, [r0]
    ldreq r1, [r1]
    bleq strcmp
    ldmfd sp!, {r0-r1}
    addlt r8, #1
    ldr pc, [r9,r8,lsl #2]
c0: cmp r5, #1
    bne a0
    cmp r7, #0
    beq a0
    sub r6, #4
    stmfd sp!, {r0-r1}
    mov r1, r6
    ldr r0, [r0]
    ldr r1, [r1]
    bl strcmp
    ldmfd sp!, {r0-r1}
    add r6, #4
    bne a0
    add r0, #4
    b 1b
a0: stmfd sp!, {r0}
    ldr r0, [r0]
    str r0, [r6], #4
    ldmfd sp!, {r0}
    add r7, #1
    add r0, #4
    b 1b
c1: cmp r5, #1
    bne a1
    cmp r7, #0
    beq a1
    sub r6, #4
    stmfd sp!, {r0-r1}
    mov r0, r6
    ldr r0, [r0]
    ldr r1, [r1]
    bl strcmp
    ldmfd sp!, {r0-r1}
    add r6, #4
    bne a1
    add r1, #4
    b 1b
a1: stmfd sp!, {r1}
    ldr r1, [r1]
    str r1, [r6], #4
    ldmfd sp!, {r1}
    add r7, #1
    add r1, #4
    b 1b
tm: mov r0, r7
    ldmfd sp!, {r1-r9, lr}
    bx lr
j1: .word tm, tm, c1, c1, c0, c0, c1, c0

@ msort: sort a list of string pointers using merge sort
@
@ Usage:
@   r0 = msort(r0, r1, r2, r3)
@ Input parameters:
@   r0: location of the string array to be sorted
@   r1: length of the string array to be sorted
@   r2: ignore case (1 to ignore case, 0 otherwise)
@   r3: ignore duplicates (1 to ignore, 0 otherwise)
@ Result:
@   r0 stores the length of the final merge sorted array
@   the merged array of string pointers is in place stored in r0
@
msort:
    cmp r1, #1
    bgt 1f
    mov r0, r1
    bx lr
1:  stmfd sp!, {r1-r9, lr}
    mov r6, r1
    mov r7, r0
    mov r1, r1, LSR #1
    bl msort
    mov r8, r0
    add r0, r7, r1, LSL #2
    sub r1, r6, r1
    mov r6, r7
    mov r7, r0
    bl msort
    mov r9, r0
    @ r8 and r9 store lengths of lists merge sorted
    @ r6 and r7 store positions of lists
    mov r0, r6
    mov r1, r7
    mov r5, r3
    mov r3, r8
    mov r4, r9
    bl merge
    @ r0 will store length of merged list now
    @ the merged list itself is in mdata. Load it in to the main list
    mov r9, r0
    ldr r1, =mdata
    add r0, r1, r0, LSL #2
2:  cmp r1, r0
    bge 3f
    ldr r2, [r1], #4
    str r2, [r6], #4
    b 2b
3:  mov r0, r9
    ldmfd sp!, {r1-r9, lr}
    bx lr

    .data
t1: .skip 256
t2: .skip 256
mdata: .skip 1000
