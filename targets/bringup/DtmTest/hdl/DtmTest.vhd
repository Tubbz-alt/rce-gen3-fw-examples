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
-- DtmTest.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
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


entity DtmTest is
   generic (
      TPD_G        : time := 1 ns;
      BUILD_INFO_G : BuildInfoType);
   port (

      -- Debug
      led          : out   slv(1 downto 0);

      -- I2C
      i2cSda       : inout sl;
      i2cScl       : inout sl;

      -- PCI Exress
      pciRefClkP   : in    sl;
      pciRefClkM   : in    sl;
      pciRxP       : in    sl;
      pciRxM       : in    sl;
      pciTxP       : out   sl;
      pciTxM       : out   sl;
      pciResetL    : out   sl;

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
      dtmToRtmLsP  : inout slv(5 downto 0);
      dtmToRtmLsM  : inout slv(5 downto 0);

      -- DPM Signals
      dpmClkP      : out   slv(2  downto 0);
      dpmClkM      : out   slv(2  downto 0);
      dpmFbP       : in    slv(7  downto 0);
      dpmFbM       : in    slv(7  downto 0);

      -- Backplane Clocks
      bpClkIn      : in    slv(5 downto 0);
      bpClkOut     : out   slv(5 downto 0);

      -- Spare Signals
      --plSpareP     : inout slv(4 downto 0);
      --plSpareM     : inout slv(4 downto 0);

      -- IPMI
      dtmToIpmiP   : out   slv(1 downto 0);
      dtmToIpmiM   : out   slv(1 downto 0)

   );
end DtmTest;

architecture STRUCTURE of DtmTest is

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
   signal locAxilReadMaster  : AxiLiteReadMasterArray(1 downto 0);
   signal locAxilReadSlave   : AxiLiteReadSlaveArray(1 downto 0);
   signal locAxilWriteMaster : AxiLiteWriteMasterArray(1 downto 0);
   signal locAxilWriteSlave  : AxiLiteWriteSlaveArray(1 downto 0);
   signal dmaClk             : slv(2 downto 0);
   signal dmaClkRst          : slv(2 downto 0);
   signal dmaState           : RceDmaStateArray(2 downto 0);
   signal dmaObMaster        : AxiStreamMasterArray(2 downto 0);
   signal dmaObSlave         : AxiStreamSlaveArray(2 downto 0);
   signal dmaIbMaster        : AxiStreamMasterArray(2 downto 0);
   signal dmaIbSlave         : AxiStreamSlaveArray(2 downto 0);

