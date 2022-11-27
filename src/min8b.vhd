LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity min8b is
	port (
		A: in std_logic_vector(7 downto 0);
		B: in std_logic_vector(7 downto 0);
		Cin: in std_logic;
		X: out std_logic_vector(7 downto 0);
		Cout: out std_logic);
end min8b;

architecture Behavioral of min8b is
	signal Bmin: std_logic_vector(7 downto 0);
	component twoc
		port (
			A: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	component add8b
		port (
			A: in std_logic_vector(7 downto 0);
			B: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
			Cout: out std_logic);
	end component;
begin
	complement: component twoc
		port map (
			A => B,
			X => Bmin);
	add: component add8b
		port map (
			A => A,
			B => Bmin,
			Cin => Cin,
			X => X,
			Cout => Cout);
end Behavioral;
