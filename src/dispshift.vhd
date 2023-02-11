library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity dispshift is port(
	CLK: in std_logic; -- system clock
	S: in std_logic; -- shift
	D: in std_logic_vector(3 downto 0); -- shift input (data)
	N0, N1, N2, N3: out std_logic_vector(3 downto 0)); -- shift outputs
end dispshift;

architecture Behavioral of dispshift is

begin


end Behavioral;
