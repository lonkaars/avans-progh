library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity note_synth is port(
	CLK: in std_logic; -- system clock
	RESET: in std_logic; -- async reset
	NOTE_IDX: in std_logic_vector(3 downto 0); -- note index
	NOTE_WRONG: in std_logic; -- note wrong
	NOTE_PLAY: in std_logic; -- output audio
	PWM_OUT: out std_logic); -- audio signal level
end note_synth;

architecture Behavioral of note_synth is
begin
	PWM_OUT <= '0';
end Behavioral;
