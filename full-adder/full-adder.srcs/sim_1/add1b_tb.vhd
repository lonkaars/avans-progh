library ieee;
library unisim;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;

entity add1b_tb is
end add1b_tb;

architecture behavioral of add1b_tb is
component add1b
port (
	A: in std_logic;
	B: in std_logic;
	Cin: in std_logic;
	X: out std_logic;
	Cout: out std_logic);
end component;

signal A: std_logic;
signal B: std_logic;
signal Cin: std_logic;
signal X: std_logic;
signal Cout: std_logic;
signal test_case: std_logic_vector(2 downto 0);
signal ok: boolean := true;

begin
	test_port: add1b port map(
		A => A,
		B => B,
		X => X,
		Cout => Cout,
		Cin => Cin);

	tb: process
		variable A_t: std_logic;
		variable B_t: std_logic;
		variable Cin_t: std_logic;
		variable X_t: std_logic;
		variable Cout_t: std_logic;
		variable Out_t: std_logic_vector(1 downto 0);

	begin
		for i in 0 to 7 loop
			test_case <= std_logic_vector(to_unsigned(i,3));
			wait for 1 ps;
	
			A <= test_case(0);
			B <= test_case(1);
			Cin <= test_case(2);

			A_t := test_case(0);
			B_t := test_case(1);
			Cin_t := test_case(2);

			X_t := A_t xor B_t xor Cin_t;
			Cout_t := (A_t and B_t) or (B_t and Cin_t) or (Cin_t and A_t);

			wait for 5 ns;
			If X /= X_t then
				OK <= false;
			end if;
			if Cout /= Cout_t then
				OK <= false;
			end if;
			wait for 5 ns;
		end loop;
		wait; -- stop for simulator
	end process;
end;
