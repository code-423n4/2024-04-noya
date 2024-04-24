pragma solidity 0.8.20;

import "testFoundry/utils/testStarter.sol";
import "contracts/connectors/UNIv3Connector.sol";
import "./utils/resources/OptimismAddresses.sol";

import "./utils/resources/MainnetAddresses.sol";

import "@openzeppelin/contracts-5.0/utils/Strings.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";
import { IUniswapV3Pool } from "contracts/external/interfaces/UNIv3/IUniswapV3Pool.sol";
import { LiquidityAmounts } from "contracts/external/libraries/uniswap/LiquidityAmounts.sol";
import { TickMath } from "contracts/external/libraries/uniswap/TickMath.sol";
import { FullMath } from "contracts/external/libraries/uniswap/FullMath.sol";
import { FixedPoint96 } from "contracts/external/libraries/uniswap/FixedPoint96.sol";
import "contracts/connectors/PancakeswapConnector.sol";

contract testPancakeswapv3 is testStarter, MainnetAddresses {
    using SafeERC20 for IERC20;
    using Strings for uint256;

    PancakeswapConnector public connector;

    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env ---------------------------------

        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);
        deployEverythingNormal(USDC);

        // --------------------------------- init connector ---------------------------------

        connector = new PancakeswapConnector(
            mastercheffAddress,
            pancakeSwapV3PositionManager,
            pancakeSwapV3factory,
            BaseConnectorCP(registry, 0, swapHandler, noyaOracle)
        );

        console.log("UNIv3Connector deployed: %s", address(connector));

        // ------------------- add connector to vaultManager -------------------
        addConnectorToRegistry(vaultId, address(connector));

        // ------------------- add AaveConnector as eligable user for swap -------------------
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(DAI), address(USDC), address(840));

        console.log("Tokens added to registry");
        registry.addTrustedPosition(
            vaultId, connector.UNI_LP_POSITION_TYPE(), address(connector), true, false, abi.encode(DAI, USDC), ""
        );
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        console.log("Positions added to registry");
        vm.stopPrank();
    }

    event R(int24 tickSpacing);

    function testOpenPosition() public {
        console.log("----------- Test Open Position -----------");
        uint256 _amount = 10_000_000;
        _dealWhale(baseToken, address(connector), USDC_Whale, _amount);
        _dealERC20(DAI, address(connector), 10e18);
        vm.startPrank(owner);
        connector.updateTokenInRegistry(USDC);
        connector.updateTokenInRegistry(DAI);

        uint256 tvl = accountingManager.TVL();
        console.log("TVL: %s", tvl);
        assertEq(isCloseTo(tvl, 20e6, 100), true);

        (int24 lower, int24 upper) = _getUpperAndLowerTick(USDC, DAI, 100, 100, 0);

        connector.openPosition(
            MintParams({
                token0: DAI,
                token1: USDC,
                fee: 100,
                amount0Desired: 10e18,
                amount1Desired: 10_000_000,
                amount0Min: 0,
                amount1Min: 0,
                tickLower: lower,
                tickUpper: upper,
                recipient: address(connector),
                deadline: block.timestamp + 1000
            })
        );

        console.log("Position opened");
        tvl = accountingManager.TVL();
        console.log("USDC: %s", IERC20(USDC).balanceOf(address(connector)) / 1e6);
        console.log("DAI: %s", IERC20(DAI).balanceOf(address(connector)) / 1e18);
        console.log("TVL: %s", tvl);
        assertEq(isCloseTo(tvl, 20e6, 100), true);

        connector.sendPositionToMasterChef(7986);

        vm.warp(block.timestamp + 1 days);
        connector.updatePosition(7986);

        connector.withdraw(7986);

        console.log("Position withdrawn, cake balance: %s", IERC20(CAKE).balanceOf(address(connector)));
        vm.stopPrank();
    }

    function _getUpperAndLowerTick(address token0, address token1, uint24 fee, int24 size, int24 shift)
        internal
        view
        returns (int24 lower, int24 upper)
    {
        IUniswapV3Pool pool = IUniswapV3Pool(IUniswapV3Factory(pancakeSwapV3factory).getPool(token0, token1, fee));
        (, int24 tick,,,,,) = pool.slot0();
        tick = tick + shift;
        int24 spacing = pool.tickSpacing();
        lower = tick - (tick % spacing);
        lower = lower - ((spacing * size) / 2);
        upper = lower + spacing * size;
    }
}
