LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity sl8b is
	port (
		A, S: in std_logic_vector(7 downto 0);
		X: out std_logic_vector(7 downto 0));
end sl8b;

architecture Behavioral of sl8b is
begin
	X <= std_logic_vector(shift_left(unsigned(A), 1));
end Behavioral;
