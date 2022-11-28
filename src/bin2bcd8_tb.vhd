library ieee;
library unisim;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;

entity bin2bcd8_tb is 
end bin2bcd8_tb;

architecture Behavioral of bin2bcd8_tb is
component bin2bcd8 port(
	A: in std_logic_vector(7 downto 0); -- binary input (unsigned 8-bit)
	X: out std_logic_vector(3 downto 0); -- bcd output
	R: out std_logic_vector(7 downto 0)); -- remainder after operation
end component;
-- test input
signal I: std_logic_vector(7 downto 0) := (others => '0');
-- test output
signal X: std_logic_vector(3 downto 0);
signal R: std_logic_vector(7 downto 0);

signal test_case: std_logic_vector(7 downto 0);
signal OK: boolean := true;
begin
	test: bin2bcd8 port map(
		A => I,
		X => X,
		R => R);

	tb: process
		-- expected output
		variable X_t: integer := 0;
		variable Y_t: integer := 0;
	begin
	
	for test_i in 0 to 255 loop
		test_case <= std_logic_vector(to_unsigned(test_i,8));
		wait for 1 ps;

		I <= test_case;

		wait for 10 ns;
	end loop;
	wait; -- stop simulator
	end process;
end Behavioral;

