----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2023 15:07:08
-- Design Name: 
-- Module Name: MetastablilitySyncronizer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MetastablilitySyncronizer is port(
	clk: in std_logic; -- system clock
	input: in std_logic; -- Metastable data
	output: out std_logic); -- stable data
end MetastablilitySyncronizer;

architecture Behavioral of MetastablilitySyncronizer is
    signal inputD, inputDD: std_logic := '0';
begin    
    process (clk)
    begin
       if rising_edge(clk) then
          -- 1
          inputD  <= input;
          -- 2
          inputDD <= inputD;
          -- 3
          output <= inputDD;
       end if;
    end process;
end Behavioral;
