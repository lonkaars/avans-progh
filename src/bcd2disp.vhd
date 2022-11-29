library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd2disp is
	port(
		CLK: in std_logic; -- mux clock (switch to next display on rising edge)
		N0, N1, N2, N3: in std_logic_vector(3 downto 0); -- input bcd digits
		DD: out std_logic_vector(7 downto 0); -- display segment data
		DS: out std_logic_vector(3 downto 0)); -- display select
	-- display 4 bcd digits on display
end bcd2disp;

architecture Behavioral of bcd2disp is
	component bcddec
		port(
			A: in std_logic_vector(3 downto 0);
			X: out std_logic_vector(7 downto 0));
	end component;
	component dispdrv
		port (
			CLK: in std_logic;
			D0: in std_logic_vector(7 downto 0);
			D1: in std_logic_vector(7 downto 0);
			D2: in std_logic_vector(7 downto 0);
			D3: in std_logic_vector(7 downto 0);
			D: out std_logic_vector(7 downto 0);
			S: out std_logic_vector(1 downto 0));
	end component;
	signal D0: std_logic_vector(7 downto 0); -- display 0 segment bits
	signal D1: std_logic_vector(7 downto 0); -- display 1 segment bits
	signal D2: std_logic_vector(7 downto 0); -- display 2 segment bits
	signal D3: std_logic_vector(7 downto 0); -- display 3 segment bits
	signal SX: std_logic_vector(1 downto 0); -- output display mux select
	signal DX: std_logic_vector(7 downto 0); -- output display segment data
begin
	bcddec0: component bcddec
		port map (
			A => N0,
			X => D0);
	bcddec1: component bcddec
		port map (
			A => N1,
			X => D1);
	bcddec2: component bcddec
		port map (
			A => N2,
			X => D2);
	bcddec3: component bcddec
		port map (
			A => N3,
			X => D3);

	drv: component dispdrv
		port map (
			CLK => CLK,
			D0 => D0,
			D1 => D1,
			D2 => D2,
			D3 => D3,
			D => DX,
			S => SX);

	DD <= not DX;
	DS <= "1110" when SX = "00" else
	      "1101" when SX = "01" else
	      "1011" when SX = "10" else
	      "0111" when SX = "11";
end Behavioral;

