LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity add8b is
	port (
		A: in std_logic_vector(7 downto 0);
		B: in std_logic_vector(7 downto 0);
		Cin: in std_logic;
		X: out std_logic_vector(7 downto 0);
		Cout: out std_logic);
	-- chain of eight add1b components
end add8b;

architecture Behavioral of add8b is
  signal C0: std_logic; -- Cout0 -> Cin1
  signal C1: std_logic; -- Cout1 -> Cin2
  signal C2: std_logic; -- Cout2 -> Cin3
  signal C3: std_logic; -- Cout3 -> Cin5
  signal C4: std_logic; -- Cout4 -> Cin6
  signal C5: std_logic; -- Cout5 -> Cin7
  signal C6: std_logic; -- Cout6 -> Cin8
	component add1b 
		port (
			A: in std_logic;
			B: in std_logic;
			Cin: in std_logic;
			X: out std_logic;
			Cout: out std_logic);
	end component;
begin
	add0: component add1b
		port map (
			A => A(0),
			B => B(0),
			Cin => Cin,
			X => X(0),
			Cout => C0);
	add1: component add1b
		port map (
			A => A(1),
			B => B(1),
			Cin => C0,
			X => X(1),
			Cout => C1);
	add2: component add1b
		port map (
			A => A(2),
			B => B(2),
			Cin => C1,
			X => X(2),
			Cout => C2);
	add3: component add1b
		port map (
			A => A(3),
			B => B(3),
			Cin => C2,
			X => X(3),
			Cout => C3);
	add4: component add1b
		port map (
			A => A(4),
			B => B(4),
			Cin => C3,
			X => X(4),
			Cout => C4);
	add5: component add1b
		port map (
			A => A(5),
			B => B(5),
			Cin => C4,
			X => X(5),
			Cout => C5);
	add6: component add1b
		port map (
			A => A(6),
			B => B(6),
			Cin => C5,
			X => X(6),
			Cout => C6);
	add7: component add1b
		port map (
			A => A(7),
			B => B(7),
			Cin => C6,
			X => X(7),
			Cout => Cout);
end Behavioral;
