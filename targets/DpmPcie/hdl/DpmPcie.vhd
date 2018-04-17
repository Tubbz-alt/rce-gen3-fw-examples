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
-- DpmPcie.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use work.RceG3Pkg.all;
use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.AxiStreamPkg.all;
use work.AxiPkg.all;

entity DpmPcie is
   generic (
      BUILD_INFO_G    : BuildInfoType);
   port (

      -- Debug
      led          : out   slv(1 downto 0);

      -- I2C
      i2cSda       : inout sl;
      i2cScl       : inout sl;

      -- Ethernet
      ethRxP       : in    slv(0 downto 0);
      ethRxM       : in    slv(0 downto 0);
      ethTxP       : out   slv(0 downto 0);
      ethTxM       : out   slv(0 downto 0);
      ethRefClkP   : in    sl;
      ethRefClkM   : in    sl;

      -- RTM High Speed
      dpmToRtmHsP  : out   slv(0 downto 0);
      dpmToRtmHsM  : out   slv(0 downto 0);
      rtmToDpmHsP  : in    slv(0 downto 0);
      rtmToDpmHsM  : in    slv(0 downto 0);

      -- Reference Clocks
      locRefClkP   : in    sl;
      locRefClkM   : in    sl;
      dtmRefClkP   : in    sl;
      dtmRefClkM   : in    sl;

      -- DTM Signals
      dtmClkP      : in    slv(1  downto 0);
      dtmClkM      : in    slv(1  downto 0);
      dtmFbP       : out   sl;
      dtmFbM       : out   sl;

      -- Clock Select
      clkSelA      : out   slv(1 downto 0);
      clkSelB      : out   slv(1 downto 0)
   );
end DpmPcie;

architecture STRUCTURE of DpmPcie is

   constant TPD_C : time := 1 ns;

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
   signal iethRxP            : slv(3 downto 0);
   signal iethRxM            : slv(3 downto 0);
   signal iethTxP            : slv(3 downto 0);
   signal iethTxM            : slv(3 downto 0);
   signal pcieReadMaster     : AxiReadMasterArray(1 downto 0);
   signal pcieReadSlave      : AxiReadSlaveArray(1 downto 0);
   signal pcieWriteMaster    : AxiWriteMasterArray(1 downto 0);
   signal pcieWriteSlave     : AxiWriteSlaveArray(1 downto 0);
   signal userWriteSlave     : AxiWriteSlaveType;
   signal userWriteMaster    : AxiWriteMasterType;
   signal userReadSlave      : AxiReadSlaveType;
   signal userReadMaster     : AxiReadMasterType;
   signal userInterrupt      : slv(USER_INT_COUNT_C-1 downto 0);

