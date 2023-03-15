library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pixeldata is port(
	CLK: in std_logic; -- system clock
	RESET: in std_logic; -- async reset
	X, Y: in std_logic_vector(9 downto 0); -- pixel x/y
	NOTE_IDX: in std_logic_vector(3 downto 0);
	NOTE_WRONG: in std_logic;
	RGB: out std_logic_vector(11 downto 0)); -- RGB output color
end pixeldata;

architecture Behavioral of pixeldata is
begin
	RGB <= (others => '0');
end Behavioral;
