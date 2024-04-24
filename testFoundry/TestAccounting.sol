// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "./utils/testStarter.sol";
import "contracts/helpers/BaseConnector.sol";
import "contracts/accountingManager/NoyaFeeReceiver.sol";
import "./utils/resources/OptimismAddresses.sol";
import "contracts/governance/Keepers.sol";
import "./utils/mocks/EmergancyMock.sol";
import "./utils/mocks/ConnectorMock2.sol";

contract TestAccounting is testStarter, OptimismAddresses {
    using SafeERC20 for IERC20;

    address connector;
    address connector2;
    NoyaFeeReceiver managementFeeReceiver;
    NoyaFeeReceiver performanceFeeReceiver;
    address withdrawFeeReceiver = bob;

    uint256 privateKey1 = 0x99ba14aff4aba765903a41b48aacdf600b6fcdb2b0c2424cd2f8f2c089f20476;
    uint256 privateKey2 = 0x68ab62e784b873b929e98fc6b6696abcc624cf71af05bf8d88b4287e9b58ab99;
    uint256 privateKey3 = 0x952b55e8680117e6de5bde1d3e7902baa89bfde931538a5bb42ba392ef3464a4;
    uint256 privateKey4 = 0x885f1d08ebc23709517fedbec64418e4a09ac1e47e976c868fd8c93de0f88f09;

    function setUp() public {
        // --------------------------------- set env --------------------------------
        uint256 fork = vm.createFork(RPC_URL, startingBlock);
        vm.selectFork(fork);

        console.log("Test timestamp: %s", block.timestamp);

        // --------------------------------- deploy the contracts ---------------------------------
        vm.startPrank(owner);

        deployEverythingNormal(USDC);

        // --------------------------------- init connector ---------------------------------
        connector = address(new BaseConnector(BaseConnectorCP(registry, 0, swapHandler, noyaOracle)));
        connector2 = address(new ConnectorMock2(address(registry), 0));

        // ------------------- add connector to registry -------------------
        addConnectorToRegistry(vaultId, connector);
        addConnectorToRegistry(vaultId, connector2);
        console.log("AaveConnector added to registry");

        addTrustedTokens(vaultId, address(accountingManager), USDC);
        addTrustedTokens(vaultId, address(accountingManager), DAI);

        addTokenToChainlinkOracle(address(USDC), address(840), address(USDC_USD_FEED));
        addTokenToNoyaOracle(address(USDC), address(chainlinkOracle));

        addTokenToChainlinkOracle(address(DAI), address(840), address(DAI_USD_FEED));
        addTokenToNoyaOracle(address(DAI), address(chainlinkOracle));

        console.log("Tokens added to registry");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(USDC), "");
        registry.addTrustedPosition(vaultId, 0, address(accountingManager), false, false, abi.encode(DAI), "");
        console.log("Positions added to registry");

        managementFeeReceiver = new NoyaFeeReceiver(address(accountingManager), baseToken, owner);
        performanceFeeReceiver = new NoyaFeeReceiver(address(accountingManager), baseToken, owner);

        accountingManager.updateValueOracle(noyaOracle);
        vm.stopPrank();
    }

    function testVaultSingleDepositFlow() public {
        console.log("-----------Base Workflow--------------");

        assertEq(accountingManager.withdrawFee(), 0, "withdrawFee is not correct1");
        assertEq(accountingManager.managementFee(), 0, "managementFee is not correct1");
        assertEq(accountingManager.performanceFee(), 0, "performanceFee is not correct1");
        assertEq(accountingManager.withdrawFeeReceiver(), owner, "withdrawFeeReceiver is not correct1");
        assertEq(accountingManager.performanceFeeReceiver(), owner, "performanceFeeReceiver is not correct1");
        assertEq(accountingManager.managementFeeReceiver(), owner, "managementFeeReceiver is not correct1");

        uint256 _amount = 10_000 * 1e6;
        console.log("  Balance before deposit: %s USDC", _amount / 1e6);
        _dealWhale(baseToken, address(alice), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);

        vm.startPrank(alice);

        // ------------------------------ deposit ------------------------------
        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), _amount);
        accountingManager.deposit(address(alice), _amount, address(0));

        // ------------------------------ check deposit queue ------------------------------

        console.log("Balance after deposit: %s USDC", IERC20(USDC).balanceOf(alice) / 1e6);

        uint256[] memory arr = new uint256[](1);
        arr[0] = 0;
        (DepositRequest[] memory depositItem,) = accountingManager.getQueueItems(true, arr);
        assertDepositRequest(
            depositItem[0],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: _amount,
                shares: 0
            })
        );
        (uint256 first, uint256 middle, uint256 last, uint256 tokenAmountWaitingForDeposit) =
            accountingManager.depositQueue();

        assertTrue(
            tokenAmountWaitingForDeposit == _amount, "DepositQueue tokenAmountWaitingForConfirmation is not correct"
        );
        assertTrue(first == 0, "DepositQueue first is not correct");
        assertTrue(last == 1, "DepositQueue last is not correct");
        assertTrue(middle == 0, "DepositQueue length is not correct");

        console.log("Deposit time: %s", block.timestamp);

        // ------------------------------ calculate shares ------------------------------
        vm.expectRevert();
        accountingManager.calculateDepositShares(10);

        // ------------------------------ change the address ------------------------------

        vm.stopPrank();
        vm.startPrank(owner);

        accountingManager.calculateDepositShares(10);

        // // ------------------------------ check deposit queue ------------------------------
        (depositItem,) = accountingManager.getQueueItems(true, arr);
        assertDepositRequest(
            depositItem[0],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: _amount,
                shares: _amount
            })
        );

        (first, middle, last, tokenAmountWaitingForDeposit) = accountingManager.depositQueue();
        assertTrue(
            tokenAmountWaitingForDeposit == _amount, "DepositQueue tokenAmountWaitingForConfirmation is not correct"
        );
        assertTrue(first == 0, "DepositQueue first is not correct");
        assertTrue(last == 1, "DepositQueue last is not correct");
        assertTrue(middle == 1, "DepositQueue length is not correct");

        // // ------------------------------ execute deposit ------------------------------
        // // won't effect because the time is not passed yet
        vm.expectRevert();
        accountingManager.executeDeposit(10, connector, "");
        vm.expectRevert();
        accountingManager.executeDeposit(10, connector, "");

        (first, middle, last, tokenAmountWaitingForDeposit) = accountingManager.depositQueue();
        assertTrue(
            tokenAmountWaitingForDeposit == _amount, "DepositQueue tokenAmountWaitingForConfirmation is not correct"
        );
        assertTrue(first == 0, "DepositQueue first is not correct");
        assertTrue(last == 1, "DepositQueue last is not correct");
        assertTrue(middle == 1, "DepositQueue length is not correct");

        // // ------------------------------ warp the vm time ------------------------------

        vm.warp(block.timestamp + 35 minutes);

        accountingManager.executeDeposit(10, connector, "");

        (first, middle, last, tokenAmountWaitingForDeposit) = accountingManager.depositQueue();

        assertTrue(tokenAmountWaitingForDeposit == 0, "DepositQueue tokenAmountWaitingForConfirmation is not correct");
        assertTrue(first == 1, "DepositQueue first is not correct");
        assertTrue(last == 1, "DepositQueue last is not correct");
        assertTrue(middle == 1, "DepositQueue length is not correct");

        accountingManager.updateValueOracle(noyaOracle);

        accountingManager.setFeeReceivers(owner, owner, owner);

        accountingManager.setFees(0, 0, 0);

        vm.stopPrank();
    }

    function testVaultMultipleDepositFlow() public {
        console.log("-----------Base Workflow--------------");
        uint256 _amount = 10_000 * 1e6;
        console.log("  Balance before deposit: %s USDC", _amount / 1e6);

        _dealWhale(baseToken, address(alice), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), 10 * _amount);

        vm.startPrank(alice);

        //     // ------------------------------ deposit ------------------------------
        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), 5 * _amount);
        accountingManager.deposit(address(alice), _amount, address(0));
        accountingManager.deposit(address(alice), _amount, address(0));
        accountingManager.deposit(address(alice), _amount, address(0));
        accountingManager.deposit(address(alice), _amount, address(0));
        accountingManager.deposit(address(alice), _amount, address(0));

        //     // ------------------------------ check deposit queue ------------------------------

        console.log("Balance after deposit: %s USDC", IERC20(USDC).balanceOf(alice) / 1e6);

        uint256[] memory arr = new uint256[](5);
        arr[0] = 0;
        arr[1] = 1;
        arr[2] = 2;
        arr[3] = 3;
        arr[4] = 4;
        (DepositRequest[] memory depositItem,) = accountingManager.getQueueItems(true, arr);
        assertDepositRequest(
            depositItem[0],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: _amount,
                shares: 0
            })
        );
        assertDepositRequest(
            depositItem[1],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: _amount,
                shares: 0
            })
        );
        assertDepositRequest(
            depositItem[2],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: _amount,
                shares: 0
            })
        );
        assertDepositRequest(
            depositItem[3],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: _amount,
                shares: 0
            })
        );
        assertDepositRequest(
            depositItem[4],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: _amount,
                shares: 0
            })
        );

        (uint256 first, uint256 middle, uint256 last, uint256 tokenAmountWaitingForDeposit) =
            accountingManager.depositQueue();
        assertTrue(
            tokenAmountWaitingForDeposit == 5 * _amount, "DepositQueue tokenAmountWaitingForCalculation is not correct"
        );
        assertTrue(first == 0, "DepositQueue first is not correct");
        assertTrue(last == 5, "DepositQueue last is not correct");
        assertTrue(middle == 0, "DepositQueue length is not correct");

        console.log("Deposit time: %s", block.timestamp);
        //     // ------------------------------ calculate shares ------------------------------
        vm.stopPrank();
        vm.startPrank(owner);
        accountingManager.calculateDepositShares(3);

        //     // ------------------------------ check deposit queue -----------------------------
        (depositItem,) = accountingManager.getQueueItems(true, arr);
        assertDepositRequest(
            depositItem[0],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: _amount,
                shares: _amount
            })
        );
        assertDepositRequest(
            depositItem[1],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: _amount,
                shares: _amount
            })
        );
        assertDepositRequest(
            depositItem[2],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: _amount,
                shares: _amount
            })
        );
        assertDepositRequest(
            depositItem[3],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: _amount,
                shares: 0
            })
        );
        assertDepositRequest(
            depositItem[4],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: _amount,
                shares: 0
            })
        );

        (first, middle, last, tokenAmountWaitingForDeposit) = accountingManager.depositQueue();

        assertTrue(
            tokenAmountWaitingForDeposit == 5 * _amount, "DepositQueue tokenAmountWaitingForConfirmation is not correct"
        );
        assertTrue(first == 0, "DepositQueue first is not correct");
        assertTrue(last == 5, "DepositQueue last is not correct");
        assertTrue(middle == 3, "DepositQueue length is not correct");

        // ------------------------------ calculate shares ------------------------------
        accountingManager.calculateDepositShares(3);

        // ------------------------------ check deposit queue -----------------------------
        (depositItem,) = accountingManager.getQueueItems(true, arr);
        assertDepositRequest(
            depositItem[0],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: _amount,
                shares: _amount
            })
        );
        assertDepositRequest(
            depositItem[1],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: _amount,
                shares: _amount
            })
        );
        assertDepositRequest(
            depositItem[2],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: _amount,
                shares: _amount
            })
        );
        assertDepositRequest(
            depositItem[3],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: _amount,
                shares: _amount
            })
        );
        assertDepositRequest(
            depositItem[4],
            DepositRequest({
                receiver: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: _amount,
                shares: _amount
            })
        );

        (first, middle, last, tokenAmountWaitingForDeposit) = accountingManager.depositQueue();
        assertTrue(
            tokenAmountWaitingForDeposit == 5 * _amount, "DepositQueue tokenAmountWaitingForConfirmation is not correct"
        );
        assertTrue(first == 0, "DepositQueue first is not correct");
        assertTrue(last == 5, "DepositQueue last is not correct");
        assertTrue(middle == 5, "DepositQueue length is not correct");

        // ------------------------------ execute deposit ------------------------------
        // won't effect because the time is not passed yet
        vm.expectRevert();
        accountingManager.executeDeposit(10, connector, "");

        (first, middle, last, tokenAmountWaitingForDeposit) = accountingManager.depositQueue();
        assertTrue(
            tokenAmountWaitingForDeposit == 5 * _amount, "DepositQueue tokenAmountWaitingForConfirmation is not correct"
        );

        assertTrue(first == 0, "DepositQueue first is not correct");
        assertTrue(last == 5, "DepositQueue last is not correct");
        assertTrue(middle == 5, "DepositQueue length is not correct");

        // ------------------------------ warp the vm time ------------------------------

        vm.warp(block.timestamp + 35 minutes);

        accountingManager.executeDeposit(10, connector, "");

        (first, middle, last, tokenAmountWaitingForDeposit) = accountingManager.depositQueue();
        assertTrue(tokenAmountWaitingForDeposit == 0, "DepositQueue tokenAmountWaitingForConfirmation is not correct");
        assertTrue(first == 5, "DepositQueue first is not correct");
        assertTrue(last == 5, "DepositQueue last is not correct");
        assertTrue(middle == 5, "DepositQueue length is not correct");

        vm.stopPrank();
    }

    function testVaultMultipleDepositFlowWithWithdraw() public {
        console.log("-----------Base Workflow--------------");
        uint256 _amount = 10_000 * 1e6;
        console.log("  Balance before deposit: %s USDC", _amount / 1e6);

        _dealWhale(baseToken, address(alice), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), 10 * _amount);

        vm.startPrank(alice);

        // ------------------------------ deposit ------------------------------
        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), 6 * _amount);
        accountingManager.deposit(address(alice), _amount, address(0));
        accountingManager.deposit(address(alice), _amount, address(0));
        accountingManager.deposit(address(alice), _amount, address(0));
        accountingManager.deposit(address(alice), _amount, address(0));
        accountingManager.deposit(address(alice), _amount, address(0));
        accountingManager.deposit(address(alice), _amount, address(0));

        // ------------------------------ calculate shares ------------------------------
        vm.stopPrank();
        vm.startPrank(owner);

        accountingManager.setFees(1e4, 0, 0);

        accountingManager.calculateDepositShares(10);

        // ------------------------------ warp the vm time ------------------------------

        vm.warp(block.timestamp + 35 minutes);

        accountingManager.executeDeposit(10, connector, "");

        // ------------------------------ withdraw ------------------------------
        vm.stopPrank();
        vm.startPrank(alice);

        assertEq(accountingManager.neededAssetsForWithdraw(), 0, "neededAssetsForWithdraw is not correct3");
        vm.expectRevert();
        accountingManager.withdraw(20 * _amount, address(alice));
        accountingManager.withdraw(2 * _amount, address(alice));
        accountingManager.withdraw(3 * _amount, address(alice));

        // ------------------------------ check withdraw queue -----------------------------
        uint256[] memory arr = new uint256[](2);
        arr[0] = 0;
        arr[1] = 1;
        (, WithdrawRequest[] memory withdrawRequests) = accountingManager.getQueueItems(false, arr);
        assertWithdrawRequest(
            withdrawRequests[0],
            WithdrawRequest({
                receiver: address(alice),
                owner: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: 0,
                shares: 2 * _amount
            })
        );
        assertWithdrawRequest(
            withdrawRequests[1],
            WithdrawRequest({
                receiver: address(alice),
                owner: address(alice),
                recordTime: block.timestamp,
                calculationTime: 0,
                amount: 0,
                shares: 3 * _amount
            })
        );

        (uint256 first, uint256 middle, uint256 last) = accountingManager.withdrawQueue();
        assertEq(first, 0, "WithdrawQueue first is not correct");
        assertEq(last, 2, "WithdrawQueue last is not correct");
        assertEq(middle, 0, "WithdrawQueue length is not correct");

        vm.expectRevert();
        accountingManager.transfer(owner, 50_000_000_000);

        // ------------------------------ calculate withdraw ------------------------------
        vm.stopPrank();
        vm.startPrank(owner);
        accountingManager.calculateWithdrawShares(10);

        (, withdrawRequests) = accountingManager.getQueueItems(false, arr);
        assertWithdrawRequest(
            withdrawRequests[0],
            WithdrawRequest({
                receiver: address(alice),
                owner: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: 2 * _amount,
                shares: 2 * _amount
            })
        );
        assertWithdrawRequest(
            withdrawRequests[1],
            WithdrawRequest({
                receiver: address(alice),
                owner: address(alice),
                recordTime: block.timestamp,
                calculationTime: block.timestamp,
                amount: 3 * _amount,
                shares: 3 * _amount
            })
        );

        (first, middle, last) = accountingManager.withdrawQueue();
        assertEq(first, 0, "WithdrawQueue first is not correct");
        assertEq(last, 2, "WithdrawQueue last is not correct");
        assertEq(middle, 2, "WithdrawQueue length is not correct");

        // // ------------------------------ warp the vm time ------------------------------
        vm.warp(block.timestamp + 6 hours + 5 minutes);

        console.log(
            "amount needed to withdraw before startCurrentWithdrawGroup: %s",
            accountingManager.neededAssetsForWithdraw()
        );

        accountingManager.startCurrentWithdrawGroup();

        assertTrue(accountingManager.neededAssetsForWithdraw() > 0, "neededAssetsForWithdraw is not correct");

        {
            (
                uint256 lastId,
                uint256 totalCalculatedBaseTokenAmount,
                ,
                uint256 totalAvailableBaseTokenAmount,
                bool isStarted,
                bool isFullfilled
            ) = accountingManager.currentWithdrawGroup();

            assertEq(lastId, 2, "lastId is not correct");
            assertEq(totalCalculatedBaseTokenAmount, 5 * _amount, "totalCalculatedBaseTokenAmount is not correct");
            assertEq(totalAvailableBaseTokenAmount, 0, "totalAvailableBaseTokenAmount is not correct");
            assertEq(isStarted, true, "isStarted is not correct");
            assertEq(isFullfilled, false, "isFullfilled is not correct");
        }

        bytes memory data = hex"1232";

        RetrieveData[] memory retrieveData = new RetrieveData[](1);
        retrieveData[0] = RetrieveData(6 * _amount, address(connector), abi.encode(6 * _amount, data));

        vm.expectRevert();
        accountingManager.retrieveTokensForWithdraw(retrieveData);
        retrieveData[0] = RetrieveData(5 * _amount, address(connector), abi.encode(5 * _amount, data));
        accountingManager.retrieveTokensForWithdraw(retrieveData);

        console.log(
            "amount needed to withdraw after startCurrentWithdrawGroup 123: %s",
            accountingManager.neededAssetsForWithdraw()
        );

        console.log("already asked amount: %s", accountingManager.amountAskedForWithdraw());
        assertEq(accountingManager.neededAssetsForWithdraw(), 0, "neededAssetsForWithdraw is not correct1 ");

        vm.expectRevert();
        accountingManager.calculateWithdrawShares(10);
        accountingManager.fulfillCurrentWithdrawGroup();
        (,,, uint256 totalAB,,) = accountingManager.currentWithdrawGroup();
        console.log("currentWithdrawGroup.totalABAmount: %s", totalAB);
        vm.stopPrank();
        vm.startPrank(alice);
        accountingManager.withdraw(_amount, address(alice));
        vm.stopPrank();
        vm.startPrank(owner);
        accountingManager.calculateWithdrawShares(10);
        assertEq(accountingManager.neededAssetsForWithdraw(), 0, "neededAssetsForWithdraw is not correct2");

        // ------------------------------ execute withdraw ------------------------------
        accountingManager.executeWithdraw(10);
        (first, middle, last) = accountingManager.withdrawQueue();
        assertEq(first, 2, "WithdrawQueue first is not correct");
        assertEq(last, 3, "WithdrawQueue last is not correct");
        assertEq(middle, 3, "WithdrawQueue length is not correct");

        // check the balance of the alice
        assertEq(IERC20(USDC).balanceOf(address(alice)), 89_500_000_000, "alice balance is not correct");

        assertEq(accountingManager.getProfit(), 0, "noya profit is not correct");
        // log tvl
        console.log("Tvl: %s", accountingManager.TVL());
        // log total deposited
        console.log("Total deposited: %s", accountingManager.totalDepositedAmount());
        console.log("Total withdraw: %s", accountingManager.totalWithdrawnAmount());
    }

    function testFullfill() public {
        console.log("-----------Base Workflow--------------");
        uint256 _amount = 10_000 * 1e6;

        _dealWhale(baseToken, address(alice), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), 10 * _amount);

        vm.startPrank(alice);

        // ------------------------------ deposit ------------------------------
        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), 6 * _amount);
        accountingManager.deposit(address(alice), 6 * _amount, address(0));

        // ------------------------------ calculate shares ------------------------------
        vm.stopPrank();
        vm.startPrank(owner);

        accountingManager.calculateDepositShares(10);

        // ------------------------------ warp the vm time ------------------------------

        vm.warp(block.timestamp + 35 minutes);

        accountingManager.executeDeposit(10, connector2, "");

        // ------------------------------ withdraw ------------------------------
        vm.stopPrank();
        vm.startPrank(alice);
        accountingManager.withdraw(6 * _amount, address(alice));

        // ------------------------------ calculate withdraw ------------------------------
        vm.stopPrank();
        vm.startPrank(owner);
        accountingManager.calculateWithdrawShares(10);

        vm.warp(block.timestamp + 6 hours + 5 minutes);
        accountingManager.startCurrentWithdrawGroup();

        console.log(
            "amount needed to withdraw after startCurrentWithdrawGroup 12456: %s",
            accountingManager.neededAssetsForWithdraw()
        );
        (, uint256 totalCBAmount,, uint256 totalAVB,,) = accountingManager.currentWithdrawGroup();
        console.log("totalCBAmount 12456: %s", totalCBAmount);
        console.log("amountAskedForWithdraw 12456: %s", accountingManager.amountAskedForWithdraw());
        vm.expectRevert();
        accountingManager.fulfillCurrentWithdrawGroup();

        RetrieveData[] memory retrieveData = new RetrieveData[](2);
        retrieveData[0] = RetrieveData(6 * _amount, address(owner), abi.encode(_amount));
        retrieveData[0] = RetrieveData(6 * _amount, address(connector2), abi.encode(_amount / 2, _amount));
        vm.expectRevert();
        accountingManager.retrieveTokensForWithdraw(retrieveData);
        retrieveData[0] = RetrieveData(6 * _amount, address(connector2), abi.encode(_amount, _amount));
        accountingManager.retrieveTokensForWithdraw(retrieveData); // Covered coverage bug number 4

        vm.expectRevert();
        accountingManager.executeWithdraw(10);

        accountingManager.fulfillCurrentWithdrawGroup();
        // // ------------------------------ execute withdraw ------------------------------
        accountingManager.executeWithdraw(10);
    }

    function testErrors() public {
        console.log("-----------Base Workflow--------------");

        uint256 _amount = 10_000 * 1e6;
        _dealWhale(baseToken, address(owner), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);

        vm.startPrank(owner);

        // ------------------------------ deposit ------------------------------
        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), _amount);
        vm.expectRevert();
        accountingManager.deposit(address(owner), 0, address(0));

        accountingManager.setDepositLimits(10_000_000_000, 10);

        vm.expectRevert();
        accountingManager.deposit(address(owner), _amount, address(0));

        accountingManager.setDepositLimits(10, 1000);

        vm.expectRevert();
        accountingManager.deposit(address(owner), _amount, address(0));

        uint256 usdcBalance = IERC20(USDC).balanceOf(address(owner));
        accountingManager.sendTokensToTrustedAddress(USDC, 1000, address(0), "");
        assertEq(
            IERC20(USDC).balanceOf(address(owner)),
            usdcBalance,
            "owner balance is not correct after sendTokensToTrustedAddress"
        );

        vm.stopPrank();
    }

    function testResetMiddle() public {
        uint256 _amount = 10_000 * 1e6;

        _dealWhale(baseToken, address(alice), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);

        vm.startPrank(alice);
        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), _amount);
        accountingManager.deposit(address(alice), _amount, address(0));

        vm.stopPrank();
        vm.startPrank(owner);

        accountingManager.calculateDepositShares(10);

        (uint256 first, uint256 middle, uint256 last, uint256 tokenAmountWaitingForDeposit) =
            accountingManager.depositQueue();
        assertTrue(middle == 1, "DepositQueue length is not correct");

        vm.expectRevert();
        accountingManager.resetMiddle(10, true);

        accountingManager.resetMiddle(0, true);
        (first, middle, last, tokenAmountWaitingForDeposit) = accountingManager.depositQueue();
        assertTrue(middle == 0, "DepositQueue length is not correct");

        accountingManager.calculateDepositShares(10);
        (first, middle, last, tokenAmountWaitingForDeposit) = accountingManager.depositQueue();
        assertTrue(middle == 1, "DepositQueue length is not correct");

        vm.warp(block.timestamp + 35 minutes);

        accountingManager.executeDeposit(10, connector, "");

        // ------------------------------ withdraw ------------------------------
        vm.stopPrank();
        vm.startPrank(alice);

        accountingManager.withdraw(_amount, address(alice));

        // ------------------------------ calculate withdraw ------------------------------
        vm.stopPrank();
        vm.startPrank(owner);

        (first, middle, last) = accountingManager.withdrawQueue();
        assertTrue(middle == 0, "WithdrawQueue length is not correct");
        accountingManager.calculateWithdrawShares(10);
        (first, middle, last) = accountingManager.withdrawQueue();
        assertTrue(middle == 1, "WithdrawQueue length is not correct");
        vm.expectRevert();
        accountingManager.resetMiddle(10, false);

        accountingManager.resetMiddle(0, false);
        (first, middle, last) = accountingManager.withdrawQueue();

        assertTrue(middle == 0, "WithdrawQueue length is not correct");
        accountingManager.calculateWithdrawShares(10);
        (first, middle, last) = accountingManager.withdrawQueue();
        assertTrue(middle == 1, "WithdrawQueue length is not correct");
    }

    function testManagementFees() public {
        console.log("-----------Base Workflow--------------");

        uint256 _amount = 10_000 * 1e6;
        _dealWhale(baseToken, address(owner), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);

        vm.startPrank(owner);
        accountingManager.setFeeReceivers(
            withdrawFeeReceiver, address(performanceFeeReceiver), address(managementFeeReceiver)
        );
        // -------------------- ---------- deposit ------------------------------
        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), _amount);
        accountingManager.deposit(address(owner), _amount, address(0));

        accountingManager.setFees(0, 0, 1e5);

        accountingManager.calculateDepositShares(10);

        vm.warp(block.timestamp + 35 minutes);

        accountingManager.executeDeposit(10, connector, "");

        (uint256 sharesAmount, uint256 timePassed) = accountingManager.collectManagementFees();

        assertEq(sharesAmount, 0, "sharesAmount is not correct");
        assertEq(timePassed, 0, "timePassed is not correct");

        vm.warp(block.timestamp + 5 days);
        uint256 expectedShares = uint256(
            accountingManager.totalSupply() * (5 days + 35 minutes) * accountingManager.managementFee() / 365 days
                / accountingManager.FEE_PRECISION()
        );

        (sharesAmount, timePassed) = accountingManager.collectManagementFees();
        assertEq(sharesAmount, expectedShares, "sharesAmount is not correct");

        vm.warp(block.timestamp + 15 days);

        expectedShares = uint256(
            (accountingManager.totalSupply() - sharesAmount) * (10 days) * accountingManager.managementFee() / 365 days
                / accountingManager.FEE_PRECISION()
        );
        (sharesAmount, timePassed) = accountingManager.collectManagementFees(); // Covered coverage bug number 3

        assertEq(sharesAmount, expectedShares, "sharesAmount is not correct2");

        managementFeeReceiver.withdrawShares(sharesAmount / 2);
        managementFeeReceiver.burnShares(sharesAmount / 2);
    }

    function testPerformanceFee() public {
        console.log("-----------Base Workflow--------------");

        uint256 _amount = 10_000 * 1e6;
        _dealWhale(baseToken, address(owner), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);

        vm.startPrank(owner);
        accountingManager.setFeeReceivers(
            withdrawFeeReceiver, address(performanceFeeReceiver), address(managementFeeReceiver)
        );
        // -------------------- ---------- deposit ------------------------------
        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), _amount);
        accountingManager.deposit(address(owner), _amount, address(0));

        accountingManager.setFees(1e4, 1e5, 1e5);

        accountingManager.calculateDepositShares(10);

        vm.warp(block.timestamp + 35 minutes);

        accountingManager.executeDeposit(10, connector, "");

        vm.stopPrank();
        _dealWhale(baseToken, address(accountingManager), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);
        vm.startPrank(owner);

        assertTrue(accountingManager.getProfit() > 0, "noya profit is not correct");

        accountingManager.recordProfitForFee();
        accountingManager.recordProfitForFee();

        // nothing happens
        accountingManager.collectPerformanceFees();

        assertEq(
            accountingManager.balanceOf(address(performanceFeeReceiver)),
            0,
            "performanceFeeReceiver balance is the issue"
        );

        vm.warp(block.timestamp + 13 hours);

        accountingManager.collectPerformanceFees();
        accountingManager.rescue(baseToken, 10); // decreasing profit
        accountingManager.recordProfitForFee();

        assertTrue(
            accountingManager.balanceOf(address(performanceFeeReceiver)) > 0,
            "performanceFeeReceiver balance is not correcr3"
        );

        vm.stopPrank();
        _dealWhale(baseToken, address(accountingManager), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);
        vm.startPrank(owner);

        accountingManager.recordProfitForFee();

        uint256 balance = accountingManager.balanceOf(address(performanceFeeReceiver));
        vm.warp(block.timestamp + 50 hours);
        accountingManager.collectPerformanceFees();

        assertEq(
            accountingManager.balanceOf(address(performanceFeeReceiver)),
            balance,
            "performanceFeeReceiver balance is not correct2"
        );

        vm.stopPrank();
    }

    function testProfitDrop() public {
        console.log("-----------Base Workflow--------------");

        uint256 _amount = 10_000 * 1e6;
        _dealWhale(baseToken, address(owner), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);

        vm.startPrank(owner);
        accountingManager.setFeeReceivers(
            withdrawFeeReceiver, address(performanceFeeReceiver), address(managementFeeReceiver)
        );
        // -------------------- ---------- deposit ------------------------------
        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), _amount);
        accountingManager.deposit(address(owner), _amount, address(0));

        vm.expectRevert();
        accountingManager.setFees(1e6, 1e5, 1e5);
        vm.expectRevert();
        accountingManager.setFees(1e4, 1e6, 1e5);
        vm.expectRevert();
        accountingManager.setFees(1e4, 1e5, 1e6);
        accountingManager.setFees(1e4, 1e5, 1e5);

        accountingManager.calculateDepositShares(10);

        vm.warp(block.timestamp + 35 minutes);

        accountingManager.executeDeposit(10, address(connector), "");

        vm.stopPrank();
        _dealWhale(baseToken, address(accountingManager), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);
        vm.startPrank(owner);

        assertTrue(accountingManager.getProfit() > 0, "noya profit is not correct");

        accountingManager.recordProfitForFee();

        uint256 fee = accountingManager.preformanceFeeSharesWaitingForDistribution();
        accountingManager.checkIfTVLHasDroped();
        assertEq(
            accountingManager.preformanceFeeSharesWaitingForDistribution(),
            fee,
            "preformanceFeeSharesWaitingForDistribution should not change"
        );
        accountingManager.rescue(address(USDC), 1000);
        accountingManager.checkIfTVLHasDroped();

        assertEq(
            accountingManager.preformanceFeeSharesWaitingForDistribution(),
            0,
            "preformanceFeeSharesWaitingForDistribution is not correct"
        );
    }

    function assertDepositRequest(DepositRequest memory _depositRequest1, DepositRequest memory _depositRequest2)
        internal
    {
        assertEq(_depositRequest1.receiver, _depositRequest2.receiver, "Deposit request alice is not correct");
        assertEq(_depositRequest1.recordTime, _depositRequest2.recordTime, "Deposit request timestamp is not correct");
        assertEq(
            _depositRequest1.calculationTime,
            _depositRequest2.calculationTime,
            "Deposit request calculationTime is not correct"
        );
        assertEq(_depositRequest1.amount, _depositRequest2.amount, "Deposit request amount is not correct");
        assertEq(_depositRequest1.shares, _depositRequest2.shares, "Deposit request shares is not correct");
    }

    function assertWithdrawRequest(WithdrawRequest memory _withdrawRequest1, WithdrawRequest memory _withdrawRequest2)
        internal
    {
        assertEq(_withdrawRequest1.receiver, _withdrawRequest2.receiver, "Withdraw request alice is not correct");
        assertEq(_withdrawRequest1.owner, _withdrawRequest2.owner, "Withdraw request owner is not correct");
        assertEq(
            _withdrawRequest1.recordTime, _withdrawRequest2.recordTime, "Withdraw request timestamp is not correct"
        );
        assertEq(
            _withdrawRequest1.calculationTime,
            _withdrawRequest2.calculationTime,
            "Withdraw request calculationTime is not correct"
        );
        assertEq(_withdrawRequest1.amount, _withdrawRequest2.amount, "Withdraw request amount is not correct");
        assertEq(_withdrawRequest1.shares, _withdrawRequest2.shares, "Withdraw request shares is not correct");
    }

    function testKeeper() public {
        console.log("-----------Base Workflow--------------");

        uint256 _amount = 10_000 * 1e6;
        _dealWhale(baseToken, address(owner), address(0x1AB4973a48dc892Cd9971ECE8e01DcC7688f8F23), _amount);

        vm.startPrank(owner);

        address dest = address(accountingManager);
        bytes memory data = abi.encodeWithSignature("calculateDepositShares(uint256)", 10);
        uint256 amounts = type(uint256).max;

        address[] memory keeperOwners = new address[](3);
        keeperOwners[0] = vm.addr(privateKey1);
        keeperOwners[1] = vm.addr(privateKey2);
        keeperOwners[2] = vm.addr(privateKey3);
        Keepers keeper = new Keepers(keeperOwners, 2);

        vm.stopPrank();
        vm.startPrank(keeperOwners[0]);

        bytes32[] memory sigR = new bytes32[](2);
        bytes32[] memory sigS = new bytes32[](2);
        uint8[] memory sigV = new uint8[](2);

        bytes32 txInputHash = keccak256(
            abi.encode(keeper.TXTYPE_HASH(), keeper.nonce(), dest, data, amounts, keeperOwners[0], block.timestamp + 1)
        );
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", keeper.domainSeparatorV4(), txInputHash));

        (sigV[0], sigR[0], sigS[0]) = vm.sign(privateKey2, digest);
        (sigV[1], sigR[1], sigS[1]) = vm.sign(privateKey3, digest);

        vm.expectRevert(); // signatures order is not correct
        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1);

        (sigV[0], sigR[0], sigS[0]) = vm.sign(privateKey3, digest);
        (sigV[1], sigR[1], sigS[1]) = vm.sign(privateKey2, digest);
        vm.expectRevert(); // failed execution
        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1); // Covered coverage bug number 50

        vm.stopPrank();
        vm.startPrank(owner);

        registry.changeVaultAddresses(vaultId, owner, owner, owner, address(keeper), owner, owner);

        SafeERC20.forceApprove(IERC20(USDC), address(accountingManager), _amount);
        accountingManager.deposit(address(owner), _amount, address(0));

        vm.expectRevert(); // not the owner
        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1); // Covered coverage bug number 46

        vm.stopPrank();
        vm.startPrank(keeperOwners[0]);

        vm.warp(block.timestamp + 35 minutes);
        vm.expectRevert(); // deadline passed
        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1); // Covered coverage bug number 48

        vm.warp(block.timestamp - 35 minutes);
        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1);

        vm.stopPrank();
        vm.startPrank(owner);
        keeper.setThreshold(3);

        vm.stopPrank();
        vm.startPrank(keeperOwners[0]);
        vm.expectRevert(); // not enough signatures
        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1); // Covered coverage bug number 47

        sigR = new bytes32[](3);
        sigS = new bytes32[](2);
        sigV = new uint8[](2);
        vm.expectRevert();
        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1);

        sigR = new bytes32[](3);
        sigS = new bytes32[](3);
        sigV = new uint8[](2);
        vm.expectRevert();
        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1);

        sigR = new bytes32[](3);
        sigS = new bytes32[](3);
        sigV = new uint8[](3);

        txInputHash = keccak256(
            abi.encode(keeper.TXTYPE_HASH(), keeper.nonce(), dest, data, amounts, keeperOwners[0], block.timestamp + 1)
        );
        digest = keccak256(abi.encodePacked("\x19\x01", keeper.domainSeparatorV4(), txInputHash));

        (sigV[0], sigR[0], sigS[0]) = vm.sign(privateKey3, digest);
        (sigV[1], sigR[1], sigS[1]) = vm.sign(privateKey1, digest);
        (sigV[2], sigR[2], sigS[2]) = vm.sign(privateKey2, digest);
        vm.expectRevert();
        keeper.execute(dest, data, amounts, keeperOwners[1], sigR, sigS, sigV, block.timestamp + 1); // Covered coverage bug number 48

        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1); // Covered coverage bug number 50

        vm.stopPrank();
        vm.startPrank(owner);
        address[] memory updatingKeeperOwners = new address[](1);
        bool[] memory isOwner = new bool[](1);
        updatingKeeperOwners[0] = vm.addr(privateKey1);
        isOwner[0] = false;
        vm.expectRevert();
        keeper.updateOwners(updatingKeeperOwners, isOwner);
        keeper.setThreshold(2);
        keeper.updateOwners(updatingKeeperOwners, isOwner);
        vm.stopPrank();
        vm.startPrank(keeperOwners[0]);

        vm.expectRevert();
        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1);

        vm.stopPrank();
        vm.startPrank(owner);
        isOwner[0] = true;
        keeper.updateOwners(updatingKeeperOwners, isOwner);
        updatingKeeperOwners[0] = vm.addr(privateKey4);
        keeper.updateOwners(updatingKeeperOwners, isOwner);

        vm.expectRevert();

        keeper.execute(dest, data, amounts, keeperOwners[0], sigR, sigS, sigV, block.timestamp + 1);

        vm.stopPrank();
    }

    function testEmergency() public {
        _dealWhale(baseToken, address(accountingManager), USDC_Whale, 10_000 * 1e6);
        vm.deal(address(accountingManager), 1 ether);

        vm.startPrank(owner);

        accountingManager.changeWithdrawWaitingTime(10);

        accountingManager.changeDepositWaitingTime(1000);

        accountingManager.emergencyStop(); // Covered coverage bug number 6

        accountingManager.rescue(address(USDC), 1000);

        accountingManager.rescue(address(0), 1 ether);

        accountingManager.unpause(); // Covered coverage bug number 7
        vm.deal(address(accountingManager), 1 ether);

        EmergancyMock mock = new EmergancyMock();

        registry.changeVaultAddresses(vaultId, owner, owner, owner, owner, address(watchers), address(mock));
        mock.callRescue(address(accountingManager), address(0), 1000);
        mock.setAccept(false);
        vm.expectRevert();
        mock.callRescue(address(accountingManager), address(0), 1000); // Covered coverage bug number 8
        vm.stopPrank();
    }
}
