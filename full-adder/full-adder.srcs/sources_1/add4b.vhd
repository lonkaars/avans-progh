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
begin
	-- first add A and B with HA
  add0: entity work.half_add
    port map (
      A => A,
      B => B,
      X => s0,
      Cout => s1);
	-- then add first result with Cin to get final result
  add1: entity work.half_add
    port map (
      A => Cin,
      B => s0,
      X => X,
      Cout => s2);
	-- calculate Cout by OR-ing the Cout of both half adders
  Cout <= (s2 OR s1);
end Behavioral;



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
begin
	-- full adder ladder (e.g. Cin -> Cin0, Cout0 -> Cin1, ..., Cout3 -> Cout)
  add0: entity work.add1b
    port map (
      A => A(0),
      B => B(0),
      Cin => Cin,
      X => X(0),
      Cout => C0);
  add1: entity work.add1b
    port map (
      A => A(1),
      B => B(1),
      Cin => C0,
      X => X(1),
      Cout => C1);
  add2: entity work.add1b
    port map (
      A => A(2),
      B => B(2),
      Cin => C1,
      X => X(2),
      Cout => C2);
  add3: entity work.add1b
    port map (
      A => A(3),
      B => B(3),
      Cin => C2,
      X => X(3),
      Cout => Cout);
end Behavioral;

