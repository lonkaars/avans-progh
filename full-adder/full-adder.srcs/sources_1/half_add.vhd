LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- half adder entity
entity half_add is
  port (
    A: in std_logic;
    B: in std_logic;
    X: out std_logic;
    Cout: out std_logic);
end half_add;

architecture Behavioral of half_add is
begin
  Cout <= (A AND B);
  X <= (A XOR B);
end Behavioral;
