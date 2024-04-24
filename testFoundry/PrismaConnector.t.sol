// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "contracts/connectors/PrismaConnector.sol";
import "contracts/helpers/valueOracle/oracles/WETH_Oracle.sol";

import "./utils/resources/MainnetAddresses.sol";

contract TestPrismaConnector is testStarter, MainnetAddresses {
    uint256 startingBlockPrisma = 19_305_785;

    PrismaConnector connector;

    function setUp() public {
        console.log("----------- Initialization -----------");
        uint256 fork = vm.createFork(RPC_URL, startingBlockPrisma);
        vm.selectFork(fork);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(WETH);

        // --------------------------------- init connector ---------------------------------
        connector = new PrismaConnector(BaseConnectorCP(registry, vaultId, swapHandler, noyaOracle));
        console.log("PrismaConnector deployed: %s", address(connector));

        // ------------------- add connector to registry -------------------
        addConnectorToRegistry(vaultId, address(connector));
        console.log("PrismaConnector added to registry");

        addTrustedTokens(vaultId, address(accountingManager), WETH);
        addTrustedTokens(vaultId, address(accountingManager), weETH);
        addTrustedTokens(vaultId, address(accountingManager), ULTRA);

        addTokenToChainlinkOracle(address(WETH), address(840), address(WETH_USD_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(ULTRA), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(ULTRA), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(weETH), address(840), address(WEETH_ETH_FEED));
        addTokenToNoyaOracle(address(weETH), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(weETH), address(WETH), address(840));
        addRoutesToNoyaOracle(address(ULTRA), address(WETH), address(840));

        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(WETH), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(weETH), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(ULTRA), "");
        registry.addTrustedPosition(
            vaultId,
            connector.PRISMA_POSITION_ID(),
            address(connector),
            true,
            false,
            abi.encode(ULTRA_StakeNTroveZap, ULTRA_weeth_troveManager),
            abi.encode(WETH)
        );

        registry.addTrustedPosition(
            vaultId,
            12,
            address(connector),
            true,
            false,
            abi.encode(ULTRA_StakeNTroveZap, ULTRA_weeth_troveManager),
            abi.encode(WETH)
        );
    }

    function test_depositAndBorrow() public {
        uint256 amount = 100e18;
        _dealERC20(WETH, address(connector), 3 * amount);

        vm.startPrank(owner);

        vm.expectRevert();
        connector.openTrove(
            IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, 12_500_000_000_000_000, amount, 2000e18
        );

        connector.approveZap(IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, true);

        connector.approveZap(IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, false); //  Covered coverage bug number 30
        connector.approveZap(IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, true);

        vm.expectRevert();
        connector.approveZap(IStakeNTroveZap(ULTRA_StakeNTroveZap), MKUSD_StakeNTroveZap, true);

        connector.openTrove(
            IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, 12_500_000_000_000_000, amount, 2000e18
        );

        vm.expectRevert();
        connector.addColl(IStakeNTroveZap(ULTRA_StakeNTroveZap), MKUSD_StakeNTroveZap, amount); //  Covered coverage bug number 32

        connector.addColl(IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, amount);
        ITroveManager(ULTRA_weeth_troveManager).getTroveCollAndDebt(address(connector));

        vm.expectRevert();
        connector.adjustTrove(IStakeNTroveZap(ULTRA_StakeNTroveZap), MKUSD_StakeNTroveZap, 0, amount, 2000e18, true); //  Covered coverage bug number 33

        connector.updateMinimumHealthFactor(5e18);

        vm.expectRevert();
        connector.adjustTrove(IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, 0, amount, 0, false);
        connector.updateMinimumHealthFactor(15e17);

        connector.adjustTrove(
            IStakeNTroveZap(ULTRA_StakeNTroveZap),
            ULTRA_weeth_troveManager,
            12_500_000_000_000_000,
            amount,
            2000e18,
            true
        );

        connector.adjustTrove(
            IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, 12_500_000_000_000_000, 0, 2000e18, false
        ); //  Covered coverage bug number 34

        uint256 tvl = accountingManager.TVL();

        connector.getPositionTVL(
            HoldingPI({
                calculatorConnector: address(connector),
                positionId: registry.calculatePositionId(
                    address(connector), 12, abi.encode(ULTRA_StakeNTroveZap, ULTRA_weeth_troveManager)
                    ),
                ownerConnector: address(connector),
                data: "",
                additionalData: "",
                positionTimestamp: 0
            }),
            address(WETH)
        ); //  Covered coverage bug number 35

        vm.stopPrank();
    }

    function test_depositAndClose() public {
        uint256 amount = 100e18;
        _dealERC20(WETH, address(connector), 3 * amount);

        vm.startPrank(owner);

        connector.approveZap(IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, true);

        connector.openTrove(
            IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager, 12_500_000_000_000_000, amount, 2000e18
        );

        _dealERC20(ULTRA, address(connector), 3000 * amount);

        connector.closeTrove(IStakeNTroveZap(ULTRA_StakeNTroveZap), ULTRA_weeth_troveManager);

        vm.stopPrank();
    }
}
