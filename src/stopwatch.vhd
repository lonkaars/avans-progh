library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Watch is
	port(
		clk, sysReset, watchRunning, watchReset: in std_logic;
		mins, secs: out std_logic_vector(5 downto 0));
end Watch;

architecture Behavioral of Watch is
begin
	process(clk, sysReset)
		variable subsec: std_logic_vector(26 downto 0) := (others => '0'); -- floor(log2(100_000_000))
		-- = 26 (bits needed to count to 1 second for 100Mhz clock)
		variable minute, second: std_logic_vector(5 downto 0) := (others => '0');
	begin
		if sysReset = '1' then
			subsec := (others => '0');
			second := (others => '0');
			minute := (others => '0');
		elsif rising_edge(clk) then
			if watchRunning = '1' then
				subsec := (subsec + 1);

				-- if subsec is 100_000_000 (second complete)
				if subsec = "101111101011110000100000000" then
					subsec := (others => '0');
					second := (second + 1);

					-- if second is 60 (minute complete)
					if second = "111100" then
						second := (others => '0');
						minute := (minute + 1);
	
						-- if minute is 60 (hour complete)
						if minute = "111100" then
							minute := (others => '0');
						end if;
					end if;
				end if;
			elsif watchReset = '1' then
				subsec := (others => '0');
				second := (others => '0');
				minute := (others => '0');
			end if;
		end if;

		mins <= minute;
		secs <= second;
	end process;
end Behavioral;
