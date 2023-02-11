library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity ps2sync is port(
	CLK: in std_logic; -- system clock
	PS2_CLK: in std_logic; -- async ps/2 clock input
	PS2_DAT: in std_logic; -- async ps/2 data input
	DAT: out std_logic_vector(7 downto 0); -- scancode data
	NEW_DAT: out std_logic); -- if scancode was just completed (1 for once clock cycle)
end ps2sync;

architecture Behavioral of ps2sync is

begin


end Behavioral;
