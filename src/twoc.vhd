LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity twoc is
	port (
		A: in std_logic_vector(7 downto 0);
		Cin: in std_logic;
		X: out std_logic_vector(7 downto 0);
    Cout: out std_logic);
end twoc;

architecture Behavioral of twoc is
	signal NA: std_logic_vector(7 downto 0); -- not A
	signal NC: std_logic; -- not Cin
	signal C: std_logic; -- carry from 8-bit adder to 1-bit adder
	component add8b is
		port (
			A, B: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
			Cout: out std_logic);
	end component;
	component add1b is
		port (
			A, B: in std_logic;
			Cin: in std_logic;
			X: out std_logic;
			Cout: out std_logic);
	end component;
begin
	NA <= not A; -- invert A
	NC <= not Cin; -- invert Cin

	add1: component add8b -- add one
		port map (
			A => NA,
			B => x"01",
			Cin => '0',
			X => X,
      Cout => C);
	add2: component add1b -- sign bit
		port map (
			A => NC,
			B => '0',
			Cin => C,
			X => Cout,
      Cout => open);
end Behavioral;
