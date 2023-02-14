library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity main is
	port(
		CLK100: in std_logic; -- system clock
		PS2_CLK: in std_logic; -- async ps/2 clock input
		PS2_DAT: in std_logic; -- async ps/2 data input
		DD: out std_logic_vector(7 downto 0); -- display segment data
		DS: out std_logic_vector(3 downto 0)); -- display select
end main;

architecture Behavioral of main is
	component ps2sync
		port(
			CLK: in std_logic; -- system clock
			PS2_CLK: in std_logic; -- async ps/2 clock input
			PS2_DAT: in std_logic; -- async ps/2 data input
			DAT: out std_logic_vector(7 downto 0); -- scancode data
			NEW_DAT: out std_logic); -- if scancode was just completed (1 for once clock cycle)
	end component;
	component scancodefilter
		port(
			CLK: in std_logic; -- system clock
			DAT: in std_logic_vector(7 downto 0); -- scancode input
			NEW_DAT: in std_logic; -- new scancode input
			BCD: out std_logic_vector(3 downto 0); -- bcd digit 0-9 or dash (0xB) for keypress
			SHIFT: out std_logic); -- shift display (1 for one clock cycle per key down press)
	end component;
	component dispshift
		port(
			CLK: in std_logic; -- system clock
			S: in std_logic; -- shift
			D: in std_logic_vector(3 downto 0); -- shift input (data)
			N0, N1, N2, N3: out std_logic_vector(3 downto 0)); -- shift outputs
	end component;
	component bcd2disp
		port (
			CLK: in std_logic; -- system clock
			N0, N1, N2, N3: in std_logic_vector(3 downto 0); -- shift inputs
			DD: out std_logic_vector(7 downto 0); -- display data
			DS: out std_logic_vector(3 downto 0)); -- display select
	end component;
    component MetastablilitySyncronizer is port(
        clk: in std_logic; -- system clock
        input: in std_logic; -- Metastable data
        output: out std_logic); -- stable data
    end component;

	signal PS2_CLK_STABLE, PS2_DAT_STABLE: std_logic; -- Stabalize clk, data
	signal SYNC_DAT: std_logic_vector(7 downto 0); -- ps2sync <-> scancodefilter
	signal SYNC_DAT_NEW: std_logic; -- ps2sync <-> scancodefilter
	signal BCD_NEW: std_logic_vector(3 downto 0); -- scancodefilter <-> dispshift
	signal BCD_SHIFT: std_logic; -- scancodefilter <-> dispshift
	signal N0, N1, N2, N3: std_logic_vector(3 downto 0); -- inputs for display
	signal DISP_CLK: std_logic_vector(16 downto 0); -- clock counter for display clock
	-- clock period = (2 << 16) / 100_000_000 = 1.31 ms per display / 5.24 ms full refresh
begin
	-- Stabalize clk
	msClk: component MetastablilitySyncronizer
		port map (
			clk => CLK100,
			input => PS2_CLK,
			output => PS2_CLK_STABLE);
	-- Stabalize data
	msData: component MetastablilitySyncronizer
		port map (
			clk => CLK100,
			input => PS2_DAT,
			output => PS2_DAT_STABLE);
			
	-- convert async ps2 signals into synchronous lines
	ps2: component ps2sync
		port map (
			CLK => CLK100,
			PS2_CLK => PS2_CLK_STABLE,
			PS2_DAT => PS2_DAT_STABLE,
			DAT => SYNC_DAT,
			NEW_DAT => SYNC_DAT_NEW);
	
	-- filter key up scancodes, and convert non-numeric keys into "-" (0xB)
	filter: component scancodefilter
		port map(
			CLK => CLK100,
			DAT => SYNC_DAT,
			NEW_DAT => SYNC_DAT_NEW,
			BCD => BCD_NEW,
			SHIFT => BCD_SHIFT);
	
	-- display 'shift register'
	shift_register: component dispshift
		port map(
			CLK => CLK100,
			S => BCD_SHIFT,
			D => BCD_NEW,
			N0 => N0,
			N1 => N1,
			N2 => N2,
			N3 => N3);

	-- display driver clock divider
	process(CLK100)
	begin
		if rising_edge(CLK100) then
			DISP_CLK <= (DISP_CLK + 1);
		end if;
	end process;

	-- numbers N0-N3 to displays 0-3
	disp: component bcd2disp
		port map (
			CLK => DISP_CLK(16),
			N0 => N0,
			N1 => N1,
			N2 => N2,
			N3 => N3,
			DD => DD,
			DS => DS);
			
end Behavioral;

