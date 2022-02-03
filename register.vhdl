work.constants.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerBlock is
    port (
        rst                     : in std_logic;
        clk                     : in std_logic;
        outputBusAddrDataFlag   : in std_logic; -- Addr=0, Data=1
        registerReadWriteFlag   : in std_logic; -- Read=0, Write=1
        registerLowHighByte     : in std_logic; -- Low=0, High=1
        registerSelect          : in std_logic_vector (regSelectWidth-1 downto 0);
        dataBus                 : inout std_logic_vector (registerWidth-1 downto 0);
        addrBus                 : inout std_logic_vector (addressWidth-1 downto 0)
    );
end registerBlock;

architecture rtl of registerBlock is
    signal regAB        : std_logic_vector (registerBlockWidth-1 downto 0);
    signal regCD        : std_logic_vector (registerBlockWidth-1 downto 0);

    signal internalReadBus  : std_logic_vector (registerBlockWidth-1 downto 0);
    signal internalWriteBus  : std_logic_vector (registerBlockWidth-1 downto 0);
begin

    registerResetProcess : process (rst) is
    begin
        if rst = '1' then
            regAB <= (others => '0');
            regCD <= (others => '0');
        end if;
    end process;

    -- Register reading is combinational.
    registerReadProcess : process (registerReadWriteFlag, registerSelect) is
        if registerReadWriteFlag = '0' then
            case unsigned(registerSelect) is
                when 1 => 
                    internalReadBus <= regAB;
                when 2 => 
                    internalReadBus <= regCD;
                when others => 
                    internalReadBus <= (others => '0);
            end case;
        end if;
    end process;

    -- Register writing is clocked.
    registerWriteProcess : process (clk) is
        if rising_edge(clk) and registerReadWriteFlag = '1' then
            case unsigned(registerSelect) is
                when 1 => 
                    regAB <= internalWriteBus;
                when 2 => 
                    regCD <= internalWriteBus;
            end case;
        end if;
    end process

    -- Connect the internal busses to the correct input/output
    registerBusSelectProcess : process (outputBusAddrDataFlag, registerReadWriteFlag, registerLowHighByte) is
        -- Address Bus - Full 16 bits
        if outputBusAddrDataFlag = '0' and registerReadWriteFlag = '0' then
            -- Read from address bus

                

end rtl;