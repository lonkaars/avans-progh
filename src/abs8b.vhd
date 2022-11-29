library ieee;
use ieee.std_logic_1164.all;

entity abs8b is
	port(
		A: in std_logic_vector(8 downto 0);
		X: out std_logic_vector(8 downto 0));
end abs8b;

architecture Behavioral of abs8b is
	component twoc
		port (
			A: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
      Cout: out std_logic);
	end component;
	signal ntop: std_logic_vector(8 downto 0);
begin
	-- calculate two's complement for A (A * -1)
	inv: component twoc
		port map(
			A => A(7 downto 0),
			Cin => A(8),
			X => ntop(7 downto 0),
			Cout => ntop(8));
	-- output -A if A < 0 else A
	X <= ntop when A(8) = '1' else A;
end Behavioral;
