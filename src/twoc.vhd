LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity twoc is
	port (
		A: in std_logic_vector(7 downto 0);
		X: out std_logic_vector(7 downto 0));
end twoc;

architecture Behavioral of twoc is
	signal NA: std_logic_vector(7 downto 0); -- not A
	component add8b is
		port (
			A: in std_logic_vector(7 downto 0);
			B: in std_logic_vector(7 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(7 downto 0);
			Cout: out std_logic);
	end component;
begin
	NA <= not A; -- invert A
	add: component add8b -- add one
		port map (
			A => NA,
			B => "00000001",
			Cin => '0',
			X => X);
end Behavioral;
