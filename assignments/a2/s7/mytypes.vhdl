library ieee;
use ieee.std_logic_1164.all;

package MyTypes is

    subtype dword is std_logic_vector (63 downto 0);
    subtype word is std_logic_vector (31 downto 0);
    subtype hword is std_logic_vector (15 downto 0);
    subtype byte is std_logic_vector (7 downto 0);
    subtype nibble is std_logic_vector (3 downto 0);
    subtype bit_pair is std_logic_vector (1 downto 0);

    type mem is array(integer range <>) of std_logic_vector(31 downto 0);

    constant cpsr_N: integer := 0;
    constant cpsr_Z: integer := 1;
    constant cpsr_C: integer := 2;
    constant cpsr_V: integer := 3;

    type flags_t is record 
        negative: std_logic;
        zero: std_logic;
        carry: std_logic;
        overflow: std_logic;
    end record flags_t;

    type instruction_t is (DP_IMM_SHIFT, DP_REG_SHIFT, DP_IMM, MUL_32, MUL_64, DT_IMM, DT_REG, DT_HW_IMM, DT_HW_REG, LDR_SIGNED_REG, LDR_SIGNED_IMM, BRANCH);
    type DP_opcode_t is (ANDOP, EOR, SUB, RSB, ADD, ADC, SBC, RSC, TST, TEQ, CMP, CMN, ORR, MOV, BIC, MVN);
    type condition_t is (EQ, NE, HS, LO, MI, PL, VS, VC, HI, LS, GE, LT, GT, LE, AL);
    type DT_opcode_t is (LDR, STR, LDRB, STRB, LDRH, STRH, LDRSH, LDRSB);
    type shift_t is (LS_LEFT, LS_RIGHT, AS_RIGHT, ROT_RIGHT);
    type mul_t is (MUL, MLA, UMULL, UMLAL, SMULL, SMLAL);

    type signal_array is array(integer range <>) of std_logic_vector(31 downto 0);
end MyTypes;

package body MyTypes is
end MyTypes;
