LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- full 4-bit adder entity
entity add4b is
  port (
    A: in std_logic_vector(3 downto 0);
    B: in std_logic_vector(3 downto 0);
    Cin: in std_logic;
    X: out std_logic_vector(3 downto 0);
    Cout: out std_logic);
end add4b;

architecture Behavioral of add4b is
  signal C0: std_logic; -- Cout0 -> Cin1
  signal C1: std_logic; -- Cout1 -> Cin2
  signal C2: std_logic; -- Cout2 -> Cin3
  component add1b 
    port (
      A: in std_logic;
      B: in std_logic;
      Cin: in std_logic;
      X: out std_logic;
      Cout: out std_logic);
  end component;
begin
	-- full adder ladder (e.g. Cin -> Cin0, Cout0 -> Cin1, ..., Cout3 -> Cout)
  add0: component add1b
    port map (
      A => A(0),
      B => B(0),
      Cin => Cin,
      X => X(0),
      Cout => C0);
  add1: component add1b
    port map (
      A => A(1),
      B => B(1),
      Cin => C0,
      X => X(1),
      Cout => C1);
  add2: component add1b
    port map (
      A => A(2),
      B => B(2),
      Cin => C1,
      X => X(2),
      Cout => C2);
  add3: component add1b
    port map (
      A => A(3),
      B => B(3),
      Cin => C2,
      X => X(3),
      Cout => Cout);
end Behavioral;

