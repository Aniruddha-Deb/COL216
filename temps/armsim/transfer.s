    TTL transfer
    AREA Program, CODE, READONLY
    ENTRY

Main
    LDRB R1, Value
    STR R1, Result
    SWI 0x11

Value DCW &C123
      ALIGN
Result DCW 0
       End
