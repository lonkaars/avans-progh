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
		DS: out std_logic_vector(3 downto 0));
end main;

architecture Behavioral of main is
	component ALU
		port (
			A, B: in std_logic_vector(7 downto 0);
			Op: in std_logic_vector(3 downto 0);
			Res: out std_logic_vector(7 downto 0);
			Cout, Equal: out std_logic);
	end component;
	component stopp
		port(
			A: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	component bin2bcd8
		port(
			A: in std_logic_vector(7 downto 0);
			X: out std_logic_vector(3 downto 0);
			R: out std_logic_vector(7 downto 0));
	end component;
	component bcd2disp
		port(
			CLK: in std_logic;
			N0, N1, N2, N3: in std_logic_vector(3 downto 0);
			DD: out std_logic_vector(7 downto 0);
			DS: out std_logic_vector(3 downto 0));
	end component;

	signal ALU_OUT: std_logic_vector(7 downto 0);
	signal ALU_COUT, ALU_EQ: std_logic;
	signal DISP_NUM: std_logic_vector(7 downto 0);
	signal N0, N1, N2, N3: std_logic_vector(3 downto 0);
	signal NC0, NC1: std_logic_vector(7 downto 0); -- carry from bin2bcd8
	signal CLK_T: std_logic_vector(18 downto 0); -- clock counter for display clock
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
			Res => ALU_OUT,
			Cout => ALU_COUT,
			Equal => ALU_EQ);
	
	topos: component stopp
		port map(
			A => ALU_OUT,
			X => DISP_NUM);
	
	bcd0: component bin2bcd8
		port map(
			A => DISP_NUM,
			X => N0,
			R => NC0);
	bcd1: component bin2bcd8
		port map(
			A => NC0,
			X => N1,
			R => NC1);
	bcd2: component bin2bcd8
		port map(
			A => NC1,
			X => N2,
			R => open);

	disp: component bcd2disp
		port map(
			CLK => CLK_T(18),
			N0 => "0000",
			N1 => N2,
			N2 => N1,
			N3 => N0,
			DD => DD,
			DS => DS);

end Behavioral;
