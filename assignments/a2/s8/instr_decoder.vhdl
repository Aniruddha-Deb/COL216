library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.MyTypes.all;

entity instr_decoder is
    port (
        instruction: in word;

        instruction_class : out instruction_t;
        DP_opcode : out DP_opcode_t;
        condition : out condition_t;
        DT_opcode : out DT_opcode_t;
        mul_opcode: out mul_t;
        shift : out shift_t
    );
end instr_decoder;

architecture instr_decoder_arc of instr_decoder is
begin

    instruction_class <= DP_IMM_SHIFT when instruction(27 downto 25) = "000" and instruction(4) = '0' else
                         MUL_32 when instruction(27 downto 22) = "000000" and instruction(7 downto 4) = "1001" else
                         MUL_64 when instruction(27 downto 23) = "00001" and instruction(7 downto 4) = "1001" else
                         DT_HW_IMM when instruction(27 downto 25) = "000" and instruction(22) = '1' and instruction(7 downto 4) = "1011" else
                         DT_HW_REG when instruction(27 downto 25) = "000" and instruction(22) = '0' and instruction(7 downto 4) = "1011" else
                         LDR_SIGNED_REG when instruction(27 downto 25) = "000" and instruction(22) = '0' and instruction(20) = '1' and instruction(7 downto 6) = "11" and instruction(4) = '1' else
                         LDR_SIGNED_IMM when instruction(27 downto 25) = "000" and instruction(22) = '1' and instruction(20) = '1' and instruction(7 downto 6) = "11" and instruction(4) = '1' else
                         DP_REG_SHIFT when instruction(27 downto 25) = "000" and instruction(4) = '1' else
                         DP_IMM when instruction(27 downto 25) = "001" else
                         DT_IMM when instruction(27 downto 25) = "010" else
                         DT_REG when instruction(27 downto 25) = "011" and instruction(4) = '0' else -- TODO ones below this
                         SWI when instruction(27 downto 24) = "1111" else
                         BRANCH;

    condition <= EQ when instruction(31 downto 28) = "0000" else
                 NE when instruction(31 downto 28) = "0001" else
                 HS when instruction(31 downto 28) = "0010" else
                 LO when instruction(31 downto 28) = "0011" else
                 MI when instruction(31 downto 28) = "0100" else
                 PL when instruction(31 downto 28) = "0101" else
                 VS when instruction(31 downto 28) = "0110" else
                 VC when instruction(31 downto 28) = "0111" else
                 HI when instruction(31 downto 28) = "1000" else
                 LS when instruction(31 downto 28) = "1001" else
                 GE when instruction(31 downto 28) = "1010" else
                 LT when instruction(31 downto 28) = "1011" else
                 GT when instruction(31 downto 28) = "1100" else
                 LE when instruction(31 downto 28) = "1101" else
                 AL;

    DP_opcode <= ANDOP when instruction(24 downto 21) = "0000" else
                 EOR when instruction(24 downto 21) = "0001" else
                 SUB when instruction(24 downto 21) = "0010" else
                 RSB when instruction(24 downto 21) = "0011" else
                 ADD when instruction(24 downto 21) = "0100" else
                 ADC when instruction(24 downto 21) = "0101" else
                 SBC when instruction(24 downto 21) = "0110" else
                 RSC when instruction(24 downto 21) = "0111" else
                 TST when instruction(24 downto 21) = "1000" else
                 TEQ when instruction(24 downto 21) = "1001" else
                 CMP when instruction(24 downto 21) = "1010" else
                 CMN when instruction(24 downto 21) = "1011" else
                 ORR when instruction(24 downto 21) = "1100" else
                 MOV when instruction(24 downto 21) = "1101" else
                 BIC when instruction(24 downto 21) = "1110" else
                 MVN;

    DT_opcode <= LDR when instruction(27 downto 26) = "01" and instruction(22) = '0' and instruction(20) = '1' else
                 STR when instruction(27 downto 26) = "01" and instruction(22) = '0' and instruction(20) = '0' else
                 LDRB when instruction(27 downto 26) = "01" and instruction(22) = '1' and instruction(20) = '1' else -- TODO ones below this
                 STRB when instruction(27 downto 26) = "01" and instruction(22) = '1' and instruction(20) = '0' else
                 LDRH when instruction(27 downto 25) = "000" and instruction(20) = '1' and instruction(6) = '0' else
                 STRH when instruction(27 downto 25) = "000" and instruction(20) = '0' else
                 LDRSH when instruction(27 downto 25) = "000" and instruction(20) = '1' and instruction(6) = '1' and instruction(5) = '1' else
                 LDRSB;

    mul_opcode <= MUL when instruction(27 downto 21) = "0000000" and instruction(7 downto 4) = "1001" else
                  MLA when instruction(27 downto 21) = "0000001" and instruction(7 downto 4) = "1001" else
                  UMULL when instruction(27 downto 21) = "0000100" and instruction(7 downto 4) = "1001" else
                  SMULL when instruction(27 downto 21) = "0000110" and instruction(7 downto 4) = "1001" else
                  UMLAL when instruction(27 downto 21) = "0000101" and instruction(7 downto 4) = "1001" else
                  SMLAL;

    shift <= LS_LEFT when instruction(6 downto 5) = "00" else 
             LS_RIGHT when instruction(6 downto 5) = "01" else 
             AS_RIGHT when instruction(6 downto 5) = "10" else 
             ROT_RIGHT;

end instr_decoder_arc;
