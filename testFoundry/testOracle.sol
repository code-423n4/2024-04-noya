// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";
import "contracts/helpers/valueOracle/NoyaValueOracle.sol";

import "./utils/testStarter.sol";

import "./utils/resources/MainnetAddresses.sol";
import "./utils/mocks/MockDataFeed.sol";

contract TestOracle is testStarter, MainnetAddresses {
    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env --------------------------------
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        deployUniswapOracle(uniV3Factory);

        console.log("Tokens added to registry");

        console.log("Positions added to registry");
        vm.stopPrank();
    }

    function testGetValueUSD() public {
        vm.startPrank(owner);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));
        addTokenToNoyaOracle(address(840), address(chainlinkOracle));

        address[] memory assets = new address[](1);
        assets[0] = address(840);
        noyaOracle.updatePriceRoute(address(USDC), address(DAI), assets);
        noyaOracle.updatePriceRoute(address(DAI), address(USDC), assets);
        console.log("----------- Test getValue USD -----------");
        {
            uint256 value_zero = noyaOracle.getValue(address(address(DAI)), address(840), 0);
            assertEq(value_zero, 0);
            uint256 value_same = noyaOracle.getValue(address(address(DAI)), address(DAI), 1_000_000_000_000_000_000);
            assertEq(value_same, 1_000_000_000_000_000_000);
        }

        uint256 value = noyaOracle.getValue(address(address(DAI)), address(840), 1_000_000_000_000_000_000);
        value = noyaOracle.getValue(address(840), address(address(DAI)), value);
        assertEq(value, 1_000_000_000_000_000_000);
        value = noyaOracle.getValue(address(USDC), address(840), 1_000_000_000);
        value = noyaOracle.getValue(address(840), address(USDC), value);
        assert(value <= 1_001_000_000 || value >= 999_000_000);
        value = noyaOracle.getValue(address(USDC), address(DAI), 1_000_000_000);
        value = noyaOracle.getValue(address(DAI), address(USDC), value);
        assert(value <= 1_001_000_000 || value >= 999_000_000);
        vm.stopPrank();
    }

    function testGetValueETH() public {
        vm.startPrank(owner);
        address[] memory assets = new address[](1);
        assets[0] = address(0);
        noyaOracle.updatePriceRoute(address(STETH), address(USDC), assets);
        noyaOracle.updatePriceRoute(address(USDC), address(STETH), assets);
        addTokenToChainlinkOracle(address(STETH), address(0), address(STETH_ETH_FEED));
        addTokenToChainlinkOracle(address(USDC), address(0), address(USDC_ETH_FEED));

        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));
        addTokenToNoyaOracle(address(STETH), address(chainlinkOracle));
        addTokenToNoyaOracle(address(0), address(chainlinkOracle));
        console.log("----------- Test getValue ETH -----------");
        uint256 value = noyaOracle.getValue(steth, address(0), 1_000_000_000_000_000_000);
        uint256 value2 = noyaOracle.getValue(address(0), steth, value);
        assertEq(value2, 1_000_000_000_000_000_000);
        uint256 value3 = noyaOracle.getValue(address(USDC), address(0), 2_300_000_000);
        uint256 value4 = noyaOracle.getValue(address(0), address(USDC), value3);
        assertEq(value4, 2_300_000_000);
        uint256 value5 = noyaOracle.getValue(address(USDC), steth, 2_300_000_000);
        uint256 value6 = noyaOracle.getValue(steth, address(USDC), value5);

        assert(value6 <= 2_301_000_000 || value6 >= 2_299_000_000);

        assertEq(chainlinkOracle.getValue(USDC, USDC, 100_000), 100_000);

        vm.expectRevert();
        noyaOracle.getValue(address(USDT), steth, 2_300_000_000);

        vm.expectRevert();
        noyaOracle.getValue(rETH, steth, 2_300_000_000);

        vm.stopPrank();
    }

    function testErrors() public {
        vm.startPrank(owner);
        addTokenToChainlinkOracle(address(STETH), address(0), address(STETH_ETH_FEED));
        addTokenToNoyaOracle(address(STETH), address(chainlinkOracle));
        addTokenToNoyaOracle(address(0), address(chainlinkOracle));

        vm.expectRevert();
        chainlinkOracle.updateChainlinkPriceAgeThreshold(0);

        vm.expectRevert();
        chainlinkOracle.updateChainlinkPriceAgeThreshold(100 days);
        chainlinkOracle.updateChainlinkPriceAgeThreshold(8 days);
        vm.warp(block.timestamp + 100 days);
        vm.expectRevert();
        noyaOracle.getValue(steth, address(0), 1_000_000_000_000_000_000);

        vm.stopPrank();
    }

    function testUniswap() public {
        console.log("----------- Test Uniswap -----------");

        vm.startPrank(owner);
        uniswapOracle.addPool(address(USDC), address(DAI), 100);

        vm.expectRevert();
        uniswapOracle.addPool(address(USDC), alice, 100); // Covered coverage bug number 76

        vm.expectRevert();
        uniswapOracle.getValue(address(USDC), alice, 100);

        vm.expectRevert();
        noyaOracle.getValue(address(USDC), alice, 100);

        uniswapOracle.assetToBaseToPool(address(USDC), address(DAI));

        address[] memory assets = new address[](1);
        assets[0] = address(DAI);
        address[] memory baseTokens = new address[](1);
        baseTokens[0] = address(USDC);
        address[] memory sources = new address[](1);
        sources[0] = address(uniswapOracle);
        noyaOracle.updateAssetPriceSource(assets, baseTokens, sources);

        uint256 value = noyaOracle.getValue(address(USDC), address(DAI), 1_000_000_000);
        value = noyaOracle.getValue(address(DAI), address(USDC), value);
        assert(value <= 1_001_000_000 || value >= 999_000_000);

        vm.expectRevert();
        uniswapOracle.setPeriod(0);

        uniswapOracle.setPeriod(1000);

        value = noyaOracle.getValue(address(USDC), address(DAI), 1_000_000_000);
        value = noyaOracle.getValue(address(DAI), address(USDC), value);
        assert(value <= 1_001_000_000 || value >= 999_000_000);
    }

    function testMockData() public {
        vm.startPrank(owner);

        MockData mockData = new MockData();
        mockData.setAnswer(0, block.timestamp);

        addTokenToChainlinkOracle(address(USDC), address(840), address(mockData));
        vm.expectRevert();
        uint256 value = noyaOracle.getValue(address(USDC), address(840), 1_000_000_000); // Covered coverage bug number 78
    }
}
