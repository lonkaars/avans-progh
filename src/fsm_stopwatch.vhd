library ieee;
use ieee.std_logic_1164.all;

entity FSM_controller is
	port(
		clk, sysReset: in std_logic;
		buttons: in std_logic_vector(1 downto 0);
		watchRunning, watchReset: out std_logic);
end FSM_controller;

architecture Behavioral of FSM_controller is
	type states is (RESET, PAUSED_IDLE, PAUSED_TRANS, RUNNING_IDLE, RUNNING_TRANS);
	signal state, nextState: states := PAUSED_IDLE;
begin
	-- finite state machine
	FSM: process(clk, sysReset)
	begin
		if sysReset = '1' then
			state <= PAUSED_IDLE;
		elsif rising_edge(clk) then
			state <= nextState;
		end if;
	end process;

	-- next state logic and output decoder (combined)
	CL: process(state)
	begin
		nextState <= state;
		case state is
			when RESET =>
				if buttons(0) = '0' then
					nextState <= PAUSED_IDLE;
				end if;
				watchReset <= '1';
				watchRunning <= '0';
			when PAUSED_IDLE =>
				if buttons(0) = '1' and buttons(1) = '0' then
					nextState <= RESET;
				end if;
				if buttons(0) = '0' and buttons(1) = '1' then
					nextState <= PAUSED_TRANS;
				end if;
				watchReset <= '0';
				watchRunning <= '0';
			when PAUSED_TRANS =>
				if buttons(1) = '0' then
					nextState <= RUNNING_IDLE;
				end if;
				watchReset <= '0';
				watchRunning <= '0';
			when RUNNING_IDLE =>
				if buttons(1) = '1' then
					nextState <= RUNNING_TRANS;
				end if;
				watchReset <= '0';
				watchRunning <= '1';
			when RUNNING_TRANS =>
				if buttons(1) = '0' then
					nextState <= PAUSED_IDLE;
				end if;
				watchReset <= '0';
				watchRunning <= '1';
		end case;
	end process;
end Behavioral;

