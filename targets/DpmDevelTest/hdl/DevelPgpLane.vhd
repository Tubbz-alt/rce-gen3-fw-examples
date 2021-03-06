-------------------------------------------------------------------------------
-- Title         : PGP Lane For Data DPM
-- File          : HpsPgpCtrlLane.vhd
-- Author        : Ryan Herbst, rherbst@slac.stanford.edu
-- Created       : 05/21/2014
-------------------------------------------------------------------------------
-- Description:
-- PGP Lane
-------------------------------------------------------------------------------
-- This file is part of 'RCE Development Firmware'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'RCE Development Firmware', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------
-- Modification history:
-- 05/21/2014: created.
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
use surf.Pgp2bPkg.all;
use surf.Gtx7CfgPkg.all;

library rce_gen3_fw_lib;
use rce_gen3_fw_lib.RceG3Pkg.all;

library unisim;
use unisim.vcomponents.all;

entity DevelPgpLane is
   generic (
      TPD_G  : time := 1 ns
   );
   port (

      -- Sys Clocks
      sysClk200       : in  sl;

      -- AXI Bus
      axiClk          : in  sl;
      axiClkRst       : in  sl;
      axiReadMaster   : in  AxiLiteReadMasterType;
      axiReadSlave    : out AxiLiteReadSlaveType;
      axiWriteMaster  : in  AxiLiteWriteMasterType;
      axiWriteSlave   : out AxiLiteWriteSlaveType;

      -- AXI Streaming
      pgpAxisClk      : in  sl;
      pgpAxisRst      : in  sl;
      pgpDataRxMaster : out AxiStreamMasterType;
      pgpDataRxSlave  : in  AxiStreamSlaveType;
      pgpDataTxMaster : in  AxiStreamMasterType;
      pgpDataTxSlave  : out AxiStreamSlaveType;
      pgpDmaState     : in  RceDmaStateType;

      -- Reference Clock
      locRefClkP      : in  sl;
      locRefClkM      : in  sl;

      -- PHY
      pgpTxP          : out sl;
      pgpTxM          : out sl;
      pgpRxP          : in  sl;
      pgpRxM          : in  sl
   );
end DevelPgpLane;

architecture STRUCTURE of DevelPgpLane is

   signal pgpClkRst          : sl;
   signal pgpClk             : sl;
   signal locRefClk          : sl;
   signal locRefClkG         : sl;
   signal pgpRxIn            : Pgp2bRxInType;
   signal pgpRxOut           : Pgp2bRxOutType;
   signal pgpTxIn            : Pgp2bTxInType;
   signal pgpTxOut           : Pgp2bTxOutType;
   signal muxTxMaster        : AxiStreamMasterType;
   signal muxTxSlave         : AxiStreamSlaveType;
   signal pgpTxMasters       : AxiStreamMasterArray(3 downto 0);
   signal pgpTxSlaves        : AxiStreamSlaveArray(3 downto 0);
   signal pgpRxMastersMuxed  : AxiStreamMasterType;
   signal pgpRxCtrl          : AxiStreamCtrlType;

   constant AXIL_CLK_FREQ_C    : real            := 125.0E6;
   constant PGP_LINE_RATE_G    : real            := 3.125E9;
   constant GTX_REFCLK_FREQ_C  : real            := 250.0E6;
   constant PGP_GTX_CPLL_CFG_C : Gtx7CPllCfgType := getGtx7CPllCfg(GTX_REFCLK_FREQ_C, PGP_LINE_RATE_G);

