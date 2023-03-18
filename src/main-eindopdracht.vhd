library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity top is port (
	SYSCLK, SYSRESET : in std_logic; -- system clock (100 MHz) and reset
	R, G, B : out std_logic_vector(3 downto 0); -- VGA color signals
	HSYNC, VSYNC : out std_logic; -- VGA sync signals
	PS2_CLK : in std_logic; -- async ps/2 clock input
	PS2_DAT : in std_logic; -- async ps/2 data input
	GLOBAL_MUTE : in std_logic; -- global mute switch
	PWM_OUT : out std_logic; -- audio PWM output
	UART_TXD : buffer std_logic; -- USB UART TX
	UART_RXD : buffer std_logic); -- USB UART RX
end top;

architecture Behavioral of top is
	component pixclkgen is port ( 
		vga_pixel_clk : out std_logic;
		reset : in std_logic;
		clk : in std_logic);
	end component;
	component vga port (
		clk25, reset : in std_logic;
		x, y : out std_logic_vector(9 downto 0);
		rgb : in std_logic_vector(11 downto 0);
		red, green, blue : out std_logic_vector(3 downto 0);
		hsync, vsync : out std_logic);
	end component;
	component ps2sync port(
		CLK: in std_logic; -- system clock
		RESET: in std_logic; -- async reset
		PS2_CLK: in std_logic; -- async ps/2 clock input
		PS2_DAT: in std_logic; -- async ps/2 data input
		DAT: out std_logic_vector(7 downto 0); -- scancode data
		NEW_DAT: out std_logic); -- if scancode was just completed (1 for once clock cycle)
	end component;
	component bcd2disp port (
		CLK: in std_logic; -- system clock
		N0, N1, N2, N3: in std_logic_vector(3 downto 0); -- shift inputs
		DD: out std_logic_vector(7 downto 0); -- display data
		DS: out std_logic_vector(3 downto 0)); -- display select
	end component;
	component design_1_wrapper port (
		gpio_out_tri_o : out std_logic_vector (7 downto 0);
		ps2_sync_in_tri_i : in std_logic_vector (8 downto 0);
		reset : in std_logic;
		sys_clock : in std_logic;
		usb_uart_rxd : in std_logic;
		usb_uart_txd : out std_logic);
	end component;
	component pixeldata is port(
		CLK: in std_logic; -- system clock
		RESET: in std_logic; -- async reset
		NOTE_IDX: in std_logic_vector(3 downto 0);
		NOTE_WRONG: in std_logic;
		X, Y: in std_logic_vector(9 downto 0); -- pixel x/y
		RGB: out std_logic_vector(11 downto 0)); -- RGB output color
	end component;
	component note_synth is port(
		CLK: in std_logic; -- system clock
		RESET: in std_logic; -- async reset
		NOTE_IDX: in std_logic_vector(3 downto 0); -- note index
		NOTE_WRONG: in std_logic; -- note wrong
		NOTE_PLAY: in std_logic; -- output audio
		PWM_OUT: out std_logic); -- audio signal level
	end component;

	signal SYNC_DAT: std_logic_vector(7 downto 0); -- ps2sync <-> scancodefilter
	signal SYNC_DAT_NEW: std_logic; -- ps2sync <-> scancodefilter
	signal BCD_NEW: std_logic_vector(3 downto 0); -- scancodefilter <-> dispshift
	signal BCD_SHIFT: std_logic; -- scancodefilter <-> dispshift

	signal PIXEL_X, PIXEL_Y : std_logic_vector(9 downto 0); -- current pixel coordinates
	signal PIXEL_COLOR : std_logic_vector(11 downto 0); -- pixel color ("RRRRGGGGBBBB")
	signal AUDIO_SIGNAL : std_logic_vector(7 downto 0); -- audio voltage level (0 - 255)
	signal PIXCLK : std_logic; -- VGA pixel clock
	signal PWM_OUT_TEMP : std_logic; -- audio output buffer (for muting)

	-- game state signals
	signal MICROBLAZE_GPIO_IN : std_logic_vector(8 downto 0);
	signal MICROBLAZE_GPIO_OUT : std_logic_vector(7 downto 0);
	alias NOTE_IDX is MICROBLAZE_GPIO_OUT(3 downto 0); -- note (f3 - f4)
	alias NOTE_PLAY is MICROBLAZE_GPIO_OUT(4); -- play note on output
	alias NOTE_WRONG is MICROBLAZE_GPIO_OUT(5); -- note is wrong (change color + error sound)

	-- index  freq    note
	-- 0x0    329.6   E4 (on lowest bar)
	-- 0x1    349.2   F4
	-- 0x2    391.9   G4
	-- 0x3    440.0   A4
	-- 0x4    493.8   B4
	-- 0x5    523.2   C5
	-- 0x6    587.3   D5
	-- 0x7    659.2   E5
	-- 0x8    698.4   F5 (on highest bar)
begin
	note: note_synth port map (
		CLK => SYSCLK,
		RESET => SYSRESET,
		NOTE_IDX => NOTE_IDX,
		NOTE_WRONG => NOTE_WRONG,
		NOTE_PLAY => NOTE_PLAY,
		PWM_OUT => PWM_OUT_TEMP);

	PWM_OUT <= PWM_OUT_TEMP and GLOBAL_MUTE;

	-- convert async ps2 signals into synchronous lines
	ps2: component ps2sync port map (
		CLK => SYSCLK,
		RESET => SYSRESET,
		PS2_CLK => PS2_CLK,
		PS2_DAT => PS2_DAT,
		DAT => SYNC_DAT,
		NEW_DAT => SYNC_DAT_NEW);

	vga_pixel_clk_gen: component pixclkgen port map ( 
		clk => SYSCLK,
		reset => SYSRESET,
		vga_pixel_clk => PIXCLK);

	MICROBLAZE_GPIO_IN <= SYNC_DAT_NEW & SYNC_DAT;
	microblaze: component design_1_wrapper port map (
		gpio_out_tri_o => MICROBLAZE_GPIO_OUT,
		ps2_sync_in_tri_i => MICROBLAZE_GPIO_IN,
		reset => SYSRESET,
		sys_clock => SYSCLK,
		usb_uart_rxd => UART_RXD,
		usb_uart_txd => UART_TXD);

	image: component pixeldata port map (
		CLK => SYSCLK,
		RESET => SYSRESET,
		X => PIXEL_X,
		Y => PIXEL_Y,
		NOTE_IDX => NOTE_IDX,
		NOTE_WRONG => NOTE_WRONG,
		RGB => PIXEL_COLOR);

	display : component vga port map(
		reset => SYSRESET,
		clk25 => PIXCLK,
		rgb => PIXEL_COLOR,
		x => PIXEL_X,
		y => PIXEL_Y,
		hsync => HSYNC,
		vsync => VSYNC,
		red => R,
		green => G,
		blue => B);
end Behavioral;
