library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity main is
	port(
		clk, sysReset: in std_logic;
		buttons: in std_logic_vector(1 downto 0);
		DD: out std_logic_vector(7 downto 0);
		DS: out std_logic_vector(3 downto 0));
end main;

architecture Behavioral of main is
	component FSM_controller
		port(
			clk, sysReset: in std_logic;
			buttons: in std_logic_vector(1 downto 0);
			watchRunning, watchReset: out std_logic);
	end component;
	component Watch
		port(
			clk, sysReset, watchRunning, watchReset: in std_logic;
			mins, secs: out std_logic_vector(5 downto 0));
	end component;
	component bin2bcd
		generic(
			width: integer := 6);
		port(
			A: in std_logic_vector(width-1 downto 0); -- binary input (unsigned 8-bit)
			X: out std_logic_vector(3 downto 0); -- bcd output
			R: out std_logic_vector(width-1 downto 0)); -- remainder after operation
	end component;
	component bcd2disp
		port(
			CLK: in std_logic; -- mux clock (switch to next display on rising edge)
			N0, N1, N2, N3: in std_logic_vector(3 downto 0); -- input bcd digits
			DD: out std_logic_vector(7 downto 0); -- display segment data
			DS: out std_logic_vector(3 downto 0)); -- display select
		-- display 4 bcd digits on display
	end component;
	signal watchRunning, watchReset: std_logic;
	signal mins, secs: std_logic_vector(5 downto 0);
	signal NC0, NC1: std_logic_vector(5 downto 0); -- carry from bin2bcd8
	signal N0, N1, N2, N3: std_logic_vector(3 downto 0);
	signal CLK_T: std_logic_vector(16 downto 0); -- clock counter for display clock
	-- clock period = (2 << 16) / 100_000_000 = 1.31 ms per display / 5.24 ms full refresh
begin
	process(clk)
	begin
		if rising_edge(clk) then
			CLK_T <= (CLK_T + 1);
		end if;
	end process;

	-- finite state machine (synchronous Watch controller)
	controller: component FSM_controller
		port map(
			clk => clk,
			sysReset => sysReset,
			buttons => buttons,
			watchRunning => watchRunning,
			watchReset => watchReset);
	-- stopwatch
	stopwatch: component Watch
		port map(
			clk => clk,
			sysReset => sysReset,
			watchRunning => watchRunning,
			watchReset => watchReset,
			mins => mins,
			secs => secs);
	
	-- convert seconds to bcd
	bcd0: component bin2bcd
		port map(
			A => secs,
			X => N0,
			R => NC0);
	bcd1: component bin2bcd
		port map(
			A => NC0,
			X => N1,
			R => open);

	-- convert minutes to bcd
	bcd2: component bin2bcd
		port map(
			A => mins,
			X => N2,
			R => NC1);
	bcd3: component bin2bcd
		port map(
			A => NC1,
			X => N3,
			R => open);

	-- display bcd digits
	disp: component bcd2disp
		port map(
			CLK => CLK_T(16),
			N0 => N3,
			N1 => N2,
			N2 => N1,
			N3 => N0,
			DD => DD,
			DS => DS);
end Behavioral;

