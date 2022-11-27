library ieee;
library unisim;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;

entity twoc_tb is
end twoc_tb;

architecture behavioral of twoc_tb is
	component twoc
		port (
			A: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	signal A: std_logic_vector(7 downto 0);
	signal X: std_logic_vector(7 downto 0);
	signal test_case: std_logic_vector(7 downto 0) := (others => '0');
	signal OK: boolean := true;
begin
	UUT: component twoc
		port map(
			A => A,
			X => X);

	tb: process
		variable X_t: integer;

	begin
		for i in 0 to 255 loop
			test_case <= std_logic_vector(to_unsigned(i,8));
			wait for 1 ps;
			A <= test_case;

			X_t := -i;

			wait for 5 ns;
			if to_signed(X_t, 8) /= signed(X) then
				OK <= false;
			end if;
			wait for 5 ns;
		end loop;
		wait; -- stop for simulator
	end process;
end;
