library ieee;
use ieee.std_logic_1164.all;
use work.MyTypes.all;

entity predicator is
    port (
        condition: in std_logic_vector(3 downto 0);
        flags: in std_logic_vector(3 downto 0);
        p: out std_logic
    );
end predicator;

architecture predicator_arc of predicator is
begin
    p <= '1' when (condition = "0000" and flags(cpsr_Z) = '1') else
         '1' when (condition = "0001" and flags(cpsr_Z) = '0') else
         '1' when (condition = "0010" and flags(cpsr_C) = '1') else
         '1' when (condition = "0011" and flags(cpsr_C) = '0') else
         '1' when (condition = "0100" and flags(cpsr_N) = '1') else
         '1' when (condition = "0101" and flags(cpsr_N) = '0') else
         '1' when (condition = "0110" and flags(cpsr_V) = '1') else
         '1' when (condition = "0111" and flags(cpsr_V) = '0') else
         '1' when (condition = "1000" and flags(cpsr_C) = '1' and flags(cpsr_Z) = '0')  else
         '1' when (condition = "1001" and (flags(cpsr_C) = '0' or flags(cpsr_Z) = '1')) else
         '1' when (condition = "1010" and flags(cpsr_N) = flags(cpsr_V)) else
         '1' when (condition = "1011" and flags(cpsr_N) /= flags(cpsr_V)) else
         '1' when (condition = "1100" and flags(cpsr_Z) = '0' and flags(cpsr_N) = flags(cpsr_V)) else
         '1' when (condition = "1101" and not (flags(cpsr_Z) = '0' and flags(cpsr_N) = flags(cpsr_V))) else
         '1' when (condition = "1110") else
         '0';
end predicator_arc;
