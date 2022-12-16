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
		red, green, blue: out std_logic;
		hsync, vsync: out std_logic);
	end component;
	signal clk25: std_logic_vector(1 downto 0); -- clock divider (100_000_000/4)
	signal r, g, b: std_logic;
begin
	process(clk)
	begin
		if rising_edge(clk) then
			clk25 <= (clk25 + 1);
		end if;
	end process;

	display: component vga
	port map(
		reset => reset,
		clk25 => clk25(1),
		red => r,
		green => g,
		blue => b,
		hsync => hsync,
		vsync => vsync);

	red <= (others => r);
	green <= (others => g);
	blue <= (others => b);

end Behavioral;
