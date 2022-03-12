@ shift_test.s
@ test file for the shifter

    .text

@ Data Processsing Shifts:
@ the following types of data processing shifts exist in ARM
@
@ - #<immediate>
@ - <Rm>
@ - <Rm>, LSL #<shift_imm>
@ - <Rm>, LSL <Rs>
@ - <Rm>, LSR #<shift_imm>
@ - <Rm>, LSR <Rs>
@ - <Rm>, ASR #<shift_imm>
@ - <Rm>, ASR <Rs>
@ - <Rm>, ROR #<shift_imm>
@ - <Rm>, ROR <Rs>
@ - <Rm>, RRX
@
@ most of these are self explanatory, and all have been implemented, except for 
@ RRX. For Data processing, encoding is in one of three ways:
@ 1. 32-bit immediate - an 8 bit constant rotated right by twice of a four-bit 
@                       constant. #<immed_8>, <rotate_amount>
@ 2. Immediate Shift - Rm shifted by an immediate constant
@ 3. Register Shift - Rm shifted by a register Rs

    mov r1, #8 @ we'll use this for register shifts
    mov r2, #0x234 @ shows immediate shift working, because 0x234 won't fit in 8 bits

    mov r0, #12, 4 @ r0 = 1100 >> 4 = 110000...00 (immediate)
    mov r0, r2, LSL #4 @ r0 = 0x2340
    mov r0, r2, LSL r1 @ r0 = 0x23400
    mov r0, r2, LSR #4 @ r0 = 0x23
    mov r0, r2, LSR r1 @ r0 = 0x2
    mov r0, r2, ASR #4 @ same as above
    mov r0, r2, ASR r1 @ same as above
    mov r0, r2, ROR #4 @ r0 = 0x40000023
    mov r0, r2, ROR r1 @ r0 = 0x34000002

@ edge cases: ASR for negatives, shifting out by a value greater than 32

    mov r1, #56

    mov r0, r2, LSL r1 @ r0 = 0
    mov r0, r2, LSR r1 @ r0 = 0
    mov r0, r2, ASR r1 @ r0 = 0
    mov r0, r2, ROR r1 @ r0 = 0x23400 (56 = -8 mod 32, so equiv. to LSL #8)

    mvn r2, #0x000FF000
    mov r0, r2, ASR #8 @ r0 = 0xFFFFF00F
    mov r0, r2, ASR r1 @ r0 = 0xFFFFFFFF

@ data transfer: 
@ the following types of data transfer operators exist in ARM
@ 
@ 1. [<Rn>, #+/-<offset_12>]
@ 2. [<Rn>, +/-<Rm>]
@ 3. [<Rn>, +/-<Rm>, <shift> #<shift_imm>]
@ 4. [<Rn>, #+/-<offset_12>]!
@ 5. [<Rn>, +/-<Rm>]!
@ 6. [<Rn>, +/-<Rm>, <shift> #<shift_imm>]!
@ 7. [<Rn>], #+/-<offset_12>
@ 8. [<Rn>], +/-<Rm>
@ 9. [<Rn>], +/-<Rm>, <shift> #<shift_imm>
@
@ From these operations, only (1), (2), (3) have been implemented in this version.
@ We test these implementations below:

    mov r1, #42
    mov r2, #8
    mov r0, #116

    str r1, [r0, #4]
    str r1, [r0, r2]
    str r1, [r0, r2, LSR #4]

    ldr r3, [r0, #4]
    ldr r4, [r0, r2]
    ldr r5, [r0, r2, LSR #4]


    .data
pos: .skip 20
    .end