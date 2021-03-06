------------------------------------------------------------------------------
-- This file is part of 'RCE Development Firmware'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'RCE Development Firmware', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- DtmBringupC10.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;
use surf.AxiPkg.all;
use surf.AxiStreamPkg.all;

library rce_gen3_fw_lib;
use rce_gen3_fw_lib.RceG3Pkg.all;

library unisim;
use unisim.vcomponents.all;

entity DtmBringupC10 is
   generic (
      TPD_G        : time := 1 ns;
      BUILD_INFO_G : BuildInfoType);
   port (

      -- Debug
      led : out slv(1 downto 0);

      -- I2C
      i2cSda : inout sl;
      i2cScl : inout sl;

      -- PCI Exress
      pciRefClkP : in  sl;
      pciRefClkM : in  sl;
      pciRxP     : in  sl;
      pciRxM     : in  sl;
      pciTxP     : out sl;
      pciTxM     : out sl;
      pciResetL  : out sl;

      -- COB Ethernet
      ethRxP : in  sl;
      ethRxM : in  sl;
      ethTxP : out sl;
      ethTxM : out sl;

      -- Reference Clock
      locRefClkP : in sl;
      locRefClkM : in sl;

      -- Clock Select
      clkSelA : out sl;
      clkSelB : out sl;

      -- Base Ethernet
      ethRxCtrl  : in    slv(1 downto 0);
      ethRxClk   : in    slv(1 downto 0);
      ethRxDataA : in    Slv(1 downto 0);
      ethRxDataB : in    Slv(1 downto 0);
      ethRxDataC : in    Slv(1 downto 0);
      ethRxDataD : in    Slv(1 downto 0);
      ethTxCtrl  : out   slv(1 downto 0);
      ethTxClk   : out   slv(1 downto 0);
      ethTxDataA : out   Slv(1 downto 0);
      ethTxDataB : out   Slv(1 downto 0);
      ethTxDataC : out   Slv(1 downto 0);
      ethTxDataD : out   Slv(1 downto 0);
      ethMdc     : out   Slv(1 downto 0);
      ethMio     : inout Slv(1 downto 0);
      ethResetL  : out   Slv(1 downto 0);

      -- RTM High Speed
      --dtmToRtmHsP : out   sl;
      --dtmToRtmHsM : out   sl;
      --rtmToDtmHsP : in    sl;
      --rtmToDtmHsM : in    sl;

      -- RTM Low Speed
      --dtmToRtmLsP  : inout slv(5 downto 0);
      --dtmToRtmLsM  : inout slv(5 downto 0);

      -- DPM Signals
      dpmClkP : out slv(2 downto 0);
      dpmClkM : out slv(2 downto 0);
      dpmFbP  : in  slv(7 downto 0);
      dpmFbM  : in  slv(7 downto 0);

      -- Backplane Clocks
      bpClkIn  : in  slv(5 downto 0);
      bpClkOut : out slv(5 downto 0);

      -- Spare Signals
      --plSpareP     : inout slv(4 downto 0);
      --plSpareM     : inout slv(4 downto 0);

      -- IPMI
      dtmToIpmiP : out slv(1 downto 0);
      dtmToIpmiM : out slv(1 downto 0)

      );
end DtmBringupC10;

architecture STRUCTURE of DtmBringupC10 is

   -- Local Signals
   signal axiClk             : sl;
   signal axiClkRst          : sl;
   signal sysClk125          : sl;
   signal sysClk125Rst       : sl;
   signal sysClk200          : sl;
   signal sysClk200Rst       : sl;
   signal extAxilReadMaster  : AxiLiteReadMasterType;
   signal extAxilReadSlave   : AxiLiteReadSlaveType;
   signal extAxilWriteMaster : AxiLiteWriteMasterType;
   signal extAxilWriteSlave  : AxiLiteWriteSlaveType;
   signal dmaClk             : slv(2 downto 0);
   signal dmaClkRst          : slv(2 downto 0);
   signal dmaState           : RceDmaStateArray(2 downto 0);
   signal dmaObMaster        : AxiStreamMasterArray(2 downto 0);
   signal dmaObSlave         : AxiStreamSlaveArray(2 downto 0);
   signal dmaIbMaster        : AxiStreamMasterArray(2 downto 0);
   signal dmaIbSlave         : AxiStreamSlaveArray(2 downto 0);
   signal userInterrupt      : slv(USER_INT_COUNT_C-1 downto 0);

