pragma solidity 0.8.20;

import "testFoundry/utils/testStarter.sol";
import "contracts/connectors/UNIv3Connector.sol";
import "./utils/resources/OptimismAddresses.sol";

import "@openzeppelin/contracts-5.0/utils/Strings.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";
import { IUniswapV3Pool } from "contracts/external/interfaces/UNIv3/IUniswapV3Pool.sol";
import { LiquidityAmounts } from "contracts/external/libraries/uniswap/LiquidityAmounts.sol";
import { TickMath } from "contracts/external/libraries/uniswap/TickMath.sol";
import { FullMath } from "contracts/external/libraries/uniswap/FullMath.sol";
import { FixedPoint96 } from "contracts/external/libraries/uniswap/FixedPoint96.sol";

interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

contract testUNIv3 is testStarter, OptimismAddresses {
    using SafeERC20 for IERC20;
    using Strings for uint256;

    UNIv3Connector public connector;

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

        connector = new UNIv3Connector(
            uniswapV3PositionManager, uniswapV3Factory, BaseConnectorCP(registry, 0, swapHandler, noyaOracle)
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
            vaultId, connector.UNI_LP_POSITION_TYPE(), address(connector), true, false, abi.encode(USDC, DAI), ""
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

        connector.openPosition(
            MintParams({
                token0: USDC,
                token1: DAI,
                fee: 100,
                amount0Desired: 10_000_000,
                amount1Desired: 10e18,
                amount0Min: 0,
                amount1Min: 0,
                tickLower: 276_422,
                tickUpper: 276_423,
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
        vm.stopPrank();
    }

    function testClaimRewards() public {
        console.log("----------- Test claim rewards -----------");
        _dealWhale(USDC, address(connector), USDC_Whale, 10_000_000);
        _dealWhale(USDC, address(owner), USDC_Whale, 1_000_000_000_000);
        _dealERC20(DAI, address(connector), 10e18);
        vm.startPrank(owner);

        (int24 lower, int24 upper) = _getUpperAndLowerTick(USDC, DAI, 100, 100, 0);

        uint256 tokenId = connector.openPosition(
            MintParams({
                token0: USDC,
                token1: DAI,
                fee: 100,
                amount0Desired: 10_000_000,
                amount1Desired: 10e18,
                amount0Min: 0,
                amount1Min: 0,
                tickLower: lower,
                tickUpper: upper,
                recipient: address(connector),
                deadline: block.timestamp + 1000
            })
        );
        console.log("Position opened");

        uint256 tvl = accountingManager.TVL();
        console.log("TVL: %s", tvl);

        {
            uint256 beforeBalance = IERC20(DAI).balanceOf(owner);
            _swapWithUniRouter(USDC, DAI, 1_000_000_000_000, owner);
            uint256 afterBalance = IERC20(DAI).balanceOf(owner);
            assertTrue(afterBalance > beforeBalance);
            console.log("DAI claimed: %s", afterBalance - beforeBalance);
        }

        {
            uint256[] memory indices = new uint256[](1);
            indices[0] = tokenId;
            uint256 beforeBalance = IERC20(USDC).balanceOf(address(connector));
            connector.collectAllFees(indices);
            uint256 beforeAfter = IERC20(USDC).balanceOf(address(connector));
            console.log("Fees collected: %s %s", beforeAfter, beforeBalance);
            assertTrue(beforeAfter > beforeBalance, "Fees should be collected");
        }

        vm.stopPrank();
    }

    function testRemoveAndDeleteLiquidityTest() public {
        console.log("----------- Test remove and delete liquidity -----------");
        _dealWhale(USDC, address(connector), USDC_Whale, 2 * 10_000_000);
        _dealERC20(DAI, address(connector), 2 * 10e18);
        vm.startPrank(owner);
        (int24 lower, int24 upper) = _getUpperAndLowerTick(USDC, DAI, 100, 100, 0);

        uint256 tokenId = connector.openPosition(
            MintParams({
                token0: USDC,
                token1: DAI,
                fee: 100,
                amount0Desired: 10_000_000,
                amount1Desired: 10e18,
                amount0Min: 0,
                amount1Min: 0,
                tickLower: lower,
                tickUpper: upper,
                recipient: address(connector),
                deadline: block.timestamp + 1000
            })
        );
        console.log("Position opened");
        uint256 tvl = accountingManager.TVL();
        console.log("TVL: %s", tvl);

        {
            uint256 beforeBalance = IERC20(USDC).balanceOf(address(connector));
            (,,,,,,, uint128 liquidity,,,,) = INonfungiblePositionManager(uniswapV3PositionManager).positions(tokenId);
            vm.expectRevert();
            connector.decreasePosition(DecreaseLiquidityParams(tokenId, liquidity * 100, 0, 0, block.timestamp));
            connector.decreasePosition(DecreaseLiquidityParams(tokenId, liquidity / 2, 0, 0, block.timestamp)); // Cover coverage bug number 45
            uint256 afterBalance = IERC20(USDC).balanceOf(address(connector));
            console.log("Holdings TVL Before: %s", beforeBalance);
            console.log("Holdings TVL After: %s", afterBalance);
            assertTrue(beforeBalance < afterBalance);

            connector.increasePosition(
                IncreaseLiquidityParams({
                    tokenId: tokenId,
                    amount0Desired: 10_000_000,
                    amount1Desired: 10e18,
                    amount0Min: 0,
                    amount1Min: 0,
                    deadline: block.timestamp + 1000
                })
            );
            (,,,,,,, liquidity,,,,) = INonfungiblePositionManager(uniswapV3PositionManager).positions(tokenId);
            connector.decreasePosition(DecreaseLiquidityParams(tokenId, liquidity, 0, 0, block.timestamp)); // Cover coverage bug number 45
        }

        vm.stopPrank();
    }

    function _getUpperAndLowerTick(address token0, address token1, uint24 fee, int24 size, int24 shift)
        internal
        view
        returns (int24 lower, int24 upper)
    {
        IUniswapV3Pool pool = IUniswapV3Pool(IUniswapV3Factory(uniswapV3Factory).getPool(token0, token1, fee));
        (, int24 tick,,,,,) = pool.slot0();
        tick = tick + shift;
        int24 spacing = pool.tickSpacing();
        lower = tick - (tick % spacing);
        lower = lower - ((spacing * size) / 2);
        upper = lower + spacing * size;
    }

    function _swapWithUniRouter(address tokenIn, address tokenOut, uint256 amount, address receipient) internal {
        // Approve assets to be swapped through the router.
        IERC20(tokenIn).forceApprove(uniV3Router, amount);

        uint256 tokenOutAmountOut = ISwapRouter(uniV3Router).exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: 100,
                recipient: receipient,
                deadline: block.timestamp + 1000,
                amountIn: amount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 69_250_422_046_465_406_747_723_829_060_761_753
            })
        );
    }
}
