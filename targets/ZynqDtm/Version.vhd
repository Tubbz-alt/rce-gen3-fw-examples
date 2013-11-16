-------------------------------------------------------------------------------
-- Title         : Version Constant File
-- Project       : COB Zynq DTM
-------------------------------------------------------------------------------
-- File          : Version.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 05/07/2013
-------------------------------------------------------------------------------
-- Description:
-- Version Constant Module
-------------------------------------------------------------------------------
-- Copyright (c) 2012 by SLAC. All rights reserved.
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package Version is

constant FPGA_VERSION_C : std_logic_vector(31 downto 0) := x"DC000016"; -- MAKE_VERSION

constant BUILD_STAMP_C : string := "Built Fri Nov 15 16:45:31 PST 2013 by rherbst";

end Version;

-------------------------------------------------------------------------------
-- Revision History:
-- 05/07/2013 (0xDC000001): Initial Version
-- 05/22/2013 (0xDC000002): Stable/Chipscope
-- 05/22/2013 (0xDC000003): Loopback
-- 06/12/2013 (0xDC000006): Transaction loopback
-- 06/12/2013 (0xDC000007): Transaction chipscope
-- 06/13/2013 (0xDC000008): Transaction chipscope
-- 06/13/2013 (0xDC000009): Address decode fix
-- 06/13/2013 (0xDC00000A): TX_RXDETECT_REF to 3'b010
-- 06/20/2013 (0xDC00000B): TX_RXDETECT_REF to normal, fix PCIE Config space
-- 06/21/2013 (0xDC00000C): Fix PCIE Config space
-- 06/21/2013 (0xDC00000D): PCIE Config space debug
-- 06/21/2013 (0xDC00000E): PCIE Config
-- 06/24/2013 (0xDC00000F): Seperate external reset
-- 07/08/2013 (0xDC000010): Force phy configuration to clear isolate bit
-- 10/22/2013 (0xDC000011): New FIFO structure.
-- 10/26/2013 (0xDC000013): New build structure.
-- 10/29/2013 (0xDC000014): Quad word FIFO fix.
-- 11/05/2013 (0xDC000015): Changed outbound free list FIFOs.
-- 11/15/2013 (0xDC000016): Added core module.
-------------------------------------------------------------------------------
