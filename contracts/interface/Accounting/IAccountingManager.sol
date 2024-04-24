// SPDX-License-Identifier: Apache-2.0
import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";
import "../valueOracle/INoyaValueOracle.sol";
import "@openzeppelin/contracts-5.0/utils/Pausable.sol";

pragma solidity 0.8.20;
/*
    * @notice DepositRequest is a struct that holds the deposit information that are waiting for calculation of their shares
    * @param receiver is the address that will receive the shares
    * @param recordTime is the time that the deposit was recorded
    * @param calculationTime is the time that the shares were calculated
    * @param amount is the amount of the base token that was deposited
    * @param shares is the amount of shares that will be minted for the receiver
    **/

struct DepositRequest {
    address receiver;
    uint256 recordTime;
    uint256 calculationTime;
    uint256 amount;
    uint256 shares;
}

struct RetrieveData {
    uint256 withdrawAmount;
    address connectorAddress;
    bytes data;
}

/*
    * @notice WithdrawRequest is a struct that holds the withdraw information that are waiting for calculation of their shares
    * @param owner is the address that owns the shares
    * @param receiver is the address that will receive the base token
    * @param recordTime is the time that the withdraw was recorded
    * @param calculationTime is the time that the base token amount was calculated
    * @param shares is the amount of shares that will be burned for the owner
    * @param amount is the amount of the base token that will be sent to the receiver
    **/
struct WithdrawRequest {
    address owner;
    address receiver;
    uint256 recordTime;
    uint256 calculationTime;
    uint256 shares;
    uint256 amount;
}

/*
    * @notice DepositQueue is a struct that holds the deposit queue
    * @param queue is a mapping that holds the DepositRequest structs
    * @param first is the first index of the queue (indicates the index that is waiting for the tvl to be updated)
    * @param middle is the middle index of the queue (indicates the index that is waiting for calculation)
    * @param last is the last index of the queue (indicates the index that is waiting for execution)
    * @param totalAWFDeposit is the total amount of the base token that is waiting for execution
    **/
struct DepositQueue {
    mapping(uint256 => DepositRequest) queue;
    uint256 first;
    uint256 middle;
    uint256 last;
    uint256 totalAWFDeposit;
}

/*
    * @notice WithdrawQueue is a struct that holds the withdraw queue
    * @param queue is a mapping that holds the WithdrawRequest structs
    * @param first is the first index of the queue (indicates the index that is waiting for the tvl to be updated)
    * @param middle is the middle index of the queue (indicates the index that is waiting for calculation)
    * @param last is the last index of the queue (indicates the index that is waiting for execution)
    * @param totalSharesWaitingForWithdraw is the total amount of shares that is waiting for execution
    **/
struct WithdrawQueue {
    mapping(uint256 => WithdrawRequest) queue;
    uint256 first;
    uint256 middle;
    uint256 last;
}

/*
    * @notice At each point in time if there are some users waiting for a withdraw, we create one WithdrawGroup for them
    * @param lastId is the last index of the withdraw queue that is waiting for execution
    * @param totalCBAmount is the total amount of the base token that is waiting for execution
    * @param totalABAmount is the total amount of the base token that is available for withdraw
    * @param isStarted indicates if the withdraw group is started
    * @param isFullfilled indicates if the withdraw group is fullfilled
    * @dev if isStarted is true and isFullfilled is false, it means that the withdraw group is active
    * @dev if isStarted is false and isFullfilled is false, it means that there is no active withdraw group
    * @dev if isStarted is true and isFullfilled is true, it means that the withdraw group is fullfilled and but there are still some withdraws that are waiting for execution
    * @dev users of the withdraw group will bear the gas cost of the withdraw
    **/
struct WithdrawGroup {
    uint256 lastId;
    uint256 totalCBAmount;
    uint256 totalCBAmountFullfilled;
    uint256 totalABAmount;
    bool isStarted;
    bool isFullfilled;
}

