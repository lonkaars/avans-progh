library ieee;
use ieee.std_logic_1164.all;
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
                        -- if correct signal
                        if(PS2_DAT = '0') then
                            state <= READING; 
                        else
                            state <= START_BIT; 
                        end if;
                        
                    when READING =>
                        -- always add 1 overwrite later
                        readCount <= readCount + 1;
                        
                        -- get data
                        DAT_TMP(readCount) <= PS2_DAT;
                        
                        -- 0 -> 6 get other one
                        if (readCount < 7) then
                            state <= READING; 
                        else
                            -- was last
                            state <= PARITY_BIT;
                            readCount <= 0; 
                        end if;   
                                             
                    when PARITY_BIT =>
                        -- if correct paraty (even)
                        if(PS2_DAT /= std_logic (DAT_TMP(0) xor DAT_TMP(1) xor DAT_TMP(2) xor DAT_TMP(3) xor DAT_TMP(4) xor DAT_TMP(5) xor DAT_TMP(6) xor DAT_TMP(7)) ) then
                            state <= STOP_BIT; 
                        else
                            state <= START_BIT; 
                        end if;
                    when STOP_BIT =>                    
                        -- if correct signal
                        if(PS2_DAT = '1') then
                            NEW_DAT <= '1';
                            state <= START_BIT; 
                        else
                            NEW_DAT <= '0';
                            state <= START_BIT; 
                        end if;
                    when others =>
                        state <= START_BIT; 
                end case;
            end if;
        end if;
    end process;
end Behavioral;