begin

   -- locRefClk drives PGP
   U_LocRefClkIbufds : IBUFDS_GTE2
      port map (
         I     => locRefClkP,
         IB    => locRefClkM,
         CEB   => '0',
         O     => locRefClk,
         ODIV2 => open);

   U_LocRefClkBufg : BUFG
      port map (
         I => locRefClk,
         O => locRefClkG);

   ClockManager7_1 : entity surf.ClockManager7
      generic map (
         TPD_G              => TPD_G,
         TYPE_G             => "MMCM",
         INPUT_BUFG_G       => false,
         FB_BUFG_G          => true,
         RST_IN_POLARITY_G  => '1',
         NUM_CLOCKS_G       => 1,
         BANDWIDTH_G        => "OPTIMIZED",
         CLKIN_PERIOD_G     => 4.0,
         DIVCLK_DIVIDE_G    => 1,
         CLKFBOUT_MULT_F_G  => 5.0,
         CLKOUT0_DIVIDE_G   => 8,
         CLKOUT0_RST_HOLD_G => 8)
      port map (
         clkIn     => locRefClkG,
         rstIn     => axiClkRst,
         clkOut(0) => pgpClk,
         rstOut(0) => pgpClkRst);

   Pgp2bGtx7VarLat_1 : entity surf.Pgp2bGtx7VarLat
      generic map (
         TPD_G                 => TPD_G,
         STABLE_CLOCK_PERIOD_G => 4.0E-9,
         CPLL_REFCLK_SEL_G     => "001",
         CPLL_FBDIV_G          => PGP_GTX_CPLL_CFG_C.CPLL_FBDIV_G,
         CPLL_FBDIV_45_G       => PGP_GTX_CPLL_CFG_C.CPLL_FBDIV_45_G,
         CPLL_REFCLK_DIV_G     => PGP_GTX_CPLL_CFG_C.CPLL_REFCLK_DIV_G,
         RXOUT_DIV_G           => PGP_GTX_CPLL_CFG_C.OUT_DIV_G,
         TXOUT_DIV_G           => PGP_GTX_CPLL_CFG_C.OUT_DIV_G,
         RX_CLK25_DIV_G        => PGP_GTX_CPLL_CFG_C.CLK25_DIV_G,
         TX_CLK25_DIV_G        => PGP_GTX_CPLL_CFG_C.CLK25_DIV_G,
         TX_PLL_G              => "CPLL",
         RX_PLL_G              => "CPLL",
         PAYLOAD_CNT_TOP_G     => 7,
         VC_INTERLEAVE_G       => 1,
         NUM_VC_EN_G           => 4)
      port map (
         stableClk        => sysClk200,
         gtCPllRefClk     => locRefClk,
         gtCPllLock       => open,
         gtQPllRefClk     => '0',
         gtQPllClk        => '0',
         gtQPllLock       => '0',
         gtQPllRefClkLost => '0',
         gtQPllReset      => open,
         gtTxP            => pgpTxP,
         gtTxN            => pgpTxM,
         gtRxP            => pgpRxP,
         gtRxN            => pgpRxM,
         pgpTxReset       => pgpClkRst,
         pgpTxClk         => pgpClk,
         pgpTxRecClk      => open,
         pgpTxMmcmReset   => open,
         pgpTxMmcmLocked  => '1',
         pgpRxReset       => pgpClkRst,
         pgpRxRecClk      => open,
         pgpRxClk         => pgpClk,
         pgpRxMmcmReset   => open,
         pgpRxMmcmLocked  => '1',
         pgpRxIn          => pgpRxIn,
         pgpRxOut         => pgpRxOut,
         pgpTxIn          => pgpTxIn,
         pgpTxOut         => pgpTxOut,
         pgpTxMasters     => pgpTxMasters,
         pgpTxSlaves      => pgpTxSlaves,
         pgpRxMasters     => open,
         pgpRxMasterMuxed => pgpRxMastersMuxed,
         pgpRxCtrl(0)     => pgpRxCtrl,
         pgpRxCtrl(1)     => pgpRxCtrl,
         pgpRxCtrl(2)     => pgpRxCtrl,
         pgpRxCtrl(3)     => pgpRxCtrl);

   -- PGP Axil Controller
   U_Pgp2bAxi : entity surf.Pgp2bAxi 
      generic map (
         TPD_G              => TPD_G,
         COMMON_TX_CLK_G    => false,
         COMMON_RX_CLK_G    => false,
         WRITE_EN_G         => true,
         AXI_CLK_FREQ_G     => AXIL_CLK_FREQ_C,
         STATUS_CNT_WIDTH_G => 32,
         ERROR_CNT_WIDTH_G  => 4
      ) port map (
         pgpTxClk          => pgpClk,
         pgpTxClkRst       => pgpClkRst,
         pgpTxIn           => pgpTxIn,
         pgpTxOut          => pgpTxOut,
         pgpRxClk          => pgpClk,
         pgpRxClkRst       => pgpClkRst,
         pgpRxIn           => pgpRxIn,
         pgpRxOut          => pgpRxOut,
         statusWord        => open,
         statusSend        => open,
         axilClk           => axiClk,
         axilRst           => axiClkRst,
         axilReadMaster    => axiReadMaster,
         axilReadSlave     => axiReadSlave,
         axilWriteMaster   => axiWriteMaster,
         axilWriteSlave    => axiWriteSlave
      );

   U_RxFifo : entity surf.AxiStreamFifo
      generic map (
         TPD_G               => TPD_G,
         PIPE_STAGES_G       => 1,
         SLAVE_READY_EN_G    => false,
         VALID_THOLD_G       => 1,
         MEMORY_TYPE_G       => "block",
         GEN_SYNC_FIFO_G     => false,
         FIFO_ADDR_WIDTH_G   => 9,
         FIFO_FIXED_THRESH_G => true,
         FIFO_PAUSE_THRESH_G => 255,
         SLAVE_AXI_CONFIG_G  => SSI_PGP2B_CONFIG_C,
         MASTER_AXI_CONFIG_G => RCEG3_AXIS_DMA_CONFIG_C)
      port map (
         sAxisClk        => pgpClk,
         sAxisRst        => pgpClkRst,
         sAxisMaster     => pgpRxMastersMuxed,
         sAxisSlave      => open,
         sAxisCtrl       => pgpRxCtrl,
         fifoPauseThresh => (others => '1'),
         mAxisClk        => pgpAxisClk,
         mAxisRst        => pgpAxisRst,
         mAxisMaster     => pgpDataRxMaster,
         mAxisSlave      => pgpDataRxSlave);

   U_TxFifo : entity surf.AxiStreamFifo
      generic map (
         TPD_G               => TPD_G,
         PIPE_STAGES_G       => 1,
         SLAVE_READY_EN_G    => true,
         VALID_THOLD_G       => 1,
         MEMORY_TYPE_G       => "block",
         GEN_SYNC_FIFO_G     => false,
         FIFO_ADDR_WIDTH_G   => 9,
         FIFO_FIXED_THRESH_G => true,
         FIFO_PAUSE_THRESH_G => 255,
         SLAVE_AXI_CONFIG_G  => RCEG3_AXIS_DMA_CONFIG_C,
         MASTER_AXI_CONFIG_G => SSI_PGP2B_CONFIG_C)
      port map (
         sAxisClk        => pgpAxisClk,
         sAxisRst        => pgpAxisRst,
         sAxisMaster     => pgpDataTxMaster,
         sAxisSlave      => pgpDataTxSlave,
         sAxisCtrl       => open,
         fifoPauseThresh => (others => '1'),
         mAxisClk        => pgpClk,
         mAxisRst        => pgpClkRst,
         mAxisMaster     => muxTxMaster,
         mAxisSlave      => muxTxSlave);

   U_PgpTxMux : entity surf.AxiStreamDeMux 
      generic map (
         TPD_G         => TPD_G,
         NUM_MASTERS_G => 4
      ) port map (
         axisClk      => pgpClk,
         axisRst      => pgpClkRst,
         sAxisMaster  => muxTxMaster, 
         sAxisSlave   => muxTxSlave, 
         mAxisMasters => pgpTxMasters,
         mAxisSlaves  => pgpTxSlaves
      );

end architecture STRUCTURE;

