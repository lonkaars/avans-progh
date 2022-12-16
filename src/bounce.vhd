library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity bounce is
	port (
		clk, reset: in std_logic;
		x, y: out std_logic_vector(9 downto 0));
end bounce;

architecture Behavioral of bounce is
	type states is (NORMAL, REVERSE);
	-- x state, x next, y state, y next
	signal x_s, x_n, y_s, y_n: states := NORMAL;
	constant velocity: std_logic_vector(9 downto 0) := "0000000001";
begin
	process(clk)
		variable temp_x, temp_y: std_logic_vector(9 downto 0) := "0000001000";
	begin
		temp_x := temp_x + velocity;
		temp_y := temp_y + velocity;
		x <= temp_x;
		y <= temp_y;
	end process;
	-- FSM: process(clk, reset)
	-- begin
	-- 	if reset = '1' then
	-- 		x_s <= NORMAL;
	-- 		y_s <= NORMAL;
	-- 	elsif rising_edge(clk) then
	-- 		x_s <= x_n;
	-- 		y_s <= y_n;
	-- 	end if;
	-- end process;

	-- process(x_s)
	-- begin
	-- 	x_n <= x_s;

	-- 	case x_s is
	-- 		when NORMAL =>
	-- 			temp_x <= temp_x + velocity;
	-- 			if temp_x + velocity > 630 then
	-- 				x_n <= REVERSE;
	-- 			end if;
	-- 		when REVERSE =>
	-- 			temp_x <= temp_x - velocity;
	-- 			if temp_x - velocity < 0 then
	-- 				x_n <= NORMAL;
	-- 			end if;
	-- 	end case;
	-- end process;

	-- process(y_s)
	-- begin
	-- 	y_n <= y_s;

	-- 	case y_s is
	-- 		when NORMAL =>
	-- 			temp_y <= temp_y + velocity;
	-- 			if temp_y + velocity > 630 then
	-- 				y_n <= REVERSE;
	-- 			end if;
	-- 		when REVERSE =>
	-- 			temp_y <= temp_y - velocity;
	-- 			if temp_y - velocity < 0 then
	-- 				y_n <= NORMAL;
	-- 			end if;
	-- 	end case;
	-- end process;
end Behavioral;
