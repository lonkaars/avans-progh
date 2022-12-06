library ieee;
use ieee.std_logic_1164.all;

entity FSM_controller is
	port(
		clk, sysReset: in std_logic;
		buttons: in std_logic_vector(1 downto 0);
		watchRunning, watchReset: out std_logic);
end FSM_controller;

architecture Behavioral of FSM_controller is
begin
end Behavioral;

