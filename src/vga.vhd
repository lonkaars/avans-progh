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
begin

	process (clk25) 
	begin
		if rising_edge(clk25) then
			if (hcount >= 144) and (hcount < 784) and (vcount >= 31) and (vcount < 511) then
				x <= hcount - 144;
				y <= vcount - 31;
				red <= rgb(11 downto 8);
				green <= rgb(7 downto 4);
				blue <= rgb(3 downto 0);
			else
				red <= x"0";
				green <= x"0";	
				blue <= x"0";
			end if;

			if hcount < 97 then
				hsync <= '0';
			else
				hsync <= '1';
			end if;

			if vcount < 3 then
				vsync <= '0';
			else
				vsync <= '1';
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

