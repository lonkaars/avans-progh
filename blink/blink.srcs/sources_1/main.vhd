library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
	Port (clk : in STD_LOGIC;
	      led : out STD_LOGIC);
end main;

architecture Behavioral of main is signal count: STD_LOGIC_VECTOR(24 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			count <= (count + 1);
		end if;
	end process;
	led <= count(24);

end Behavioral;
