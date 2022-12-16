library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pixeldata is
	port (
		pixel_clk, bounce_clk, reset: in std_logic;
		x, y: in std_logic_vector(9 downto 0);
		red, green, blue: out std_logic);
end pixeldata;

architecture Behavioral of pixeldata is
	component bounce
		port (
			clk, reset: in std_logic;
			x, y: out std_logic_vector(9 downto 0));
	end component;
	signal sx, sy: std_logic_vector(9 downto 0);
begin
	bounce_pos: component bounce
		port map (
			reset => reset,
			clk => bounce_clk,
			x => sx,
			y => sy);
	process(pixel_clk, sx, sy)
	begin
		if rising_edge(pixel_clk) then
			if (x >= sx) and (x < sx + 10) and (y >= sy) and (y < sy + 10) then
				red <= '1';
				green <= '1';
				blue <= '1';
			else
				red <= '0';
				green <= '0';
				blue <= '1';
			end if;
		end if;
	end process;
end Behavioral;

