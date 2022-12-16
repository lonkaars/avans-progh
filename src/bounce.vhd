library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity bounce is
	-- bounce motion
	port (
		clk, reset: in std_logic;
		x, y: out std_logic_vector(9 downto 0));
end bounce;

architecture Behavioral of bounce is
	-- direction[1]: 0 = right, 1 = left
	-- direction[0]: 0 = down, 1 = up
	signal direction: std_logic_vector(1 downto 0) := "00";
	constant velocity: natural := 1;

	-- current square position
	signal temp_x, temp_y: std_logic_vector(9 downto 0) := (others => '0');
begin
	x <= temp_x;
	y <= temp_y;
	process(clk, reset)
	begin
		if reset = '1' then
			-- async reset
			direction <= "00"; -- reset direction to bottom right
			temp_x <= (others => '0');
			temp_y <= (others => '0');
		elsif rising_edge(clk) then
			if direction(0) = '0' then
				temp_x <= temp_x + velocity; -- move left
				if (temp_x + velocity) > 630 then
					direction(0) <= '1';
				end if;
			else
				temp_x <= temp_x - velocity; -- move right
				if (temp_x - velocity) <= 0 then
					direction(0) <= '0';
				end if;
			end if;
			if direction(1) = '0' then
				temp_y <= temp_y + 1; -- move down
				if (temp_y + velocity) > 470 then
					direction(1) <= '1';
				end if;
			else
				temp_y <= temp_y - 1; -- move up
				if (temp_y - velocity) <= 0 then
					direction(1) <= '0';
				end if;
			end if;
		end if;
	end process;
end Behavioral;
