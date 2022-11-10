library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin2bcd is
  port (
    A: in std_logic_vector(4 downto 0);
    X: out std_logic_vector(3 downto 0);
    Y: out std_logic_vector(3 downto 0));
end bin2bcd;

architecture Behavioral of bin2bcd is
  signal X_tmp: unsigned(3 downto 0);
  signal Y_tmp: unsigned(3 downto 0);
begin
	X_tmp <= (unsigned(A(X_tmp'range)) / 10);
	Y_tmp <= (unsigned(A(Y_tmp'range)) mod 10);

	X <= std_logic_vector(X_tmp);
	Y <= std_logic_vector(Y_tmp);
end Behavioral;
