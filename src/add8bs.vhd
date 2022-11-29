LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity add8bs is
	port (
		A, B: in std_logic_vector(7 downto 0);
		Cin: in std_logic;
		X: out std_logic_vector(7 downto 0);
		Cout: out std_logic);
end add8bs;

architecture Behavioral of add8bs is
  signal C: std_logic; -- Cout0 -> Cin1
	component add8b 
		port (
			A, B: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
			Cout: out std_logic);
	end component;
	component add1b 
		port (
			A, B, Cin: in std_logic;
			X, Cout: out std_logic);
	end component;
begin
	-- add8b (signed)
	-- add first eight bits normally
	add0: component add8b
		port map (
			A => A,
			B => B,
			Cin => Cin,
			X => X,
			Cout => C);
	-- extend signed (two's complement) number to 9-bits
	add1: component add1b
		port map (
			A => A(7),
			B => B(7),
			Cin => C,
			X => Cout,
			Cout => open);
end Behavioral;
