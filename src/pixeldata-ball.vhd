library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pixeldata is
	port (
		sys_clk, pixel_clk, bounce_clk, reset: in std_logic;
		x, y: in std_logic_vector(9 downto 0);
		rgb: out std_logic_vector(11 downto 0));
end pixeldata;

architecture Behavioral of pixeldata is
	component bounce
		port (
			clk, reset: in std_logic;
			x, y: out std_logic_vector(9 downto 0));
	end component;
	component ball_rom
		port (
			clka: in std_logic;
			addra: in std_logic_vector(6 downto 0);
			douta: out std_logic_vector(11 downto 0));
	end component;
	signal sx, sy: std_logic_vector(9 downto 0); -- square x and y
	signal bitmap_idx: std_logic_vector(6 downto 0);
	signal bitmap_out: std_logic_vector(11 downto 0);
begin
	bounce_pos: component bounce
		port map (
			reset => reset,
			clk => bounce_clk,
			x => sx,
			y => sy);
	bitmap_lookup: component ball_rom
		port map (
			clka => sys_clk,
			addra => bitmap_idx,
			douta => bitmap_out);
	process(pixel_clk)
	begin
		if rising_edge(pixel_clk) then
			if (x >= sx) and (x < sx + 10) and (y >= sy) and (y < sy + 10) then
				-- draw ball
				bitmap_idx <= std_logic_vector(resize(unsigned(y - sy) + unsigned(y - sy) * 10, bitmap_idx'length));
				rgb <= bitmap_out;
			else
				-- blue background
				rgb <= x"00f";
			end if;
		end if;
	end process;
end Behavioral;
