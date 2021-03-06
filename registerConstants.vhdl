library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package registerConstants is
    --  Physical Constants
    constant regCount            : integer := 4;
    constant regAddrBusWidth     : integer := 2;
    constant regDataBusHalfWidth : integer := 8;
    constant regDataBusWideWidth : integer := regDataBusHalfWidth*2;
    constant regOpCodeWidth      : integer := 3;
    
    -- Register OpCodes
    constant regNOP      : std_logic_vector(regOpCodeWidth-1 downto 0) := "000";
    constant regCpyToPC  : std_logic_vector(regOpCodeWidth-1 downto 0) := "001";
    constant regHalfOutL : std_logic_vector(regOpCodeWidth-1 downto 0) := "010";
    constant regHalfOutH : std_logic_vector(regOpCodeWidth-1 downto 0) := "011";
    constant regHalfInL  : std_logic_vector(regOpCodeWidth-1 downto 0) := "100";
    constant regHalfInH  : std_logic_vector(regOpCodeWidth-1 downto 0) := "101";
    constant regWideOut  : std_logic_vector(regOpCodeWidth-1 downto 0) := "110";

    -- Register indicies
    constant regPC : integer := 0; -- Program Counter
    constant regA  : integer := 1;
    constant regB  : integer := 2;
    constant regC  : integer := 3;

    -- Register std_logic_vector
    constant regPC_slv : std_logic_vector(regAddrBusWidth-1 downto 0) := std_logic_vector(to_unsigned(regPC, regAddrBusWidth)); -- Program Counter
    constant regA_slv  : std_logic_vector(regAddrBusWidth-1 downto 0) := std_logic_vector(to_unsigned(regA, regAddrBusWidth));
    constant regB_slv  : std_logic_vector(regAddrBusWidth-1 downto 0) := std_logic_vector(to_unsigned(regB, regAddrBusWidth));
    constant regC_slv  : std_logic_vector(regAddrBusWidth-1 downto 0) := std_logic_vector(to_unsigned(regC, regAddrBusWidth));
end registerConstants;

package body registerConstants is
end registerConstants;