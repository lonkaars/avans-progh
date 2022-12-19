	component bounce
		port (
			clk, reset: in std_logic;
			x, y: out std_logic_vector(9 downto 0));
	end component;
	signal sx, sy: std_logic_vector(9 downto 0); -- square x and y
  signal pixel_index: integer;
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
				-- draw 10x10 pixel box in white
				rgb <= bitmap_ball(to_integer(unsigned(x - sx)) + to_integer(unsigned(y - sy)) * 10);
			else
				-- blue background
				rgb <= x"00f";
			end if;
		end if;
	end process;
end Behavioral;
