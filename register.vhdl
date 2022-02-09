use work.registerConstants.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dualBusRegisterBlock is
    port (
        rst         : in std_logic;
        clk         : in std_logic;
        wideOutEn   : in std_logic;
        halfOutEn   : in std_logic;
        halfLHSel   : in std_logic;  -- Low=0, High=1
        rw          : in std_logic;  -- Read=1, Write=0
        incrementPC : in std_logic;
        addrBus     : in std_logic_vector (regAddrBusWidth-1 downto 0);
        dataBusWide : out std_logic_vector (regDataBusWideWidth-1 downto 0);
        dataBusHalf : inout std_logic_vector (regDataBusHalfWidth-1 downto 0)
    );
end dualBusRegisterBlock;

architecture rtl of dualBusRegisterBlock is
    signal internalDataBusHalf          : std_logic_vector (regDataBusHalfWidth-1 downto 0) := (others => '0');
    signal internalDataBusWide          : std_logic_vector (regDataBusWideWidth-1 downto 0) := (others => '0');
    
    type registerBlockType is array (0 to regCount-1) of std_logic_vector (regDataBusWideWidth-1 downto 0);
    signal registerBlockArray : registerBlockType := (others => (others => '0'));
begin
    dataBusHalf <= internalDataBusHalf when halfOutEn = '1' else (others => 'Z');
    dataBusWide <= internalDataBusWide when wideOutEn = '1' else (others => 'Z');

    readProcess : process (rw, addrBus, wideOutEn, halfOutEn, halfLHSel) is
    begin
        if rw = '1' then
            if wideOutEn = '1' then
                internalDataBusWide <= registerBlockArray(to_integer(unsigned(addrBus)));
            else
                internalDataBusWide <= (others => '0');
            end if;

            if halfOutEn = '1' then
                if halfLHSel = '0' then
                    internalDataBusHalf <= registerBlockArray(to_integer(unsigned(addrBus))) (regDataBusHalfWidth-1 downto 0);
                else
                    internalDataBusHalf <= registerBlockArray(to_integer(unsigned(addrBus))) (regDataBusWideWidth-1 downto regDataBusHalfWidth);
                end if;
            else
                internalDataBusHalf <= (others => '0');
            end if;
        else
            internalDataBusWide <= (others => '0');
            internalDataBusHalf <= (others => '0');         
        end if;
    end process;

    writeProcess : process (clk, rst) is
    begin
        if rst = '1' then
            registerBlockArray <= (others => (others => '0'));
        elsif rising_edge(clk) and rw = '0' then
            if to_integer(unsigned(addrBus)) = PC then
                if incrementPC = '1' then
                    registerBlockArray(PC) <= std_logic_vector(unsigned(registerBlockArray(PC)) + 1);
                else
                    if halfLHSel = '0' then
                        registerBlockArray(PC) (regDataBusHalfWidth-1 downto 0) <= dataBusHalf;
                    else
                        registerBlockArray(PC) (regDataBusWideWidth-1 downto regDataBusHalfWidth) <= dataBusHalf;
                    end if;
                end if;
            else
                if halfLHSel = '0' then
                    registerBlockArray(to_integer(unsigned(addrBus))) (regDataBusHalfWidth-1 downto 0) <= dataBusHalf;
                else
                    registerBlockArray(to_integer(unsigned(addrBus))) (regDataBusWideWidth-1 downto regDataBusHalfWidth) <= dataBusHalf;
                end if;
            end if;
        end if;
    end process;

end rtl;








