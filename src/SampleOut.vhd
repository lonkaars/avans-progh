library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SampleOut is
    generic(
        INPUT_DEPTH: integer := 256;
        INPUT_SAMPLE_SIZE: integer := 200000;
        INPUT_AUDIO_HZ: integer := 44100;
        INPUT_CLK_HZ: integer := 100000000
    );
    Port ( 	reset, clk : in STD_LOGIC;
			inCOEData : in STD_LOGIC_VECTOR(7 downto 0);
			outCOEData : out STD_LOGIC_VECTOR(7 downto 0);
			outCOEAddress : out STD_LOGIC_VECTOR(17 downto 0)
			);
end SampleOut;

architecture Behavioral of SampleOut is
    signal count: integer;
    signal COEAddress: integer;    

begin
    outCOEData <= inCOEData;
    
    process (reset, clk) 
    begin        
        -- if reset
        if (reset = '1') then
            -- default values for outputs, so output state is always defined
            outCOEAddress <= (others => '0');
            count <= 0;
            COEAddress <= 0;
        -- 
        elsif rising_edge(clk) then
            -- default values for outputs, so output state is always defined
            outCOEAddress <= (others => '0');
            count <= 0;
            COEAddress <= 0;
            
            -- start code
            outCOEAddress <= std_logic_vector (to_unsigned(COEAddress, outCOEAddress'length));
            count <= count + 1;     
            COEAddress <= COEAddress;
            
            -- if counter is >= the max amount of pulses paer audio sample
            if (count >= INPUT_CLK_HZ/INPUT_AUDIO_HZ) then-- Next audio sample
                count <= 0;
                COEAddress <= COEAddress + 1; --todo: check timing delay
                -- add + 1 becouse COEAddress is signal updated ad end of process
                outCOEAddress <= std_logic_vector (to_unsigned(COEAddress + 1, outCOEAddress'length));
                
                -- check for max level: add + 1 becouse COEAddress is signal updated ad end of process
                if (COEAddress + 1 >= INPUT_SAMPLE_SIZE) then
                    -- First audio sample
                    outCOEAddress <= (others => '0');
                    COEAddress <= 0;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
