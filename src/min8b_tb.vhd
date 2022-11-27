library ieee;
library unisim;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use unisim.vcomponents.all;

entity min8b_tb is
end min8b_tb;

architecture behavioral of min8b_tb is
	component min8b
		port (
			A: in std_logic_vector(7 downto 0);
			B: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
			Cout: out std_logic);
	end component;
	signal A: std_logic_vector(7 downto 0);
	signal B: std_logic_vector(7 downto 0);
	signal Cin: std_logic;
	signal test_case: std_logic_vector(7 downto 0) := (others => '0');
	signal Cout: std_logic;
	signal OK: boolean := true;
begin
	UUT: component twoc
		port map(
			A => A,
			X => X);

	tb: process
		variable temp: std_logic_vector(8 downto 0);
	begin
		Cin <= '0';
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
