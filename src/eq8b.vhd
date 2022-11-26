LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity eq8b is
	port (
		A: in std_logic_vector(7 downto 0);
		B: in std_logic_vector(7 downto 0);
		Equal: out std_logic);
end eq8b;

architecture Behavioral of eq8b is
	signal X: std_logic_vector(7 downto 0); -- XOR temp
begin
	X <= (A xor B); -- bitwise and
	Equal <= not (X(0) or X(1) or X(2) or X(3) or X(4) or X(5) or X(6) or X(7)); -- nor all bits
end Behavioral;
