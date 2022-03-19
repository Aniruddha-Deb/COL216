library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- for type conversions
use work.MyTypes.all;

entity pmconnect is
    port (
        Rout : in word;
        Rin : out word;
        instruction : in DT_type;
        enable : in std_logic;
        adr: in std_logic_vector(1 downto 0);
        Min: out word;
        Mout: in word;
        MW : out std_logic_vector(3 downto 0)
    );
end pmconnect;

architecture pmconnect_arc of pmconnect is
begin

    MW <= "1111" when (enable = '1' and instruction = str) else
          "0011" when (enable = '1' and instruction = strh and adr = "00") else
          "1100" when (enable = '1' and instruction = strh and adr = "10") else
          "0001" when (enable = '1' and instruction = strb and adr = "00") else
          "0010" when (enable = '1' and instruction = strb and adr = "01") else
          "0100" when (enable = '1' and instruction = strb and adr = "10") else
          "1000" when (enable = '1' and instruction = strb and adr = "11") else
          "0000";

    Min <= Rout(15 downto 0) & Rout(15 downto 0) when instruction = strh else
           Rout(7 downto 0) & Rout(7 downto 0) & Rout(7 downto 0) & Rout(7 downto 0) when instruction = strb else
           Rout;

    Rin <= Mout when instruction = ldr else
           std_logic_vector(resize(unsigned(Mout(15 downto 0)),32)) when instruction = ldrh and adr = "00" else
           std_logic_vector(resize(unsigned(Mout(31 downto 16)),32)) when instruction = ldrh and adr = "10" else
           std_logic_vector(resize(signed(Mout(15 downto 0)),32)) when instruction = ldrsh and adr = "00" else
           std_logic_vector(resize(signed(Mout(31 downto 16)),32)) when instruction = ldrsh and adr = "10" else
           std_logic_vector(resize(unsigned(Mout(7 downto 0)),32)) when instruction = ldrb and adr = "00" else
           std_logic_vector(resize(unsigned(Mout(15 downto 8)),32)) when instruction = ldrb and adr = "01" else
           std_logic_vector(resize(unsigned(Mout(23 downto 16)),32)) when instruction = ldrb and adr = "10" else
           std_logic_vector(resize(unsigned(Mout(31 downto 24)),32)) when instruction = ldrb and adr = "11" else
           std_logic_vector(resize(signed(Mout(7 downto 0)),32)) when instruction = ldrsb and adr = "00" else
           std_logic_vector(resize(signed(Mout(15 downto 8)),32)) when instruction = ldrsb and adr = "01" else
           std_logic_vector(resize(signed(Mout(23 downto 16)),32)) when instruction = ldrsb and adr = "10" else
           std_logic_vector(resize(signed(Mout(31 downto 24)),32)) when instruction = ldrsb and adr = "11" else
           Mout;

end pmconnect_arc;