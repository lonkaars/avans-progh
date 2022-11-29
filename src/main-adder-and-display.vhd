library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity main is
	port(
		CLK: in std_logic; -- clk for display refresh
		A: in std_logic_vector(3 downto 0); -- adder A input
		B: in std_logic_vector(3 downto 0); -- adder B input
		Cin: in std_logic;
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
		generic(
			width: integer := 5);
		port(
			A: in std_logic_vector(width-1 downto 0); -- binary input (unsigned 8-bit)
			X: out std_logic_vector(3 downto 0); -- bcd output
			R: out std_logic_vector(width-1 downto 0)); -- remainder after operation
	end component;
	component bcd2disp
		port (
			CLK: in std_logic;
			N0, N1, N2, N3: in std_logic_vector(3 downto 0);
			DD: out std_logic_vector(7 downto 0);
			DS: out std_logic_vector(3 downto 0));
	end component;
	signal X: std_logic_vector(3 downto 0); -- add out
	signal Cout: std_logic; -- carry out
	signal AOW, BCDC: std_logic_vector(4 downto 0); -- add out wide and bin2bcd carry (5-bit)
	signal BCD0: std_logic_vector(3 downto 0); -- bcd 10^0
	signal BCD1: std_logic_vector(3 downto 0); -- bcd 10^1
	signal CLK_T: std_logic_vector(16 downto 0); -- clock counter for display clock
	-- clock period = (2 << 16) / 100_000_000 = 1.31 ms per display / 5.24 ms full refresh
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
			Cin => Cin,
			X => X,
			Cout => Cout);
  AOW <= Cout & X;
	bcdd0: component bin2bcd
		port map (
			A => AOW,
			X => BCD0,
			R => BCDC);
	bcdd1: component bin2bcd
		port map (
			A => BCDC,
			X => BCD1,
			R => open);
	disp: component bcd2disp
		port map (
			CLK => CLK_T(16),
			N0 => x"a", -- empty
			N1 => x"a", -- empty
			N2 => BCD1,
			N3 => BCD0,
			DD => DD,
			DS => DS);
end Behavioral;

