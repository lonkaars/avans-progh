library ieee;
library unisim;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;

entity add4b_tb is
end add4b_tb;

architecture behavioral of add4b_tb is component add4b
	port (
		A: in std_logic_vector(3 downto 0);
		B: in std_logic_vector(3 downto 0);
		Cin: in std_logic;
		X: out std_logic_vector(3 downto 0);
		Cout: out std_logic);
end component;

signal A: std_logic_vector(3 downto 0);
signal B: std_logic_vector(3 downto 0);
signal S: std_logic_vector(3 downto 0);
signal C_out	:	STD_LOGIC;
signal C_in  :	STD_LOGIC;
signal Test_case: STD_LOGIC_VECTOR (7 downto 0):= (others =>'0');
signal OK: boolean := true;

begin
	UUT: add4b port map(
		A => A,
		B => B,
		X => S,
		Cout => C_out,
		Cin => C_in);

	tb: process
		variable S0_t	:	STD_LOGIC;
		variable S1_t	:	STD_LOGIC;
		variable S2_t	:	STD_LOGIC;
		variable S3_t	:	STD_LOGIC;
		variable C_out_t	:	STD_LOGIC;
		variable A_t : integer;
		variable B_t : integer;
		variable sum : integer;

	begin
		C_in <= '0'; -- C_in is ignored in this test
		for I in 0 to 255 loop

			Test_case <= Std_logic_vector(to_unsigned(I,8));
			wait for 1 ps;
			A(0) <= Test_case(0);
			A(1) <= Test_case(1);
			A(2) <= Test_case(2);
			A(3) <= Test_case(3);
			B(0) <= Test_case(4);
			B(1) <= Test_case(5);
			B(2) <= Test_case(6);
			B(3) <= Test_case(7);

			A_t := To_integer(unsigned(test_case(3 downto 0)));
			B_t := To_integer(unsigned(test_case(7 downto 4)));
			sum := A_t+B_t;

			S0_t := to_unsigned(sum,5)(0);
			S1_t := to_unsigned(sum,5)(1);
			S2_t := to_unsigned(sum,5)(2);
			S3_t := to_unsigned(sum,5)(3);
			C_out_t := to_unsigned(sum,5)(4);

			wait for 5 ns;
			If S(0) /= S0_t then
				OK <= false;
			end if;
			if S(1) /= S1_t then
				OK <= false;
			end if;
			if S(2) /= S2_t then
				OK <= false;
			end if;
			if S(3) /= S3_t then
				OK <= false;
			end if;
			if C_out /= C_out_t then
				OK <= false;
			end if;
			wait for 5 ns;
		end loop;
		wait; -- stop for simulator
	end process;
end;
