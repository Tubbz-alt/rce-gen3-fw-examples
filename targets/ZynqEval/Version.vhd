-------------------------------------------------------------------------------
-- Title         : Version Constant File
-- Project       : COB DPM
-------------------------------------------------------------------------------
-- File          : Version.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 04/03/2013
-------------------------------------------------------------------------------
-- Description:
-- Version Constant Module
-------------------------------------------------------------------------------
-- Copyright (c) 2012 by SLAC. All rights reserved.
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

package Version is

constant FPGA_VERSION_C : std_logic_vector(31 downto 0) := x"F1000307"; -- MAKE_VERSION

constant BUILD_STAMP_C : string := "ZynqEval: Built Tue Jul 15 13:02:08 PDT 2014 by rherbst";

end Version;

-------------------------------------------------------------------------------
-- Revision History:
-- 04/03/2013 (0xF1000001): Initial Version
-- 04/18/2013 (0xF1000003): Added event test
-- 04/22/2013 (0xF1000004): Changed signals
-- 04/23/2013 (0xF1000005): Modified event control with handshake
-- 04/23/2013 (0xF1000006): Cleaned up eventI generation
-- 04/23/2013 (0xF1000007): Added debug
-- 04/24/2013 (0xF1000008): Added debug
-- 04/25/2013 (0xF1000009): Setup user flag
-- 04/28/2013 (0xF100000A): Added I2C
-- 04/30/2013 (0xF1000010): New structure, new FIFO interface
-- 05/03/2013 (0xF1000012): Interrupts added
-- 05/03/2013 (0xF1000100): Updated FIFO block
-- 05/03/2013 (0xF1000101): PCIexpress and ethernet hooks.
-- 05/03/2013 (0xF1000102): Fixed FIFO interrupts
-- 06/14/2013 (0xF1000103): Changed buffer structure per Mike
-- 08/29/2013 (0xF1000104): Added outbound FIFO
-- 10/22/2013 (0xF1000107): Changed FIFO structure
-- 10/24/2013 (0xF1000108): Adjusted descriptors
-- 10/24/2013 (0xF1000109): Timing Fixes
-- 10/26/2013 (0xF100010A): New build structure
-- 10/29/2013 (0xF100010B): Quad word FIFO bug
-- 11/03/2013 (0xF100010C): Moved free list FIFOs
-- 11/15/2013 (0xF100010D): New Core Structure
-- 11/18/2013 (0xF1000200): Vivado Build
-- 11/18/2013 (0xF1000201): Remove PPI Data
-- 02/28/2014 (0xF1000202): new build
-- 02/28/2014 (0xF1000203): Updated register bus
-- 03/13/2014 (0xF1000204): Debug
-- 03/13/2014 (0xF1000205): External AXI clock slow down
-- 03/17/2014 (0xF1000206): Crossbar Fix
-- 03/25/2014 (0xF1000207): PPI Interface
-- 03/31/2014 (0xF1000208): Modified Completion Value
-- 04/02/2014 (0xF1000209): Outbound DMA pending size bug
-- 04/02/2014 (0xF100020A): Debug
-- 04/29/2014 (0xF100020B): Re-build after reorg
-- 05/14/2014 (0xF1000300): New RCE structure
-- 05/14/2014 (0xF1000301): Added PPI
-- 05/14/2014 (0xF1000302): Inbound length fix.
-- 05/14/2014 (0xF1000303): Compile test.
-- 07/01/2014 (0xF1000304): Interrupt controller fix.
-- 07/08/2014 (0xF1000305): Zero length header support
-- 07/14/2014 (0xF1000306): Added e-fuse readback, PPI Fix
-- 07/15/2014 (0xF1000307): Test
-------------------------------------------------------------------------------

