library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ps2sync is port(
	CLK: in std_logic; -- system clock
	PS2_CLK: in std_logic; -- async ps/2 clock input
	PS2_DAT: in std_logic; -- async ps/2 data input
	DAT: out std_logic_vector(7 downto 0); -- scancode data
	NEW_DAT: out std_logic); -- if scancode was just completed (1 for once clock cycle)
end ps2sync;

architecture Behavioral of ps2sync is
	component d_ff
		port (
			CLK: in std_logic;
			D: in std_logic;
			Q: out std_logic);
	end component;
	signal PS2_CLK_F_0,
	       PS2_CLK_F_1,
	       PS2_CLK_F_2,
	       PS2_DAT_F_0,
	       PS2_DAT_F_1,
	       PS2_DAT_F_2: std_logic;
	signal PS2_CLK_F_2_LAST: std_logic;
	signal NEW_DAT_TMP: std_logic := '0';
	signal DAT_TMP: std_logic_vector(7 downto 0) := x"00";
	type states is (START_BIT, READING, PARITY_BIT, STOP_BIT);
	signal state: states := START_BIT;
begin
	clkstab0: component d_ff port map(CLK => CLK, D => PS2_CLK,     Q => PS2_CLK_F_0);
	clkstab1: component d_ff port map(CLK => CLK, D => PS2_CLK_F_0, Q => PS2_CLK_F_1);
	clkstab2: component d_ff port map(CLK => CLK, D => PS2_CLK_F_1, Q => PS2_CLK_F_2);
	datstab0: component d_ff port map(CLK => CLK, D => PS2_DAT,     Q => PS2_DAT_F_0);
	datstab1: component d_ff port map(CLK => CLK, D => PS2_DAT_F_0, Q => PS2_DAT_F_1);
	datstab2: component d_ff port map(CLK => CLK, D => PS2_DAT_F_1, Q => PS2_DAT_F_2);

	process(CLK)
		variable DAT_TMP_IDX: natural range 0 to 10 := 0;
	begin
		DAT <= DAT_TMP;
		NEW_DAT <= NEW_DAT_TMP;

		if rising_edge(CLK) then
			-- update stable CLK last
			PS2_CLK_F_2_LAST <= PS2_CLK_F_2;

			-- reset NEW_DAT after one clock cycle
			if NEW_DAT_TMP = '1' then
				NEW_DAT_TMP <= '0';
			end if;

			-- if PS2 CLK falling edge occurred
			if PS2_CLK_F_2_LAST = '1' and PS2_CLK_F_2 = '0' then
				case state is
					when START_BIT =>
						state <= READING;

					when READING =>
						DAT_TMP(DAT_TMP_IDX) <= PS2_DAT_F_2;
						DAT_TMP_IDX := (DAT_TMP_IDX + 1);

						if DAT_TMP_IDX = 8 then -- stop reading at bit 7
							state <= PARITY_BIT;
							DAT_TMP_IDX := 0;
						end if;

					when PARITY_BIT =>
						state <= STOP_BIT;
						NEW_DAT_TMP <= '1';

					when STOP_BIT =>
						state <= START_BIT;

					when others =>
						state <= START_BIT;
				end case;
			end if;
		end if;
	end process;
end Behavioral;
