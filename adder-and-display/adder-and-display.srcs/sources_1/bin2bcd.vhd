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
			x"0" when x"00" | x"0a" | x"14" | x"1e",
			x"1" when x"01" | x"0b" | x"15" | x"1f",
			x"2" when x"02" | x"0c" | x"16",
			x"3" when x"03" | x"0d" | x"17",
			x"4" when x"04" | x"0e" | x"18",
			x"5" when x"05" | x"0f" | x"19",
			x"6" when x"06" | x"10" | x"1a",
			x"7" when x"07" | x"11" | x"1b",
			x"8" when x"08" | x"12" | x"1c",
			x"9" when x"09" | x"13" | x"1d",
			(others => '0') when others;
	with I select
		Y <=
			x"0" when x"00" | x"01" | x"02" | x"03" | x"04" | x"05" | x"06" | x"07" | x"08" | x"09",
			x"1" when x"0a" | x"0b" | x"0c" | x"0d" | x"0e" | x"0f" | x"10" | x"11" | x"12" | x"13",
			x"2" when x"14" | x"15" | x"16" | x"17" | x"18" | x"19" | x"1a" | x"1b" | x"1c" | x"1d",
			x"3" when x"1e" | x"1f",
			(others => '0') when others;
end Behavioral;

