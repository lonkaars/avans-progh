LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity rr8b is
	port (
		A, S: in std_logic_vector(7 downto 0);
		X: out std_logic_vector(7 downto 0));
end rr8b;

architecture Behavioral of rr8b is
	signal s_val: std_logic_vector(7 downto 0); -- shift value
	component rl8b
		port (
			A, S: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	component min8b
		port (
			A: in std_logic_vector(7 downto 0);
			B: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
			Cout: out std_logic);
	end component;
begin
	calc_val: component min8b
		port map(
			A => x"08",
			B => S,
			Cin => '0',
			X => s_val,
			Cout => open);
	rotate: component rl8b
		port map(
			A => A,
			S => s_val,
			X => X);
	-- this rotate-shifts using rotate right
	-- C expressions with same functionality:
	-- (uint8_t) X = (A << (8-S)) | (A >> S);
	-- X = rotateLeft(A, 8-S);
end Behavioral;
