library ieee;
use ieee.std_logic_1164.all;

entity stopp is
	port(
		A: in std_logic_vector(7 downto 0);
		X: out std_logic_vector(7 downto 0));
end stopp;

architecture Behavioral of stopp is
	component twoc
		port (
			A: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0);
			Cout: out std_logic);
	end component;
	signal ntop: std_logic_vector(7 downto 0);
begin
	inv: component twoc
		port map(A => A, X => ntop);
	X <= ntop when A(7) = '1' else A;
end Behavioral;
