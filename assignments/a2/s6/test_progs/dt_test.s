@ dt_test.s
@ 
@ testing all types of DT instructions
@

    .text
    mov r0, #120 @ byte address 30
    mov r1, #0xAD
    orr r1, #0xDE00
    orr r1, #0xFE0000
    orr r1, #0xCA000000
    str r1, [r0]

    strh r1, [r0,#4]
    strh r1, [r0,#6]

    strb r1, [r0,#8]
    strb r1, [r0,#9]
    strb r1, [r0,#10]
    strb r1, [r0,#11]

    ldr r2, [r0]
    
    ldrh r2, [r0]
    ldrsh r2, [r0]
    ldrh r2, [r0,#2]
    ldrsh r2, [r0,#2]

    ldrb r2, [r0]
    ldrsb r2, [r0]
    ldrb r2, [r0,#1]
    ldrsb r2, [r0,#1]
    ldrb r2, [r0,#2]
    ldrsb r2, [r0,#2]
    ldrb r2, [r0,#3]
    ldrsb r2, [r0,#3]

    .data
space: .skip 20
    .end