use work.registerConstants.all;

-- use std.env.finish;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--  A testbench has no ports.
entity register_tb is
end register_tb;
    
architecture behavioural of register_tb is
    --  Declaration of the component that will be instantiated.
    component dualBusRegisterBlock
    port (
        rst         : in std_logic;
        clk         : in std_logic;
        wideOutEn   : in std_logic;
        halfOutEn   : in std_logic;
        halfLHSel   : in std_logic;
        rw          : in std_logic;
        incrementPC : in std_logic;
        addrBus     : in std_logic_vector (regAddrBusWidth-1 downto 0);
        dataBusWide : out std_logic_vector (regDataBusWideWidth-1 downto 0);
        dataBusHalf : inout std_logic_vector (regDataBusHalfWidth-1 downto 0)
    );
    end component;

    --  Specifies which entity is bound with the component.
    for dualBusRegisterBlock_UUT: dualBusRegisterBlock use entity work.dualBusRegisterBlock;

    signal rst         : std_logic;
    signal clk         : std_logic;
    signal wideOutEn   : std_logic;
    signal halfOutEn   : std_logic;
    signal halfLHSel   : std_logic;
    signal rw          : std_logic;
    signal incrementPC : std_logic;
    signal addrBus     : std_logic_vector (regAddrBusWidth-1 downto 0);
    signal dataBusWide : std_logic_vector (regDataBusWideWidth-1 downto 0);
    signal dataBusHalf : std_logic_vector (regDataBusHalfWidth-1 downto 0);
begin
    -- Component instantiation.
    dualBusRegisterBlock_UUT : dualBusRegisterBlock port map 
    (
        rst         => rst,
        clk         => clk,
        wideOutEn   => wideOutEn,
        halfOutEn   => halfOutEn,
        halfLHSel   => halfLHSel,
        rw          => rw,
        incrementPC => incrementPC,
        addrBus     => addrBus,
        dataBusWide => dataBusWide,
        dataBusHalf => dataBusHalf
    );

    -- Clock process.
    process 
    begin 
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Actual working process block.
    process
        type test_pattern_type is record
            rst         : std_logic;
            wideOutEn   : std_logic;
            halfOutEn   : std_logic;
            halfLHSel   : std_logic;
            rw          : std_logic;
            incrementPC : std_logic;
            addrBus     : std_logic_vector (regAddrBusWidth-1 downto 0);
            dataBusWide : std_logic_vector (regDataBusWideWidth-1 downto 0);
            dataBusHalf : std_logic_vector (regDataBusHalfWidth-1 downto 0);
        end record;
        
        type test_pattern_array is array (natural range <>) of test_pattern_type;
        
        constant test_pattern : test_pattern_array :=
        (
            ('0', '0', '0', '0', '0', '0', "00", "----------------", "10101010"),  -- Load 170 into low byte of reg0
            ('0', '0', '0', '1', '0', '0', "00", "----------------", "11110000"),  -- Load 240 into high byte of reg0
            ('0', '1', '0', '0', '1', '0', "00", "1111000010101010", "--------"),  -- Read out ADDR bus
            ('0', '0', '1', '0', '1', '0', "00", "----------------", "10101010"),  -- Read out low byte of reg0
            ('0', '0', '1', '1', '1', '0', "00", "----------------", "11110000"),  -- Read out high byte of reg0
            ('0', '0', '0', '0', '0', '0', "00", "----------------", "11111110"),  -- Load 254 into low byte of reg0
            ('0', '0', '0', '0', '0', '1', "00", "----------------", "--------"),  -- Increment reg0
            ('0', '0', '0', '0', '0', '1', "00", "----------------", "--------"),  -- Increment reg0
            ('0', '0', '0', '0', '0', '1', "00", "----------------", "--------"),  -- Increment reg0
            ('0', '0', '1', '0', '1', '0', "00", "----------------", "00000001"),  -- Read out low byte of reg0
            ('0', '0', '1', '1', '1', '0', "00", "----------------", "11110001"),  -- Read out high byte of reg0
            ('0', '1', '0', '0', '1', '0', "00", "1111000100000001", "--------"),  -- Read out ADDR bus

            ('0', '0', '0', '0', '0', '0', "01", "----------------", "10101010"),  -- Load 170 into low byte of reg1
            ('0', '0', '0', '1', '0', '0', "01", "----------------", "11110000"),  -- Load 240 into high byte of reg1
            ('0', '1', '0', '0', '1', '0', "01", "1111000010101010", "--------"),  -- Read out ADDR bus
            ('0', '0', '1', '0', '1', '0', "01", "----------------", "10101010"),  -- Read out low byte of reg1
            ('0', '0', '1', '1', '1', '0', "01", "----------------", "11110000"),  -- Read out high byte of reg1
            
            ('0', '0', '0', '0', '0', '0', "10", "----------------", "10101010"),  -- Load 170 into low byte of reg2
            ('0', '0', '0', '1', '0', '0', "10", "----------------", "11110000"),  -- Load 240 into high byte of reg2
            ('0', '1', '0', '0', '1', '0', "10", "1111000010101010", "--------"),  -- Read out ADDR bus
            ('0', '0', '1', '0', '1', '0', "10", "----------------", "10101010"),  -- Read out low byte of reg3
            ('0', '0', '1', '1', '1', '0', "10", "----------------", "11110000"),  -- Read out high byte of reg3

            ('0', '0', '0', '0', '0', '0', "11", "----------------", "10101010"),  -- Load 170 into low byte of reg4
            ('0', '0', '0', '1', '0', '0', "11", "----------------", "11110000"),  -- Load 240 into high byte of reg4
            ('0', '1', '0', '0', '1', '0', "11", "1111000010101010", "--------"),  -- Read out ADDR bus
            ('0', '0', '1', '0', '1', '0', "11", "----------------", "10101010"),  -- Read out low byte of reg4
            ('0', '0', '1', '1', '1', '0', "11", "----------------", "11110000")   -- Read out high byte of reg4
        );
    begin

        for i in test_pattern'range loop
            -- Set input signals
            rst <= test_pattern(i).rst;
            wideOutEn <= test_pattern(i).wideOutEn;
            halfOutEn <= test_pattern(i).halfOutEn;
            halfLHSel <= test_pattern(i).halfLHSel;
            rw <= test_pattern(i).rw;
            incrementPC <= test_pattern(i).incrementPC;
            addrBus <= test_pattern(i).addrBus;
            dataBusHalf <= test_pattern(i).dataBusHalf;
            dataBusWide <= test_pattern(i).dataBusWide;

            wait for 20 ns;

            if test_pattern(i).wideOutEn = '1' and test_pattern(i).rw = '1' then
                assert dataBusWide = test_pattern(i).dataBusWide
                    report "Bad 'dataBusWide' value " & to_string(dataBusWide) & 
                            ", expected " & to_string(test_pattern(i).dataBusWide) &
                            " at test pattern index " & integer'image(i) severity error;
            end if;
                        
            if test_pattern(i).halfOutEn = '1' and test_pattern(i).rw = '1' then
                assert dataBusHalf = test_pattern(i).dataBusHalf
                    report "Bad 'dataBusHalf' value " & to_string(dataBusHalf) & 
                            ", expected " & to_string(test_pattern(i).dataBusHalf) & 
                            " at test pattern index " & integer'image(i) severity error;
            end if;
        end loop;

        assert false report "End Of Test - All Tests Successful!" severity note;
        wait;
    end process;

end behavioural;