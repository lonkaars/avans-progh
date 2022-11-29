LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity sr8b is
	port (
		A, S: in std_logic_vector(7 downto 0);
		X: out std_logic_vector(7 downto 0));
	-- X = A >> S;
end sr8b;

architecture Behavioral of sr8b is
begin
	X <= std_logic_vector(shift_right(unsigned(A), natural(to_integer(unsigned(S)))));
end Behavioral;
