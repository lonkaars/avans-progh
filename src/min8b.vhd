LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity min8b is
	port (
		A, B: in std_logic_vector(7 downto 0);
		Cin: in std_logic;
		X: out std_logic_vector(7 downto 0);
		Cout: out std_logic);
end min8b;

architecture Behavioral of min8b is
	signal Bmin: std_logic_vector(7 downto 0);
  signal Bcom: std_logic;
  signal carry: std_logic;
	component twoc
		port (
			A: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
      Cout: out std_logic);
	end component;
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
	complement: component twoc
		port map (
			A => B,
			Cin => B(7),
			X => Bmin,
      Cout => Bcom);
	add8: component add8b
		port map (
			A => A,
			B => Bmin,
			Cin => Cin,
			X => X,
			Cout => carry);
  add1: component add1b
    port map(
      A => A(7),
      B => Bcom,
      Cin => carry,
      X => Cout,
      Cout => open);
end Behavioral;
