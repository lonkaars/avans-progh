LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity d_ff is
  port (
    CLK: in std_logic;
    D: in std_logic;
    Q: out std_logic);
end d_ff;

architecture Behavioral of d_ff is
begin
	process(CLK)
		if(rising_edge(CLK)) then
			Q <= D;
		end if;
	begin
end Behavioral;
