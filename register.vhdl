use work.registerConstants.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dualBusRegisterBlock is
    port (
        rst         : in std_logic;
        clk         : in std_logic;
        opCode      : in std_logic_vector (regOpCodeWidth-1 downto 0);
        regAddrBus  : in std_logic_vector (regAddrBusWidth-1 downto 0);
        dataBusWide : out std_logic_vector (regDataBusWideWidth-1 downto 0);
        dataBusHalf : inout std_logic_vector (regDataBusHalfWidth-1 downto 0)
    );
end dualBusRegisterBlock;

architecture rtl of dualBusRegisterBlock is
    type registerBlockType is array (0 to regCount-1) of std_logic_vector (regDataBusWideWidth-1 downto 0);
    signal registerBlockArray : registerBlockType := (others => (others => '0'));
begin
    readProcess : process (opCode, regAddrBus) is
    begin
        if opCode = regHalfOutL then
            dataBusHalf <= registerBlockArray(to_integer(unsigned(regAddrBus))) (regDataBusHalfWidth-1 downto 0);
        elsif opCode = regHalfOutH then
            dataBusHalf <= registerBlockArray(to_integer(unsigned(regAddrBus))) (regDataBusWideWidth-1 downto regDataBusHalfWidth);
        else
            dataBusHalf <= (others => 'Z');
        end if;

        if opCode = regWideOut then
            dataBusWide <= registerBlockArray(to_integer(unsigned(regAddrBus)));
        else
            dataBusWide <= (others => 'Z');
        end if;
    end process;

    writeProcess : process (clk, rst) is
    begin
        if rst = '1' then
            registerBlockArray <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if opCode = regCpyToPC then
                registerBlockArray(regPC) <= registerBlockArray(to_integer(unsigned(regAddrBus)));
            elsif opCode = regIncPC then
                registerBlockArray(regPC) <= std_logic_vector(unsigned(registerBlockArray(regPC)) + 1);
            elsif opCode = regHalfInL then
                registerBlockArray(to_integer(unsigned(regAddrBus))) (regDataBusHalfWidth-1 downto 0) <= dataBusHalf;
            elsif opCode = regHalfInH then
                registerBlockArray(to_integer(unsigned(regAddrBus))) (regDataBusWideWidth-1 downto regDataBusHalfWidth) <= dataBusHalf;
            end if;
        end if;
    end process;
end rtl;








