-------------------------------------------------------------------------------
-- File       : HsioDtmEmpty.vhd
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2018-05-01
-- Last update: 2018-08-30
-------------------------------------------------------------------------------
-- Description: 
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

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;
use surf.AxiPkg.all;
use surf.AxiStreamPkg.all;

library rce_gen3_fw_lib;
use rce_gen3_fw_lib.RceG3Pkg.all;

library unisim;
use unisim.vcomponents.all;

entity HsioDtmEmpty is
   generic (
      TPD_G        : time := 1 ns;
      BUILD_INFO_G : BuildInfoType);
   port (
      -- Debug
      led        : out   slv(1 downto 0);
      -- I2C
      i2cSda     : inout sl;
      i2cScl     : inout sl;
      -- Clock Select
      clkSelA    : out   sl;
      clkSelB    : out   sl;
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
      -- IPMI
      dtmToIpmiP : out   slv(1 downto 0);
      dtmToIpmiM : out   slv(1 downto 0));
end HsioDtmEmpty;

architecture TOP_LEVEL of HsioDtmEmpty is

   signal axilClk         : sl;
   signal axilRst         : sl;
   signal axilReadMaster  : AxiLiteReadMasterType  := AXI_LITE_READ_MASTER_INIT_C;
   signal axilReadSlave   : AxiLiteReadSlaveType   := AXI_LITE_READ_SLAVE_EMPTY_OK_C;
   signal axilWriteMaster : AxiLiteWriteMasterType := AXI_LITE_WRITE_MASTER_INIT_C;
   signal axilWriteSlave  : AxiLiteWriteSlaveType  := AXI_LITE_WRITE_SLAVE_EMPTY_OK_C;

   signal dmaClk      : slv(3 downto 0);
   signal dmaRst      : slv(3 downto 0);
   signal dmaIbMaster : AxiStreamMasterArray(3 downto 0);
   signal dmaIbSlave  : AxiStreamSlaveArray(3 downto 0);
   signal dmaObMaster : AxiStreamMasterArray(3 downto 0);
   signal dmaObSlave  : AxiStreamSlaveArray(3 downto 0);

begin

   led <= "00";

   -----------
   -- DTM Core
   -----------
   U_HsioCore : entity rce_gen3_fw_lib.HsioCore
      generic map (
         TPD_G          => TPD_G,
         BUILD_INFO_G   => BUILD_INFO_G,
         RCE_DMA_MODE_G => RCE_DMA_AXISV2_C)  -- AXIS V2 Driver
      port map (
         -- I2C
         i2cSda             => i2cSda,
         i2cScl             => i2cScl,
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
         -- External Axi Bus, 0xA0000000 - 0xAFFFFFFF
         axiClk             => axilClk,
         axiClkRst          => axilRst,
         extAxilReadMaster  => axilReadMaster,
         extAxilReadSlave   => axilReadSlave,
         extAxilWriteMaster => axilWriteMaster,
         extAxilWriteSlave  => axilWriteSlave,
         -- DMA Interfaces
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

end TOP_LEVEL;
