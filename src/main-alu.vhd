library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity main is
	port(
		A, B: in std_logic_vector(7 downto 0);
		Op: in std_logic_vector(3 downto 0);
		CLK: in std_logic;
		DD: out std_logic_vector(7 downto 0);
		DS: out std_logic_vector(3 downto 0);
		EQ: out std_logic);
end main;

architecture Behavioral of main is
	component ALU
		port (
			A, B: in std_logic_vector(7 downto 0);
			Op: in std_logic_vector(3 downto 0);
			Res: out std_logic_vector(7 downto 0);
			Cout, Equal: out std_logic);
	end component;
	component abs8b
		port(
			A: in std_logic_vector(8 downto 0);
			X: out std_logic_vector(8 downto 0));
	end component;
	component bin2bcd
		generic(
			width: integer := 9);
		port(
			A: in std_logic_vector(width-1 downto 0);
			X: out std_logic_vector(3 downto 0);
			R: out std_logic_vector(width-1 downto 0));
	end component;
	component bcd2disp
		port(
			CLK: in std_logic;
			N0, N1, N2, N3: in std_logic_vector(3 downto 0);
			DD: out std_logic_vector(7 downto 0);
			DS: out std_logic_vector(3 downto 0));
	end component;

	signal CALC_NUM: std_logic_vector(8 downto 0);
	signal DISP_NUM: std_logic_vector(8 downto 0);
	signal N0, N1, N2, N3: std_logic_vector(3 downto 0);
	signal NC0, NC1: std_logic_vector(8 downto 0); -- carry from bin2bcd8
	signal CLK_T: std_logic_vector(16 downto 0); -- clock counter for display clock
	-- clock period = (2 << 16) / 100_000_000 = 1.31 ms per display / 5.24 ms full refresh
begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			CLK_T <= (CLK_T + 1);
		end if;
	end process;

	calc: component ALU
		port map(
			A => A,
			B => B,
			Op => Op,
			Res => CALC_NUM(7 downto 0),
			Cout => CALC_NUM(8),
			Equal => EQ);
	
	-- get absolute value of CALC_NUM
	topos: component abs8b
		port map(
			A => CALC_NUM,
			X => DISP_NUM);
	
	-- bcd digits
	bcd0: component bin2bcd
		port map(
			A => DISP_NUM,
			X => N0,
			R => NC0);
	bcd1: component bin2bcd
		port map(
			A => NC0,
			X => N1,
			R => NC1);
	bcd2: component bin2bcd
		port map(
			A => NC1,
			X => N2,
			R => open);
	-- minus sign if ALU.Cout = '1' else empty display
	N3 <= "1011" when CALC_NUM(8) = '1' else "1010";

	disp: component bcd2disp
		port map(
			CLK => CLK_T(16),
			N0 => N3,
			N1 => N2,
			N2 => N1,
			N3 => N0,
			DD => DD,
			DS => DS);
end Behavioral;