begin

   --------------------------------------------------
   -- Core
   --------------------------------------------------
   U_DpmCore: entity work.DpmCore 
      generic map (
         TPD_G          => TPD_C,
         BUILD_INFO_G   => BUILD_INFO_G,
         RCE_DMA_MODE_G => RCE_DMA_AXISV2_C,
         --RCE_DMA_MODE_G => RCE_DMA_PPI_C,
         USE_AXI_IC_G   => true,
         ETH_10G_EN_G   => false
      ) port map (
         i2cSda                   => i2cSda,
         i2cScl                   => i2cScl,
         ethRxP                   => iethRxP,
         ethRxM                   => iethRxM,
         ethTxP                   => iethTxP,
         ethTxM                   => iethTxM,
         ethRefClkP               => ethRefClkP,
         ethRefClkM               => ethRefClkM,
         clkSelA                  => clkSelA,
         clkSelB                  => clkSelB,
         sysClk125                => sysClk125,
         sysClk125Rst             => sysClk125Rst,
         sysClk200                => sysClk200,
         sysClk200Rst             => sysClk200Rst,
         axiClk                   => axiClk,
         axiClkRst                => axiClkRst,
         extAxilReadMaster        => extAxilReadMaster,
         extAxilReadSlave         => extAxilReadSlave,
         extAxilWriteMaster       => extAxilWriteMaster,
         extAxilWriteSlave        => extAxilWriteSlave,
         pcieReadMaster           => pcieReadMaster,
         pcieReadSlave            => pcieReadSlave,
         pcieWriteMaster          => pcieWriteMaster,
         pcieWriteSlave           => pcieWriteSlave,
         userWriteSlave           => userWriteSlave,
         userWriteMaster          => userWriteMaster,
         userReadSlave            => userReadSlave,
         userReadMaster           => userReadMaster,
         dmaClk                   => dmaClk,
         dmaClkRst                => dmaClkRst,
         dmaState                 => dmaState,
         dmaObMaster              => dmaObMaster,
         dmaObSlave               => dmaObSlave,
         dmaIbMaster              => dmaIbMaster,
         dmaIbSlave               => dmaIbSlave,
         userInterrupt            => userInterrupt
      );

   ethTxP(0)           <= iethTxP(0);
   ethTxM(0)           <= iethTxM(0);
   iethRxP(0)          <= ethRxP(0);
   iethRxM(0)          <= ethRxM(0);
   iethRxP(3 downto 1) <= (others=>'0');
   iethRxM(3 downto 1) <= (others=>'0');

   -- Empty AXI Slave
   -- 0xA0000000 - 0xAFFFFFFF
   U_AxiVersion: entity work.AxiVersion 
      generic map (
         TPD_G              => TPD_C,
         BUILD_INFO_G       => BUILD_INFO_G)
      port map (
         axiClk          => axiClk,
         axiRst          => axiClkRst,
         axiReadMaster   => extAxilReadMaster,
         axiReadSlave    => extAxilReadSlave,
         axiWriteMaster  => extAxilWriteMaster,
         axiWriteSlave   => extAxilWriteSlave
      );

   --------------------------------------------------
   -- PCIE
   --------------------------------------------------
   U_PcieRoot: entity work.ZynqPcieRoot
      generic map ( TPD_G => TPD_C )
      port map (
         axiClk          => axiClk,
         axiClkRst       => axiClkRst,
         pcieReadMaster  => pcieReadMaster,
         pcieReadSlave   => pcieReadSlave,
         pcieWriteMaster => pcieWriteMaster,
         pcieWriteSlave  => pcieWriteSlave,
         sysClk200       => sysClk200,
         sysClk200Rst    => sysClk200Rst,
         userWriteSlave  => userWriteSlave,
         userWriteMaster => userWriteMaster,
         userReadSlave   => userReadSlave,
         userReadMaster  => userReadMaster,
         pciRefClkP      => locRefClkP,
         pciRefClkM      => locRefClkM,
         pcieInt         => userInterrupt(USER_INT_COUNT_C-1),
         pcieRxP         => rtmToDpmHsP(0),
         pcieRxM         => rtmToDpmHsM(0),
         pcieTxP         => dpmToRtmHsP(0),
         pcieTxM         => dpmToRtmHsM(0)
      );

   userInterrupt(USER_INT_COUNT_C-2 downto 0) <= (others=>'0');

   --------------------------------------------------
   -- PPI Loopback
   --------------------------------------------------
   dmaClk      <= (others=>sysClk125);
   dmaClkRst   <= (others=>sysClk125Rst);
   dmaIbMaster <= dmaObMaster;
   dmaObSlave  <= dmaIbSlave;

   --------------------------------------------------
   -- Top Level Signals
   --------------------------------------------------
   led <= (others=>'0');

   -- RTM High Speed
   --dpmToRtmHsP : out   slv(11 downto 0);
   --dpmToRtmHsM : out   slv(11 downto 0);
   --rtmToDpmHsP : in    slv(11 downto 0);
   --rtmToDpmHsM : in    slv(11 downto 0);

   -- Reference Clocks
   --locRefClkP   : in    sl;
   --locRefClkM   : in    sl;
   --dtmRefClkP   : in    sl;
   --dtmRefClkM   : in    sl;

   -- DTM Clock Signals
   U_DtmClkgen : for i in 0 to 1 generate
      U_DtmClkIn : IBUFDS
         generic map ( DIFF_TERM => true ) 
         port map(
            I      => dtmClkP(i),
            IB     => dtmClkM(i),
            O      => open
         );
   end generate;

   -- DTM Feedback
   U_DtmFbOut : OBUFDS
      port map(
         O      => dtmFbP,
         OB     => dtmFbM,
         I      => '0'
      );

end architecture STRUCTURE;