struct AccountingManagerConstructorParams {
    string _name;
    string _symbol;
    address _baseTokenAddress;
    address _registry;
    address _valueOracle;
    uint256 _vaultId;
    address _withdrawFeeReceiver;
    address _managementFeeReceiver;
    address _performanceFeeReceiver;
    uint256 _withdrawFee;
    uint256 _performanceFee;
    uint256 _managementFee;
}

interface IAccountingManager {
    event RecordDeposit(uint256 depositId, address receiver, uint256 recordTime, uint256 amount, address referrer);
    event CalculateDeposit(
        uint256 depositId, address receiver, uint256 recordTime, uint256 amount, uint256 shares, uint256 sharePrice
    );
    event MoveTheMiddle(uint256 newMiddle, bool depositOrWithdraw);
    event ExecuteDeposit(
        uint256 depositId, address receiver, uint256 recordTime, uint256 amount, uint256 shares, uint256 sharePrice
    );

    event RecordWithdraw(uint256 withdrawId, address owner, address receiver, uint256 shares, uint256 recordTime);
    event CalculateWithdraw(
        uint256 withdrawId,
        address owner,
        address receiver,
        uint256 shares,
        uint256 calculatedAmount,
        uint256 recordTime
    );
    event ExecuteWithdraw(
        uint256 withdrawId,
        address owner,
        address receiver,
        uint256 shares,
        uint256 calculatedAmount,
        uint256 sendedAmount,
        uint256 recordTime
    );
    event FeeRecepientsChanged(address, address, address);
    event FeeRatesChanged(uint256, uint256, uint256);
    event WithdrawGroupStarted(uint256 lastId, uint256 totalCBAmount);
    event WithdrawGroupFulfilled(uint256 lastId, uint256 totalCBAmount, uint256 totalABAmount);
    event ValueOracleUpdated(address valueOracle);
    event TransferTokensToTrustedAddress(address token, uint256 amount, address caller, bytes data);
    event ResetMiddle(uint256 newMiddle, uint256 oldMiddle, bool depositOrWithdraw);
    event RecordProfit(uint256 storedProfitAmount, uint256 currentProfit, uint256 feeAmount, uint256 recordTime);
    event ResetFee(uint256 storedProfitAmount, uint256 currentProfit, uint256 recordTime);
    event CollectManagementFee(uint256 feeAmount, uint256 timeDuration, uint256 totalShares, uint256 currentFeeShares);
    event CollectPerformanceFee(uint256 feeAmount);
    event RetrieveTokensForWithdraw(
        uint256 withdrawAmount, address connectorAddress, uint256 fetchedAmount, uint256 totalAmountAsked
    );

    event SetDepositLimits(uint256 depositLimitPerTransaction, uint256 depositTotalAmount);
    event SetDepositWaitingTime(uint256 depositWaitingTime);
    event SetWithdrawWaitingTime(uint256 withdrawWaitingTime);
    event Rescue(address caller, address token, uint256 amount);

    error NoyaAccounting_INSUFFICIENT_FUNDS(uint256 balance, uint256 amount, uint256 amountForWithdraw);
    error NoyaAccounting_INVALID_AMOUNT();
    error NoyaAccounting_TotalDepositLimitExceeded();
    error NoyaAccounting_DepositLimitPerTransactionExceeded();
    error NoyaAccounting_ThereIsAnActiveWithdrawGroup();
    error NoyaAccounting_InvalidTimeForCalculation();
    error NoyaAccounting_RequestIsNotCalculated();
    error NoyaAccounting_INVALID_CONNECTOR();
    error NoyaAccounting_NOT_READY_TO_FULFILL();
    error NoyaAccounting_banalceAfterIsNotEnough();
    error NoyaAccounting_InvalidPositionType();
    error NoyaAccounting_NOT_ALLOWED();
    error NoyaAccounting_INVALID_FEE();
}
