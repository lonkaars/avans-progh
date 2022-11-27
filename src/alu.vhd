LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ALU is
	port (
		A, B: in std_logic_vector(7 downto 0);
		Op: in std_logic_vector(3 downto 0);
		Res: out std_logic_vector(7 downto 0);
		Cout, Equal: out std_logic);
end ALU;

architecture Behavioral of ALU is
	signal R_AplusB,
	       R_AminB,
				 R_BminA,
				 R_Dummy,
				 R_OnlyA,
				 R_OnlyB,
				 R_MinA,
				 R_MinB,
				 R_ShiftLeftA,
				 R_ShiftRightA,
				 R_RotateLeftA,
				 R_RotateRightA,
				 R_AllZeros,
				 R_AllOnes,
				 R: std_logic_vector(7 downto 0) := (others => '0');
	signal C_AMinB, C_BMinA, C_MinA, C_MinB: std_logic := '0'; -- Minus carry out (test bench edge case)
	component add8b is
		port (
			A: in std_logic_vector(7 downto 0);
			B: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
			Cout: out std_logic);
	end component;
	component min8b is
		port (
			A: in std_logic_vector(7 downto 0);
			B: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
			Cout: out std_logic);
	end component;
	component twoc is
		port (
			A: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0);
      Cout: out std_logic);
	end component;
	component sl8b is
		port (
			A, S: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	component sr8b is
		port (
			A, S: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	component rl8b is
		port (
			A, S: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	component rr8b is
		port (
			A, S: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	component eq8b is
		port (
			A: in std_logic_vector(7 downto 0);
			B: in std_logic_vector(7 downto 0);
			Equal: out std_logic);
	end component;
begin
	R_Dummy <= x"00";
	R_AllOnes <= x"ff";
	R_AllZeros <= x"00";

	AplusB: component add8b
		port map(
			A => A,
			B => B,
			Cin => '0',
			X => R_AplusB,
			Cout => open);
	AminB: component min8b
		port map(
			A => A,
			B => B,
			Cin => '0',
			X => R_AminB,
			Cout => C_AMinB);
	BminA: component min8b
		port map(
			A => B,
			B => A,
			Cin => '0',
			X => R_BminA,
			Cout => C_BMinA);
	R_OnlyA <= A;
	R_OnlyB <= B;
	MinA: component twoc
		port map(
      A => A,
      X => R_MinA,
      Cout => C_MinA);
	MinB: component twoc
		port map(
      A => B,
      X => R_MinB,
      Cout => C_MinB);
	ShiftLeftA: component sl8b
		port map(
			A => A,
			S => x"01",
			X => R_ShiftLeftA);
	ShiftRightA: component sr8b
		port map(
			A => A,
			S => x"01",
			X => R_ShiftRightA);
	RotateLeftA: component rl8b
		port map(
			A => A,
			S => x"01",
			X => R_RotateLeftA);
	RotateRightA: component rr8b
		port map(
			A => A,
			S => x"01",
			X => R_RotateRightA);

	with Op select
		R <=
			R_AplusB       when x"0", -- AplusB
			R_AminB        when x"1", -- AminB
			R_BminA        when x"2", -- BminA
			R_Dummy        when x"3", -- Dummy
			R_OnlyA        when x"4", -- OnlyA
			R_OnlyB        when x"5", -- OnlyB
			R_MinA         when x"6", -- MinA
			R_MinB         when x"7", -- MinB
			R_ShiftLeftA   when x"8", -- ShiftLeftA
			R_ShiftRightA  when x"9", -- ShiftRightA
			R_RotateLeftA  when x"a", -- RotateLeftA
			R_RotateRightA when x"b", -- RotateRightA
			R_Dummy        when x"c", -- Dummy
			R_Dummy        when x"d", -- Dummy
			R_AllZeros     when x"e", -- AllZeros
			R_AllOnes      when x"f", -- AllOnes
			(others => '0') when others;
	with Op select
		Cout <=
			R(7) when x"0" | x"3" | x"c" | x"d", -- AplusB, MinA, MinB, Dummy
			C_AMinB when x"1", -- AminB
			C_BMinA when x"2", -- BminA
			A(7) when x"4" | x"8" | x"a", -- OnlyA, ShiftLeftA, RotateLeftA
			B(7) when x"5", -- OnlyB
      C_MinA when x"6", -- MinA TODO FIX
      C_MinB when x"7", -- MinB TODO FIX
			'0'  when x"9" | x"b" | x"e", -- ShiftRightA, RotateRightA, AllZeros
			'1'  when x"f", -- AllOnes
			'0' when others;
	eq: component eq8b
		port map(
			A => A,
			B => B,
			Equal => Equal);
	Res <= R;
end Behavioral;
