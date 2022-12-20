library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity main is
	port (
		clk, reset: in std_logic;
		red, green, blue: out std_logic_vector(3 downto 0);
		hsync, vsync: out std_logic);
end main;

architecture Behavioral of main is
	component vga port (
		clk25, reset: in std_logic;
		x, y: out std_logic_vector(9 downto 0);
		rgb: in std_logic_vector(11 downto 0);
		red, green, blue: out std_logic_vector(3 downto 0);
		hsync, vsync: out std_logic);
	end component;
  component pixeldata port (
    sys_clk, pixel_clk, bounce_clk, reset: in std_logic;
    x, y: in std_logic_vector(9 downto 0);
    rgb: out std_logic_vector(11 downto 0));
  end component;
	signal clk25: std_logic_vector(1 downto 0); -- clock divider (100_000_000/4)
	signal vsync_temp: std_logic; -- vsync signal
	signal vsync_inv: std_logic; -- inverted vsync (frame clock)
	signal x, y: std_logic_vector(9 downto 0); -- current pixel xy
	signal rgb: std_logic_vector(11 downto 0); -- pixel rgb out -> vga in
begin
	-- clock divider
	process(clk)
	begin
		if rising_edge(clk) then
			clk25 <= (clk25 + 1);
		end if;
	end process;

	-- get current pixel color
	pixel: component pixeldata
		port map (
			sys_clk => clk,
			pixel_clk => clk25(1),
			bounce_clk => vsync_inv,
			reset => reset,
			x => x,
			y => y,
			rgb => rgb);

	-- display on vga monitor
	display: component vga
	port map(
		reset => reset,
		clk25 => clk25(1),
		rgb => rgb,
		x => x,
		y => y,
		hsync => hsync,
		vsync => vsync_temp,
		red => red,
		green => green,
		blue => blue);
	vsync <= vsync_temp; -- vsync output
	vsync_inv <= not vsync_temp; -- frame clock output


end Behavioral;
