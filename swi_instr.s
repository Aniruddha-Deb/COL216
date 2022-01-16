    @ Input Streams - the SWI commands generally take a file descriptor. Putting
    @ these would allow them to take input/output from the standard streams
    .equ STDIN , 0
    .equ STDOUT, 1
    .equ STDERR, 2

    @ Legacy SWI Instruction set.
    @ NOTE: to activate these, you'd need to check the LegacySWIInstruction plugin
    @ in the ARMSim preferences. By default, ARMSim uses the Angel SWI instruction
    @ set, whose commands are below this.
    @ 
    @ These instructions are called by first moving the required parameters into
    @ R0 and R1, then calling `swi SWI_Leg_<cmd>`. Returned values, if any, are 
    @ stored in R0. 
    @
    @ for the printing/input statements, r0 stores the file handle, or one of 
    @ STDIN/STDOUT/STDERR. R1 stores the string/destination address/integer.
    @
    @ for more documentation, see https://lri.fr/~dr/ARM-Tutorial.pdf

    .equ SWI_Leg_PrChr, 0x00 @ r0: character
    .equ SWI_Leg_Print, 0x02 @ r0: address of ASCIZ string
    .equ SWI_Leg_PrStr, 0x69 @ r0: file handle, r1: address of ASCIZ string
    .equ SWI_Leg_Exit , 0x11 @ Halt Execution
    .equ SWI_Leg_Open , 0x66 @ r0: file name as ASCIZ string, r1: mode (0-input,1-output,2-append)
                             @ returns: r0 as file handle
    .equ SWI_Leg_Close, 0x68 @ r0: file handle
    .equ SWI_Leg_RdStr, 0x6a @ r0: file handle, r1: destination address, r2: max bytes
                             @ returns: r0 as number of bytes stored
    .equ SWI_Leg_PrInt, 0x6b @ r0: file handle, r1: integer
    .equ SWI_Leg_RdInt, 0x6c @ r0: file handle. returns: r0 as integer
    .equ SWI_Leg_Timer, 0x6d @ returns: r0 as number of ticks (ms)

    @ Angel SWI Instruction set
    @ All Angel commands use just one instruction to interrupt: swi 0x123456
    @ The command type, as well as the parameters for the command are stored in
    @ the registers R0 and R1. R0 contains a _reason code_, whereas R1 contains
    @ the address to a block of parameters held in memory.
    @ Results, if any, are stored in r0

    .equ SWI_Ang      , 0x123456
    .equ SWI_Ang_Open , 0x01 @ r1: filename address, filename length, file mode
    .equ SWI_Ang_Close, 0x02 @ r1: file handle
    .equ SWI_Ang_Write, 0x05 @ r1: file handle, buf address, # bytes to write 
    .equ SWI_Ang_Read , 0x06 @ r1: file handle, buf address, # bytes to read
    .equ SWI_Ang_IsTTY, 0x09 @ r1: file handle
    .equ SWI_Ang_FSeek, 0x0A @ r1: file handle, offset 
    .equ SWI_Ang_FLen , 0x0C @ r1: file handle
    .equ SWI_Ang_FName, 0x0D @ r1: buf address, unique int, buf length 
    .equ SWI_Ang_FRem , 0x0E @ r1: filename address, filename length
    .equ SWI_Ang_FRnme, 0x0F @ r1: filename 1 addr, l1, filename 2 addr, l2
    .equ SWI_Ang_ETime, 0x10  
    .equ SWI_Ang_ATime, 0x11
    .equ SWI_Ang_ErrNo, 0x13
    .equ SWI_Ang_Heap , 0x16
    .equ SWI_Ang_Exit , 0x18
