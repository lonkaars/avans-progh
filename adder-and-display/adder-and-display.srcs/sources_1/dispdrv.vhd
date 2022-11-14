library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dispdrv is
	port (
		CLK: in std_logic;
		D0: in std_logic_vector(7 downto 0);
		D1: in std_logic_vector(7 downto 0);
		D2: in std_logic_vector(7 downto 0);
		D3: in std_logic_vector(7 downto 0);
		D: out std_logic_vector(7 downto 0);
		S: out std_logic_vector(1 downto 0));
end dispdrv;

architecture Behavioral of dispdrv is
signal disp_idx: std_logic_vector(1 downto 0);
begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			disp_idx <= (disp_idx + 1);
		end if;
	end process;

	S <= disp_idx;
	with disp_idx select
		D <=
			D0 when "00",
			D1 when "01",
			D2 when "10",
			D3 when "11",
			(others => '0') when others;
end Behavioral;

