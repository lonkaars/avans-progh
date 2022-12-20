library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vga is
	port (
		clk25, reset: in std_logic;
		x, y: out std_logic_vector(9 downto 0);
		rgb: in std_logic_vector(11 downto 0);
		red, green, blue: out std_logic_vector(3 downto 0);
		hsync, vsync: out std_logic);
end vga;

architecture Behavioral of vga is
	signal hcount: std_logic_vector(9 downto 0);
	signal vcount: std_logic_vector(9 downto 0);

	-- timing info from http://www.tinyvga.com/vga-timing/640x480@60Hz
	constant screen_sz_ver: natural := 480; -- screen size vertical
	constant pulse_ver: natural := 2; -- vertical sync pulse width
	constant front_porch_ver: natural := 10; -- vertical front porch pulse width
	constant back_porch_ver: natural := 33; -- vertical back porch pulse width
	constant screen_sz_hor: natural := 640; -- screen size horizontal
	constant pulse_hor: natural := 96; -- horizontal sync pulse width
	constant front_porch_hor: natural := 16; -- horizontal front porch pulse width
	constant back_porch_hor: natural := 48; -- horizontal back porch pulse width
begin
	process (clk25)
	begin
		-- if reset = '1' then
		-- 	red <= x"0";
		-- 	green <= x"0";
		-- 	blue <= x"0";
		-- 	hsync <= '0';
		-- 	vsync <= '0';
		-- 	hcount <= (others => '0');
		-- 	vcount <= (others => '0');
		-- elsif rising_edge(clk25) then
		if rising_edge(clk25) then
			-- display area
			if (hcount >= (pulse_hor + back_porch_hor)) and
			   (hcount < (pulse_hor + back_porch_hor + screen_sz_hor)) and
			   (vcount >= (pulse_ver + back_porch_ver)) and
			   (vcount < (pulse_ver + back_porch_ver + screen_sz_ver)) then
				x <= hcount - (pulse_hor + back_porch_hor);
				y <= vcount - (pulse_ver + back_porch_ver);
				red <= rgb(11 downto 8);
				green <= rgb(7 downto 4);
				blue <= rgb(3 downto 0);
			else
				-- turn off RGB during sync pulses
				red <= x"0";
				green <= x"0";
				blue <= x"0";
			end if;

			-- vertical pulse
			if hcount <= pulse_hor then
				hsync <= '0';
			else
				hsync <= '1';
			end if;

			-- horizontal pulse
			if vcount <= pulse_ver then
				vsync <= '0';
			else
				vsync <= '1';
			end if;

			-- update horizontal line counter
			hcount <= hcount + 1;

			-- horizontal line counter overflow
			if hcount = (front_porch_hor + back_porch_hor + pulse_hor + screen_sz_hor) then
				vcount <= vcount + 1;
				hcount <= (others => '0');
			end if;

			-- vertical line counter overflow
			if vcount = (front_porch_ver + back_porch_ver + pulse_ver + screen_sz_ver) then
				vcount <= (others => '0');
			end if;
		end if;
	end process;
end Behavioral;

