library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
	port(
		CLK: in std_logic; -- clk for display refresh
		A: in std_logic_vector(3 downto 0); -- adder A input
		B: in std_logic_vector(3 downto 0); -- adder B input
		DD: out std_logic_vector(7 downto 0); -- display segment data
		DS: out std_logic_vector(3 downto 0)); -- display select
end main;

architecture Behavioral of main is
	component add4b
		port (
			A: in std_logic_vector(3 downto 0);
			B: in std_logic_vector(3 downto 0);
			Cin: in std_logic;
			X: out std_logic_vector(3 downto 0);
			Cout: out std_logic);
	end component;
	component bin2bcd
		port (
			I: in std_logic_vector(4 downto 0);
			X: out std_logic_vector(3 downto 0);
			Y: out std_logic_vector(3 downto 0));
	end component;
	component bcd2disp
		port (
			CLK: in std_logic;
			N0: in std_logic_vector(3 downto 0);
			N1: in std_logic_vector(3 downto 0);
			N2: in std_logic_vector(3 downto 0);
			N3: in std_logic_vector(3 downto 0);
			DD: out std_logic_vector(7 downto 0);
			DS: out std_logic_vector(3 downto 0));
	end component;
	signal X: std_logic_vector(3 downto 0); -- add out
	signal Cout: std_logic; -- carry out
	signal AOW: std_logic_vector(4 downto 0); -- add out wide (5-bit)
	signal BCD0: std_logic_vector(3 downto 0); -- bcd 10^0
	signal BCD1: std_logic_vector(3 downto 0); -- bcd 10^1
	signal CLK_T: std_logic_vector(18 downto 0); -- clock counter for display clock
begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			CLK_T <= (CLK_T + 1);
		end if;
	end process;
	add: component add4b
		port map (
			A => A,
			B => B,
			Cin => '0',
			X => X,
			Cout => Cout);
  AOW <= Cout & X;
	bcd: component bin2bcd
		port map (
			I => AOW,
			X => BCD0,
			Y => BCD1);
	disp: component bcd2disp
		port map (
			CLK => CLK_T(18),
			N0 => "0000",
			N1 => "0000",
			N2 => BCD1,
			N3 => BCD0,
			DD => DD,
			DS => DS);
end Behavioral;