begin

   --------------------------------------------------
   -- Core
   --------------------------------------------------
   U_DtmCore : entity rce_gen3_fw_lib.DtmCore
      generic map (
         TPD_G         => TPD_G,
         BUILD_INFO_G  => BUILD_INFO_G,
         COB_GTE_C10_G => true)  -- true = COB with Mellanox ETH SW         
      port map (
         -- IPMI I2C Ports
         i2cSda             => i2cSda,
         i2cScl             => i2cScl,
         -- PCI Express
         pciRefClkP         => pciRefClkP,
         pciRefClkM         => pciRefClkM,
         pciRxP             => pciRxP,
         pciRxM             => pciRxM,
         pciTxP             => pciTxP,
         pciTxM             => pciTxM,
         pciResetL          => pciResetL,
         -- COB Ethernet
         ethRxP             => ethRxP,
         ethRxM             => ethRxM,
         ethTxP             => ethTxP,
         ethTxM             => ethTxM,
         -- Clock Select
         clkSelA            => clkSelA,
         clkSelB            => clkSelB,
         -- Base Ethernet
         ethRxCtrl          => ethRxCtrl,
         ethRxClk           => ethRxClk,
         ethRxDataA         => ethRxDataA,
         ethRxDataB         => ethRxDataB,
         ethRxDataC         => ethRxDataC,
         ethRxDataD         => ethRxDataD,
         ethTxCtrl          => ethTxCtrl,
         ethTxClk           => ethTxClk,
         ethTxDataA         => ethTxDataA,
         ethTxDataB         => ethTxDataB,
         ethTxDataC         => ethTxDataC,
         ethTxDataD         => ethTxDataD,
         ethMdc             => ethMdc,
         ethMio             => ethMio,
         ethResetL          => ethResetL,
         -- IPMI
         dtmToIpmiP         => dtmToIpmiP,
         dtmToIpmiM         => dtmToIpmiM,
         -- Clocks and Resets
         sysClk125          => sysClk125,
         sysClk125Rst       => sysClk125Rst,
         sysClk200          => sysClk200,
         sysClk200Rst       => sysClk200Rst,
         -- AXI-Lite Register Interface
         -- 0x90000000 - 0x97FFFFFF (COB_MIN_C10_G = True)           
         axiClk             => axiClk,
         axiClkRst          => axiClkRst,
         extAxilReadMaster  => extAxilReadMaster,
         extAxilReadSlave   => extAxilReadSlave,
         extAxilWriteMaster => extAxilWriteMaster,
         extAxilWriteSlave  => extAxilWriteSlave,
         -- AXI Stream DMA Interfaces
         dmaClk             => dmaClk,
         dmaClkRst          => dmaClkRst,
         dmaState           => dmaState,
         dmaObMaster        => dmaObMaster,
         dmaObSlave         => dmaObSlave,
         dmaIbMaster        => dmaIbMaster,
         dmaIbSlave         => dmaIbSlave);

   U_AxiVersion : entity surf.AxiVersion
      generic map (
         TPD_G        => TPD_G,
         BUILD_INFO_G => BUILD_INFO_G)
      port map (
         axiClk         => axiClk,
         axiRst         => axiClkRst,
         axiReadMaster  => extAxilReadMaster,
         axiReadSlave   => extAxilReadSlave,
         axiWriteMaster => extAxilWriteMaster,
         axiWriteSlave  => extAxilWriteSlave);

   --------------------------------------------------
   -- PPI Loopback
   --------------------------------------------------
   dmaClk      <= (others => sysClk125);
   dmaClkRst   <= (others => sysClk125Rst);
   dmaIbMaster <= dmaObMaster;
   dmaObSlave  <= dmaIbSlave;

   --------------------------------------------------
   -- Top Level Signals
   --------------------------------------------------

   -- Debug
   led <= (others => '0');

   -- Reference Cloc/afs/slac.stanford.edu/g/reseng/vol15/Xilinx/vivado_2014.1/SDK/2014.1/gnu/arm/lin/k
   --locRefClkP  : in    sl;
   --locRefClkM  : in    sl;

   -- RTM High Speed
   --dtmToRtmHsP : out   sl;
   --dtmToRtmHsM : out   sl;
   --rtmToDtmHsP : in    sl;
   --rtmToDtmHsM : in    sl;

   -- RTM Low Speed
   --dtmToRtmLsP  : inout slv(5 downto 0);
   --dtmToRtmLsM  : inout slv(5 downto 0);

   -- DPM Clock Signals
   U_DpmClkGen : for i in 0 to 2 generate
      U_DpmClkOut : OBUFDS
         port map(
            O  => dpmClkP(i),
            OB => dpmClkM(i),
            I  => '0'
            );
   end generate;

   -- DPM Feedback Signals
   U_DpmFbGen : for i in 0 to 7 generate
      U_DpmFbIn : IBUFDS
         generic map (DIFF_TERM => true)
         port map(
            I  => dpmFbP(i),
            IB => dpmFbM(i),
            O  => open
            );
   end generate;

   -- Backplane Clocks
   --bpClkIn      : in    slv(5 downto 0);
   --bpClkOut     : out   slv(5 downto 0);
   bpClkOut <= (others => '0');

   -- Spare Signals
   --plSpareP     : inout slv(4 downto 0);
   --plSpareM     : inout slv(4 downto 0)

end architecture STRUCTURE;

