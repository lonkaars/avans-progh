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
				 R: std_logic_vector(7 downto 0);
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
			X: out std_logic_vector(7 downto 0));
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
			Cout => open);
	BminA: component min8b
		port map(
			A => B,
			B => A,
			Cin => '0',
			X => R_BminA,
			Cout => open);
	R_OnlyA <= A;
	R_OnlyB <= B;
	MinA: component twoc
		port map(A => A, X => R_MinA);
	MinB: component twoc
		port map(A => B, X => R_MinA);
	ShiftLeftA: component sl8b
		port map(
			A => A,
			S => B,
			X => R_ShiftLeftA);
	ShiftRightA: component sr8b
		port map(
			A => A,
			S => B,
			X => R_ShiftRightA);
	RotateLeftA: component rl8b
		port map(
			A => A,
			S => B,
			X => R_RotateLeftA);
	RotateRightA: component rr8b
		port map(
			A => A,
			S => B,
			X => R_RotateRightA);

	with Op select
		R <=
			R_AplusB       when x"0",
			R_AminB        when x"1",
			R_BminA        when x"2",
			R_Dummy        when x"3",
			R_OnlyA        when x"4",
			R_OnlyB        when x"5",
			R_MinA         when x"6",
			R_MinB         when x"7",
			R_ShiftLeftA   when x"8",
			R_ShiftRightA  when x"9",
			R_RotateLeftA  when x"a",
			R_RotateRightA when x"b",
			R_Dummy        when x"c",
			R_Dummy        when x"d",
			R_AllZeros     when x"e",
			R_AllOnes      when x"f",
			(others => '0') when others;
	eq: component eq8b
		port map(
			A => A,
			B => B,
			Equal => Equal);
	Res <= R;
	Cout <= R(7);
end Behavioral;
