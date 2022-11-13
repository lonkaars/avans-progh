LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- full adder entity
entity add1b is
  port (
    A: in std_logic;
    B: in std_logic;
    Cin: in std_logic;
    X: out std_logic;
    Cout: out std_logic);
end add1b;

architecture Behavioral of add1b is
  signal s0: std_logic;
  signal s1: std_logic;
  signal s2: std_logic;
  component half_add
	port (
	  A: in std_logic;
      B: in std_logic;
      X: out std_logic;
      Cout: out std_logic);
  end component;
begin
	-- first add A and B with HA
	add0: component half_add
    port map (
      A => A,
      B => B,
      X => s0,
      Cout => s1);
	-- then add first result with Cin to get final result
  add1: component half_add
    port map (
      A => Cin,
      B => s0,
      X => X,
      Cout => s2);
	-- calculate Cout by OR-ing the Cout of both half adders
  Cout <= (s2 OR s1);
end Behavioral;
