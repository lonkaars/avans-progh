library ieee;
library unisim;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;

entity bin2bcd_tb is 
end bin2bcd_tb;

architecture Behavioral of bin2bcd_tb is
component bin2bcd port(
	I: in std_logic_vector(4 downto 0);
	X: out std_logic_vector(3 downto 0);
	Y: out std_logic_vector(3 downto 0));
end component;
-- test input
signal I: std_logic_vector(4 downto 0) := (others => '0');
-- test output
signal X: std_logic_vector(3 downto 0);
signal Y: std_logic_vector(3 downto 0);

signal test_case: std_logic_vector(4 downto 0);
signal OK: boolean := true;
begin
	test: bin2bcd port map(
		I => I,
		X => X,
		Y => Y);

	tb: process
		variable I_t: integer := 0;
		-- expected output
		variable X_t: integer := 0;
		variable Y_t: integer := 0;
	begin
	
	for test_i in 0 to 31 loop
		test_case <= std_logic_vector(to_unsigned(test_i,5));
		wait for 1 ps;

		I <= test_case;
		I_t := test_i;

		case I_t is
			when 0 | 10 | 20 | 30 => X_t := 0;
			when 1 | 11 | 21 | 31 => X_t := 1;
			when 2 | 12 | 22  => X_t := 2;
			when 3 | 13 | 23  => X_t := 3;
			when 4 | 14 | 24  => X_t := 4;
			when 5 | 15 | 25  => X_t := 5;
			when 6 | 16 | 26  => X_t := 6;
			when 7 | 17 | 27  => X_t := 7;
			when 8 | 18 | 28  => X_t := 8;
			when 9 | 19 | 29  => X_t := 9;
			when others => X_t := 0;
		end case;
		case I_t is
			when 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 => Y_t := 0;
			when 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 => Y_t := 1;
			when 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 => Y_t := 2;
			when 30 | 31 => Y_t := 3;
			when others => Y_t := 0;
		end case;

		wait for 5 ns;

		if X /= std_logic_vector(to_unsigned(X_t,4)) then
			OK <= false;
		end if;
		if Y /= std_logic_vector(to_unsigned(Y_t,4)) then
			OK <= false;
		end if;

		wait for 5 ns;
	end loop;
	wait; -- stop simulator
	end process;
end Behavioral;

