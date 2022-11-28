library ieee;
use ieee.std_logic_1164.all;

entity stopp is
	port(
		A: in std_logic_vector(8 downto 0);
		X: out std_logic_vector(8 downto 0));
end stopp;

architecture Behavioral of stopp is
	component twoc
		port (
			A: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
      Cout: out std_logic);
	end component;
	signal ntop: std_logic_vector(8 downto 0);
begin
	inv: component twoc
		port map(
			A => A(7 downto 0),
			Cin => A(8),
			X => ntop(7 downto 0),
			Cout => ntop(8));
	X <= ntop when A(8) = '1' else A;
end Behavioral;
