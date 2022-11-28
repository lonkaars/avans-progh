library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcddec is port(
	A: in std_logic_vector(3 downto 0);
	X: out std_logic_vector(7 downto 0));
end bcddec;

architecture Behavioral of bcddec is
begin
	X <= "00111111" when A = "0000" else
	     "00000110" when A = "0001" else
	     "01011011" when A = "0010" else
	     "01001111" when A = "0011" else
	     "01100110" when A = "0100" else
	     "01101101" when A = "0101" else
	     "01111101" when A = "0110" else
	     "00100111" when A = "0111" else
	     "01111111" when A = "1000" else
	     "01101111" when A = "1001" else
	     "00000000" when A = "1010" else
	     "01000000" when A = "1011" else
	     "00000000";
end Behavioral;

