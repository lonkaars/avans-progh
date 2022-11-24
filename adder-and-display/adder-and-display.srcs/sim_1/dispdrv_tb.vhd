library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VCOMPONENTS.ALL;

entity dispdrv_tb is
end dispdrv_tb;

architecture Behavioral of dispdrv_tb is
component dispdrv port (
	CLK: in std_logic;
	D0: in std_logic_vector(7 downto 0);
	D1: in std_logic_vector(7 downto 0);
	D2: in std_logic_vector(7 downto 0);
	D3: in std_logic_vector(7 downto 0);
	D: out std_logic_vector(7 downto 0);
	S: out std_logic_vector(1 downto 0));
end component;
signal CLK: std_logic;
signal D0: std_logic_vector(7 downto 0);
signal D1: std_logic_vector(7 downto 0);
signal D2: std_logic_vector(7 downto 0);
signal D3: std_logic_vector(7 downto 0);
signal D: std_logic_vector(7 downto 0);
signal S: std_logic_vector(1 downto 0);

signal test_case: std_logic_vector(1 downto 0);
signal OK: boolean := true;
begin
	test: dispdrv port map(
		CLK => CLK,
		D0 => D0,
		D1 => D1,
		D2 => D2,
		D3 => D3,
		D => D,
		S => S);

	tb: process
		variable D0_t: std_logic_vector(7 downto 0) := b"00001111";
		variable D1_t: std_logic_vector(7 downto 0) := b"11110000";
		variable D2_t: std_logic_vector(7 downto 0) := b"01010101";
		variable D3_t: std_logic_vector(7 downto 0) := b"10101010";
	begin

	D0 <= D0_t;
	D1 <= D1_t;
	D2 <= D2_t;
	D3 <= D3_t;

	for test_i in 0 to 3 loop
		test_case <= std_logic_vector(to_unsigned(test_i, 2));
		CLK <= '0';
		wait for 5 ns;
		CLK <= '1';
		wait for 5 ns;

		if test_case = 0 and D /= D0_t then
			OK <= false;
		end if;
		if test_case = 1 and D /= D1_t then
			OK <= false;
		end if;
		if test_case = 2 and D /= D2_t then
			OK <= false;
		end if;
		if test_case = 3 and D /= D3_t then
			OK <= false;
		end if;
	end loop;
	wait;
	end process;
end Behavioral;

