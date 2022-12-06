library ieee;
use ieee.std_logic_1164.all;

entity Watch is
	port(
		clk, sysReset, watchRunning, watchReset: in std_logic;
		mins, secs: out std_logic_vector(5 downto 0));
end Watch;

architecture Behavioral of Watch is
begin
end Behavioral;
