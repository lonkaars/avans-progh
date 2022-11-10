library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcddec is port(
	A: in std_logic_vector(3 downto 0);
	X: out std_logic_vector(6 downto 0));
end bcddec;

architecture Behavioral of bcddec is
begin
	X <= "0111111" when A = "0000" else
	     "0000110" when A = "0001" else
	     "1011011" when A = "0010" else
	     "1001111" when A = "0011" else
	     "1100110" when A = "0100" else
	     "1101101" when A = "0101" else
	     "1111101" when A = "0110" else
	     "0100111" when A = "0111" else
	     "1111111" when A = "1000" else
	     "1101111" when A = "1001";
end Behavioral;

