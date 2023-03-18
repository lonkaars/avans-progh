library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity note_synth_top is port (
	SYSCLK, SYSRESET : in std_logic; -- system clock (100 MHz) and reset
	GLOBAL_MUTE : in std_logic; -- global mute switch
	NOTE_IDX: in std_logic_vector(3 downto 0); -- note index
	NOTE_WRONG: in std_logic; -- note wrong
	NOTE_PLAY: in std_logic; -- output audio
	PWM_OUT : out std_logic); -- audio PWM output
end note_synth_top;

architecture Behavioral of note_synth_top is
	component note_synth is port(
		CLK: in std_logic; -- system clock
		RESET: in std_logic; -- async reset
		NOTE_IDX: in std_logic_vector(3 downto 0); -- note index
		NOTE_WRONG: in std_logic; -- note wrong
		NOTE_PLAY: in std_logic; -- output audio
		PWM_OUT: out std_logic); -- audio signal level
	end component;
	signal PWM_OUT_TEMP : std_logic; -- audio output buffer (for muting)
begin
	note: note_synth port map (
		CLK => SYSCLK,
		RESET => SYSRESET,
		NOTE_IDX => NOTE_IDX,
		NOTE_WRONG => NOTE_WRONG,
		NOTE_PLAY => NOTE_PLAY,
		PWM_OUT => PWM_OUT_TEMP);

	PWM_OUT <= PWM_OUT_TEMP and GLOBAL_MUTE;
end Behavioral;
