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
	signal PS2_CLK_F_0,
	       PS2_CLK_F_1,
	       PS2_CLK_F_2,
	       PS2_DAT_F_0,
	       PS2_DAT_F_1,
	       PS2_DAT_F_2: std_logic;
	signal PS2_CLK_F_2_LAST: std_logic;
	signal DAT_TMP: std_logic_vector(7 downto 0) := x"00";
	signal DAT_TMP_IDX: std_logic_vector(2 downto 0) := "000";
	type states is (START_BIT, READING, PARITY_BIT, STOP_BIT);
	signal state: states := START_BIT;
begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			PS2_CLK_F_2_LAST <= PS2_CLK_F_2;
			if PS2_CLK_F_2_LAST = '1' and PS2_CLK_F_2 = '0' then
				case state is
					when START_BIT =>
						state <= READING;
					when READING =>
						DAT_TMP(natural(to_integer(unsigned(DAT_TMP_IDX)))) <= PS2_DAT_F_2;
						DAT_TMP_IDX <= (DAT_TMP_IDX + 1);
						if DAT_TMP_IDX = "110" then
							state <= PARITY_BIT;
						end if;
					when PARITY_BIT =>
						state <= STOP_BIT;
					when STOP_BIT =>
						state <= START_BIT;
				end case;
			end if;
		end if;
	end process;
end Behavioral;
