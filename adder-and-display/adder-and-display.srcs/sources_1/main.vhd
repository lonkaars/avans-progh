library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
	port(
		CLK: in std_logic; -- clk for display refresh
		A: in std_logic_vector(3 downto 0); -- adder A input
		B: in std_logic_vector(3 downto 0); -- adder B input
		DD: out std_logic_vector(7 downto 0); -- display segment data
		DS: out std_logic_vector(3 downto 0)); -- display select
end main;

bcd2disp  bcddec  dispdrv
architecture Behavioral of main is
  component add4b
    port (
      A: in std_logic_vector(3 downto 0);
      B: in std_logic_vector(3 downto 0);
      Cin: in std_logic;
      X: out std_logic_vector(3 downto 0);
      Cout: out std_logic);
  end component;
  component bin2bcd
    port (
      I: in std_logic_vector(3 downto 0);
      X: out std_logic_vector(3 downto 0);
      Y: out std_logic_vector(3 downto 0);
  end component;
  component bcd2disp
    port (
			CLK: in std_logic;
			N0: in std_logic_vector(3 downto 0);
			N1: in std_logic_vector(3 downto 0);
			N2: in std_logic_vector(3 downto 0);
			N3: in std_logic_vector(3 downto 0));
  end component;
  signal X: std_logic_vector(4 downto 0); -- add out
  signal BCD0: std_logic_vector(4 downto 0); -- bcd 10^0
  signal BCD1: std_logic_vector(4 downto 0); -- bcd 10^1
begin
  add: component add4b
    port map (
      A => A,
      B => B,
      Cin => 0,
      X => X,
      Cout => 0);
  bcd: component bin2bcd
    port map (
      I => X,
      X => BCD0,
      Y => BCD1);
  disp: component bcd2disp
    port map (
      CLK => CLK,
      N0 => BCD0,
      N1 => BCD1,
      N2 => 0,
      N3 => 0);
end Behavioral;

