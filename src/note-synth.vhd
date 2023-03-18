library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity note_synth is port(
	CLK: in std_logic; -- system clock
	RESET: in std_logic; -- async reset
	NOTE_IDX: in std_logic_vector(3 downto 0); -- note index
	NOTE_WRONG: in std_logic; -- note wrong
	NOTE_PLAY: in std_logic; -- output audio
	PWM_OUT: out std_logic); -- audio signal level
end note_synth;

architecture Behavioral of note_synth is
	function clk_for_freq(n : real) return natural is
		constant SYSFREQ : real := 100000000.0;
	begin
		return natural(integer(round(SYSFREQ / n)));
	end function;

	constant CLK_FOR_ERROR : natural := clk_for_freq(150.0);
	constant CLK_FOR_E4 : natural := clk_for_freq(329.6);
	constant CLK_FOR_F4 : natural := clk_for_freq(349.2);
	constant CLK_FOR_G4 : natural := clk_for_freq(391.9);
	constant CLK_FOR_A4 : natural := clk_for_freq(440.0);
	constant CLK_FOR_B4 : natural := clk_for_freq(493.8);
	constant CLK_FOR_C5 : natural := clk_for_freq(523.2);
	constant CLK_FOR_D5 : natural := clk_for_freq(587.3);
	constant CLK_FOR_E5 : natural := clk_for_freq(659.2);
	constant CLK_FOR_F5 : natural := clk_for_freq(698.4);
	signal MAX_CLK : natural := 1;
	signal PWM_OUT_TEMP : std_logic := '0';
begin
	MAX_CLK <= CLK_FOR_ERROR when NOTE_WRONG = '1' else
	           CLK_FOR_E4 when NOTE_IDX = x"0" else
						 CLK_FOR_F4 when NOTE_IDX = x"1" else
	           CLK_FOR_G4 when NOTE_IDX = x"2" else
	           CLK_FOR_A4 when NOTE_IDX = x"3" else
	           CLK_FOR_B4 when NOTE_IDX = x"4" else
	           CLK_FOR_C5 when NOTE_IDX = x"5" else
	           CLK_FOR_D5 when NOTE_IDX = x"6" else
	           CLK_FOR_E5 when NOTE_IDX = x"7" else
	           CLK_FOR_F5;

	PWM_OUT <= PWM_OUT_TEMP and NOTE_PLAY;
	process(CLK)
		variable CLK_COUNTER : integer := 0;
	begin
		if RESET = '1' then
			CLK_COUNTER := 0;
		elsif rising_edge(CLK) then
			CLK_COUNTER := CLK_COUNTER + 1;
			if CLK_COUNTER >= MAX_CLK then
				CLK_COUNTER := 0;

				if PWM_OUT_TEMP = '0' then PWM_OUT_TEMP <= '1'; else PWM_OUT_TEMP <= '0'; end if; -- toggle output
			end if;
		end if;
	end process;
end Behavioral;