begin

   --------------------------------------------------
   -- Core
   --------------------------------------------------
   U_DtmCore: entity rce_gen3_fw_lib.DtmCore 
      generic map (
         TPD_G         => TPD_G,
         BUILD_INFO_G  => BUILD_INFO_G,
         COB_GTE_C10_G => false)  -- false = COB with Fulcrum ETH SW  
      port map (
         -- IPMI I2C Ports
         i2cSda              => i2cSda,
         i2cScl              => i2cScl,
         -- PCI Express
         pciRefClkP          => pciRefClkP,
         pciRefClkM          => pciRefClkM,
         pciRxP              => pciRxP,
         pciRxM              => pciRxM,
         pciTxP              => pciTxP,
         pciTxM              => pciTxM,
         pciResetL           => pciResetL,
         -- COB Ethernet
         ethRxP              => ethRxP,
         ethRxM              => ethRxM,
         ethTxP              => ethTxP,
         ethTxM              => ethTxM,
         -- Clock Select
         clkSelA             => clkSelA,
         clkSelB             => clkSelB,
         -- Base Ethernet
         ethRxCtrl           => ethRxCtrl,
         ethRxClk            => ethRxClk,
         ethRxDataA          => ethRxDataA,
         ethRxDataB          => ethRxDataB,
         ethRxDataC          => ethRxDataC,
         ethRxDataD          => ethRxDataD,
         ethTxCtrl           => ethTxCtrl,
         ethTxClk            => ethTxClk,
         ethTxDataA          => ethTxDataA,
         ethTxDataB          => ethTxDataB,
         ethTxDataC          => ethTxDataC,
         ethTxDataD          => ethTxDataD,
         ethMdc              => ethMdc,
         ethMio              => ethMio,
         ethResetL           => ethResetL,
         -- IPMI
         dtmToIpmiP          => dtmToIpmiP,
         dtmToIpmiM          => dtmToIpmiM,
         -- Clocks and Resets
         sysClk125           => sysClk125,
         sysClk125Rst        => sysClk125Rst,
         sysClk200           => sysClk200,
         sysClk200Rst        => sysClk200Rst,
         -- AXI-Lite Register Interface
         -- 0xA0000000 - 0xAFFFFFFF (COB_MIN_C10_G = false)           
         axiClk              => axiClk,
         axiClkRst           => axiClkRst,
         extAxilReadMaster   => extAxilReadMaster,
         extAxilReadSlave    => extAxilReadSlave,
         extAxilWriteMaster  => extAxilWriteMaster,
         extAxilWriteSlave   => extAxilWriteSlave,
         -- AXI Stream DMA Interfaces
         dmaClk              => dmaClk,
         dmaClkRst           => dmaClkRst,
         dmaState            => dmaState,
         dmaObMaster         => dmaObMaster,
         dmaObSlave          => dmaObSlave,
         dmaIbMaster         => dmaIbMaster,
         dmaIbSlave          => dmaIbSlave);

   -------------------------------------
   -- AXI Lite Crossbar
   -- Base: 0xA0000000 - 0xAFFFFFFF
   -------------------------------------
   U_AxiCrossbar : entity surf.AxiLiteCrossbar 
      generic map (
         TPD_G              => TPD_G,
         NUM_SLAVE_SLOTS_G  => 1,
         NUM_MASTER_SLOTS_G => 2,
         DEC_ERROR_RESP_G   => AXI_RESP_OK_C,
         MASTERS_CONFIG_G   => (

            -- Channel 0 = 0xA0000000 - 0xA000FFFF : DTM Timing Source
            0 => ( baseAddr     => x"A0000000",
                   addrBits     => 16,
                   connectivity => x"FFFF"),

            -- Channel 1 = 0xA0001000 - 0xA001FFFF : PGP Test
            1 => ( baseAddr     => x"A0010000",
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
   dmaClk(0)    <= sysClk200;
   dmaClkRst(0) <= sysClk200Rst;
   dmaClk(1)    <= sysClk125;
   dmaClkRst(1) <= sysClk125Rst;
   dmaClk(2)    <= sysClk125;
   dmaClkRst(2) <= sysClk125Rst;

   dmaIbMaster <= dmaObMaster;
   dmaObSlave  <= dmaIbSlave;


   --------------------------------------------------
   -- Timing Signals
   --------------------------------------------------
   U_DtmTimingSource : entity rce_gen3_fw_lib.DtmTimingSource 
      generic map (
         TPD_G => TPD_G
      ) port map (
         axiClk              => axiClk,
         axiClkRst           => axiClkRst,
         axiReadMaster       => locAxilReadMaster(0),
         axiReadSlave        => locAxilReadSlave(0),
         axiWriteMaster      => locAxilWriteMaster(0),
         axiWriteSlave       => locAxilWriteSlave(0),
         sysClk200           => sysClk200,
         sysClk200Rst        => sysClk200Rst,
         distClk             => sysClk200,
         distClkRst          => sysClk200Rst,
         timingCode          => (others=>'0'),
         timingCodeEn        => '0',
         fbCode              => open,
         fbCodeEn            => open,
         dpmClkP             => dpmClkP,
         dpmClkM             => dpmClkM,
         dpmFbP              => dpmFbP,
         dpmFbM              => dpmFbM,
         led                 => led
      );


   --------------------------------------------------
   -- RTM Testing
   --------------------------------------------------
   U_RtmTest : entity work.DtmRtmTest 
      generic map (
         TPD_G => TPD_G
      ) port map (
         sysClk200           => sysClk200,
         sysClk200Rst        => sysClk200Rst,
         axiClk              => axiClk,
         axiClkRst           => axiClkRst,
         topAxiReadMaster    => locAxilReadMaster(1),
         topAxiReadSlave     => locAxilReadSlave(1),
         topAxiWriteMaster   => locAxilWriteMaster(1),
         topAxiWriteSlave    => locAxilWriteSlave(1),
         locRefClkP          => locRefClkP,
         locRefClkM          => locRefClkM,
         dtmToRtmHsP         => dtmToRtmHsP,
         dtmToRtmHsM         => dtmToRtmHsM,
         rtmToDtmHsP         => rtmToDtmHsP,
         rtmToDtmHsM         => rtmToDtmHsM,
         dtmToRtmLsP         => dtmToRtmLsP,
         dtmToRtmLsM         => dtmToRtmLsM
      );


   --------------------------------------------------
   -- Top Level Signals
   --------------------------------------------------

   -- Backplane Clocks
   --bpClkIn      : in    slv(5 downto 0);
   --bpClkOut     : out   slv(5 downto 0);
   bpClkOut <= (others=>'0');

   -- Spare Signals
   --plSpareP     : inout slv(4 downto 0);
   --plSpareM     : inout slv(4 downto 0)

end architecture STRUCTURE;

