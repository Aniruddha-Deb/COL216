library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.MyTypes.all;

entity pmconnect is
    port (
        Rout : in word;
        Rin : out word;
        dt_opcode : in DT_opcode_t;
        enable : in std_logic;
        adr: in bit_pair;
        Min: out word;
        Mout: in word;
        MW : out nibble
    );
end pmconnect;

architecture pmconnect_arc of pmconnect is
begin

    MW <= "1111" when (enable = '1' and dt_opcode = STR) else
          "0011" when (enable = '1' and dt_opcode = STRH and adr = "00") else
          "1100" when (enable = '1' and dt_opcode = STRH and adr = "10") else
          "0001" when (enable = '1' and dt_opcode = STRB and adr = "00") else
          "0010" when (enable = '1' and dt_opcode = STRB and adr = "01") else
          "0100" when (enable = '1' and dt_opcode = STRB and adr = "10") else
          "1000" when (enable = '1' and dt_opcode = STRB and adr = "11") else
          "0000";

    Min <= Rout(15 downto 0) & Rout(15 downto 0) when dt_opcode = STRH else
           Rout(7 downto 0) & Rout(7 downto 0) & Rout(7 downto 0) & Rout(7 downto 0) when dt_opcode = STRB else
           Rout;

    Rin <= Mout when dt_opcode = LDR else
           std_logic_vector(resize(unsigned(Mout(15 downto 0)),32)) when dt_opcode = LDRH and adr = "00" else
           std_logic_vector(resize(unsigned(Mout(31 downto 16)),32)) when dt_opcode = LDRH and adr = "10" else
           std_logic_vector(resize(signed(Mout(15 downto 0)),32)) when dt_opcode = LDRSH and adr = "00" else
           std_logic_vector(resize(signed(Mout(31 downto 16)),32)) when dt_opcode = LDRSH and adr = "10" else
           std_logic_vector(resize(unsigned(Mout(7 downto 0)),32)) when dt_opcode = LDRB and adr = "00" else
           std_logic_vector(resize(unsigned(Mout(15 downto 8)),32)) when dt_opcode = LDRB and adr = "01" else
           std_logic_vector(resize(unsigned(Mout(23 downto 16)),32)) when dt_opcode = LDRB and adr = "10" else
           std_logic_vector(resize(unsigned(Mout(31 downto 24)),32)) when dt_opcode = LDRB and adr = "11" else
           std_logic_vector(resize(signed(Mout(7 downto 0)),32)) when dt_opcode = LDRSB and adr = "00" else
           std_logic_vector(resize(signed(Mout(15 downto 8)),32)) when dt_opcode = LDRSB and adr = "01" else
           std_logic_vector(resize(signed(Mout(23 downto 16)),32)) when dt_opcode = LDRSB and adr = "10" else
           std_logic_vector(resize(signed(Mout(31 downto 24)),32)) when dt_opcode = LDRSB and adr = "11" else
           Mout;

end pmconnect_arc;