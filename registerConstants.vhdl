library ieee;
use ieee.std_logic_1164.all;

package registerConstants is
    --  Physical Constants
    constant regCount            : integer := 4;
    constant regAddrBusWidth     : integer := 2;
    constant regDataBusHalfWidth : integer := 8;
    constant regDataBusWideWidth : integer := regDataBusHalfWidth*2;
    
    -- Register names
    constant PC : integer := 0; -- Program Counter
    constant AB : integer := 1;
    constant CD : integer := 2;
    constant DE : integer := 3;
end registerConstants;

package body registerConstants is
end registerConstants;