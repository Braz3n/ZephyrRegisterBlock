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
        incPC       : in std_logic;
        opCode      : in std_logic_vector (regOpCodeWidth-1 downto 0);
        regAddrBus  : in std_logic_vector (regAddrBusWidth-1 downto 0);
        dataBusWide : out std_logic_vector (regDataBusWideWidth-1 downto 0);
        dataBusHalf : inout std_logic_vector (regDataBusHalfWidth-1 downto 0)
    );
    end component;

    --  Specifies which entity is bound with the component.
    for dualBusRegisterBlock_UUT: dualBusRegisterBlock use entity work.dualBusRegisterBlock;

    signal rst         : std_logic;
    signal clk         : std_logic;
    signal incPC       : std_logic;
    signal opCode      : std_logic_vector (regOpCodeWidth-1 downto 0);
    signal regAddrBus  : std_logic_vector (regAddrBusWidth-1 downto 0);
    signal dataBusWide : std_logic_vector (regDataBusWideWidth-1 downto 0);
    signal dataBusHalf : std_logic_vector (regDataBusHalfWidth-1 downto 0);

begin
    -- Component instantiation.
    dualBusRegisterBlock_UUT : dualBusRegisterBlock port map 
    (
        rst         => rst,
        clk         => clk,
        incPC       => incPC,
        opCode      => opCode,
        regAddrBus  => regAddrBus,
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
            incPC       : std_logic;
            opCode      : std_logic_vector (regOpCodeWidth-1 downto 0);
            regAddrBus  : std_logic_vector (regAddrBusWidth-1 downto 0);
            dataBusWide : std_logic_vector (regDataBusWideWidth-1 downto 0);
            dataBusHalf : std_logic_vector (regDataBusHalfWidth-1 downto 0);
        end record;
        
        type test_pattern_array is array (natural range <>) of test_pattern_type;
        
        constant test_pattern : test_pattern_array :=
        (   
            -- Test Program Counter
            ('0', '0', regHalfInL,  regPC_slv, "----------------", "10101010"),  -- Load 170 into low byte of regPC
            ('0', '0', regHalfInH,  regPC_slv, "----------------", "11110000"),  -- Load 240 into high byte of regPC
            ('0', '0', regWideOut,  regPC_slv, "1111000010101010", "--------"),  -- Read out ADDR bus
            ('0', '0', regHalfInL,  regPC_slv, "----------------", "10101010"),  -- Read out low byte of regPC
            ('0', '0', regHalfInH,  regPC_slv, "----------------", "11110000"),  -- Read out high byte of regPC
            ('0', '0', regHalfInL,  regPC_slv, "----------------", "11111110"),  -- Load 254 into low byte of regPC
            ('0', '1', regNOP,      regPC_slv, "----------------", "--------"),  -- Increment regPC
            ('0', '1', regNOP,      regPC_slv, "----------------", "--------"),  -- Increment regPC
            ('0', '1', regNOP,      regPC_slv, "----------------", "--------"),  -- Increment regPC
            ('0', '0', regHalfOutL, regPC_slv, "----------------", "00000001"),  -- Read out low byte of regPC
            ('0', '0', regHalfOutH, regPC_slv, "----------------", "11110001"),  -- Read out high byte of regPC
            ('0', '0', regWideOut,  regPC_slv, "1111000100000001", "--------"),  -- Read out PC onto the ADDR bus

            -- Test Register A
            ('0', '0', regHalfInL,  regA_slv,  "----------------", "10101010"),  -- Load 170 into low byte of regA
            ('0', '0', regHalfInH,  regA_slv,  "----------------", "11110000"),  -- Load 240 into high byte of regA
            ('0', '0', regWideOut,  regA_slv,  "1111000010101010", "--------"),  -- Read out regA onto ADDR bus
            ('0', '0', regHalfOutL, regA_slv,  "----------------", "10101010"),  -- Read out low byte of regA
            ('0', '0', regHalfOutH, regA_slv,  "----------------", "11110000"),  -- Read out high byte of regA
            
            -- Test Register B
            ('0', '0', regHalfInL,  regB_slv,  "----------------", "10101010"),  -- Load 170 into low byte of regB
            ('0', '0', regHalfInH,  regB_slv,  "----------------", "11110000"),  -- Load 240 into high byte of regB
            ('0', '0', regWideOut,  regB_slv,  "1111000010101010", "--------"),  -- Read out regB onto ADDR bus
            ('0', '0', regHalfOutL, regB_slv,  "----------------", "10101010"),  -- Read out low byte of regB
            ('0', '0', regHalfOutH, regB_slv,  "----------------", "11110000"),  -- Read out high byte of regB

            -- Test Register C
            ('0', '0', regHalfInL,  regC_slv,  "----------------", "10101010"),  -- Load 170 into low byte of regC
            ('0', '0', regHalfInH,  regC_slv,  "----------------", "11110000"),  -- Load 240 into high byte of regC
            ('0', '0', regWideOut,  regC_slv,  "1111000010101010", "--------"),  -- Read out regC onto ADDR bus
            ('0', '0', regHalfOutL, regC_slv,  "----------------", "10101010"),  -- Read out low byte of regC
            ('0', '0', regHalfOutH, regC_slv,  "----------------", "11110000"),  -- Read out high byte of regC

            -- Test regCpyToPC
            ('1', '0', regNOP,      regPC_slv, "----------------", "--------"),  -- Reset the registers
            ('0', '0', regHalfInL,  regA_slv,  "----------------", "10101111"),  -- Load 1 into low byte of regA
            ('0', '0', regHalfInH,  regB_slv,  "----------------", "11110000"),  -- Load 1 into high byte of regB
            ('0', '0', regHalfInL,  regC_slv,  "----------------", "11001100"),  -- Load 1 into low byte of regC
            ('0', '0', regHalfInH,  regC_slv,  "----------------", "11100011"),  -- Load 1 into high byte of regC
            ('0', '0', regCpyToPC,  regA_slv,  "----------------", "--------"),  -- Copy regA value into regPC
            ('0', '0', regWideOut,  regPC_slv, "0000000010101111", "--------"),  -- Read out PC onto the ADDR bus
            ('0', '0', regCpyToPC,  regB_slv,  "----------------", "--------"),  -- Copy regB value into regPC
            ('0', '0', regWideOut,  regPC_slv, "1111000000000000", "--------"),  -- Read out PC onto the ADDR bus
            ('0', '0', regCpyToPC,  regC_slv,  "----------------", "--------"),  -- Copy regC value into regPC
            ('0', '0', regWideOut,  regPC_slv, "1110001111001100", "--------")   -- Read out PC onto the ADDR bus

        );
    begin

        for i in test_pattern'range loop
            -- Set input signals
            rst <= test_pattern(i).rst;
            incPC <= test_pattern(i).incPC;
            opCode <= test_pattern(i).opCode;
            regAddrBus <= test_pattern(i).regAddrBus;

            if opCode /= regHalfOutL or opCode /= regHalfOutH then
                dataBusHalf <= test_pattern(i).dataBusHalf;
            end if;
            
            wait for 20 ns;

            if opCode = regWideOut then
                assert dataBusWide = test_pattern(i).dataBusWide
                    report "Bad 'dataBusWide' value " & to_string(dataBusWide) & 
                            ", expected " & to_string(test_pattern(i).dataBusWide) &
                            " at test pattern index " & integer'image(i) severity error;
            end if;
                        
            if opCode = regHalfOutL or opCode = regHalfOutH then
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