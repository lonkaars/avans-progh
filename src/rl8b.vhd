LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity rl8b is
	port (
		A, S: in std_logic_vector(7 downto 0);
		X: out std_logic_vector(7 downto 0));
end rl8b;

architecture Behavioral of rl8b is
	signal sr_val: std_logic_vector(7 downto 0); -- shift right value
	signal part_l, part_r: std_logic_vector(7 downto 0); -- left and right part of cylinder
	component sl8b
		port (
			A, S: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	component sr8b
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
	calc_sr_val: component min8b
		port map(
			A => x"08",
			B => S,
			Cin => '0',
			X => sr_val,
			Cout => open);
	left: component sl8b
		port map(
			A => A,
			S => S,
			X => part_l);
	right: component sr8b
		port map(
			A => A,
			S => sr_val,
			X => part_r);
	X <= part_l or part_r;
	-- this rotate-shifts using two bitshifts
	-- C expression with same functionality:
	-- (uint8_t) X = (A << S) | (A >> (8-S));
end Behavioral;
