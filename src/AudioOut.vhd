library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AudioOut is
    generic(
        INPUT_DEPTH: integer := 256;
        INPUT_SAMPLE_SIZE: integer := 200000;
        INPUT_AUDIO_HZ: integer := 44100;
        INPUT_CLK_HZ: integer := 100000000
    );
    Port ( 	reset, clk : in STD_LOGIC;
			inMusicData : in STD_LOGIC_VECTOR(7 downto 0);
			outMusic : out  STD_LOGIC);
end AudioOut;

architecture Behavioral of AudioOut is
    signal count: integer := 0;
    signal bStartMusic : boolean := false;

begin    
    process (reset, clk) 
    variable currentThreasHold: integer;
    begin        
        -- if reset
        if (reset = '1') then
            -- default values for outputs, so output state is always defined
            outMusic <= '0';
            count <= 0;
            currentThreasHold := 0;
        -- 
        elsif rising_edge(clk) then
            -- default values for outputs, so output state is always defined
            outMusic <= '0';
            count <= 0;
            currentThreasHold := 0;
                  
            -- start code
            -- sync count to soundlevel input
            if (bStartMusic = true) then          
                -- calculate amount of puls to turn on PWM
                -- calculate available PWM pulses: (INPUT_CLK_KHZ/INPUT_AUDIO_KHZ)
                -- multiply by target audio signal level
                -- devide by available audio signal depth
                currentThreasHold := ((INPUT_CLK_HZ/INPUT_AUDIO_HZ) * to_integer(unsigned(inMusicData))) / (INPUT_DEPTH);
                
                -- check if PWM duty cicle is high enough: currentThreasHold has to be variable otherwise first check count = 1 one to late
                if (count >= currentThreasHold) then
                    -- no pwm output
                    outMusic <= '0';
                else
                    -- keep pwm high
                    outMusic <= '1';
                end if;
                
                --
                count <= count + 1;
                
                -- check for max level
                -- if counter is >= the max amount of pulses per audio sample
                if (count >= (INPUT_CLK_HZ/INPUT_AUDIO_HZ)) then
                    -- Next audio sample
                    count <= 1;
                end if;
            end if;
        end if;
    end process;
    
    process (reset)
    begin      
        if (reset = '1') then
            bStartMusic <= false;
        else
            -- start sound level input sync
            bStartMusic <= true;
        end if;     
    end process;
end Behavioral;
