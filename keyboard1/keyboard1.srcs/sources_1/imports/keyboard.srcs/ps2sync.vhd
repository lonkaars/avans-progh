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
    signal DAT_TMP: std_logic_vector(7 downto 0) := x"00";
    signal PS2_CLK_OLD : std_logic := '0';
    signal readCount: natural range 0 to 7;
    type estates is (START_BIT, READING, PARITY_BIT, STOP_BIT);
    signal state: estates := START_BIT;
    begin    
    
    process(CLK)
    begin
        if rising_edge(CLK) then
            -- default values
            PS2_CLK_OLD <= PS2_CLK;
            DAT_TMP <= DAT_TMP;
            state <= state;
            DAT <= DAT_TMP;
            NEW_DAT <= '0';
            readCount <= readCount;
            
            if (PS2_CLK_OLD = '1' and PS2_CLK = '0') then                
                case state is
                    when START_BIT =>
                        state <= READING; 
                        
                    when READING =>
                        -- always add 1 overwrite later
                        readCount <= readCount + 1;
                        
                        -- get data
                        DAT_TMP(readCount) <= PS2_DAT;
                        
                        -- 0 -> 5 get other one
                        if (readCount < 6) then
                            state <= READING; 
                        else
                            -- get last
                            state <= PARITY_BIT;
                            readCount <= 0; 
                        end if;   
                                             
                    when PARITY_BIT =>
                        -- todo: add later                        
                        state <= STOP_BIT; 
                    when STOP_BIT =>
                        NEW_DAT <= '1';
                        state <= START_BIT; 
                    when others =>
                        state <= START_BIT; 
                end case;
            end if;
        end if;
    end process;
end Behavioral;
