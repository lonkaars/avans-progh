library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scancodefilter is port(
	CLK: in std_logic; -- system clock
	DAT: in std_logic_vector(7 downto 0); -- scancode input
	NEW_DAT: in std_logic; -- new scancode input
	BCD: out std_logic_vector(3 downto 0); -- bcd digit 0-9 or dash (0xB) for keypress
	SHIFT: out std_logic); -- shift display (1 for one clock cycle per key down press)
end scancodefilter;

architecture Behavioral of scancodefilter is

-- init as empty key
--signal lastKey: std_logic_vector(3 downto 0) := x"a";
signal lastNEW_DAT: std_logic := '0';
signal DAT_OLD: std_logic_vector(7 downto 0); -- scancode preveouse input

begin
    process(CLK)
    begin
        if (rising_edge (clk)) then
            -- always set data on output             
            BCD <= x"a";
            SHIFT <= '0';
            lastNEW_DAT <= NEW_DAT;
            DAT_OLD <= DAT_OLD;
            
            -- when NEW_DAT does go high
            if ((lastNEW_DAT = '0') and (NEW_DAT = '1')) then    
                -- set DAT_OLD
                DAT_OLD <= DAT;
                         
                -- only is pervioause data is not release of key scancode and currend data
                if (DAT_OLD /= x"F0" and DAT /= x"F0") then     
                    case DAT is
                        when x"45" =>
                            BCD <= std_logic_vector(to_unsigned(0, BCD'length));
                            SHIFT <= '1';
                        when x"16" =>
                            BCD <= std_logic_vector(to_unsigned(1, BCD'length));
                            SHIFT <= '1';
                        when x"1E" =>
                            BCD <= std_logic_vector(to_unsigned(2, BCD'length));
                            SHIFT <= '1';
                        when x"26" =>
                            BCD <= std_logic_vector(to_unsigned(3, BCD'length));
                            SHIFT <= '1';
                        when x"25" =>
                            BCD <= std_logic_vector(to_unsigned(4, BCD'length));
                            SHIFT <= '1';
                        when x"2E" =>
                            BCD <= std_logic_vector(to_unsigned(5, BCD'length));
                            SHIFT <= '1';
                        when x"36" =>
                            BCD <= std_logic_vector(to_unsigned(6, BCD'length));
                            SHIFT <= '1';
                        when x"3D" =>
                            BCD <= std_logic_vector(to_unsigned(7, BCD'length));
                            SHIFT <= '1';
                        when x"3E" =>
                            BCD <= std_logic_vector(to_unsigned(8, BCD'length));
                            SHIFT <= '1';
                        when x"46" =>
                            BCD <= std_logic_vector(to_unsigned(9, BCD'length));
                            SHIFT <= '1';
                        when others =>
                            BCD <= x"b";
                            SHIFT <= '1';
                    end case;
                end if;
            end if;
        end if;     
    end process;
end Behavioral;
