-------------------------------------------------------------------------------
-- File       : DtmEmpty.vhd
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2018-06-13
-- Last update: 2018-08-30
-------------------------------------------------------------------------------
-- Description: Top Level Firmware Target
-------------------------------------------------------------------------------
-- This file is part of 'RCE Development Firmware'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'RCE Development Firmware', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.AxiPkg.all;
use work.AxiStreamPkg.all;
use work.RceG3Pkg.all;

library unisim;
use unisim.vcomponents.all;

entity DtmEmpty is
   generic (
      TPD_G        : time := 1 ns;
      BUILD_INFO_G : BuildInfoType);
   port (
      -- Debug
      led         : out   slv(1 downto 0);
      -- I2C
      i2cSda      : inout sl;
      i2cScl      : inout sl;
      -- PCI Express
      pciRefClkP  : in    sl;
      pciRefClkM  : in    sl;
      pciRxP      : in    sl;
      pciRxM      : in    sl;
      pciTxP      : out   sl;
      pciTxM      : out   sl;
      pciResetL   : out   sl;
      -- COB Ethernet
      ethRxP      : in    sl;
      ethRxM      : in    sl;
      ethTxP      : out   sl;
      ethTxM      : out   sl;
      -- Reference Clock
      locRefClkP  : in    sl;
      locRefClkM  : in    sl;
      -- Clock Select
      clkSelA     : out   sl;
      clkSelB     : out   sl;
      -- Base Ethernet
      ethRxCtrl   : in    slv(1 downto 0);
      ethRxClk    : in    slv(1 downto 0);
      ethRxDataA  : in    Slv(1 downto 0);
      ethRxDataB  : in    Slv(1 downto 0);
      ethRxDataC  : in    Slv(1 downto 0);
      ethRxDataD  : in    Slv(1 downto 0);
      ethTxCtrl   : out   slv(1 downto 0);
      ethTxClk    : out   slv(1 downto 0);
      ethTxDataA  : out   Slv(1 downto 0);
      ethTxDataB  : out   Slv(1 downto 0);
      ethTxDataC  : out   Slv(1 downto 0);
      ethTxDataD  : out   Slv(1 downto 0);
      ethMdc      : out   Slv(1 downto 0);
      ethMio      : inout Slv(1 downto 0);
      ethResetL   : out   Slv(1 downto 0);
      -- RTM High Speed
      dtmToRtmHsP : out   sl;
      dtmToRtmHsM : out   sl;
      rtmToDtmHsP : in    sl;
      rtmToDtmHsM : in    sl;
      -- RTM Low Speed
      dtmToRtmLsP : inout slv(5 downto 0);
      dtmToRtmLsM : inout slv(5 downto 0);
      -- DPM Signals
      dpmClkP     : out   slv(2 downto 0);
      dpmClkM     : out   slv(2 downto 0);
      dpmFbP      : in    slv(7 downto 0);
      dpmFbM      : in    slv(7 downto 0);
      -- Backplane Clocks
      bpClkIn     : in    slv(5 downto 0);
      bpClkOut    : out   slv(5 downto 0);
      -- IPMI
      dtmToIpmiP  : out   slv(1 downto 0);
      dtmToIpmiM  : out   slv(1 downto 0));
end DtmEmpty;

architecture TOP_LEVEL of DtmEmpty is

   signal axilClk         : sl;
   signal axilRst         : sl;
   signal axilReadMaster  : AxiLiteReadMasterType  := AXI_LITE_READ_MASTER_INIT_C;
   signal axilReadSlave   : AxiLiteReadSlaveType   := AXI_LITE_READ_SLAVE_EMPTY_OK_C;
   signal axilWriteMaster : AxiLiteWriteMasterType := AXI_LITE_WRITE_MASTER_INIT_C;
   signal axilWriteSlave  : AxiLiteWriteSlaveType  := AXI_LITE_WRITE_SLAVE_EMPTY_OK_C;

   signal dmaClk      : slv(2 downto 0);
   signal dmaRst      : slv(2 downto 0);
   signal dmaIbMaster : AxiStreamMasterArray(2 downto 0);
   signal dmaIbSlave  : AxiStreamSlaveArray(2 downto 0);
   signal dmaObMaster : AxiStreamMasterArray(2 downto 0);
   signal dmaObSlave  : AxiStreamSlaveArray(2 downto 0);

begin

   led <= "00";

   --------------------------------------------------
   -- Core
   --------------------------------------------------
   U_DtmCore : entity work.DtmCore
      generic map (
         TPD_G          => TPD_G,
         BUILD_INFO_G   => BUILD_INFO_G,
         COB_GTE_C10_G  => true, -- true = COB with Mellanox ETH SW
         RCE_DMA_MODE_G => RCE_DMA_AXISV2_C)
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
         -- AXI-Lite Register Interface
         -- 0x90000000 - 0x97FFFFFF (COB_MIN_C10_G = True)         
         axiClk             => axilClk,
         axiClkRst          => axilRst,
         extAxilReadMaster  => axilReadMaster,
         extAxilReadSlave   => axilReadSlave,
         extAxilWriteMaster => axilWriteMaster,
         extAxilWriteSlave  => axilWriteSlave,
         -- AXI Stream DMA Interfaces
         dmaClk             => dmaClk,
         dmaClkRst          => dmaRst,
         dmaObMaster        => dmaObMaster,
         dmaObSlave         => dmaObSlave,
         dmaIbMaster        => dmaIbMaster,
         dmaIbSlave         => dmaIbSlave);

   dmaClk      <= (others => axilClk);
   dmaRst      <= (others => axilRst);
   dmaIbMaster <= dmaObMaster;
   dmaObSlave  <= dmaIbSlave;

   ----------
   -- RTM GTs
   ----------
   U_TERM_GTs : entity work.Gtxe2ChannelDummy
      generic map (
         TPD_G   => TPD_G,
         WIDTH_G => 1)
      port map (
         refClk   => axilClk,
         gtRxP(0) => rtmToDtmHsP,
         gtRxN(0) => rtmToDtmHsM,
         gtTxP(0) => dtmToRtmHsP,
         gtTxN(0) => dtmToRtmHsM);

   ------------
   -- DPM Clock
   ------------
   U_DpmClkGen : for i in 0 to 2 generate
      U_DpmClkOut : OBUFDS
         port map(
            O  => dpmClkP(i),
            OB => dpmClkM(i),
            I  => '0');
   end generate;

   ---------------
   -- DPM Feedback
   ---------------
   U_DpmFbGen : for i in 0 to 7 generate
      U_DpmFbIn : IBUFDS
         port map(
            I  => dpmFbP(i),
            IB => dpmFbM(i),
            O  => open);
   end generate;

   -------------------
   -- Backplane Clocks
   -------------------
   bpClkOut <= (others => '0');

end TOP_LEVEL;
