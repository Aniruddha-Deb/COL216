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
begin -- TODO lot more prediction conditions
    p <= '1' when (condition = "0000" and flags(cpsr_Z) = '1') else
         '1' when (condition = "0001" and flags(cpsr_Z) = '0') else
         '1' when condition = "1110" else
         '0';
end predicator_arc;
