// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";
import { ERC4626, ERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/extensions/ERC4626.sol";
import "../interface/Accounting/IAccountingManager.sol";
import { NoyaGovernanceBase, PositionBP } from "../governance/NoyaGovernanceBase.sol";
import "../helpers/TVLHelper.sol";

/*
* @title AccountingManager
* @notice AccountingManager is a contract that handles the accounting of the vault
* @notice It is also responsible for managing deposits and withdraws
* @notice It is also responsible for holding the shares of the users
**/
contract AccountingManager is IAccountingManager, ERC4626, ReentrancyGuard, Pausable, NoyaGovernanceBase {
    using SafeERC20 for IERC20;

    // ------------ state variable -------------- //
    /// @notice depositQueue is a struct that holds the deposit queue
    DepositQueue public depositQueue;
    /// @notice withdrawQueue is a struct that holds the withdraw queue
    WithdrawQueue public withdrawQueue;

    /// @notice withdrawRequestsByAddress is a mapping that holds the withdraw requests of the users
    /// @dev withdrawRequestsByAddress is used to prevent users from withdrawing or transferring more than their shares, while their withdraw request are waiting for execution
    mapping(address => uint256) public withdrawRequestsByAddress;
    /// @notice amountAskedForWithdraw is the total amount of the base token that is asked for withdraw from connectors
    /// @dev we use this variable to prevent the withdraw group from being fullfilled before the needed amount is gathered
    uint256 public amountAskedForWithdraw;

    /// @notice totalDepositedAmount is the total amount of the base token that is deposited to the vault by the users
    /// @dev we use this variable to calculate the profit of the vault
    uint256 public totalDepositedAmount;
    /// @notice totalWithdrawnAmount is the total amount of the base token that is withdrawn from the vault by the users
    /// @dev we use this variable to calculate the profit of the vault
    uint256 public totalWithdrawnAmount;
    /// @notice storedProfitForFee is the total amount of profit that is cached.
    /// @dev This variable is used to calculate the performance fee and prevent the strategy manager to increase the profit of the vault by depositing the profit to the vault
    /// @dev for a short period of time and getting more fees than it should
    uint256 public storedProfitForFee;
    /// @notice profitStoredTime is the time that the profit is cached. We allow the strategy manager to get the performance fee only if the profit is cached for more than 12 hours
    uint256 public profitStoredTime;
    /// @notice lastFeeDistributionTime is the time that the last fee distribution is done. This variable is used to calculate the management fee (x% of the total assets per year)
    uint256 public lastFeeDistributionTime;
    /// @notice totalProfitCalculated is the total amount of profit that is calculated.
    uint256 public totalProfitCalculated;
    /// @notice preformanceFeeSharesWaitingForDistribution is the total amount of shares that are waiting for distribution of the performance fee
    /// @dev we use this variable to prevent the strategy manager to get the performance fee before the lock period is passed
    uint256 public preformanceFeeSharesWaitingForDistribution;

    uint256 public constant FEE_PRECISION = 1e6;
    uint256 public constant WITHDRAWAL_MAX_FEE = 5e4;
    uint256 public constant MANAGEMENT_MAX_FEE = 5e5;
    uint256 public constant PERFORMANCE_MAX_FEE = 1e5;

    /// @notice baseToken is the address of the base token of the vault
    /// @dev baseToken is used to handle the deposits and withdraws
    /// @dev baseToken is also used to calculate the price of the shares (also profits)
    IERC20 public baseToken;

    /// @notice withdrawFee is the fee that is taken from the users when they withdraw their shares
    uint256 public withdrawFee; // 0.0001% = 1
    /// @notice performanceFee is the fee that is taken for the profit of the vault (x% of the profit)
    uint256 public performanceFee;
    /// @notice managementFee is the fee that is taken for the total assets of the vault (x% of the total assets per year)
    uint256 public managementFee;
    /// @notice withdrawFeeReceiver is the address that the withdraw fee is sent to
    address public withdrawFeeReceiver;
    /// @notice performanceFeeReceiver is the address that the performance fee is sent to
    address public performanceFeeReceiver;
    /// @notice managementFeeReceiver is the address that the management fee is sent to
    address public managementFeeReceiver;

    /// @notice currentWithdrawGroup is holding the current withdraw group that is waiting for execution
    /// @dev if isStarted is true and isFullfilled is false, it means that the withdraw group is active and we are gethering funds for these withdrawals
    /// @dev if isStarted is false and isFullfilled is false, it means that there is no active withdraw group
    /// @dev if isStarted is true and isFullfilled is true, it means that the withdraw group is fullfilled and but there are still some withdraws that are waiting for execution
    WithdrawGroup public currentWithdrawGroup;

    /// @notice depositWaitingTime is the time that the deposit should wait for execution after calculation
    uint256 public depositWaitingTime = 30 minutes;
    /// @notice depositWaitingTime is the time that the withdraw should wait for execution after calculation
    uint256 public withdrawWaitingTime = 6 hours;

    /// @notice depositLimitTotalAmount is the total amount of the base token that can be deposited to the vault
    uint256 public depositLimitTotalAmount = 1e6 * 200_000;
    /// @notice depositLimitPerTransaction is the total amount of the base token that can be deposited to the vault per transaction
    uint256 public depositLimitPerTransaction = 1e6 * 2000;

    /// @notice valueOracle is the address of the value oracle that is used to calculate the price of the assets (used to get TVL of holding tokens)
    INoyaValueOracle public valueOracle;

    constructor(AccountingManagerConstructorParams memory p)
        ERC4626(IERC20(p._baseTokenAddress))
        ERC20(p._name, p._symbol)
        NoyaGovernanceBase(PositionRegistry(p._registry), p._vaultId)
    {
        baseToken = IERC20(p._baseTokenAddress);
        valueOracle = INoyaValueOracle(p._valueOracle);
        lastFeeDistributionTime = block.timestamp;
        withdrawFeeReceiver = p._withdrawFeeReceiver;
        performanceFeeReceiver = p._performanceFeeReceiver;
        managementFeeReceiver = p._managementFeeReceiver;

        require(p._baseTokenAddress != address(0));
        require(p._valueOracle != address(0));
        require(p._withdrawFeeReceiver != address(0));
        require(p._performanceFeeReceiver != address(0));
        require(p._managementFeeReceiver != address(0));

        if (
            p._withdrawFee > WITHDRAWAL_MAX_FEE || p._performanceFee > PERFORMANCE_MAX_FEE
                || p._managementFee > MANAGEMENT_MAX_FEE
        ) {
            revert NoyaAccounting_INVALID_FEE();
        }
        withdrawFee = p._withdrawFee;
        performanceFee = p._performanceFee;
        managementFee = p._managementFee;
    }

    /// @notice updateValueOracle is a function that is used to update the value oracle of the vault
    function updateValueOracle(INoyaValueOracle _valueOracle) public onlyMaintainer {
        require(address(_valueOracle) != address(0));
        valueOracle = _valueOracle;
        emit ValueOracleUpdated(address(_valueOracle));
    }

    /// @notice setFeeReceivers is a function that is used to update the fee receivers of the vault
    /// @dev the access to this function is restricted to the maintainer
    /// @param _withdrawFeeReceiver is the address that the withdraw fee is sent to
    /// @param _performanceFeeReceiver is the address that the performance fee is sent to (this should be the NoyaFeeReceiver contract address)
    /// @param _managementFeeReceiver is the address that the management fee is sent to(this should be another instance of NoyaFeeReceiver contract address)
    function setFeeReceivers(
        address _withdrawFeeReceiver,
        address _performanceFeeReceiver,
        address _managementFeeReceiver
    ) public onlyMaintainer {
        require(_withdrawFeeReceiver != address(0));
        require(_performanceFeeReceiver != address(0));
        require(_managementFeeReceiver != address(0));
        withdrawFeeReceiver = _withdrawFeeReceiver;
        performanceFeeReceiver = _performanceFeeReceiver;
        managementFeeReceiver = _managementFeeReceiver;
        emit FeeRecepientsChanged(_withdrawFeeReceiver, _performanceFeeReceiver, _managementFeeReceiver);
    }

    /// @notice sendTokensToTrustedAddress is used to transfer tokens from accounting manager to other contracts
    function sendTokensToTrustedAddress(address token, uint256 amount, address _caller, bytes calldata _data)
        external
        returns (uint256)
    {
        emit TransferTokensToTrustedAddress(token, amount, _caller, _data);
        if (registry.isAnActiveConnector(vaultId, msg.sender)) {
            IERC20(token).safeTransfer(address(msg.sender), amount);
            return amount;
        }
        return 0;
    }

    /**
     * @dev Sets the fees for withdrawals, performance, and management.
     * Can only be called by the maintainer.
     *
     * @param _withdrawFee The fee for withdrawals.
     * @param _performanceFee The fee for performance.
     * @param _managementFee The fee for management.
     */
    function setFees(uint256 _withdrawFee, uint256 _performanceFee, uint256 _managementFee) public onlyMaintainer {
        if (
            _withdrawFee > WITHDRAWAL_MAX_FEE || _performanceFee > PERFORMANCE_MAX_FEE
                || _managementFee > MANAGEMENT_MAX_FEE
        ) {
            revert NoyaAccounting_INVALID_FEE();
        }
        withdrawFee = _withdrawFee;
        performanceFee = _performanceFee;
        managementFee = _managementFee;
        emit FeeRatesChanged(_withdrawFee, _performanceFee, _managementFee);
    }

    /// @notice _update is an internal function that is used to update the balances of the users in ERC20 statndard
    /// @notice by overriding this function we can prevent users from withdrawing or transferring more than their shares, while their withdraw request are waiting for execution
    function _update(address from, address to, uint256 amount) internal override {
        if (!(from == address(0)) && balanceOf(from) < amount + withdrawRequestsByAddress[from]) {
            revert NoyaAccounting_INSUFFICIENT_FUNDS(balanceOf(from), amount, withdrawRequestsByAddress[from]);
        }
        super._update(from, to, amount);
    }

    /*
    * @notice users can deposit base token to the vault using this function
    * @param receiver is the address that will receive the shares
    * @param amount is the amount of the base token that is deposited
    * @param referrer is the address that referred the user to the vault
    * @dev this function is used to deposit base token to the vault
    * @dev the deposit request is recorded to the deposit queue
    **/
    function deposit(address receiver, uint256 amount, address referrer) public nonReentrant whenNotPaused {
        if (amount == 0) {
            revert NoyaAccounting_INVALID_AMOUNT();
        }

        baseToken.safeTransferFrom(msg.sender, address(this), amount);

        if (amount > depositLimitPerTransaction) {
            revert NoyaAccounting_DepositLimitPerTransactionExceeded();
        }

        if (TVL() > depositLimitTotalAmount) {
            revert NoyaAccounting_TotalDepositLimitExceeded();
        }

        depositQueue.queue[depositQueue.last] = DepositRequest(receiver, block.timestamp, 0, amount, 0);
        emit RecordDeposit(depositQueue.last, receiver, block.timestamp, amount, referrer);
        depositQueue.last += 1;
        depositQueue.totalAWFDeposit += amount;
    }

    /*
    * @notice calculateDepositShares is a function that calculates the shares of the deposits that are waiting for calculation
    * @param maxIterations is the maximum number of iterations that the function can do
    * @dev this function is used to calculate the users desposit shares that has been deposited before the oldest update time of the vault
    */
    function calculateDepositShares(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {
        uint256 middleTemp = depositQueue.middle;
        uint64 i = 0;

        uint256 oldestUpdateTime = TVLHelper.getLatestUpdateTime(vaultId, registry);

        while (
            depositQueue.last > middleTemp && depositQueue.queue[middleTemp].recordTime <= oldestUpdateTime
                && i < maxIterations
        ) {
            i += 1;
            DepositRequest storage data = depositQueue.queue[middleTemp];

            uint256 shares = previewDeposit(data.amount);
            data.shares = shares;
            data.calculationTime = block.timestamp;
            emit CalculateDeposit(
                middleTemp, data.receiver, block.timestamp, shares, data.amount, shares * 1e18 / data.amount
            );

            middleTemp += 1;
        }

        depositQueue.middle = middleTemp;
    }

    /// @notice executeDeposit is a function that is used to execute the deposits that are waiting for execution
    /// @param maxI is the maximum number of iterations that the function can do
    /// @param connector is the address of the connector that is used to add liquidity to the connector
    /// @param addLPdata is the data that is used to add liquidity to the connector
    /// @dev this function is used to mint the shares for the users and add liquidity to the connector
    function executeDeposit(uint256 maxI, address connector, bytes memory addLPdata)
        public
        onlyManager
        whenNotPaused
        nonReentrant
    {
        uint256 firstTemp = depositQueue.first;
        uint64 i = 0;
        uint256 processedBaseTokenAmount = 0;

        while (
            depositQueue.middle > firstTemp
                && depositQueue.queue[firstTemp].calculationTime + depositWaitingTime <= block.timestamp && i < maxI
        ) {
            i += 1;
            DepositRequest memory data = depositQueue.queue[firstTemp];

            emit ExecuteDeposit(
                firstTemp, data.receiver, block.timestamp, data.shares, data.amount, data.shares * 1e18 / data.amount
            );
            // minting shares for receiver address
            _mint(data.receiver, data.shares);

            processedBaseTokenAmount += data.amount;
            delete depositQueue.queue[firstTemp];
            firstTemp += 1;
        }
        depositQueue.totalAWFDeposit -= processedBaseTokenAmount;

        totalDepositedAmount += processedBaseTokenAmount;

        if (registry.isAnActiveConnector(vaultId, connector) && processedBaseTokenAmount > 0) {
            uint256[] memory amounts = new uint256[](1);
            amounts[0] = processedBaseTokenAmount;
            address[] memory tokens = new address[](1);
            tokens[0] = address(baseToken);
            IConnector(connector).addLiquidity(tokens, amounts, addLPdata);
        } else {
            revert NoyaAccounting_INVALID_CONNECTOR();
        }

        depositQueue.first = firstTemp;
    }

    /// @notice withdraw is a function that is used to withdraw the shares of the users
    /// @param share is the amount of shares that the user wants to withdraw
    /// @param receiver is the address that will receive the base token
    function withdraw(uint256 share, address receiver) public nonReentrant whenNotPaused {
        if (balanceOf(msg.sender) < share + withdrawRequestsByAddress[msg.sender]) {
            revert NoyaAccounting_INSUFFICIENT_FUNDS(
                balanceOf(msg.sender), share, withdrawRequestsByAddress[msg.sender]
            );
        }
        withdrawRequestsByAddress[msg.sender] += share;

        // adding the withdraw request to the withdraw queue
        withdrawQueue.queue[withdrawQueue.last] = WithdrawRequest(msg.sender, receiver, block.timestamp, 0, share, 0);
        emit RecordWithdraw(withdrawQueue.last, msg.sender, receiver, share, block.timestamp);
        withdrawQueue.last += 1;
    }
    /**
     * @notice Calculates the shares equivalent for the withdrawal requests that are waiting for calculation
     * @dev This function iterates through withdrawal requests queued for calculation and assigns the corresponding amount of base tokens to each request based on the current share price. It is intended to be called by the vault manager to process queued withdrawals efficiently.
     * @param maxIterations The maximum number of iterations the function will process to prevent gas limit issues. This allows for batch processing of withdrawal calculations.
     * @dev The steps are:
     * 1. Iterate through the withdrawal queue and calculate the amount of base tokens to be assigned to each withdrawal request.
     * 2. calculate the shares using the previewRedeem function
     * 3. Assign the calculated amount of base tokens to the withdrawal request.
     * 4. Increment the middle index of the withdrawal queue.
     */

    function calculateWithdrawShares(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {
        uint256 middleTemp = withdrawQueue.middle;
        uint64 i = 0;
        uint256 processedShares = 0;
        uint256 assetsNeededForWithdraw = 0;
        uint256 oldestUpdateTime = TVLHelper.getLatestUpdateTime(vaultId, registry);

        if (currentWithdrawGroup.isFullfilled == false && currentWithdrawGroup.isStarted == true) {
            revert NoyaAccounting_ThereIsAnActiveWithdrawGroup();
        }
        while (
            withdrawQueue.last > middleTemp && withdrawQueue.queue[middleTemp].recordTime <= oldestUpdateTime
                && i < maxIterations
        ) {
            i += 1;
            WithdrawRequest storage data = withdrawQueue.queue[middleTemp];
            uint256 assets = previewRedeem(data.shares);
            data.amount = assets;
            data.calculationTime = block.timestamp;
            assetsNeededForWithdraw += assets;
            processedShares += data.shares;
            emit CalculateWithdraw(middleTemp, data.owner, data.receiver, data.shares, assets, block.timestamp);

            middleTemp += 1;
        }
        currentWithdrawGroup.totalCBAmount += assetsNeededForWithdraw;
        withdrawQueue.middle = middleTemp;
    }

    /// @notice startCurrentWithdrawGroup is a function that is used to start the current withdraw group
    /// @dev after starting the withdraw group, we can not start another withdraw group until the current withdraw group is fullfilled
    /// @dev after starting the withdraw group, we can not calculate the withdraw shares until the withdraw group is fullfilled
    function startCurrentWithdrawGroup() public onlyManager nonReentrant whenNotPaused {
        require(currentWithdrawGroup.isStarted == false && currentWithdrawGroup.isFullfilled == false);
        currentWithdrawGroup.isStarted = true;
        currentWithdrawGroup.lastId = withdrawQueue.middle;
        emit WithdrawGroupStarted(currentWithdrawGroup.lastId, currentWithdrawGroup.totalCBAmount);
    }

    /// @notice fulfillCurrentWithdrawGroup is a function that is used to fulfill the current withdraw group
    /// @dev we fulfill the withdraw group after the needed assets are gathered
    /// @dev after fulfilling the withdraw group, we can start
    function fulfillCurrentWithdrawGroup() public onlyManager nonReentrant whenNotPaused {
        require(currentWithdrawGroup.isStarted == true && currentWithdrawGroup.isFullfilled == false);
        uint256 neededAssets = neededAssetsForWithdraw();

        if (neededAssets != 0 && amountAskedForWithdraw != currentWithdrawGroup.totalCBAmount) {
            revert NoyaAccounting_NOT_READY_TO_FULFILL();
        }
        currentWithdrawGroup.isFullfilled = true;
        amountAskedForWithdraw = 0;
        uint256 availableAssets = baseToken.balanceOf(address(this)) - depositQueue.totalAWFDeposit;
        if (availableAssets >= currentWithdrawGroup.totalCBAmount) {
            currentWithdrawGroup.totalABAmount = currentWithdrawGroup.totalCBAmount;
        } else {
            currentWithdrawGroup.totalABAmount = availableAssets;
        }
        currentWithdrawGroup.totalCBAmountFullfilled = currentWithdrawGroup.totalCBAmount;
        currentWithdrawGroup.totalCBAmount = 0;
        emit WithdrawGroupFulfilled(
            currentWithdrawGroup.lastId, currentWithdrawGroup.totalCBAmount, currentWithdrawGroup.totalABAmount
        );
    }

    /// @notice executeWithdraw is a function that is used to execute the withdraws that are waiting for execution
    /// @param maxIterations is the maximum number of iterations that the function can do
    /// @dev this function is used to burn the shares of the users and transfer the base token to the receiver
    /// @dev this function is also used to take the withdraw fee from the users
    function executeWithdraw(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {
        if (currentWithdrawGroup.isFullfilled == false) {
            revert NoyaAccounting_ThereIsAnActiveWithdrawGroup();
        }
        uint64 i = 0;
        uint256 firstTemp = withdrawQueue.first;

        uint256 withdrawFeeAmount = 0;
        uint256 processedBaseTokenAmount = 0;
        // loop through the withdraw queue and execute the withdraws
        while (
            currentWithdrawGroup.lastId > firstTemp
                && withdrawQueue.queue[firstTemp].calculationTime + withdrawWaitingTime <= block.timestamp
                && i < maxIterations
        ) {
            i += 1;
            WithdrawRequest memory data = withdrawQueue.queue[firstTemp];
            uint256 shares = data.shares;
            // calculate the base token amount that the user will receive based on the total available amount
            uint256 baseTokenAmount =
                data.amount * currentWithdrawGroup.totalABAmount / currentWithdrawGroup.totalCBAmountFullfilled;

            withdrawRequestsByAddress[data.owner] -= shares;
            _burn(data.owner, shares);

            processedBaseTokenAmount += data.amount;
            {
                uint256 feeAmount = baseTokenAmount * withdrawFee / FEE_PRECISION;
                withdrawFeeAmount += feeAmount;
                baseTokenAmount = baseTokenAmount - feeAmount;
            }

            baseToken.safeTransfer(data.receiver, baseTokenAmount);
            emit ExecuteWithdraw(
                firstTemp, data.owner, data.receiver, shares, data.amount, baseTokenAmount, block.timestamp
            );
            delete withdrawQueue.queue[firstTemp];
            // increment the first index of the withdraw queue
            firstTemp += 1;
        }
        totalWithdrawnAmount += processedBaseTokenAmount;

        if (withdrawFeeAmount > 0) {
            baseToken.safeTransfer(withdrawFeeReceiver, withdrawFeeAmount);
        }
        withdrawQueue.first = firstTemp;
        // if the withdraw group is fullfilled and there are no withdraws that are waiting for execution, we delete the withdraw group
        if (currentWithdrawGroup.lastId == firstTemp) {
            delete currentWithdrawGroup;
        }
    }

    /// @notice resetMiddle is a function that is used to reset the middle index of the deposit or withdraw queue
    /// @param newMiddle is the new middle index of the queue
    /// @param depositOrWithdraw is a boolean that indicates if the function is used to reset the middle index of the deposit or withdraw queue
    /// @dev in case of a price manipulation, we can reset the middle index of the deposit or withdraw queue to prevent the users from getting more shares than they should
    /// @dev by resetting the middle index of the deposit or withdraw queue, we force the users to wait for the calculation of their shares
    function resetMiddle(uint256 newMiddle, bool depositOrWithdraw) public onlyManager {
        if (depositOrWithdraw) {
            emit ResetMiddle(newMiddle, depositQueue.middle, depositOrWithdraw);

            if (newMiddle > depositQueue.middle || newMiddle < depositQueue.first) {
                revert NoyaAccounting_INVALID_AMOUNT();
            }
            depositQueue.middle = newMiddle;
        } else {
            emit ResetMiddle(newMiddle, withdrawQueue.middle, depositOrWithdraw);

            if (newMiddle > withdrawQueue.middle || newMiddle < withdrawQueue.first || currentWithdrawGroup.isStarted) {
                revert NoyaAccounting_INVALID_AMOUNT();
            }
            withdrawQueue.middle = newMiddle;
        }
    }

    // ------------ fee functions -------------- //
    /// @notice recordProfitForFee is a function that is used to record the profit of the vault for the performance fee
    /// @dev in this function, we calculate the profit of the vault and record it for the performance fee, if the profit is more than the total profit that is calculated
    /// @dev we mint the shares to address(this) so after the lock period is passed, the strategy manager can get the performance fee  shares by calling the collectPerformanceFees function
    function recordProfitForFee() public onlyManager nonReentrant {
        storedProfitForFee = getProfit();
        profitStoredTime = block.timestamp;

        if (storedProfitForFee < totalProfitCalculated) {
            return;
        }

        preformanceFeeSharesWaitingForDistribution =
            previewDeposit(((storedProfitForFee - totalProfitCalculated) * performanceFee) / FEE_PRECISION);
        emit RecordProfit(
            storedProfitForFee, totalProfitCalculated, preformanceFeeSharesWaitingForDistribution, block.timestamp
        );
    }

    /// @notice checkIfTVLHasDroped is a function that is used to check if the TVL has dropped
    /// @dev if the TVL has dropped, we burn the shares that are waiting for the distribution of the performance fee
    /// @dev the access to this function is public so everyone can prevent the strategy manager from getting the performance fee  more than it should
    function checkIfTVLHasDroped() public nonReentrant {
        uint256 currentProfit = getProfit();
        if (currentProfit < storedProfitForFee) {
            emit ResetFee(currentProfit, storedProfitForFee, block.timestamp);
            preformanceFeeSharesWaitingForDistribution = 0;
            profitStoredTime = 0;
        }
    }

    /// @notice collectManagementFees is a function that is used to collect the management fees
    /// @dev management fee is x% of the total assets per year
    /// @dev we can mint x% of the total shares to the management fee receiver
    function collectManagementFees() public onlyManager nonReentrant returns (uint256, uint256) {
        if (block.timestamp - lastFeeDistributionTime < 1 days) {
            return (0, 0);
        }
        uint256 timePassed = block.timestamp - lastFeeDistributionTime;
        if (timePassed > 10 days) {
            timePassed = 10 days;
        }
        uint256 totalShares = totalSupply();
        uint256 currentFeeShares = balanceOf(managementFeeReceiver) + balanceOf(performanceFeeReceiver)
            + preformanceFeeSharesWaitingForDistribution;

        uint256 managementFeeAmount =
            (timePassed * managementFee * (totalShares - currentFeeShares)) / FEE_PRECISION / 365 days;
        _mint(managementFeeReceiver, managementFeeAmount);
        emit CollectManagementFee(managementFeeAmount, timePassed, totalShares, currentFeeShares);
        lastFeeDistributionTime = block.timestamp;
        return (managementFeeAmount, timePassed);
    }

    /// @notice collectPerformanceFees after the lock period is passed, the strategy manager can get the performance fee shares by calling this function
    function collectPerformanceFees() public onlyManager nonReentrant {
        if (
            preformanceFeeSharesWaitingForDistribution == 0 || block.timestamp - profitStoredTime < 12 hours
                || block.timestamp - profitStoredTime > 48 hours
        ) {
            return;
        }

        _mint(performanceFeeReceiver, preformanceFeeSharesWaitingForDistribution);

        totalProfitCalculated = storedProfitForFee;

        emit CollectPerformanceFee(preformanceFeeSharesWaitingForDistribution);

        preformanceFeeSharesWaitingForDistribution = 0;
    }

    function burnShares(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    /// @notice retrieveTokensForWithdraw the manager can call this function to get tokens from the connectors to fulfill the withdraw requests
    function retrieveTokensForWithdraw(RetrieveData[] calldata retrieveData) public onlyManager nonReentrant {
        uint256 amountAskedForWithdraw_temp = 0;
        uint256 neededAssets = neededAssetsForWithdraw();
        for (uint256 i = 0; i < retrieveData.length; i++) {
            if (!registry.isAnActiveConnector(vaultId, retrieveData[i].connectorAddress)) {
                continue;
            }
            uint256 balanceBefore = baseToken.balanceOf(address(this));
            uint256 amount = IConnector(retrieveData[i].connectorAddress).sendTokensToTrustedAddress(
                address(baseToken), retrieveData[i].withdrawAmount, address(this), retrieveData[i].data
            );
            uint256 balanceAfter = baseToken.balanceOf(address(this));
            if (balanceBefore + amount > balanceAfter) revert NoyaAccounting_banalceAfterIsNotEnough();
            amountAskedForWithdraw_temp += retrieveData[i].withdrawAmount;
            emit RetrieveTokensForWithdraw(
                retrieveData[i].withdrawAmount,
                retrieveData[i].connectorAddress,
                amount,
                amountAskedForWithdraw + amountAskedForWithdraw_temp
            );
        }
        amountAskedForWithdraw += amountAskedForWithdraw_temp;
        if (amountAskedForWithdraw_temp > neededAssets) {
            revert NoyaAccounting_INVALID_AMOUNT();
        }
    }

    // ------------ view functions -------------- //
    /**
     * @notice Calculates the vault's current profit based on the Total Value Locked (TVL), total deposited, and withdrawn amounts
     * The profit is determined by the following formula:
     *      Profit = (TVL + Total Withdrawn Amount) - Total Deposited Amount
     *
     */
    function getProfit() public view returns (uint256) {
        uint256 tvl = TVL();
        if (tvl + totalWithdrawnAmount > totalDepositedAmount) {
            return tvl + totalWithdrawnAmount - totalDepositedAmount;
        }
        return 0;
    }

    /// @notice by overriding the totalAssets function, we can calculate the total assets of the vault and use the 4626 standard to calculate the shares price
    function totalAssets() public view override returns (uint256) {
        return TVL();
    }
    /// @notice This is a view function that helps us to get the queue items easily

    function getQueueItems(bool depositOrWithdraw, uint256[] memory items)
        public
        view
        returns (DepositRequest[] memory depositData, WithdrawRequest[] memory withdrawData)
    {
        if (depositOrWithdraw) {
            depositData = new DepositRequest[](items.length);
            for (uint256 i = 0; i < items.length; i++) {
                depositData[i] = depositQueue.queue[items[i]];
            }
        } else {
            withdrawData = new WithdrawRequest[](items.length);
            for (uint256 i = 0; i < items.length; i++) {
                withdrawData[i] = withdrawQueue.queue[items[i]];
            }
        }
        return (depositData, withdrawData);
    }
    /// @notice if the withdraw group is not fullfilled, we can get the needed assets for the withdraw using this function

    function neededAssetsForWithdraw() public view returns (uint256) {
        uint256 availableAssets = baseToken.balanceOf(address(this)) - depositQueue.totalAWFDeposit;
        if ( // check if the withdraw group is fullfilled
            currentWithdrawGroup.isStarted == false || currentWithdrawGroup.isFullfilled == true
                || availableAssets >= currentWithdrawGroup.totalCBAmount
        ) {
            return 0;
        }
        return currentWithdrawGroup.totalCBAmount - availableAssets;
    }

    function TVL() public view returns (uint256) {
        return TVLHelper.getTVL(vaultId, registry, address(baseToken)) + baseToken.balanceOf(address(this))
            - depositQueue.totalAWFDeposit;
    }

    function getPositionTVL(HoldingPI memory position, address base) public view returns (uint256) {
        PositionBP memory p = registry.getPositionBP(vaultId, position.positionId);
        if (p.positionTypeId == 0) {
            address token = abi.decode(p.data, (address));
            uint256 amount = IERC20(token).balanceOf(abi.decode(position.data, (address)));
            return _getValue(token, base, amount);
        }
        return 0;
    }

    function _getValue(address token, address base, uint256 amount) internal view returns (uint256) {
        if (token == base) {
            return amount;
        }
        return valueOracle.getValue(token, base, amount);
    }

    function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {
        if (positionTypeId == 0) {
            address[] memory tokens = new address[](1);
            tokens[0] = abi.decode(data, (address));
            return tokens;
        }
        return new address[](0);
    }

    // ------------ Config functions -------------- //
    function emergencyStop() public whenNotPaused onlyEmergency {
        _pause();
    }

    function unpause() public whenPaused onlyEmergency {
        _unpause();
    }

    function setDepositLimits(uint256 _depositLimitPerTransaction, uint256 _depositTotalAmount) public onlyMaintainer {
        depositLimitPerTransaction = _depositLimitPerTransaction;
        depositLimitTotalAmount = _depositTotalAmount;
        emit SetDepositLimits(_depositLimitPerTransaction, _depositTotalAmount);
    }

    function changeDepositWaitingTime(uint256 _depositWaitingTime) public onlyMaintainer {
        depositWaitingTime = _depositWaitingTime;
        emit SetDepositWaitingTime(_depositWaitingTime);
    }

    function changeWithdrawWaitingTime(uint256 _withdrawWaitingTime) public onlyMaintainer {
        withdrawWaitingTime = _withdrawWaitingTime;
        emit SetWithdrawWaitingTime(_withdrawWaitingTime);
    }

    function rescue(address token, uint256 amount) public onlyEmergency nonReentrant {
        if (token == address(0)) {
            (bool success,) = payable(msg.sender).call{ value: amount }("");
            require(success, "Transfer failed.");
        } else {
            IERC20(token).safeTransfer(msg.sender, amount);
        }
        emit Rescue(msg.sender, token, amount);
    }

    function mint(uint256 shares, address receiver) public override returns (uint256) {
        revert NoyaAccounting_NOT_ALLOWED();
    }

    function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {
        revert NoyaAccounting_NOT_ALLOWED();
    }

    function redeem(uint256 shares, address receiver, address shareOwner) public override returns (uint256) {
        revert NoyaAccounting_NOT_ALLOWED();
    }

    function deposit(uint256 assets, address receiver) public override returns (uint256) {
        revert NoyaAccounting_NOT_ALLOWED();
    }
}
