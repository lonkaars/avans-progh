library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity bin2bcd is
	generic(
		width: integer := 8);
	port(
		A: in std_logic_vector(width-1 downto 0); -- binary input (unsigned 8-bit)
		X: out std_logic_vector(3 downto 0); -- bcd output
		R: out std_logic_vector(width-1 downto 0)); -- remainder after operation
end bin2bcd;

architecture Behavioral of bin2bcd is
begin
	X <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) mod 10, 4));
	R <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) / 10, width));
end Behavioral;
