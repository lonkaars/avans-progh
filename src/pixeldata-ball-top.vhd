library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pixeldata is
	port (
		pixel_clk, bounce_clk, reset: in std_logic;
		x, y: in std_logic_vector(9 downto 0);
		rgb: out std_logic_vector(11 downto 0));
end pixeldata;

architecture Behavioral of pixeldata is
