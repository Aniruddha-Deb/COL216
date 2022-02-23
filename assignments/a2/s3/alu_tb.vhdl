library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end alu_tb;

architecture alu_tb_arc of alu_tb is

    signal shift_op: std_logic_vector(31 downto 0);
    signal op: std_logic_vector(31 downto 0); 
    signal carry_in: std_logic;
    signal opcode: std_logic_vector(3 downto 0);
    signal carry_out: std_logic;
    signal ans: std_logic_vector(31 downto 0);

begin

    uut: entity work.alu port map (shift_op, op, carry_in, opcode, carry_out, ans);

    test: process
    begin
        -- and test
        opcode <= "0000";
        carry_in <= '0';
        op <= x"000000FE";
        shift_op <= x"0000000F";
        wait for 0 ns;
        assert ans = x"0000000E" report "and passed" severity note;
        wait for 2 ns;

        -- eor test
        opcode <= "0001";
        carry_in <= '0';
        op <= x"000000FE";
        shift_op <= x"0000000F";
        wait for 0 ns;
        assert ans = x"00000001" report "eor passed" severity note;
        wait for 2 ns;

        -- sub test
        opcode <= "0010";
        carry_in <= '0';
        op <= x"000000FF";
        shift_op <= x"0000000F";
        wait for 0 ns;
        assert ans = x"000000F0" report "sub passed" severity note;
        wait for 2 ns;

        -- rsb test
        opcode <= "0011";
        carry_in <= '0';
        op <= x"000000F0";
        shift_op <= x"000000FF";
        wait for 0 ns;
        assert ans = x"0000000F" report "rsb passed" severity note;
        wait for 2 ns;

        -- add test
        opcode <= "0100";
        carry_in <= '0';
        op <= x"00000F00";
        shift_op <= x"000000EE";
        wait for 0 ns;
        assert ans = x"00000FEE" report "add passed" severity note;
        wait for 2 ns;

        -- check carry in add
        opcode <= "0100";
        carry_in <= '0';
        op <= x"FFFFFFFF";
        shift_op <= x"00000001";
        wait for 0 ns;
        assert (ans = x"00000000" and carry_out='1') report "add carry check passed" severity note;
        wait for 2 ns;

        -- adc check
        opcode <= "0101";
        carry_in <= '1';
        op <= x"000000FE";
        shift_op <= x"00000000";
        wait for 0 ns;
        assert ans = x"000000FF" report "adc passed" severity note;
        wait for 2 ns;

        -- sbc check
        opcode <= "0110";
        carry_in <= '0';
        op <= x"000000FF";
        shift_op <= x"0000000E";
        wait for 0 ns;
        assert ans = x"000000F0" report "sbc passed" severity note;
        wait for 2 ns;

        -- rsc check
        opcode <= "0111";
        carry_in <= '0';
        op <= x"0000000E";
        shift_op <= x"000000FF";
        wait for 0 ns;
        assert ans = x"000000F0" report "rsc passed" severity note;
        wait for 2 ns;

        -- tst check (same as AND)
        opcode <= "1000";
        carry_in <= '0';
        op <= x"000000FE";
        shift_op <= x"0000000F";
        wait for 0 ns;
        assert ans = x"0000000E" report "tst passed" severity note;
        wait for 2 ns;

        -- teq test (same as EOR)
        opcode <= "1001";
        carry_in <= '0';
        op <= x"000000FE";
        shift_op <= x"0000000F";
        wait for 0 ns;
        assert ans = x"00000001" report "teq passed" severity note;
        wait for 2 ns;

        -- cmp test (same as sub)
        opcode <= "1010";
        carry_in <= '0';
        op <= x"000000FF";
        shift_op <= x"0000000F";
        wait for 0 ns;
        assert ans = x"000000F0" report "cmp passed" severity note;
        wait for 2 ns;

        -- cmn test (same as add)
        opcode <= "1011";
        carry_in <= '0';
        op <= x"00000F00";
        shift_op <= x"000000EE";
        wait for 0 ns;
        assert ans = x"00000FEE" report "cmn passed" severity note;
        wait for 2 ns;

        -- orr test 
        opcode <= "1100";
        carry_in <= '0';
        op <= x"0000FF00";
        shift_op <= x"000000EE";
        wait for 0 ns;
        assert ans = x"0000FFEE" report "orr passed" severity note;
        wait for 2 ns;

        -- mov test 
        opcode <= "1101";
        carry_in <= '0';
        op <= x"0000FF00";
        shift_op <= x"000000EE";
        wait for 0 ns;
        assert ans = x"000000EE" report "mov passed" severity note;
        wait for 2 ns;

        -- bic test 
        opcode <= "1110";
        carry_in <= '0';
        op <= x"0000FF00";
        shift_op <= x"0000FF00";
        wait for 0 ns;
        assert ans = x"00000000" report "bic passed" severity note;
        wait for 2 ns;

        -- mvn test 
        opcode <= "1111";
        carry_in <= '0';
        op <= x"0000FF00";
        shift_op <= x"0000FF00";
        wait for 0 ns;
        assert ans = x"FFFF00FF" report "mvn passed" severity note;
        wait for 2 ns;

    end process test;

end alu_tb_arc;