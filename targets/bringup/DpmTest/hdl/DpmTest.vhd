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
-- DpmTest.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;
use surf.AxiPkg.all;
use surf.AxiStreamPkg.all;

library rce_gen3_fw_lib;
use rce_gen3_fw_lib.RceG3Pkg.all;

entity DpmTest is
   generic (
      TPD_G           : time := 1 ns;
      BUILD_INFO_G    : BuildInfoType);
   port (

      -- Debug
      led : out slv(1 downto 0);

      -- I2C
      i2cSda : inout sl;
      i2cScl : inout sl;

      -- Ethernet
      ethRxP     : in  slv(3 downto 0);
      ethRxM     : in  slv(3 downto 0);
      ethTxP     : out slv(3 downto 0);
      ethTxM     : out slv(3 downto 0);
      ethRefClkP : in  sl;
      ethRefClkM : in  sl;

      -- RTM High Speed
      dpmToRtmHsP : out slv(11 downto 0);
      dpmToRtmHsM : out slv(11 downto 0);
      rtmToDpmHsP : in  slv(11 downto 0);
      rtmToDpmHsM : in  slv(11 downto 0);

      -- Reference Clocks
      locRefClkP : in sl;
      locRefClkM : in sl;
      dtmRefClkP : in sl;
      dtmRefClkM : in sl;

      -- DTM Signals
      dtmClkP : in  slv(1 downto 0);
      dtmClkM : in  slv(1 downto 0);
      dtmFbP  : out sl;
      dtmFbM  : out sl;

      -- Clock Select
      clkSelA : out slv(1 downto 0);
      clkSelB : out slv(1 downto 0)
      );
end DpmTest;

architecture STRUCTURE of DpmTest is

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
   signal locAxilReadMaster  : AxiLiteReadMasterArray(5 downto 0);
   signal locAxilReadSlave   : AxiLiteReadSlaveArray(5 downto 0);
   signal locAxilWriteMaster : AxiLiteWriteMasterArray(5 downto 0);
   signal locAxilWriteSlave  : AxiLiteWriteSlaveArray(5 downto 0);
   signal prbAxilReadMaster  : AxiLiteReadMasterArray(3 downto 0);
   signal prbAxilReadSlave   : AxiLiteReadSlaveArray(3 downto 0);
   signal prbAxilWriteMaster : AxiLiteWriteMasterArray(3 downto 0);
   signal prbAxilWriteSlave  : AxiLiteWriteSlaveArray(3 downto 0);
   signal dmaClk             : slv(2 downto 0);
   signal dmaClkRst          : slv(2 downto 0);
   signal dmaState           : RceDmaStateArray(2 downto 0);
   signal dmaObMaster        : AxiStreamMasterArray(2 downto 0);
   signal dmaObSlave         : AxiStreamSlaveArray(2 downto 0);
   signal dmaIbMaster        : AxiStreamMasterArray(2 downto 0);
   signal dmaIbSlave         : AxiStreamSlaveArray(2 downto 0);
   signal prbsAxisMaster     : AxiStreamMasterArray(3 downto 0);
   signal prbsAxisSlave      : AxiStreamSlaveArray(3 downto 0);
   signal timingCode         : slv(7 downto 0);
   signal timingCodeEn       : sl;
   signal fbCode             : slv(7 downto 0);
   signal fbCodeEn           : sl;
   signal userInterrupt      : slv(USER_INT_COUNT_C-1 downto 0);

