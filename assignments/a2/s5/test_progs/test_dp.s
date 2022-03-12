@ parts of ISA supported till now:
@ - all DP instructions 
@ - all condition codes
@ - the S flag
@ - DT instructions - ldr and str
@ - branch instructions (branch linked, branch to register not supported)

@ for now, this program is a test of all 16 ALU opcodes 
    .text

    mov r0, #0
    mov r1, #1

    @ mvn (just because I need all bits set in r15)
    mvn r15, r0

    @ and 
    and r2, r1, r0
    mov r0, #1
    and r2, r1, r0
    and r2, r15, #0xFD

    @ eor
    eor r2, r1, r0
    mov r0, #0
    eor r2, r1, r0

    @ sub
    mov r1, #5
    mov r0, #20
    sub r2, r0, r1 @ 15

    @ rsb
    rsb r2, r0, r1 @ -15

    @ add
    add r2, r0, r1 @ 15
    @ test for overflows
    add r15, r1 @ should overflow

    @ adc
    adc r2, r1, r0
    @sbc
    sbc r2, r1, r0
    @ rsb
    rsb r2, r1, r0

    @ tst, teq should set flags
    mov r0, #0
    mov r1, #0
    tst r0, r1
    teq r0, r1

    @ cmp should set flags
    cmp r0, #0
    cmp r0, #1
    cmp r0, r1

    @ orr
    mov r1, #1
    orr r2, r1, r0

    @ bic
    bic r2, r15, r1

    .end

@ and
@ eor
@ sub
@ rsb
@ add
@ adc
@ sbc
@ rsc
@ tst
@ teq
@ cmp
@ cmn
@ orr
@ mov
@ bic
@ mvn
