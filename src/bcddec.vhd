library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcddec is port(
	A: in std_logic_vector(3 downto 0);
	X: out std_logic_vector(7 downto 0));
end bcddec;

architecture Behavioral of bcddec is
begin
	-- convert bcd to segment data
	--    0-9 = numbers
	--     10 = empty (no segments on)
	--     11 = dash or minus sign
	-- others = empty
	--
	--  segment order       number
	--   "pgfedcba"         x"num"
	X <= "00111111" when A = x"0" else
	     "00000110" when A = x"1" else
	     "01011011" when A = x"2" else
	     "01001111" when A = x"3" else
	     "01100110" when A = x"4" else
	     "01101101" when A = x"5" else
	     "01111101" when A = x"6" else
	     "00100111" when A = x"7" else
	     "01111111" when A = x"8" else
	     "01101111" when A = x"9" else
	     "00000000" when A = x"a" else
	     "01000000" when A = x"b" else
	     "00000000";
end Behavioral;

