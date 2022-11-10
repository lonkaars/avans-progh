library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
  port (
    A: in std_logic_vector(3 downto 0);
    B: in std_logic_vector(3 downto 0);
    Cin: in std_logic;
    D1: out std_logic_vector(6 downto 0);
    D2: out std_logic_vector(6 downto 0);
    Cout: out std_logic);
end main;

architecture Behavioral of main is
signal RESULT: std_logic_vector(3 downto 0);
signal BCD1: std_logic_vector(3 downto 0);
signal BCD2: std_logic_vector(3 downto 0);
begin
	add: entity work.add4b port map (
		A => A,
		B => B,
		Cin => Cin,
		X => RESULT,
		Cout => Cout);
	bcdconv: entity work.bin2bcd port map (
		A => RESULT,
		X => BCD1,
		Y => BCD2);
	bcddec1: entity work.bcddec port map (
		A => BCD1,
		X => D1);
	bcddec2: entity work.bcddec port map (
		A => BCD2,
		X => D2);
end Behavioral;

