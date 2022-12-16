library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vga is
	port (
		clk25, reset: in std_logic;
		red, green, blue: out std_logic;
		hsync, vsync: out std_logic);
end vga;

architecture Behavioral of vga is
	signal hcount: std_logic_vector(9 downto 0);
	signal vcount: std_logic_vector(9 downto 0);
	component pixeldata
		port (
			pixel_clk, bounce_clk, reset: in std_logic;
			x, y: in std_logic_vector(9 downto 0);
			red, green, blue: out std_logic);
	end component;
	signal bounce_clk: std_logic;
	signal x, y: std_logic_vector(9 downto 0);
	signal pr, pg, pb: std_logic;
begin
	pixel: component pixeldata
		port map (
			pixel_clk => clk25,
			bounce_clk => bounce_clk,
			reset => reset,
			x => x,
			y => y,
			red => pr,
			green => pg,
			blue => pb);

	process (clk25) 
	begin
		if rising_edge(clk25) then
			if (hcount >= 144) and (hcount < 784) and (vcount >= 31) and (vcount < 511) then
				x <= hcount - 144;
				y <= vcount - 31;
				red <= pr;
				green <= pg;
				blue <= pb;
			else
				red <= '0';
				green <= '0';
				blue <= '0';
			end if;

			if hcount < 97 then
				hsync <= '0';
			else
				hsync <= '1';
			end if;

			if vcount < 3 then
				vsync <= '0';
				bounce_clk <= '1';
			else
				vsync <= '1';
				bounce_clk <= '0';
			end if;

			hcount <= hcount + 1;

			if hcount = 800 then
				vcount <= vcount + 1;
				hcount <= (others => '0');
			end if;

			if vcount = 521 then				
				vcount <= (others => '0');
			end if;
		end if;
	end process;
end Behavioral;

