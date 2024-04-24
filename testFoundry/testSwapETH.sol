// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/utils/Strings.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

import "contracts/helpers/BaseConnector.sol";
import "./utils/testStarter.sol";
import "./utils/resources/OptimismAddresses.sol";
import "./utils/mocks/lifiDiamondMock.sol";
import "./utils/mocks/IDiamondCut.sol";

contract testSwapETH is testStarter, OptimismAddresses {
    // using SafeERC20 for IERC20;

    BaseConnector connector;

    address lifiOwner = 0x37347dD595C49212C5FC2D95EA10d1085896f51E;

    ///
    //
    function setUp() public {
        console.log("----------- Initialization -----------");
        // --------------------------------- set env --------------------------------
        uint256 fork = vm.createFork(RPC_URL, 117_539_598);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        // --------------------------------- init connector ---------------------------------
        connector = new BaseConnector(BaseConnectorCP(registry, 0, swapHandler, noyaOracle));

        console.log("connector deployed: %s", address(connector));
        // ------------------- add connector to registry -------------------
        addConnectorToRegistry(vaultId, address(connector));
        // ------------------- addTokensToSupplyOrBorrow -------------------
        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);
        addTrustedTokens(vaultId, address(accountingManager), WETH);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(WETH), address(840), address(ETH_USD_FEED));
        addTokenToNoyaOracle(address(WETH), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        addRoutesToNoyaOracle(address(DAI), address(USDC), address(840));
        addRoutesToNoyaOracle(address(WETH), address(USDC), address(840));

        console.log("Tokens added to registry");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(WETH), "");
        console.log("Positions added to registry");
        vm.stopPrank();
    }

    function testSwapEth() public {
        uint256 _amount = 10 * 1e18;
        _dealEth(owner, _amount);
        vm.startPrank(owner);

        lifiImplementation.addHandler(owner, true);

        bytes memory _data =
            hex"4630a0d8840c317287dff593bd50477b954ea50b2cce1b1a928c3a62ed6af57208322e8e00000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000b54c2435dc58fd6f172becee6b2f95b9423f9e790000000000000000000000000000000000000000000007907c97d53fc5a428f6000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000000086c6966692d617069000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002a3078303030303030303030303030303030303030303030303030303030303030303030303030303030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000020000000000000000000000000ca423977156bb05b13a2ba3b76bc5419e2fe9680000000000000000000000000ca423977156bb05b13a2ba3b76bc5419e2fe96800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000da10009cbd5d07dd0cecc66161fc93d7c9000da10000000000000000000000000000000000000000000000008ac7230489e8000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000027283bd37f900000004088ac7230489e800000a079a37c079b295c000000147ae0001926faafce6148884cd5cf98cd1878f865e8911bf000000011231deb6f5749ef6ce6943a275a1d3e7486f4eae59725ade1105051301fe8354ff060101000b020102030001030057f2be03000001040501050399f558260c000006050103e3c6e57e0c030007050003232bc98d0c0300080500020c0400090501040c00000a03010731adf3f50702000b0c9da11ff60bfc5af527f58fd61679c3ac98d040d9000000000000000000000100060c02000d0b0101b437ad370b020e0f0c0100000c0200100f01080c020011120104020cff0000b90b9b1f91a01ea22a182cd84c1e22222e39b41500000000000000000000000000000000000000001f32b1c2345538c0c6f582fcb022739c4a194ebb79c912fef520be002c2b6e57ec4324e260f38e50420000000000000000000000000000000000000685149247691df622eaf1a8bd0cafd40bc45154a91fb3cf6e48f1e7b10213e7b6d87d4c073c7fdb7bff202313e26974cfc4ab0121c485ba54303a2e41c858a329bf053be78d6239c4a4343b8fbd21472b766854992bd5363ebeeff0113f5a5795796befab0b2c639c533813f4aa9d7837caf62653d097ff85da10009cbd5d07dd0cecc66161fc93d7c9000da1d28f71e383e93c570d3edfe82ebbceb35ec6c4121337bedc9d22ecbe766df105c9623922a27963ec7f5c764cbc14f9669b88837ca1490cca17c31607bf16ef186e715668aa29cef57e2fd7f9d48adfe68323d063b1d12acce4742f1e3ed9bc46d71f422294b008aa00579c1307b0ef2c499ad98a8ce58e580000000000000000000000000000000000000000000000000000000000000000000000000000";

        SwapRequest memory swapRequest = SwapRequest(owner, 1, _amount, address(0), DAI, _data, false, 1);

        vm.expectRevert();
        lifiImplementation.performSwapAction{ value: 0 }(owner, swapRequest);

        vm.expectRevert();
        lifiImplementation.performSwapAction{ value: 0 }(owner, swapRequest); // Covered coverage bug number 73

        swapRequest = SwapRequest(owner, 0, _amount, address(0), DAI, _data, false, 1);

        lifiImplementation.performSwapAction{ value: _amount }(owner, swapRequest); // Covered coverage bug number 72, 75
            // vm.stopPrank();
    }
}