begin

   --------------------------------------------------
   -- Core
   --------------------------------------------------
   U_DpmCore : entity rce_gen3_fw_lib.DpmCore
      generic map (
         TPD_G          => TPD_G,
         BUILD_INFO_G   => BUILD_INFO_G,
         RCE_DMA_MODE_G => RCE_DMA_AXIS_C,
         ETH_TYPE_G     => "ZYNQ-GEM")
      port map (
         i2cSda             => i2cSda,
         i2cScl             => i2cScl,
         ethRxP             => ethRxP,
         ethRxM             => ethRxM,
         ethTxP             => ethTxP,
         ethTxM             => ethTxM,
         ethRefClkP         => ethRefClkP,
         ethRefClkM         => ethRefClkM,
         clkSelA            => clkSelA,
         clkSelB            => clkSelB,
         sysClk125          => sysClk125,
         sysClk125Rst       => sysClk125Rst,
         sysClk200          => sysClk200,
         sysClk200Rst       => sysClk200Rst,
         axiClk             => axiClk,
         axiClkRst          => axiClkRst,
         extAxilReadMaster  => extAxilReadMaster,
         extAxilReadSlave   => extAxilReadSlave,
         extAxilWriteMaster => extAxilWriteMaster,
         extAxilWriteSlave  => extAxilWriteSlave,
         dmaClk             => dmaClk,
         dmaClkRst          => dmaClkRst,
         dmaState           => dmaState,
         dmaObMaster        => dmaObMaster,
         dmaObSlave         => dmaObSlave,
         dmaIbMaster        => dmaIbMaster,
         dmaIbSlave         => dmaIbSlave);

   -------------------------------------
   -- AXI Lite Crossbar
   -- Base: 0xA0000000 - 0xAFFFFFFF
   -------------------------------------
   U_AxiCrossbar : entity surf.AxiLiteCrossbar
      generic map (
         TPD_G              => TPD_G,
         NUM_SLAVE_SLOTS_G  => 1,
         NUM_MASTER_SLOTS_G => 6,
         DEC_ERROR_RESP_G   => AXI_RESP_OK_C,
         MASTERS_CONFIG_G   => (

            0                  => (baseAddr => x"A0000000",
                  addrBits     => 16,
                  connectivity => x"FFFF"),

            1                  => (baseAddr => x"A0010000",
                  addrBits     => 16,
                  connectivity => x"FFFF"),

            2                  => (baseAddr => x"A0020000",
                  addrBits     => 16,
                  connectivity => x"FFFF"),

            3                  => (baseAddr => x"A0030000",
                  addrBits     => 16,
                  connectivity => x"FFFF"),

            4                  => (baseAddr => x"A0040000",
                  addrBits     => 16,
                  connectivity => x"FFFF"),

            5                  => (baseAddr => x"A0050000",
                  addrBits     => 16,
                  connectivity => x"FFFF")
            )
         ) port map (
            axiClk              => axiClk,
            axiClkRst           => axiClkRst,
            sAxiWriteMasters(0) => extAxilWriteMaster,
            sAxiWriteSlaves(0)  => extAxilWriteSlave,
            sAxiReadMasters(0)  => extAxilReadMaster,
            sAxiReadSlaves(0)   => extAxilReadSlave,
            mAxiWriteMasters    => locAxilWriteMaster,
            mAxiWriteSlaves     => locAxilWriteSlave,
            mAxiReadMasters     => locAxilReadMaster,
            mAxiReadSlaves      => locAxilReadSlave
            );


   --------------------------------------------------
   -- PPI Loopback
   --------------------------------------------------
   dmaClk         <= (others => sysClk200);
   dmaClkRst      <= (others => sysClk200Rst);
   dmaIbMaster(1) <= dmaObMaster(1);
   dmaObSlave(1)  <= dmaIbSlave(1);
   dmaObSlave(2)  <= AXI_STREAM_SLAVE_FORCE_C;

   U_PrbsGen : for i in 0 to 3 generate
      U_SsiPrbsRateGen : entity surf.SsiPrbsRateGen
         generic map (
            VALID_THOLD_G      => 128,
            VALID_BURST_MODE_G => true,
            FIFO_ADDR_WIDTH_G  => 10,
            AXIS_CLK_FREQ_G    => 200.0E+6,
            AXIS_CONFIG_G      => RCEG3_AXIS_DMA_CONFIG_C)
         port map (
            mAxisClk        => sysClk200,
            mAxisRst        => sysClk200Rst,
            mAxisMaster     => prbsAxisMaster(i),
            mAxisSlave      => prbsAxisSlave(i),
            axilReadMaster  => prbAxilReadMaster(i),
            axilReadSlave   => prbAxilReadSlave(i),
            axilWriteMaster => prbAxilWriteMaster(i),
            axilWriteSlave  => prbAxilWriteSlave(i));

      U_AxiLiteAsync : entity surf.AxiLiteAsync
         port map (
            sAxiClk         => axiClk,
            sAxiClkRst      => axiClkRst,
            sAxiReadMaster  => locAxilReadMaster(2+i),
            sAxiReadSlave   => locAxilReadSlave(2+i),
            sAxiWriteMaster => locAxilWriteMaster(2+i),
            sAxiWriteSlave  => locAxilWriteSlave(2+i),
            mAxiClk         => sysClk200,
            mAxiClkRst      => sysClk200Rst,
            mAxiReadMaster  => prbAxilReadMaster(i),
            mAxiReadSlave   => prbAxilReadSlave(i),
            mAxiWriteMaster => prbAxilWriteMaster(i),
            mAxiWriteSlave  => prbAxilWriteSlave(i));

   end generate;

   U_PrbsMuxA : entity surf.AxiStreamMux
      generic map (
         NUM_SLAVES_G   => 2,
         MODE_G         => "INDEXED",
         TDEST_LOW_G    => 0,
         ILEAVE_EN_G    => true,
         --ILEAVE_REARB_G => 64)
         ILEAVE_REARB_G => 0)
      port map (
         axisClk      => sysClk200,
         axisRst      => sysClk200Rst,
         sAxisMasters => prbsAxisMaster(1 downto 0),
         sAxisSlaves  => prbsAxisSlave(1 downto 0),
         mAxisMaster  => dmaIbMaster(2),
         mAxisSlave   => dmaIbSlave(2));

   U_PrbsMuxB : entity surf.AxiStreamMux
      generic map (
         NUM_SLAVES_G   => 2,
         MODE_G         => "INDEXED",
         TDEST_LOW_G    => 0,
         ILEAVE_EN_G    => true,
         --ILEAVE_REARB_G => 64)
         ILEAVE_REARB_G => 0)
      port map (
         axisClk      => sysClk200,
         axisRst      => sysClk200Rst,
         sAxisMasters => prbsAxisMaster(3 downto 2),
         sAxisSlaves  => prbsAxisSlave(3 downto 2),
         mAxisMaster  => dmaIbMaster(0),
         mAxisSlave   => dmaIbSlave(0));

   --------------------------------------------------
   -- Timing Signals
   --------------------------------------------------
   U_DpmTimingSink : entity rce_gen3_fw_lib.DpmTimingSink
      generic map (
         TPD_G => TPD_G
         ) port map (
            axiClk         => axiClk,
            axiClkRst      => axiClkRst,
            axiReadMaster  => locAxilReadMaster(0),
            axiReadSlave   => locAxilReadSlave(0),
            axiWriteMaster => locAxilWriteMaster(0),
            axiWriteSlave  => locAxilWriteSlave(0),
            sysClk200      => sysClk200,
            sysClk200Rst   => sysClk200Rst,
            dtmClkP        => dtmClkP,
            dtmClkM        => dtmClkM,
            dtmFbP         => dtmFbP,
            dtmFbM         => dtmFbM,
            distClk        => open,
            distClkRst     => open,
            timingCode     => timingCode,
            timingCodeEn   => timingCodeEn,
            fbCode         => fbCode,
            fbCodeEn       => fbCodeEn,
            led            => led
            );

   fbCode   <= timingCode;
   fbCodeEn <= timingCodeEn;


   --------------------------------------------------
   -- RTM Testing
   --------------------------------------------------
   U_RtmTest : entity work.DpmRtmTest
      generic map (
         TPD_G => TPD_G
         ) port map (
            sysClk200         => sysClk200,
            sysClk200Rst      => sysClk200Rst,
            axiClk            => axiClk,
            axiClkRst         => axiClkRst,
            topAxiReadMaster  => locAxilReadMaster(1),
            topAxiReadSlave   => locAxilReadSlave(1),
            topAxiWriteMaster => locAxilWriteMaster(1),
            topAxiWriteSlave  => locAxilWriteSlave(1),
            locRefClkP        => locRefClkP,
            locRefClkM        => locRefClkM,
            dpmToRtmHsP       => dpmToRtmHsP,
            dpmToRtmHsM       => dpmToRtmHsM,
            rtmToDpmHsP       => rtmToDpmHsP,
            rtmToDpmHsM       => rtmToDpmHsM
            );


   --------------------------------------------------
   -- Top Level Signals
   --------------------------------------------------

   -- Reference Clocks
   --dtmRefClkP   : in    sl;
   --dtmRefClkM   : in    sl;

end architecture STRUCTURE;
