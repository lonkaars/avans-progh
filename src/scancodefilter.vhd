library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity scancodefilter is port(
	CLK: in std_logic; -- system clock
	DAT: in std_logic_vector(7 downto 0); -- scancode input
	NEW_DAT: in std_logic; -- new scancode input
	BCD: out std_logic_vector(3 downto 0); -- bcd digit 0-9 or dash (0xB) for keypress
	SHIFT: out std_logic); -- shift display (1 for one clock cycle per key down press)
end scancodefilter;

architecture Behavioral of scancodefilter is

begin


end Behavioral;
