library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin2bcd is port(
	I: in std_logic_vector(4 downto 0);
	X: out std_logic_vector(3 downto 0);
	Y: out std_logic_vector(3 downto 0));
end bin2bcd;

architecture Behavioral of bin2bcd is
begin
	with I select
		X <=
			b"0000" when b"00000" | b"01010" | b"10100" | b"11110",
			b"0001" when b"00001" | b"01011" | b"10101" | b"11111",
			b"0010" when b"00010" | b"01100" | b"10110",
			b"0011" when b"00011" | b"01101" | b"10111",
			b"0100" when b"00100" | b"01110" | b"11000",
			b"0101" when b"00101" | b"01111" | b"11001",
			b"0110" when b"00110" | b"10000" | b"11010",
			b"0111" when b"00111" | b"10001" | b"11011",
			b"1000" when b"01000" | b"10010" | b"11100",
			b"1001" when b"01001" | b"10011" | b"11101",
			(others => '0') when others;
	with I select
		Y <=
			b"0000" when b"00000" | b"00001" | b"00010" | b"00011" | b"00100" | b"00101" | b"00110" | b"00111" | b"01000" | b"01001",
			b"0001" when b"01010" | b"01011" | b"01100" | b"01101" | b"01110" | b"01111" | b"10000" | b"10001" | b"10010" | b"10011",
			b"0010" when b"10100" | b"10101" | b"10110" | b"10111" | b"11000" | b"11001" | b"11010" | b"11011" | b"11100" | b"11101",
			b"0011" when b"11110" | b"11111",
			(others => '0') when others;
end Behavioral;

