library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity dispshift is port(
	CLK: in std_logic; -- system clock
	S: in std_logic; -- shift
	D: in std_logic_vector(3 downto 0); -- shift input (data)
	N0, N1, N2, N3: out std_logic_vector(3 downto 0)); -- shift outputs
end dispshift;

architecture Behavioral of dispshift is

-- init as empty display
signal sD: std_logic_vector(11 downto 0) := x"aaa";
signal SLastValue: std_logic := '0';

begin
    process(CLK)
    begin
        if (rising_edge (clk)) then
            -- set default values
            SLastValue <= S;
            sD <= sD;
            
            -- when S does go high update output
            if (SLastValue = '0' and S = '1') then   
                -- set data on output             
                N3 <= sD(11 downto 8);
                N2 <= sD(7 downto 4);
                N1 <= sD(3 downto 0);
                N0 <= D; 
                
                -- store new data
                sD <= sD(7 downto 0) & D;
            end if;
        end if;    
    end process;
end Behavioral;
