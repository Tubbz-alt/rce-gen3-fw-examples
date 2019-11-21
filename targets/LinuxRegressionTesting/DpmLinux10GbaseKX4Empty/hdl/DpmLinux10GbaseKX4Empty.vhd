-------------------------------------------------------------------------------
-- Title      : 
-------------------------------------------------------------------------------
-- File       : DpmLinux10GbaseKX4Empty.vhd
-- Author     : Ryan Herbst <rherbst@slac.stanford.edu>
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2015-09-03
-- Last update: 2019-04-17
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: AXIS 1GbE 
-------------------------------------------------------------------------------
-- This file is part of 'RCE Development Firmware'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'RCE Development Firmware', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;
use surf.AxiPkg.all;
use surf.AxiStreamPkg.all;

library rce_gen3_fw_lib;
use rce_gen3_fw_lib.RceG3Pkg.all;

library unisim;
use unisim.vcomponents.all;

entity DpmLinux10GbaseKX4Empty is
   generic (
      TPD_G        : time := 1 ns;
      BUILD_INFO_G : BuildInfoType);
   port (
      -- Debug
      led         : out   slv(1 downto 0);
      -- I2C
      i2cSda      : inout sl;
      i2cScl      : inout sl;
      -- Ethernet
      ethRxP      : in    slv(3 downto 0);
      ethRxM      : in    slv(3 downto 0);
      ethTxP      : out   slv(3 downto 0);
      ethTxM      : out   slv(3 downto 0);
      ethRefClkP  : in    sl;
      ethRefClkM  : in    sl;
      -- RTM High Speed
      dpmToRtmHsP : out   slv(11 downto 0);
      dpmToRtmHsM : out   slv(11 downto 0);
      rtmToDpmHsP : in    slv(11 downto 0);
      rtmToDpmHsM : in    slv(11 downto 0);
      -- Reference Clocks
      locRefClkP  : in    sl;
      locRefClkM  : in    sl;
      dtmRefClkP  : in    sl;
      dtmRefClkM  : in    sl;
      -- DTM Signals
      dtmClkP     : in    slv(1 downto 0);
      dtmClkM     : in    slv(1 downto 0);
      dtmFbP      : out   sl;
      dtmFbM      : out   sl;
      -- Clock Select
      clkSelA     : out   slv(1 downto 0);
      clkSelB     : out   slv(1 downto 0));
end DpmLinux10GbaseKX4Empty;

architecture TOP_LEVEL of DpmLinux10GbaseKX4Empty is

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
   U_DpmCore : entity rce_gen3_fw_lib.DpmCore
      generic map (
         TPD_G              => TPD_G,
         RCE_DMA_MODE_G     => RCE_DMA_AXIS_C,
         BUILD_INFO_G       => BUILD_INFO_G,
         ETH_TYPE_G         => "10GBASE-KX4",
         UDP_SERVER_EN_G    => true,
         UDP_SERVER_SIZE_G  => 1,
         UDP_SERVER_PORTS_G => (0 => 8192),
         BYP_EN_G           => false,
         BYP_ETH_TYPE_G     => x"AAAA",
         VLAN_EN_G          => false,
         VLAN_SIZE_G        => 1)
      port map (
         -- IPMI I2C Ports
         i2cSda             => i2cSda,
         i2cScl             => i2cScl,
         -- Clock Select
         clkSelA            => clkSelA,
         clkSelB            => clkSelB,
         -- Ethernet Ports
         ethRxP             => ethRxP,
         ethRxM             => ethRxM,
         ethTxP             => ethTxP,
         ethTxM             => ethTxM,
         ethRefClkP         => ethRefClkP,
         ethRefClkM         => ethRefClkM,
         -- AXI-Lite Register Interface [0xA0000000:0xAFFFFFFF]
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
   U_TERM_GTs : entity surf.Gtxe2ChannelDummy
      generic map (
         TPD_G   => TPD_G,
         WIDTH_G => 12)
      port map (
         refClk => axilClk,
         gtRxP  => rtmToDpmHsP,
         gtRxN  => rtmToDpmHsM,
         gtTxP  => dpmToRtmHsP,
         gtTxN  => dpmToRtmHsM);

   ------------
   -- DTM Clock
   ------------
   U_DtmClkgen : for i in 1 downto 0 generate
      U_DtmClkIn : IBUFDS
         generic map (DIFF_TERM => true)
         port map(
            I  => dtmClkP(i),
            IB => dtmClkM(i),
            O  => open);
   end generate;

   ---------------
   -- DTM Feedback
   ---------------
   U_DtmFbOut : OBUFDS
      port map(
         O  => dtmFbP,
         OB => dtmFbM,
         I  => '0');

end TOP_LEVEL;
