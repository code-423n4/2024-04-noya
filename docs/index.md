# Solidity API

## AccountingManager

### depositQueue

```solidity
struct DepositQueue depositQueue
```

depositQueue is a struct that holds the deposit queue

### withdrawQueue

```solidity
struct WithdrawQueue withdrawQueue
```

withdrawQueue is a struct that holds the withdraw queue

### withdrawRequestsByAddress

```solidity
mapping(address => uint256) withdrawRequestsByAddress
```

withdrawRequestsByAddress is a mapping that holds the withdraw requests of the users

_withdrawRequestsByAddress is used to prevent users from withdrawing or transferring more than their shares, while their withdraw request are waiting for execution_

### amountAskedForWithdraw

```solidity
uint256 amountAskedForWithdraw
```

amountAskedForWithdraw is the total amount of the base token that is asked for withdraw from connectors

_we use this variable to prevent the withdraw group from being fullfilled before the needed amount is gathered_

### totalDepositedAmount

```solidity
uint256 totalDepositedAmount
```

totalDepositedAmount is the total amount of the base token that is deposited to the vault by the users

_we use this variable to calculate the profit of the vault_

### totalWithdrawnAmount

```solidity
uint256 totalWithdrawnAmount
```

totalWithdrawnAmount is the total amount of the base token that is withdrawn from the vault by the users

_we use this variable to calculate the profit of the vault_

### storedProfitForFee

```solidity
uint256 storedProfitForFee
```

storedProfitForFee is the total amount of profit that is cached.

_This variable is used to calculate the performance fee and prevent the strategy manager to increase the profit of the vault by depositing the profit to the vault
for a short period of time and getting more fees than it should_

### profitStoredTime

```solidity
uint256 profitStoredTime
```

profitStoredTime is the time that the profit is cached. We allow the strategy manager to get the performance fee only if the profit is cached for more than 12 hours

### lastFeeDistributionTime

```solidity
uint256 lastFeeDistributionTime
```

lastFeeDistributionTime is the time that the last fee distribution is done. This variable is used to calculate the management fee (x% of the total assets per year)

### totalProfitCalculated

```solidity
uint256 totalProfitCalculated
```

totalProfitCalculated is the total amount of profit that is calculated.

### preformanceFeeSharesWaitingForDistribution

```solidity
uint256 preformanceFeeSharesWaitingForDistribution
```

preformanceFeeSharesWaitingForDistribution is the total amount of shares that are waiting for distribution of the performance fee

_we use this variable to prevent the strategy manager to get the performance fee before the lock period is passed_

### FEE_PRECISION

```solidity
uint256 FEE_PRECISION
```

### baseToken

```solidity
contract IERC20 baseToken
```

baseToken is the address of the base token of the vault

_baseToken is used to handle the deposits and withdraws
baseToken is also used to calculate the price of the shares (also profits)_

### withdrawFee

```solidity
uint256 withdrawFee
```

withdrawFee is the fee that is taken from the users when they withdraw their shares

### performanceFee

```solidity
uint256 performanceFee
```

performanceFee is the fee that is taken for the profit of the vault (x% of the profit)

### managementFee

```solidity
uint256 managementFee
```

managementFee is the fee that is taken for the total assets of the vault (x% of the total assets per year)

### withdrawFeeReceiver

```solidity
address withdrawFeeReceiver
```

withdrawFeeReceiver is the address that the withdraw fee is sent to

### performanceFeeReceiver

```solidity
address performanceFeeReceiver
```

performanceFeeReceiver is the address that the performance fee is sent to

### managementFeeReceiver

```solidity
address managementFeeReceiver
```

managementFeeReceiver is the address that the management fee is sent to

### currentWithdrawGroup

```solidity
struct WithdrawGroup currentWithdrawGroup
```

currentWithdrawGroup is holding the current withdraw group that is waiting for execution

_if isStarted is true and isFullfilled is false, it means that the withdraw group is active and we are gethering funds for these withdrawals
if isStarted is false and isFullfilled is false, it means that there is no active withdraw group
if isStarted is true and isFullfilled is true, it means that the withdraw group is fullfilled and but there are still some withdraws that are waiting for execution_

### depositWaitingTime

```solidity
uint256 depositWaitingTime
```

depositWaitingTime is the time that the deposit should wait for execution after calculation

### withdrawWaitingTime

```solidity
uint256 withdrawWaitingTime
```

depositWaitingTime is the time that the withdraw should wait for execution after calculation

### depositLimitTotalAmount

```solidity
uint256 depositLimitTotalAmount
```

depositLimitTotalAmount is the total amount of the base token that can be deposited to the vault

### depositLimitPerTransaction

```solidity
uint256 depositLimitPerTransaction
```

depositLimitPerTransaction is the total amount of the base token that can be deposited to the vault per transaction

### valueOracle

```solidity
contract INoyaValueOracle valueOracle
```

valueOracle is the address of the value oracle that is used to calculate the price of the assets (used to get TVL of holding tokens)

### constructor

```solidity
constructor(string _name, string _symbol, address _baseTokenAddress, contract PositionRegistry _registry, address _valueOracle, uint256 _vaultId, address _managementFeeReceiver, address _performanceFeeReceiver) public
```

### updateValueOracle

```solidity
function updateValueOracle(contract INoyaValueOracle _valueOracle) public
```

updateValueOracle is a function that is used to update the value oracle of the vault

### setFeeReceivers

```solidity
function setFeeReceivers(address _withdrawFeeReceiver, address _performanceFeeReceiver, address _managementFeeReceiver) public
```

setFeeReceivers is a function that is used to update the fee receivers of the vault

_the access to this function is restricted to the maintainer_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _withdrawFeeReceiver | address | is the address that the withdraw fee is sent to |
| _performanceFeeReceiver | address | is the address that the performance fee is sent to (this should be the NoyaFeeReceiver contract address) |
| _managementFeeReceiver | address | is the address that the management fee is sent to(this should be another instance of NoyaFeeReceiver contract address) |

### sendTokensToTrustedAddress

```solidity
function sendTokensToTrustedAddress(address token, uint256 amount, address, bytes) external returns (uint256)
```

sendTokensToTrustedAddress is used to transfer tokens from accounting manager to other contracts

### setFees

```solidity
function setFees(uint256 _withdrawFee, uint256 _performanceFee, uint256 _managementFee) public
```

_Sets the fees for withdrawals, performance, and management.
Can only be called by the maintainer._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _withdrawFee | uint256 | The fee for withdrawals. |
| _performanceFee | uint256 | The fee for performance. |
| _managementFee | uint256 | The fee for management. |

### _update

```solidity
function _update(address from, address to, uint256 amount) internal
```

_update is an internal function that is used to update the balances of the users in ERC20 statndard
by overriding this function we can prevent users from withdrawing or transferring more than their shares, while their withdraw request are waiting for execution

### deposit

```solidity
function deposit(address receiver, uint256 amount, address referrer) public
```

### calculateDepositShares

```solidity
function calculateDepositShares(uint256 maxIterations) public
```

### executeDeposit

```solidity
function executeDeposit(uint256 maxI, address connector, bytes addLPdata) public
```

executeDeposit is a function that is used to execute the deposits that are waiting for execution

_this function is used to mint the shares for the users and add liquidity to the connector_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| maxI | uint256 | is the maximum number of iterations that the function can do |
| connector | address | is the address of the connector that is used to add liquidity to the connector |
| addLPdata | bytes | is the data that is used to add liquidity to the connector |

### withdraw

```solidity
function withdraw(uint256 share, address receiver) public
```

withdraw is a function that is used to withdraw the shares of the users

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| share | uint256 | is the amount of shares that the user wants to withdraw |
| receiver | address | is the address that will receive the base token |

### calculateWithdrawShares

```solidity
function calculateWithdrawShares(uint256 maxIterations) public
```

Calculates the shares equivalent for the withdrawal requests that are waiting for calculation

_This function iterates through withdrawal requests queued for calculation and assigns the corresponding amount of base tokens to each request based on the current share price. It is intended to be called by the vault manager to process queued withdrawals efficiently.
The steps are:
1. Iterate through the withdrawal queue and calculate the amount of base tokens to be assigned to each withdrawal request.
2. calculate the shares using the previewRedeem function
3. Assign the calculated amount of base tokens to the withdrawal request.
4. Increment the middle index of the withdrawal queue._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| maxIterations | uint256 | The maximum number of iterations the function will process to prevent gas limit issues. This allows for batch processing of withdrawal calculations. |

### startCurrentWithdrawGroup

```solidity
function startCurrentWithdrawGroup() public
```

startCurrentWithdrawGroup is a function that is used to start the current withdraw group

_after starting the withdraw group, we can not start another withdraw group until the current withdraw group is fullfilled
after starting the withdraw group, we can not calculate the withdraw shares until the withdraw group is fullfilled_

### fulfillCurrentWithdrawGroup

```solidity
function fulfillCurrentWithdrawGroup() public
```

fulfillCurrentWithdrawGroup is a function that is used to fulfill the current withdraw group

_we fulfill the withdraw group after the needed assets are gathered
after fulfilling the withdraw group, we can start_

### executeWithdraw

```solidity
function executeWithdraw(uint256 maxIterations) public
```

executeWithdraw is a function that is used to execute the withdraws that are waiting for execution

_this function is used to burn the shares of the users and transfer the base token to the receiver
this function is also used to take the withdraw fee from the users_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| maxIterations | uint256 | is the maximum number of iterations that the function can do |

### resetMiddle

```solidity
function resetMiddle(uint256 newMiddle, bool depositOrWithdraw) public
```

resetMiddle is a function that is used to reset the middle index of the deposit or withdraw queue

_in case of a price manipulation, we can reset the middle index of the deposit or withdraw queue to prevent the users from getting more shares than they should
by resetting the middle index of the deposit or withdraw queue, we force the users to wait for the calculation of their shares_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newMiddle | uint256 | is the new middle index of the queue |
| depositOrWithdraw | bool | is a boolean that indicates if the function is used to reset the middle index of the deposit or withdraw queue |

### recordProfitForFee

```solidity
function recordProfitForFee() public
```

recordProfitForFee is a function that is used to record the profit of the vault for the performance fee

_in this function, we calculate the profit of the vault and record it for the performance fee, if the profit is more than the total profit that is calculated
we mint the shares to address(this) so after the lock period is passed, the strategy manager can get the performance fee  shares by calling the collectPerformanceFees function_

### checkIfTVLHasDroped

```solidity
function checkIfTVLHasDroped() public
```

checkIfTVLHasDroped is a function that is used to check if the TVL has dropped

_if the TVL has dropped, we burn the shares that are waiting for the distribution of the performance fee
the access to this function is public so everyone can prevent the strategy manager from getting the performance fee  more than it should_

### collectManagementFees

```solidity
function collectManagementFees() public returns (uint256, uint256)
```

collectManagementFees is a function that is used to collect the management fees

_management fee is x% of the total assets per year
we can mint x% of the total shares to the management fee receiver_

### collectPerformanceFees

```solidity
function collectPerformanceFees() public
```

collectPerformanceFees after the lock period is passed, the strategy manager can get the performance fee shares by calling this function

### burnShares

```solidity
function burnShares(uint256 amount) public
```

### retrieveTokensForWithdraw

```solidity
function retrieveTokensForWithdraw(struct RetrieveData[] retrieveData) public
```

retrieveTokensForWithdraw the manager can call this function to get tokens from the connectors to fulfill the withdraw requests

### getProfit

```solidity
function getProfit() public view returns (uint256)
```

Calculates the vault's current profit based on the Total Value Locked (TVL), total deposited, and withdrawn amounts
The profit is determined by the following formula:
     Profit = (TVL + Total Withdrawn Amount) - Total Deposited Amount

### totalAssets

```solidity
function totalAssets() public view returns (uint256)
```

by overriding the totalAssets function, we can calculate the total assets of the vault and use the 4626 standard to calculate the shares price

### getQueueItems

```solidity
function getQueueItems(bool depositOrWithdraw, uint256[] items) public view returns (struct DepositRequest[] depositData, struct WithdrawRequest[] withdrawData)
```

This is a view function that helps us to get the queue items easily

### neededAssetsForWithdraw

```solidity
function neededAssetsForWithdraw() public view returns (uint256)
```

if the withdraw group is not fullfilled, we can get the needed assets for the withdraw using this function

### TVL

```solidity
function TVL() public view returns (uint256)
```

### getPositionTVL

```solidity
function getPositionTVL(struct HoldingPI position, address base) public view returns (uint256)
```

### _getValue

```solidity
function _getValue(address token, address base, uint256 amount) internal view returns (uint256)
```

### getUnderlyingTokens

```solidity
function getUnderlyingTokens(uint256 positionTypeId, bytes data) public view returns (address[])
```

### emergencyStop

```solidity
function emergencyStop() public
```

### unpause

```solidity
function unpause() public
```

### setDepositLimits

```solidity
function setDepositLimits(uint256 _depositLimitPerTransaction, uint256 _depositTotalAmount) public
```

### changeDepositWaitingTime

```solidity
function changeDepositWaitingTime(uint256 _depositWaitingTime) public
```

### changeWithdrawWaitingTime

```solidity
function changeWithdrawWaitingTime(uint256 _withdrawWaitingTime) public
```

### rescue

```solidity
function rescue(address token, uint256 amount) public
```

## NoyaFeeReceiver

### receiver

```solidity
address receiver
```

### accountingManager

```solidity
address accountingManager
```

### baseToken

```solidity
address baseToken
```

### ManagementFeeReceived

```solidity
event ManagementFeeReceived(address token, uint256 amount)
```

### constructor

```solidity
constructor(address _accountingManager, address _baseToken, address _receiver) public
```

### withdrawShares

```solidity
function withdrawShares(uint256 amount) external
```

### burnShares

```solidity
function burnShares(uint256 amount) external
```

## PositionRegistry

_: PositionRegistry
This contract is used to store the information of the vaults and the positions_

### MAINTAINER_ROLE

```solidity
bytes32 MAINTAINER_ROLE
```

### GOVERNER_ROLE

```solidity
bytes32 GOVERNER_ROLE
```

### EMERGENCY_ROLE

```solidity
bytes32 EMERGENCY_ROLE
```

### vaults

```solidity
mapping(uint256 => struct Vault) vaults
```

### onlyVaultMaintainer

```solidity
modifier onlyVaultMaintainer(uint256 _vaultId)
```

### onlyVaultMaintainerWithoutTimeLock

```solidity
modifier onlyVaultMaintainerWithoutTimeLock(uint256 _vaultId)
```

### onlyVaultGoverner

```solidity
modifier onlyVaultGoverner(uint256 _vaultId)
```

### vaultExists

```solidity
modifier vaultExists(uint256 _vaultId)
```

### constructor

```solidity
constructor(address _governer, address _maintainer, address _emergency) public
```

_: Constructor
Registry roles are set in the constructor
The governer role is the admin of itself, the maintainer role and the emergency role_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _governer | address | The address of the governer |
| _maintainer | address | The address of the maintainer |
| _emergency | address | The address of the emergency |

### addVault

```solidity
function addVault(uint256 vaultId, address _accountingManager, address _baseToken, address _governer, address _maintainer, address _maintainerWithoutTimelock, address _keeperContract, address _watcher, address _emergency, address[] _trustedTokens) external
```

### changeVaultAddresses

```solidity
function changeVaultAddresses(uint256 vaultId, address _governer, address _maintainer, address _maintainerWithoutTimelock, address _keeperContract, address _watcher, address _emergency) external
```

### addConnector

```solidity
function addConnector(uint256 vaultId, address[] _connectorAddresses, bool[] _enableds) external
```

### updateConnectorTrustedTokens

```solidity
function updateConnectorTrustedTokens(uint256 vaultId, address _connectorAddress, address[] _tokens, bool trusted) external
```

### getPositionBP

```solidity
function getPositionBP(uint256 vaultId, bytes32 _positionId) public view returns (struct PositionBP)
```

### addTrustedPosition

```solidity
function addTrustedPosition(uint256 vaultId, uint256 _positionTypeId, address calculatorConnector, bool onlyOwner, bool _isDebt, bytes _data, bytes _additionalData) external
```

### removeTrustedPosition

```solidity
function removeTrustedPosition(uint256 vaultId, bytes32 _positionId) external
```

### updateHoldingPosition

```solidity
function updateHoldingPosition(struct Vault vault, uint256 vaultId, bytes32 _positionId, bytes d, bytes AD, uint256 index, bytes32 holdingPositionId) internal returns (uint256)
```

### updateHoldingPosition

```solidity
function updateHoldingPosition(uint256 vaultId, bytes32 _positionId, bytes _data, bytes additionalData, bool removePosition) public returns (uint256)
```

### updateHoldingPostionWithTime

```solidity
function updateHoldingPostionWithTime(uint256 vaultId, bytes32 _positionId, bytes _data, bytes additionalData, bool removePosition, uint256 positionTimestamp) external
```

_Same as updateHoldingPosition but with a positionTimestamp parameter
in scenarios where the positionTimestamp is not the current time (e.g. when we have positions on other chains)_

### getHoldingPositionIndex

```solidity
function getHoldingPositionIndex(uint256 vaultId, bytes32 _positionId, address _connector, bytes data) public view returns (uint256)
```

### getHoldingPosition

```solidity
function getHoldingPosition(uint256 vaultId, uint256 i) public view returns (struct HoldingPI)
```

### getHoldingPositions

```solidity
function getHoldingPositions(uint256 vaultId) public view returns (struct HoldingPI[])
```

### isPositionTrusted

```solidity
function isPositionTrusted(uint256 vaultId, bytes32 _positionId) public view returns (bool)
```

### isPositionTrustedForConnector

```solidity
function isPositionTrustedForConnector(uint256 vaultId, bytes32 _positionId, address connector) public view returns (bool)
```

### getGovernanceAddresses

```solidity
function getGovernanceAddresses(uint256 vaultId) public view returns (address, address, address, address, address, address)
```

### isTokenTrusted

```solidity
function isTokenTrusted(uint256 vaultId, address token, address connector) public view returns (bool)
```

### calculatePositionId

```solidity
function calculatePositionId(address calculatorConnector, uint256 positionTypeId, bytes data) public pure returns (bytes32)
```

_Calculates a unique ID for a position._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| calculatorConnector | address | The address of the calculator connector contract. |
| positionTypeId | uint256 | The ID of the position type. |
| data | bytes | Additional data used to calculate the position ID. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes32 | bytes32 The unique position ID. |

### isAnActiveConnector

```solidity
function isAnActiveConnector(uint256 vaultId, address connectorAddress) public view returns (bool)
```

### isPositionDebt

```solidity
function isPositionDebt(uint256 vaultId, bytes32 _positionId) public view returns (bool)
```

### getVaultAddresses

```solidity
function getVaultAddresses(uint256 vaultId) public view returns (address, address)
```

### isAddressTrusted

```solidity
function isAddressTrusted(uint256 vaultId, address addr) public view returns (bool)
```

## AaveConnector

### pool

```solidity
address pool
```

Aave pool address

### poolBaseToken

```solidity
address poolBaseToken
```

Aave pool base token

### AAVE_POSITION_ID

```solidity
uint256 AAVE_POSITION_ID
```

### constructor

```solidity
constructor(address _pool, address _poolBaseToken, struct BaseConnectorCP baseConnectorParams) public
```

### supply

```solidity
function supply(address supplyToken, uint256 amount) external
```

Supply tokens to Aave

### borrow

```solidity
function borrow(uint256 _amount, uint256 _interestRateMode, address _borrowAsset) external
```

Borrow tokens from Aave

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _amount | uint256 | - amount to borrow |
| _interestRateMode | uint256 | - Stable: 1, Variable: 2 |
| _borrowAsset | address | - asset to borrow |

### repay

```solidity
function repay(address asset, uint256 amount, uint256 i) external
```

Repays onBehalfOf's debt amount of asset which has a rateMode.

### repayWithCollateral

```solidity
function repayWithCollateral(uint256 _amount, uint256 i, address _borrowAsset) external
```

### withdrawCollateral

```solidity
function withdrawCollateral(uint256 _collateralAmount, address _collateral) external
```

Withdraw collateral from Aave
This function is used when we want to withdraw some of the collateral
It doesn't allow the health factor to go below the minimum health factor

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _collateralAmount | uint256 | - amount to withdraw |
| _collateral | address | - collateral to withdraw |

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI, address base) public view returns (uint256 tvl)
```

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256, bytes) public pure returns (address[])
```

## AerodromeConnector

### AERODROME_POSITION_TYPE

```solidity
uint256 AERODROME_POSITION_TYPE
```

### constructor

```solidity
constructor(struct BaseConnectorCP baseConnectorParams) public
```

### supply

```solidity
function supply(address pool, uint256 amount0, uint256 amount1, uint256 minBalance) public
```

### withdraw

```solidity
function withdraw(address pool, uint256 amountLiquidity) public
```

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256 p, bytes data) public view returns (address[])
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256)
```

## PoolInfo

```solidity
struct PoolInfo {
  address pool;
  address[] tokens;
  uint256 tokenIndex;
  bytes32 poolId;
  uint256[] weights;
  address auraPoolAddress;
  uint256 boosterPoolId;
}
```

## BalancerConnector

### balancerVault

```solidity
address balancerVault
```

### BAL

```solidity
address BAL
```

### AURA

```solidity
address AURA
```

### BALANCER_LP_POSITION

```solidity
uint256 BALANCER_LP_POSITION
```

### constructor

```solidity
constructor(address _balancerVault, address bal, address aura, struct BaseConnectorCP baseConnectorParams) public
```

Constructor *********************************

### harvestAuraRewards

```solidity
function harvestAuraRewards(address[] rewardsPools) public
```

### openPosition

```solidity
function openPosition(bytes32 poolId, uint256[] amounts, uint256[] amountsWithoutBPT, uint256 minBPT, bool depositIntoAura) public
```

Internal Functions *********************************

### depositIntoAuraBooster

```solidity
function depositIntoAuraBooster(bytes32 poolId, uint256 _amount) public
```

### decreasePosition

```solidity
function decreasePosition(bytes32 poolId, uint256 _lpAmount, uint256 withdrawIndex, uint256 outerIndex, uint256 _auraAmount) public
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256)
```

### totalLpBalanceOf

```solidity
function totalLpBalanceOf(struct PoolInfo pool) public view returns (uint256)
```

### totalLpBalanceOf

```solidity
function totalLpBalanceOf(bytes32 poolId) public view returns (uint256)
```

### _getPoolInfo

```solidity
function _getPoolInfo(bytes32 pooId) internal view returns (struct PoolInfo, bytes32)
```

## CompoundConnector

### COMPOUND_LP

```solidity
uint256 COMPOUND_LP
```

### constructor

```solidity
constructor(struct BaseConnectorCP baseConnectorParams) public
```

Constructor *********************************

### supply

```solidity
function supply(address market, address asset, uint256 amount) external
```

Restricted Functions *********************************

### withdrawOrBorrow

```solidity
function withdrawOrBorrow(address _market, address asset, uint256 amount) external
```

### claimRewards

```solidity
function claimRewards(address rewardContract, address market) external
```

Claim additional rewards

### getAccountHealthFactor

```solidity
function getAccountHealthFactor(contract IComet comet) public view returns (uint256)
```

Returns an accounts health factor for a given comet.

_Returns type(uint256).max if no debt is owed._

### getBorrowBalanceInBase

```solidity
function getBorrowBalanceInBase(contract IComet comet) public view returns (uint256 borrowBalanceInVirtualBase)
```

### getCollBlanace

```solidity
function getCollBlanace(contract IComet comet, bool riskAdjusted) public view returns (uint256 CollValue)
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256)
```

_Whether user has a non-zero balance of an asset, given assetsIn flags_

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256, bytes data) public view returns (address[])
```

### isInAsset

```solidity
function isInAsset(uint16 assetsIn, uint8 assetOffset) public pure returns (bool)
```

## PoolInfo

```solidity
struct PoolInfo {
  address pool;
  uint256 tokensSize;
  address lpToken;
  address gauge;
  address convexLPToken;
  address convexRewardPool;
  address prismaCurvePool;
  address prismaConvexPool;
  address[] tokens;
  address zap;
  uint256 defaultWithdrawIndex;
  address poolAddressIfDefaultWithdrawTokenIsAnotherPosition;
}
```

## CurveConnector

### convexBooster

```solidity
contract IBooster convexBooster
```

### CVX

```solidity
address CVX
```

### CRV

```solidity
address CRV
```

### PRISMA

```solidity
address PRISMA
```

### CURVE_LP_POSITION

```solidity
uint256 CURVE_LP_POSITION
```

### constructor

```solidity
constructor(address _convexBooster, address cvx, address crv, address prisma, struct BaseConnectorCP baseConnectorParams) public
```

### depositIntoGauge

```solidity
function depositIntoGauge(address pool, uint256 amount) public
```

### depositIntoPrisma

```solidity
function depositIntoPrisma(address pool, uint256 amount, bool curveOrConvex) public
```

### depositIntoConvexBooster

```solidity
function depositIntoConvexBooster(address pool, uint256 pid, uint256 amount, bool stake) public
```

### openCurvePosition

```solidity
function openCurvePosition(address pool, uint256 depositIndex, uint256 amount, uint256 minAmount) public
```

### decreaseCurvePosition

```solidity
function decreaseCurvePosition(address pool, uint256 withdrawIndex, uint256 amount, uint256 minAmount) public
```

### withdrawFromConvexBooster

```solidity
function withdrawFromConvexBooster(uint256 pid, uint256 amount) public
```

### withdrawFromConvexRewardPool

```solidity
function withdrawFromConvexRewardPool(address pool, uint256 amount) public
```

### withdrawFromGauge

```solidity
function withdrawFromGauge(address pool, uint256 amount) public
```

### withdrawFromPrisma

```solidity
function withdrawFromPrisma(address depostiToken, uint256 amount) public
```

### harvestRewards

```solidity
function harvestRewards(address[] gauges) public
```

### harvestPrismaRewards

```solidity
function harvestPrismaRewards(address[] pools) public
```

### harvestConvexRewards

```solidity
function harvestConvexRewards(address[] rewardsPools) public
```

### _getPoolInfo

```solidity
function _getPoolInfo(address pool) internal view returns (struct PoolInfo)
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

### LPToUnder

```solidity
function LPToUnder(struct PoolInfo info, uint256 balance) public view returns (uint256, address)
```

### estimateWithdrawAmount

```solidity
function estimateWithdrawAmount(contract ICurveSwap curvePool, uint256 amount, uint256 index) public view returns (uint256)
```

### totalLpBalanceOf

```solidity
function totalLpBalanceOf(struct PoolInfo info) public view returns (uint256)
```

### balanceOfConvexRewardPool

```solidity
function balanceOfConvexRewardPool(struct PoolInfo info) public view returns (uint256)
```

### balanceOfLPToken

```solidity
function balanceOfLPToken(struct PoolInfo info) public view returns (uint256)
```

### balanceOfRewardPool

```solidity
function balanceOfRewardPool(struct PoolInfo info) public view returns (uint256)
```

### balanceOfPrisma

```solidity
function balanceOfPrisma(address prismaPool) public view returns (uint256)
```

## FraxPoolInfo

```solidity
struct FraxPoolInfo {
  address collateralContract;
  address assetContract;
  bool isActive;
}
```

## FraxBorrowRequest

```solidity
struct FraxBorrowRequest {
  address poolAddress;
  uint256 amount;
}
```

## FraxConnector

### COLLATERAL_AND_DEBT_POSITION_TYPE

```solidity
uint256 COLLATERAL_AND_DEBT_POSITION_TYPE
```

### constructor

```solidity
constructor(struct BaseConnectorCP baseConnectorParams) public
```

### borrowAndSupply

```solidity
function borrowAndSupply(contract IFraxPair pool, uint256 borrowAmount, uint256 collateralAmount) external
```

### withdraw

```solidity
function withdraw(contract IFraxPair pool, uint256 withdrawAmount) public
```

### repay

```solidity
function repay(contract IFraxPair pool, uint256 sharesToRepay) public
```

### verifyHealthFactor

```solidity
function verifyHealthFactor(contract IFraxPair pool) public view
```

### _getHealthFactor

```solidity
function _getHealthFactor(contract IFraxPair _fraxlendPair, uint256 _exchangeRate) internal view virtual returns (uint256)
```

The ```_getHealthFactor``` function returns the current health factor of a respective position given an exchange rate

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _fraxlendPair | contract IFraxPair | The specified Fraxlend Pair |
| _exchangeRate | uint256 | The exchange rate, i.e. the amount of collateral to buy 1e18 asset |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | currentHF The health factor of the position atm |

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256 p, bytes data) public view returns (address[])
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

## Gearboxv3

### GEARBOX_POSITION_ID

```solidity
uint256 GEARBOX_POSITION_ID
```

### constructor

```solidity
constructor(struct BaseConnectorCP baseConnectorParams) public
```

### openAccount

```solidity
function openAccount(address facade, uint256 ref) public
```

### closeAccount

```solidity
function closeAccount(address facade, address creditAccount) public
```

### executeCommands

```solidity
function executeCommands(address facade, address creditAccount, struct MultiCall[] calls, address approvalToken, uint256 amount) public
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

## LidoConnector

### lido

```solidity
address lido
```

### lidoWithdrawal

```solidity
address lidoWithdrawal
```

### steth

```solidity
address steth
```

### weth

```solidity
address weth
```

### LIDO_WITHDRAWAL_REQUEST_ID

```solidity
uint256 LIDO_WITHDRAWAL_REQUEST_ID
```

### constructor

```solidity
constructor(address _lido, address _lidoW, address _steth, address w, struct BaseConnectorCP baseConnectorParams) public
```

### deposit

```solidity
function deposit(uint256 amountIn) external
```

### requestWithdrawals

```solidity
function requestWithdrawals(uint256 amount) public
```

### claimWithdrawal

```solidity
function claimWithdrawal(uint256 requestId) public
```

### receive

```solidity
receive() external payable
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

## MavericAddLiquidityParams

```solidity
struct MavericAddLiquidityParams {
  bool ethPoolIncluded;
  contract IMaverickPool pool;
  struct AddLiquidityParams[] params;
  uint256 minTokenAAmount;
  uint256 minTokenBAmount;
  uint256 tokenARequiredAllowance;
  uint256 tokenBRequiredAllowance;
}
```

## MaverickConnector

### mav

```solidity
address mav
```

### veMav

```solidity
address veMav
```

### maverickRouter

```solidity
address maverickRouter
```

### positionInspector

```solidity
contract IPositionInspector positionInspector
```

### MAVERICK_LP

```solidity
uint256 MAVERICK_LP
```

### constructor

```solidity
constructor(address _mav, address _veMav, address mr, address pi, struct BaseConnectorCP baseCP) public
```

### receive

```solidity
receive() external payable
```

### stake

```solidity
function stake(uint256 amount, uint256 duration, bool doDelegation) external
```

### unstake

```solidity
function unstake(uint256 lockupId) external
```

### addLiquidityInMaverickPool

```solidity
function addLiquidityInMaverickPool(struct MavericAddLiquidityParams p) external
```

### removeLiquidityFromMaverickPool

```solidity
function removeLiquidityFromMaverickPool(contract IMaverickPool pool, uint256 tokenId, struct RemoveLiquidityParams[] params, uint256 minTokenAAmount, uint256 minTokenBAmount) external
```

### claimBoostedPositionRewards

```solidity
function claimBoostedPositionRewards(contract IMaverickReward rewardContract) external
```

### onERC721Received

```solidity
function onERC721Received(address, address, uint256, bytes) public virtual returns (bytes4)
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256 id, bytes data) public view returns (address[])
```

## MorphoBlueConnector

### morphoBlue

```solidity
contract IMorpho morphoBlue
```

### ORACLE_PRICE_SCALE

```solidity
uint256 ORACLE_PRICE_SCALE
```

### MORPHO_POSITION_ID

```solidity
uint256 MORPHO_POSITION_ID
```

### constructor

```solidity
constructor(address MB, struct BaseConnectorCP baseCP) public
```

### supply

```solidity
function supply(uint256 amount, Id id, bool sOrC) external
```

### withdraw

```solidity
function withdraw(uint256 amount, Id id, bool sOrC) external
```

### borrow

```solidity
function borrow(uint256 amount, Id id) external
```

### repay

```solidity
function repay(uint256 amount, Id id) public
```

### getHealthFactor

```solidity
function getHealthFactor(Id _id, struct Market _market) public view returns (uint256)
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

### convertCToL

```solidity
function convertCToL(uint256 amount, address marketOracle, address collateral) public view returns (uint256)
```

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256, bytes data) public view returns (address[])
```

## PancakeswapConnector

### masterchef

```solidity
contract IMasterchefV3 masterchef
```

### constructor

```solidity
constructor(address MC, address _positionManager, address _factory, struct BaseConnectorCP baseConnectorParams) public
```

### sendPositionToMasterChef

```solidity
function sendPositionToMasterChef(uint256 tokenId) external
```

### updatePosition

```solidity
function updatePosition(uint256 tokenId) public
```

### withdraw

```solidity
function withdraw(uint256 tokenId) public
```

## PendleConnector

### pendleMarketDepositHelper

```solidity
contract IPendleMarketDepositHelper pendleMarketDepositHelper
```

### pendleRouter

```solidity
contract IPAllActionV3 pendleRouter
```

### staticRouter

```solidity
contract IPendleStaticRouter staticRouter
```

### PENDLE_POSITION_ID

```solidity
uint256 PENDLE_POSITION_ID
```

### InsufficientSyOut

```solidity
error InsufficientSyOut(uint256 netSyOut, uint256 minSY)
```

throws when the output of a swap operation is insufficient

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| netSyOut | uint256 | The actual amount of SY tokens received from the swap |
| minSY | uint256 | The minimum acceptable amount of SY tokens specified for the swap |

### constructor

```solidity
constructor(address _pendleMarketDepositHelper, address _pendleRouter, address SR, struct BaseConnectorCP baseCP) public
```

Initializes a new PendleConnector contract with references to other contracts for interaction

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _pendleMarketDepositHelper | address | Address of the Pendle Market Deposit Helper contract |
| _pendleRouter | address | Address of the Pendle Router contract for swap operations |
| SR | address | Address of the Pendle Static Router contract for static calls |
| baseCP | struct BaseConnectorCP | Parameters required for the base connector initialization |

### supply

```solidity
function supply(address market, uint256 amount) external
```

Supplies an amount of asset into the specified market

_Only the manager can call this function
is deposits the asset into SY and mint SY token_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | address | Address of the market where the asset is to be supplied |
| amount | uint256 | Amount of the asset to supply |

### mintPTAndYT

```solidity
function mintPTAndYT(address market, uint256 syAmount) external
```

Mints Principal Tokens (PT) and Yield Tokens (YT) in the specified market using Standardized Yield (SY) tokens

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | address | Address of the market for PT and YT minting |
| syAmount | uint256 | Amount of SY tokens to use for minting |

### depositIntoMarket

```solidity
function depositIntoMarket(contract IPMarket market, uint256 SYamount, uint256 PTamount) external
```

Deposits Standardized Yield (SY) and Principal Tokens (PT) into the specified market

_minting LP token
skim allows us to get the surplus tokens_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | contract IPMarket | Market where SY and PT are to be deposited |
| SYamount | uint256 | Amount of SY tokens to deposit |
| PTamount | uint256 | Amount of PT tokens to deposit |

### depositIntoPenpie

```solidity
function depositIntoPenpie(address _market, uint256 _amount) public
```

Deposits the LP into the Penpie pool

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _market | address | Address of the market |
| _amount | uint256 | Amount to deposit |

### withdrawFromPenpie

```solidity
function withdrawFromPenpie(address _market, uint256 _amount) public
```

Withdraws from the Penpie pool

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _market | address | Address of the market |
| _amount | uint256 | Amount to withdraw |

### swapYTForPT

```solidity
function swapYTForPT(address market, uint256 exactYTIn, uint256 min, struct ApproxParams guess) external
```

Swaps Yield Tokens (YT) for Principal Tokens (PT) in a specified market

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | address | Address of the market |
| exactYTIn | uint256 | Amount of YT to swap |
| min | uint256 | Minimum amount of PT to receive |
| guess | struct ApproxParams | Approximation parameters for the swap |

### swapYTForSY

```solidity
function swapYTForSY(address market, uint256 exactYTIn, uint256 min, struct LimitOrderData orderData) public
```

Swaps Yield Tokens (YT) for Standardized Yield (SY) tokens in a specified market

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | address | Address of the market |
| exactYTIn | uint256 | Amount of YT to swap |
| min | uint256 | Minimum amount of SY to receive |
| orderData | struct LimitOrderData | Specifies the type of swap to perform |

### swapExactPTForSY

```solidity
function swapExactPTForSY(contract IPMarket market, uint256 exactPTIn, bytes swapData, uint256 minSY) external
```

Swaps Principal Tokens (PT) for Standardized Yield (SY) tokens in a specified market

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | contract IPMarket | Market where the swap is to occur |
| exactPTIn | uint256 | Amount of PT to swap |
| swapData | bytes | Additional data for the swap |
| minSY | uint256 | Minimum amount of SY to receive |

### burnLP

```solidity
function burnLP(contract IPMarket market, uint256 amount) external
```

Burns LP tokens in the specified market and withdraws the underlying assets

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | contract IPMarket | Market from which LP tokens are to be burned |
| amount | uint256 | Amount of LP tokens to burn |

### decreasePosition

```solidity
function decreasePosition(contract IPMarket market, uint256 _amount, bool closePosition) external
```

withdraws some amount from the position in the specified market

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | contract IPMarket | Market from which the position is to be decreased |
| _amount | uint256 | Amount by which the position is to be decreased |
| closePosition | bool | Flag indicating whether to close the position entirely |

### claimRewards

```solidity
function claimRewards(contract IPMarket market) external
```

Claims rewards from the specified market

_reward tokens must be updated in the registry after claiming
the reward tokens may vary from market to market_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | contract IPMarket | Market from which rewards are to be claimed |

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

Retrieves the Total Value Locked (TVL) for a specific holding position in the given base token

_The TVL is calculated by calculating the value of YT, LP and PT in terms of SY and then converting to the base token_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| p | struct HoldingPI | Struct containing holding position information |
| base | address | Address of the base token for TVL calculation |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| tvl | uint256 | The total value locked of the position |

### getYTValue

```solidity
function getYTValue(address market, uint256 balance) public view returns (uint256)
```

Calculates the value of Yield Tokens (YT) in terms of Standardized Yield (SY) tokens

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | address | Address of the market where YT are traded |
| balance | uint256 | Amount of YT tokens to evaluate |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The equivalent SY token value of the specified YT balance |

### isMarketEmpty

```solidity
function isMarketEmpty(contract IPMarket market) public view returns (bool)
```

Checks whether all positions (SY, PT, YT, and LP (in the pool and in penpie)) in a given market are empty for this contract

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | contract IPMarket | Market to check for any remaining positions |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | True if all positions are empty, false otherwise |

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256, bytes data) public view returns (address[])
```

## PrismaConnector

### PRISMA_POSITION_ID

```solidity
uint256 PRISMA_POSITION_ID
```

### constructor

```solidity
constructor(struct BaseConnectorCP baseConnectorParams) public
```

Constructs the PrismaConnector contract with initial setup

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| baseConnectorParams | struct BaseConnectorCP | Struct containing essential parameters for the base connector |

### approveZap

```solidity
function approveZap(contract IStakeNTroveZap zap, address tm, bool approve) public
```

Approves or revokes the zap contract to operate on behalf of the borrower operations contract

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| zap | contract IStakeNTroveZap | The address of the StakeNTroveZap contract |
| tm | address | The address of the TroveManager contract |
| approve | bool | True to approve, false to revoke |

### openTrove

```solidity
function openTrove(contract IStakeNTroveZap zap, address tm, uint256 maxFee, uint256 dAmount, uint256 bAmount) public
```

Opens a new trove with specified parameters using the zap contract

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| zap | contract IStakeNTroveZap | The address of the StakeNTroveZap contract used for interaction |
| tm | address | The address of the TroveManager contract |
| maxFee | uint256 | Maximum fee for the operation |
| dAmount | uint256 | The amount of collateral to deposit |
| bAmount | uint256 | The amount of borrowing |

### addColl

```solidity
function addColl(contract IStakeNTroveZap zapContract, address tm, uint256 amountIn) public
```

Adds collateral to an existing trove

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| zapContract | contract IStakeNTroveZap | The address of the StakeNTroveZap contract |
| tm | address | The address of the TroveManager |
| amountIn | uint256 | The amount of collateral to add |

### adjustTrove

```solidity
function adjustTrove(contract IStakeNTroveZap zapContract, address tm, uint256 mFee, uint256 wAmount, uint256 bAmount, bool isBorrowing) public
```

Adjusts an existing trove, allowing for collateral withdrawal, debt repayment, or borrowing

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| zapContract | contract IStakeNTroveZap | The address of the StakeNTroveZap contract |
| tm | address | The address of the TroveManager |
| mFee | uint256 | The maximum fee for the operation |
| wAmount | uint256 | The amount of collateral to withdraw |
| bAmount | uint256 | The amount of debt to repay or borrow |
| isBorrowing | bool | Set to true if the operation involves borrowing |

### closeTrove

```solidity
function closeTrove(contract IStakeNTroveZap zapContract, address troveManager) public
```

Closes an existing trove

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| zapContract | contract IStakeNTroveZap | The address of the StakeNTroveZap contract |
| troveManager | address | The address of the TroveManager |

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

Calculates the Total Value Locked (TVL) of a given position in the specified base token

_The TVL is calculated as the value of the collateral minus the value of the debt_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| p | struct HoldingPI | The holding position information |
| base | address | The address of the base currency to calculate the TVL in |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| tvl | uint256 | The TVL of the position in the base currency |

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256, bytes data) public view returns (address[])
```

Returns the addresses of the underlying tokens involved in a position

_the tokens are returned in the order of collateral, debt token_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
|  | uint256 |  |
| data | bytes | Additional data required to identify the position |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address[] | An array of addresses of the underlying tokens |

## SiloConnector

### siloRepository

```solidity
contract ISiloRepository siloRepository
```

### SILO_LP_ID

```solidity
uint256 SILO_LP_ID
```

### constructor

```solidity
constructor(address SR, struct BaseConnectorCP baseConnectorParams) public
```

### deposit

```solidity
function deposit(address siloToken, address dToken, uint256 amount, bool oC) external
```

### withdraw

```solidity
function withdraw(address siloToken, address wToken, uint256 amount, bool oC, bool closePosition) external
```

### getData

```solidity
function getData(address siloToken) public view returns (uint256 userLTV, uint256 LiquidationThreshold, bool isSolvent)
```

### borrow

```solidity
function borrow(address siloToken, address bToken, uint256 amount) external
```

### repay

```solidity
function repay(address siloToken, address rToken, uint256 amount) external
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

### isSiloEmpty

```solidity
function isSiloEmpty(contract ISilo silo) public view returns (bool)
```

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256, bytes data) public view returns (address[])
```

## StargateRequest

```solidity
struct StargateRequest {
  uint256 poolId;
  uint256 routerAmount;
  uint256 LPStakingAmount;
}
```

## StargateConnector

### LPStaking

```solidity
contract IStargateLPStaking LPStaking
```

### stargateRouter

```solidity
contract IStargateRouter stargateRouter
```

### rewardToken

```solidity
address rewardToken
```

### STARGATE_LP_POSITION_TYPE

```solidity
uint256 STARGATE_LP_POSITION_TYPE
```

### constructor

```solidity
constructor(address lpStacking, address _stargateRouter, struct BaseConnectorCP baseConnectorParams) public
```

### depositIntoStargatePool

```solidity
function depositIntoStargatePool(struct StargateRequest depositRequest) external
```

### withdrawFromStargatePool

```solidity
function withdrawFromStargatePool(struct StargateRequest withdrawRequest) external
```

### claimStargateRewards

```solidity
function claimStargateRewards(uint256 poolId) external
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256, bytes data) public view returns (address[])
```

## UNIv3Connector

Connector for UNIv3 protocol

### positionManager

```solidity
contract INonfungiblePositionManager positionManager
```

### factory

```solidity
contract IUniswapV3Factory factory
```

### UNI_LP_POSITION_TYPE

```solidity
uint256 UNI_LP_POSITION_TYPE
```

### constructor

```solidity
constructor(address _positionManager, address _factory, struct BaseConnectorCP baseConnectorParams) public
```

### openPosition

```solidity
function openPosition(struct MintParams p) external returns (uint256 tokenId)
```

### decreasePosition

```solidity
function decreasePosition(struct DecreaseLiquidityParams p) external
```

### increasePosition

```solidity
function increasePosition(struct IncreaseLiquidityParams p) external
```

### collectAllFees

```solidity
function collectAllFees(uint256[] tokenIds) public
```

Collects the fees associated with provided liquidity

_The contract must hold the erc721 token before it can collect fees_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIds | uint256[] | The tokenIDs of the positions to collect fees from |

### getCurrentLiquidity

```solidity
function getCurrentLiquidity(uint256 tokenId) public view returns (uint128, address, address)
```

### _collectFees

```solidity
function _collectFees(uint256 tokenId) internal returns (uint256 amount0, uint256 amount1)
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI p, address base) public view returns (uint256 tvl)
```

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256, bytes data) public pure returns (address[])
```

## IPool

Defines the basic interface for an Aave Pool.

### supply

```solidity
function supply(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external
```

Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
- E.g. User supplies 100 USDC and gets in return 100 aUSDC

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The address of the underlying asset to supply |
| amount | uint256 | The amount to be supplied |
| onBehalfOf | address | The address that will receive the aTokens, same as msg.sender if the user   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens   is a different wallet |
| referralCode | uint16 | Code used to register the integrator originating the operation, for potential rewards.   0 if the action is executed directly by the user, without any middle-man |

### withdraw

```solidity
function withdraw(address asset, uint256 amount, address to) external returns (uint256)
```

Withdraws an `amount` of underlying asset from the reserve, burning the equivalent aTokens owned
E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The address of the underlying asset to withdraw |
| amount | uint256 | The underlying amount to be withdrawn   - Send the value type(uint256).max in order to withdraw the whole aToken balance |
| to | address | The address that will receive the underlying, same as msg.sender if the user   wants to receive it on his own wallet, or a different address if the beneficiary is a   different wallet |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The final amount withdrawn |

### borrow

```solidity
function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf) external
```

Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
already supplied enough collateral, or he was given enough allowance by a credit delegator on the
corresponding debt token (StableDebtToken or VariableDebtToken)
- E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
  and 100 stable/variable debt tokens, depending on the `interestRateMode`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The address of the underlying asset to borrow |
| amount | uint256 | The amount to be borrowed |
| interestRateMode | uint256 | The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable |
| referralCode | uint16 | The code used to register the integrator originating the operation, for potential rewards.   0 if the action is executed directly by the user, without any middle-man |
| onBehalfOf | address | The address of the user who will receive the debt. Should be the address of the borrower itself calling the function if he wants to borrow against his own collateral, or the address of the credit delegator if he has been given credit delegation allowance |

### repay

```solidity
function repay(address asset, uint256 amount, uint256 interestRateMode, address onBehalfOf) external returns (uint256)
```

Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
- E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The address of the borrowed underlying asset previously borrowed |
| amount | uint256 | The amount to repay - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode` |
| interestRateMode | uint256 | The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable |
| onBehalfOf | address | The address of the user who will get his debt reduced/removed. Should be the address of the user calling the function if he wants to reduce/remove his own debt, or the address of any other other borrower whose debt should be removed |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The final amount repaid |

### repayWithATokens

```solidity
function repayWithATokens(address asset, uint256 amount, uint256 interestRateMode) external returns (uint256)
```

Repays a borrowed `amount` on a specific reserve using the reserve aTokens, burning the
equivalent debt tokens
- E.g. User repays 100 USDC using 100 aUSDC, burning 100 variable/stable debt tokens

_Passing uint256.max as amount will clean up any residual aToken dust balance, if the user aToken
balance is not enough to cover the whole debt_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The address of the borrowed underlying asset previously borrowed |
| amount | uint256 | The amount to repay - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode` |
| interestRateMode | uint256 | The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The final amount repaid |

### getUserAccountData

```solidity
function getUserAccountData(address user) external view returns (uint256 totalCollateralBase, uint256 totalDebtBase, uint256 availableBorrowsBase, uint256 currentLiquidationThreshold, uint256 ltv, uint256 healthFactor)
```

Returns the user account data across all the reserves

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| user | address | The address of the user |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| totalCollateralBase | uint256 | The total collateral of the user in the base currency used by the price feed |
| totalDebtBase | uint256 | The total debt of the user in the base currency used by the price feed |
| availableBorrowsBase | uint256 | The borrowing power left of the user in the base currency used by the price feed |
| currentLiquidationThreshold | uint256 | The liquidation threshold of the user |
| ltv | uint256 | The loan to value of The user |
| healthFactor | uint256 | The current health factor of the user |

### deposit

```solidity
function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external
```

Supplies an `amount` of underlying asset into the reserve, receiving in return overlying aTokens.
- E.g. User supplies 100 USDC and gets in return 100 aUSDC

_Deprecated: Use the `supply` function instead_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The address of the underlying asset to supply |
| amount | uint256 | The amount to be supplied |
| onBehalfOf | address | The address that will receive the aTokens, same as msg.sender if the user   wants to receive them on his own wallet, or a different address if the beneficiary of aTokens   is a different wallet |
| referralCode | uint16 | Code used to register the integrator originating the operation, for potential rewards.   0 if the action is executed directly by the user, without any middle-man |

## IPool

### metadata

```solidity
function metadata() external view returns (uint256 dec0, uint256 dec1, uint256 r0, uint256 r1, bool st, address t0, address t1)
```

Returns the decimal (dec), reserves (r), stable (st), and tokens (t) of token0 and token1

### claimFees

```solidity
function claimFees() external returns (uint256, uint256)
```

Claim accumulated but unclaimed fees (claimable0 and claimable1)

### tokens

```solidity
function tokens() external view returns (address, address)
```

Returns [token0, token1]

### token0

```solidity
function token0() external view returns (address)
```

Address of token in the pool with the lower address value

### token1

```solidity
function token1() external view returns (address)
```

Address of token in the poool with the higher address value

### poolFees

```solidity
function poolFees() external view returns (address)
```

Address of linked PoolFees.sol

### factory

```solidity
function factory() external view returns (address)
```

Address of PoolFactory that created this contract

### reserve0

```solidity
function reserve0() external view returns (uint256)
```

Amount of token0 in pool

### reserve1

```solidity
function reserve1() external view returns (uint256)
```

Amount of token1 in pool

### index0

```solidity
function index0() external view returns (uint256)
```

Accumulated fees of token0 (global)

### index1

```solidity
function index1() external view returns (uint256)
```

Accumulated fees of token1 (global)

### supplyIndex0

```solidity
function supplyIndex0(address) external view returns (uint256)
```

Get an LP's relative index0 to index0

### supplyIndex1

```solidity
function supplyIndex1(address) external view returns (uint256)
```

Get an LP's relative index1 to index1

### claimable0

```solidity
function claimable0(address) external view returns (uint256)
```

Amount of unclaimed, but claimable tokens from fees of token0 for an LP

### claimable1

```solidity
function claimable1(address) external view returns (uint256)
```

Amount of unclaimed, but claimable tokens from fees of token1 for an LP

### getK

```solidity
function getK() external returns (uint256)
```

Returns the value of K in the Pool, based on its reserves.

### setName

```solidity
function setName(string __name) external
```

Set pool name
        Only callable by Voter.emergencyCouncil()

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| __name | string | String of new name |

### setSymbol

```solidity
function setSymbol(string __symbol) external
```

Set pool symbol
        Only callable by Voter.emergencyCouncil()

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| __symbol | string | String of new symbol |

### observationLength

```solidity
function observationLength() external view returns (uint256)
```

Get the number of observations recorded

### stable

```solidity
function stable() external view returns (bool)
```

True if pool is stable, false if volatile

### currentCumulativePrices

```solidity
function currentCumulativePrices() external view returns (uint256 reserve0Cumulative, uint256 reserve1Cumulative, uint256 blockTimestamp)
```

Produces the cumulative price using counterfactuals to save gas and avoid a call to sync.

### quote

```solidity
function quote(address tokenIn, uint256 amountIn, uint256 granularity) external view returns (uint256 amountOut)
```

Provides twap price with user configured granularity, up to the full window size

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIn | address | . |
| amountIn | uint256 | . |
| granularity | uint256 | . |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountOut | uint256 | . |

### prices

```solidity
function prices(address tokenIn, uint256 amountIn, uint256 points) external view returns (uint256[])
```

Returns a memory set of TWAP prices
        Same as calling sample(tokenIn, amountIn, points, 1)

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIn | address | . |
| amountIn | uint256 | . |
| points | uint256 | Number of points to return |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256[] | Array of TWAP prices |

### sample

```solidity
function sample(address tokenIn, uint256 amountIn, uint256 points, uint256 window) external view returns (uint256[])
```

Same as prices with with an additional window argument.
        Window = 2 means 2 * 30min (or 1 hr) between observations

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIn | address | . |
| amountIn | uint256 | . |
| points | uint256 | . |
| window | uint256 | . |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256[] | Array of TWAP prices |

### swap

```solidity
function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes data) external
```

This low-level function should be called from a contract which performs important safety checks

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0Out | uint256 | Amount of token0 to send to `to` |
| amount1Out | uint256 | Amount of token1 to send to `to` |
| to | address | Address to recieve the swapped output |
| data | bytes | Additional calldata for flashloans |

### burn

```solidity
function burn(address to) external returns (uint256 amount0, uint256 amount1)
```

This low-level function should be called from a contract which performs important safety checks
        standard uniswap v2 implementation

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | Address to receive token0 and token1 from burning the pool token |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | uint256 | Amount of token0 returned |
| amount1 | uint256 | Amount of token1 returned |

### mint

```solidity
function mint(address to) external returns (uint256 liquidity)
```

This low-level function should be called by addLiquidity functions in Router.sol, which performs important safety checks
        standard uniswap v2 implementation

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | Address to receive the minted LP token |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| liquidity | uint256 | Amount of LP token minted |

### getReserves

```solidity
function getReserves() external view returns (uint256 _reserve0, uint256 _reserve1, uint256 _blockTimestampLast)
```

Update reserves and, on the first call per block, price accumulators

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| _reserve0 | uint256 | . |
| _reserve1 | uint256 | . |
| _blockTimestampLast | uint256 | . |

### getAmountOut

```solidity
function getAmountOut(uint256 amountIn, address tokenIn) external view returns (uint256)
```

Get the amount of tokenOut given the amount of tokenIn

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountIn | uint256 | Amount of token in |
| tokenIn | address | Address of token |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | Amount out |

### skim

```solidity
function skim(address to) external
```

Force balances to match reserves

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | Address to receive any skimmed rewards |

### sync

```solidity
function sync() external
```

Force reserves to match balances

### initialize

```solidity
function initialize(address _token0, address _token1, bool _stable) external
```

Called on pool creation by PoolFactory

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _token0 | address | Address of token0 |
| _token1 | address | Address of token1 |
| _stable | bool | True if stable, false if volatile |

## IBalancerPool

### getPoolId

```solidity
function getPoolId() external view returns (bytes32)
```

### getNormalizedWeights

```solidity
function getNormalizedWeights() external returns (uint256[])
```

### totalSupply

```solidity
function totalSupply() external returns (uint256)
```

## IRewardPool

### deposit

```solidity
function deposit(uint256 assets, address receiver) external returns (uint256 shares)
```

### withdrawAndUnwrap

```solidity
function withdrawAndUnwrap(uint256, bool) external returns (bool)
```

### convertToAssets

```solidity
function convertToAssets(uint256) external view returns (uint256)
```

### getReward

```solidity
function getReward() external
```

## IBalancerVault

### JoinKind

```solidity
enum JoinKind {
  INIT,
  EXACT_TOKENS_IN_FOR_BPT_OUT,
  TOKEN_IN_FOR_EXACT_BPT_OUT,
  ALL_TOKENS_IN_FOR_EXACT_BPT_OUT
}
```

### ExitKind

```solidity
enum ExitKind {
  EXACT_BPT_IN_FOR_ONE_TOKEN_OUT,
  EXACT_BPT_IN_FOR_TOKENS_OUT,
  BPT_IN_FOR_EXACT_TOKENS_OUT,
  MANAGEMENT_FEE_TOKENS_OUT
}
```

### JoinPoolRequest

```solidity
struct JoinPoolRequest {
  address[] assets;
  uint256[] maxAmountsIn;
  bytes userData;
  bool fromInternalBalance;
}
```

### ExitPoolRequest

```solidity
struct ExitPoolRequest {
  address[] assets;
  uint256[] minAmountsOut;
  bytes userData;
  bool toInternalBalance;
}
```

### getPoolTokens

```solidity
function getPoolTokens(bytes32 poolId) external view returns (address[] tokens, uint256[] balances, uint256 lastChangeBlock)
```

### joinPool

```solidity
function joinPool(bytes32 poolId, address sender, address recipient, struct IBalancerVault.JoinPoolRequest request) external payable
```

### exitPool

```solidity
function exitPool(bytes32 poolId, address sender, address payable recipient, struct IBalancerVault.ExitPoolRequest request) external
```

### getPool

```solidity
function getPool(bytes32 poolId) external view returns (address poolAddress)
```

## IComet

### AssetInfo

```solidity
struct AssetInfo {
  uint8 offset;
  address asset;
  address priceFeed;
  uint64 scale;
  uint64 borrowCollateralFactor;
  uint64 liquidateCollateralFactor;
  uint64 liquidationFactor;
  uint128 supplyCap;
}
```

### TotalsCollateral

```solidity
struct TotalsCollateral {
  uint128 totalSupplyAsset;
  uint128 _reserved;
}
```

### UserBasic

```solidity
struct UserBasic {
  int104 principal;
  uint64 baseTrackingIndex;
  uint64 baseTrackingAccrued;
  uint16 assetsIn;
}
```

### userBasic

```solidity
function userBasic(address user) external view returns (struct IComet.UserBasic)
```

### numAssets

```solidity
function numAssets() external view returns (uint8)
```

### getAssetInfo

```solidity
function getAssetInfo(uint8 i) external view returns (struct IComet.AssetInfo)
```

### userCollateral

```solidity
function userCollateral(address user, address asset) external view returns (uint128 collateral, uint128 reserves)
```

### baseToken

```solidity
function baseToken() external view returns (address)
```

The address of the base token contract

### baseTokenPriceFeed

```solidity
function baseTokenPriceFeed() external view returns (address)
```

The address of the price feed for the base token

### borrowBalanceOf

```solidity
function borrowBalanceOf(address account) external view returns (uint256)
```

Query the current negative base balance of an account or zero

_Note: uses updated interest indices to calculate_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | The account whose balance to query |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The present day base balance magnitude of the account, if negative |

### collateralBalanceOf

```solidity
function collateralBalanceOf(address account, address asset) external view returns (uint128)
```

Query the current collateral balance of an account

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | The account whose balance to query |
| asset | address | The collateral asset to check the balance for |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint128 | The collateral balance of the account |

### getAssetInfoByAddress

```solidity
function getAssetInfoByAddress(address asset) external view returns (struct IComet.AssetInfo)
```

_Determine index of asset that matches given address and return assetInfo_

### getPrice

```solidity
function getPrice(address priceFeed) external view returns (uint256)
```

Get the current price from a feed

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| priceFeed | address | The address of a price feed |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The price, scaled by `PRICE_SCALE` |

### baseScale

```solidity
function baseScale() external view returns (uint256)
```

### accrualDescaleFactor

```solidity
function accrualDescaleFactor() external view returns (uint256)
```

### totalBorrow

```solidity
function totalBorrow() external view returns (uint256)
```

Get the total amount of debt

_Note: uses updated interest indices to calculate_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The amount of debt |

### totalsCollateral

```solidity
function totalsCollateral(address asset) external view returns (struct IComet.TotalsCollateral)
```

Get the total amount of given token

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The collateral asset to check the total for |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct IComet.TotalsCollateral | The total collateral balance |

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

Get the total number of tokens in circulation

_Note: uses updated interest indices to calculate_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The supply of tokens |

### supply

```solidity
function supply(address asset, uint256 amount) external
```

Supply an amount of asset to the protocol

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The asset to supply |
| amount | uint256 | The quantity to supply |

### withdraw

```solidity
function withdraw(address asset, uint256 amount) external
```

Withdraw an amount of asset from the protocol

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The asset to withdraw |
| amount | uint256 | The quantity to withdraw |

## IRewards

### RewardOwed

```solidity
struct RewardOwed {
  address token;
  uint256 owed;
}
```

### RewardConfig

```solidity
struct RewardConfig {
  address token;
  uint64 rescaleFactor;
  bool shouldUpscale;
}
```

### getRewardOwed

```solidity
function getRewardOwed(address comet, address account) external returns (struct IRewards.RewardOwed)
```

Calculates the amount of a reward token owed to an account

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| comet | address | The protocol instance |
| account | address | The account to check rewards for |

### rewardConfig

```solidity
function rewardConfig(address comet) external view returns (struct IRewards.RewardConfig)
```

### claim

```solidity
function claim(address comet, address src, bool shouldAccrue) external
```

Claim rewards of token type from a comet instance to owner address

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| comet | address | The protocol instance |
| src | address | The owner to claim for |
| shouldAccrue | bool | Whether or not to call accrue first |

### Absurd

```solidity
error Absurd()
```

### AlreadyInitialized

```solidity
error AlreadyInitialized()
```

### BadAsset

```solidity
error BadAsset()
```

### BadDecimals

```solidity
error BadDecimals()
```

### BadDiscount

```solidity
error BadDiscount()
```

### BadMinimum

```solidity
error BadMinimum()
```

### BadPrice

```solidity
error BadPrice()
```

### BorrowTooSmall

```solidity
error BorrowTooSmall()
```

### BorrowCFTooLarge

```solidity
error BorrowCFTooLarge()
```

### InsufficientReserves

```solidity
error InsufficientReserves()
```

### LiquidateCFTooLarge

```solidity
error LiquidateCFTooLarge()
```

### NoSelfTransfer

```solidity
error NoSelfTransfer()
```

### NotCollateralized

```solidity
error NotCollateralized()
```

### NotForSale

```solidity
error NotForSale()
```

### NotLiquidatable

```solidity
error NotLiquidatable()
```

### Paused

```solidity
error Paused()
```

### SupplyCapExceeded

```solidity
error SupplyCapExceeded()
```

### TimestampTooLarge

```solidity
error TimestampTooLarge()
```

### TooManyAssets

```solidity
error TooManyAssets()
```

### TooMuchSlippage

```solidity
error TooMuchSlippage()
```

### TransferInFailed

```solidity
error TransferInFailed()
```

### TransferOutFailed

```solidity
error TransferOutFailed()
```

### Unauthorized

```solidity
error Unauthorized()
```

## IBooster

### PoolInfo

```solidity
struct PoolInfo {
  address lptoken;
  address token;
  address gauge;
  address crvRewards;
  address stash;
  bool shutdown;
}
```

### owner

```solidity
function owner() external view returns (address)
```

### feeToken

```solidity
function feeToken() external view returns (address)
```

### feeDistro

```solidity
function feeDistro() external view returns (address)
```

### lockFees

```solidity
function lockFees() external view returns (address)
```

### stakerRewards

```solidity
function stakerRewards() external view returns (address)
```

### lockRewards

```solidity
function lockRewards() external view returns (address)
```

### setVoteDelegate

```solidity
function setVoteDelegate(address _voteDelegate) external
```

### vote

```solidity
function vote(uint256 _voteId, address _votingAddress, bool _support) external returns (bool)
```

### voteGaugeWeight

```solidity
function voteGaugeWeight(address[] _gauge, uint256[] _weight) external returns (bool)
```

### poolInfo

```solidity
function poolInfo(uint256 _pid) external view returns (address _lptoken, address _token, address _gauge, address _crvRewards, address _stash, bool _shutdown)
```

### earmarkRewards

```solidity
function earmarkRewards(uint256 _pid) external returns (bool)
```

### earmarkFees

```solidity
function earmarkFees() external returns (bool)
```

### isShutdown

```solidity
function isShutdown() external view returns (bool)
```

### poolLength

```solidity
function poolLength() external view returns (uint256)
```

### deposit

```solidity
function deposit(uint256 _pid, uint256 _amount, bool _stake) external returns (bool)
```

### withdraw

```solidity
function withdraw(uint256 _pid, uint256 _amount) external returns (bool)
```

## IConvexBasicRewards

### EarnedData

```solidity
struct EarnedData {
  address token;
  uint256 amount;
}
```

### stakeFor

```solidity
function stakeFor(address, uint256) external returns (bool)
```

### balanceOf

```solidity
function balanceOf(address) external view returns (uint256)
```

### earned

```solidity
function earned(address) external view returns (uint256)
```

### getReward

```solidity
function getReward(address _account, bool _claimExtras) external returns (bool)
```

### withdrawAll

```solidity
function withdrawAll(bool) external returns (bool)
```

### withdraw

```solidity
function withdraw(uint256, bool) external returns (bool)
```

### withdrawAndUnwrap

```solidity
function withdrawAndUnwrap(uint256, bool) external returns (bool)
```

### getReward

```solidity
function getReward() external returns (bool)
```

### stake

```solidity
function stake(uint256) external returns (bool)
```

## ICurveSwap

### remove_liquidity_one_coin

```solidity
function remove_liquidity_one_coin(uint256 token_amount, int128 i, uint256 min_amount) external
```

### calc_withdraw_one_coin

```solidity
function calc_withdraw_one_coin(uint256 tokenAmount, int128 i) external view returns (uint256)
```

### coins

```solidity
function coins(uint256 arg0) external view returns (address)
```

### add_liquidity

```solidity
function add_liquidity(uint256[2] amounts, uint256 min_mint_amount) external payable
```

### add_liquidity

```solidity
function add_liquidity(uint256[2] amounts, uint256 min_mint_amount, bool _use_underlying) external
```

### add_liquidity

```solidity
function add_liquidity(address _pool, uint256[2] amounts, uint256 min_mint_amount) external
```

### add_liquidity

```solidity
function add_liquidity(uint256[3] amounts, uint256 min_mint_amount) external payable
```

### add_liquidity

```solidity
function add_liquidity(uint256[3] amounts, uint256 min_mint_amount, bool _use_underlying) external payable
```

### add_liquidity

```solidity
function add_liquidity(address _pool, uint256[3] amounts, uint256 min_mint_amount) external payable
```

### add_liquidity

```solidity
function add_liquidity(uint256[4] amounts, uint256 min_mint_amount) external payable
```

### add_liquidity

```solidity
function add_liquidity(address _pool, uint256[4] amounts, uint256 min_mint_amount) external payable
```

### add_liquidity

```solidity
function add_liquidity(uint256[5] amounts, uint256 min_mint_amount) external payable
```

### add_liquidity

```solidity
function add_liquidity(address _pool, uint256[5] amounts, uint256 min_mint_amount) external payable
```

### add_liquidity

```solidity
function add_liquidity(uint256[6] amounts, uint256 min_mint_amount) external payable
```

### add_liquidity

```solidity
function add_liquidity(address _pool, uint256[6] amounts, uint256 min_mint_amount) external payable
```

### exchange

```solidity
function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external
```

## IRewardsGauge

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

### claimable_reward

```solidity
function claimable_reward(address _addr, address _token) external view returns (uint256)
```

### claim_rewards

```solidity
function claim_rewards(address _addr) external
```

### deposit

```solidity
function deposit(uint256 _value) external
```

### withdraw

```solidity
function withdraw(uint256 _value) external
```

### reward_contract

```solidity
function reward_contract() external view returns (address)
```

## IFraxPair

### ExchangeRateInfo

```solidity
struct ExchangeRateInfo {
  uint32 lastTimestamp;
  uint224 exchangeRate;
}
```

### addCollateral

```solidity
function addCollateral(uint256 _collateralAmount, address _borrower) external
```

### addInterest

```solidity
function addInterest() external returns (uint256 _interestEarned, uint256 _feesAmount, uint256 _feesShare, uint64 _newRate)
```

### asset

```solidity
function asset() external view returns (address)
```

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

### borrowAsset

```solidity
function borrowAsset(uint256 _borrowAmount, uint256 _collateralAmount, address _receiver) external returns (uint256 _shares)
```

### changeFee

```solidity
function changeFee(uint32 _newFee) external
```

### cleanLiquidationFee

```solidity
function cleanLiquidationFee() external view returns (uint256)
```

### collateralContract

```solidity
function collateralContract() external view returns (address)
```

### currentRateInfo

```solidity
function currentRateInfo() external view returns (uint64 lastBlock, uint64 feeToProtocolRate, uint64 lastTimestamp, uint64 ratePerSec)
```

### removeCollateral

```solidity
function removeCollateral(uint256 _collateralAmount, address _receiver) external
```

### repayAsset

```solidity
function repayAsset(uint256 _shares, address _borrower) external returns (uint256 _amountToRepay)
```

### repayAssetWithCollateral

```solidity
function repayAssetWithCollateral(address _swapperAddress, uint256 _collateralToSwap, uint256 _amountAssetOutMin, address[] _path) external returns (uint256 _amountAssetOut)
```

### toAssetAmount

```solidity
function toAssetAmount(uint256 _shares, bool _roundUp) external view returns (uint256)
```

### toBorrowAmount

```solidity
function toBorrowAmount(uint256 _shares, bool _roundUp, bool _previewInterest) external view returns (uint256 _amount)
```

### toBorrowAmount

```solidity
function toBorrowAmount(uint256 _shares, bool _roundUp) external view returns (uint256)
```

### toBorrowShares

```solidity
function toBorrowShares(uint256 _amount, bool _roundUp, bool _previewInterest) external view returns (uint256 _shares)
```

### userBorrowShares

```solidity
function userBorrowShares(address) external view returns (uint256)
```

### userCollateralBalance

```solidity
function userCollateralBalance(address) external view returns (uint256)
```

### exchangeRateInfo

```solidity
function exchangeRateInfo() external view returns (struct IFraxPair.ExchangeRateInfo exchangeRateInfo)
```

### getConstants

```solidity
function getConstants() external view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
```

### maxLTV

```solidity
function maxLTV() external view returns (uint256 maxLTV)
```

## AllowanceAction

```solidity
enum AllowanceAction {
  FORBID,
  ALLOW
}
```

## CollateralToken

Struct with collateral token parameters

### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct CollateralToken {
  address token;
  uint16 liquidationThreshold;
}
```

## CreditManagerOpts

Struct with credit manager configuration parameters

### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct CreditManagerOpts {
  uint128 minDebt;
  uint128 maxDebt;
  struct CollateralToken[] collateralTokens;
  address degenNFT;
  bool expirable;
  string name;
}
```

## ICreditConfiguratorV3Events

### AddCollateralToken

```solidity
event AddCollateralToken(address token)
```

Emitted when a token is made recognizable as collateral in the credit manager

### SetTokenLiquidationThreshold

```solidity
event SetTokenLiquidationThreshold(address token, uint16 liquidationThreshold)
```

Emitted when a new collateral token liquidation threshold is set

### ScheduleTokenLiquidationThresholdRamp

```solidity
event ScheduleTokenLiquidationThresholdRamp(address token, uint16 liquidationThresholdInitial, uint16 liquidationThresholdFinal, uint40 timestampRampStart, uint40 timestampRampEnd)
```

Emitted when a collateral token liquidation threshold ramping is scheduled

### ForbidToken

```solidity
event ForbidToken(address token)
```

Emitted when a collateral token is forbidden

### AllowToken

```solidity
event AllowToken(address token)
```

Emitted when a previously forbidden collateral token is allowed

### QuoteToken

```solidity
event QuoteToken(address token)
```

Emitted when a token is made quoted

### AllowAdapter

```solidity
event AllowAdapter(address targetContract, address adapter)
```

Emitted when a new adapter and its target contract are allowed in the credit manager

### ForbidAdapter

```solidity
event ForbidAdapter(address targetContract, address adapter)
```

Emitted when adapter and its target contract are forbidden in the credit manager

### SetMaxEnabledTokens

```solidity
event SetMaxEnabledTokens(uint8 maxEnabledTokens)
```

Emitted when a new maximum number of enabled tokens is set in the credit manager

### UpdateFees

```solidity
event UpdateFees(uint16 feeInterest, uint16 feeLiquidation, uint16 liquidationPremium, uint16 feeLiquidationExpired, uint16 liquidationPremiumExpired)
```

Emitted when new fee parameters are set in the credit manager

### SetPriceOracle

```solidity
event SetPriceOracle(address priceOracle)
```

Emitted when a new price oracle is set in the credit manager

### SetBotList

```solidity
event SetBotList(address botList)
```

Emitted when a new bot list is set in the credit facade

### SetCreditFacade

```solidity
event SetCreditFacade(address creditFacade)
```

Emitted when a new facade is connected to the credit manager

### CreditConfiguratorUpgraded

```solidity
event CreditConfiguratorUpgraded(address creditConfigurator)
```

Emitted when credit manager's configurator contract is upgraded

### SetBorrowingLimits

```solidity
event SetBorrowingLimits(uint256 minDebt, uint256 maxDebt)
```

Emitted when new debt principal limits are set

### SetMaxDebtPerBlockMultiplier

```solidity
event SetMaxDebtPerBlockMultiplier(uint8 maxDebtPerBlockMultiplier)
```

Emitted when a new max debt per block multiplier is set

### SetMaxCumulativeLoss

```solidity
event SetMaxCumulativeLoss(uint128 maxCumulativeLoss)
```

Emitted when a new max cumulative loss is set

### ResetCumulativeLoss

```solidity
event ResetCumulativeLoss()
```

Emitted when cumulative loss is reset to zero in the credit facade

### SetExpirationDate

```solidity
event SetExpirationDate(uint40 expirationDate)
```

Emitted when a new expiration timestamp is set in the credit facade

### AddEmergencyLiquidator

```solidity
event AddEmergencyLiquidator(address liquidator)
```

Emitted when an address is added to the list of emergency liquidators

### RemoveEmergencyLiquidator

```solidity
event RemoveEmergencyLiquidator(address liquidator)
```

Emitted when an address is removed from the list of emergency liquidators

## ICreditConfiguratorV3

### addressProvider

```solidity
function addressProvider() external view returns (address)
```

### creditManager

```solidity
function creditManager() external view returns (address)
```

### creditFacade

```solidity
function creditFacade() external view returns (address)
```

### underlying

```solidity
function underlying() external view returns (address)
```

### addCollateralToken

```solidity
function addCollateralToken(address token, uint16 liquidationThreshold) external
```

### setLiquidationThreshold

```solidity
function setLiquidationThreshold(address token, uint16 liquidationThreshold) external
```

### rampLiquidationThreshold

```solidity
function rampLiquidationThreshold(address token, uint16 liquidationThresholdFinal, uint40 rampStart, uint24 rampDuration) external
```

### forbidToken

```solidity
function forbidToken(address token) external
```

### allowToken

```solidity
function allowToken(address token) external
```

### makeTokenQuoted

```solidity
function makeTokenQuoted(address token) external
```

### allowedAdapters

```solidity
function allowedAdapters() external view returns (address[])
```

### allowAdapter

```solidity
function allowAdapter(address adapter) external
```

### forbidAdapter

```solidity
function forbidAdapter(address adapter) external
```

### setFees

```solidity
function setFees(uint16 feeInterest, uint16 feeLiquidation, uint16 liquidationPremium, uint16 feeLiquidationExpired, uint16 liquidationPremiumExpired) external
```

### setMaxEnabledTokens

```solidity
function setMaxEnabledTokens(uint8 newMaxEnabledTokens) external
```

### setPriceOracle

```solidity
function setPriceOracle(uint256 newVersion) external
```

### setBotList

```solidity
function setBotList(uint256 newVersion) external
```

### setCreditFacade

```solidity
function setCreditFacade(address newCreditFacade, bool migrateParams) external
```

### upgradeCreditConfigurator

```solidity
function upgradeCreditConfigurator(address newCreditConfigurator) external
```

### setMinDebtLimit

```solidity
function setMinDebtLimit(uint128 newMinDebt) external
```

### setMaxDebtLimit

```solidity
function setMaxDebtLimit(uint128 newMaxDebt) external
```

### setMaxDebtPerBlockMultiplier

```solidity
function setMaxDebtPerBlockMultiplier(uint8 newMaxDebtLimitPerBlockMultiplier) external
```

### forbidBorrowing

```solidity
function forbidBorrowing() external
```

### setMaxCumulativeLoss

```solidity
function setMaxCumulativeLoss(uint128 newMaxCumulativeLoss) external
```

### resetCumulativeLoss

```solidity
function resetCumulativeLoss() external
```

### setExpirationDate

```solidity
function setExpirationDate(uint40 newExpirationDate) external
```

### emergencyLiquidators

```solidity
function emergencyLiquidators() external view returns (address[])
```

### addEmergencyLiquidator

```solidity
function addEmergencyLiquidator(address liquidator) external
```

### removeEmergencyLiquidator

```solidity
function removeEmergencyLiquidator(address liquidator) external
```

## DebtLimits

Debt limits packed into a single slot

### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct DebtLimits {
  uint128 minDebt;
  uint128 maxDebt;
}
```

## CumulativeLossParams

Info on bad debt liquidation losses packed into a single slot

### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct CumulativeLossParams {
  uint128 currentCumulativeLoss;
  uint128 maxCumulativeLoss;
}
```

## FullCheckParams

Collateral check params

### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct FullCheckParams {
  uint256[] collateralHints;
  uint16 minHealthFactor;
  uint256 enabledTokensMaskAfter;
  bool revertOnForbiddenTokens;
  bool useSafePrices;
}
```

## ICreditFacadeV3Events

### OpenCreditAccount

```solidity
event OpenCreditAccount(address creditAccount, address onBehalfOf, address caller, uint256 referralCode)
```

Emitted when a new credit account is opened

### CloseCreditAccount

```solidity
event CloseCreditAccount(address creditAccount, address borrower)
```

Emitted when account is closed

### LiquidateCreditAccount

```solidity
event LiquidateCreditAccount(address creditAccount, address liquidator, address to, uint256 remainingFunds)
```

Emitted when account is liquidated

### IncreaseDebt

```solidity
event IncreaseDebt(address creditAccount, uint256 amount)
```

Emitted when account's debt is increased

### DecreaseDebt

```solidity
event DecreaseDebt(address creditAccount, uint256 amount)
```

Emitted when account's debt is decreased

### AddCollateral

```solidity
event AddCollateral(address creditAccount, address token, uint256 amount)
```

Emitted when collateral is added to account

### WithdrawCollateral

```solidity
event WithdrawCollateral(address creditAccount, address token, uint256 amount, address to)
```

Emitted when collateral is withdrawn from account

### StartMultiCall

```solidity
event StartMultiCall(address creditAccount, address caller)
```

Emitted when a multicall is started

### Execute

```solidity
event Execute(address creditAccount, address targetContract)
```

Emitted when a call from account to an external contract is made during a multicall

### FinishMultiCall

```solidity
event FinishMultiCall()
```

Emitted when a multicall is finished

## ICreditFacadeV3

### creditManager

```solidity
function creditManager() external view returns (address)
```

### degenNFT

```solidity
function degenNFT() external view returns (address)
```

### weth

```solidity
function weth() external view returns (address)
```

### botList

```solidity
function botList() external view returns (address)
```

### maxDebtPerBlockMultiplier

```solidity
function maxDebtPerBlockMultiplier() external view returns (uint8)
```

### maxQuotaMultiplier

```solidity
function maxQuotaMultiplier() external view returns (uint256)
```

### expirable

```solidity
function expirable() external view returns (bool)
```

### expirationDate

```solidity
function expirationDate() external view returns (uint40)
```

### debtLimits

```solidity
function debtLimits() external view returns (uint128 minDebt, uint128 maxDebt)
```

### lossParams

```solidity
function lossParams() external view returns (uint128 currentCumulativeLoss, uint128 maxCumulativeLoss)
```

### forbiddenTokenMask

```solidity
function forbiddenTokenMask() external view returns (uint256)
```

### canLiquidateWhilePaused

```solidity
function canLiquidateWhilePaused(address) external view returns (bool)
```

### openCreditAccount

```solidity
function openCreditAccount(address onBehalfOf, struct MultiCall[] calls, uint256 referralCode) external payable returns (address creditAccount)
```

### closeCreditAccount

```solidity
function closeCreditAccount(address creditAccount, struct MultiCall[] calls) external payable
```

### liquidateCreditAccount

```solidity
function liquidateCreditAccount(address creditAccount, address to, struct MultiCall[] calls) external
```

### multicall

```solidity
function multicall(address creditAccount, struct MultiCall[] calls) external payable
```

### botMulticall

```solidity
function botMulticall(address creditAccount, struct MultiCall[] calls) external
```

### setBotPermissions

```solidity
function setBotPermissions(address creditAccount, address bot, uint192 permissions) external
```

### setExpirationDate

```solidity
function setExpirationDate(uint40 newExpirationDate) external
```

### setDebtLimits

```solidity
function setDebtLimits(uint128 newMinDebt, uint128 newMaxDebt, uint8 newMaxDebtPerBlockMultiplier) external
```

### setBotList

```solidity
function setBotList(address newBotList) external
```

### setCumulativeLossParams

```solidity
function setCumulativeLossParams(uint128 newMaxCumulativeLoss, bool resetCumulativeLoss) external
```

### setTokenAllowance

```solidity
function setTokenAllowance(address token, enum AllowanceAction allowance) external
```

### setEmergencyLiquidator

```solidity
function setEmergencyLiquidator(address liquidator, enum AllowanceAction allowance) external
```

## ADD_COLLATERAL_PERMISSION

```solidity
uint192 ADD_COLLATERAL_PERMISSION
```

## INCREASE_DEBT_PERMISSION

```solidity
uint192 INCREASE_DEBT_PERMISSION
```

## DECREASE_DEBT_PERMISSION

```solidity
uint192 DECREASE_DEBT_PERMISSION
```

## ENABLE_TOKEN_PERMISSION

```solidity
uint192 ENABLE_TOKEN_PERMISSION
```

## DISABLE_TOKEN_PERMISSION

```solidity
uint192 DISABLE_TOKEN_PERMISSION
```

## WITHDRAW_COLLATERAL_PERMISSION

```solidity
uint192 WITHDRAW_COLLATERAL_PERMISSION
```

## UPDATE_QUOTA_PERMISSION

```solidity
uint192 UPDATE_QUOTA_PERMISSION
```

## REVOKE_ALLOWANCES_PERMISSION

```solidity
uint192 REVOKE_ALLOWANCES_PERMISSION
```

## EXTERNAL_CALLS_PERMISSION

```solidity
uint192 EXTERNAL_CALLS_PERMISSION
```

## ALL_CREDIT_FACADE_CALLS_PERMISSION

```solidity
uint256 ALL_CREDIT_FACADE_CALLS_PERMISSION
```

## ALL_PERMISSIONS

```solidity
uint256 ALL_PERMISSIONS
```

## FORBIDDEN_TOKENS_BEFORE_CALLS

```solidity
uint256 FORBIDDEN_TOKENS_BEFORE_CALLS
```

## EXTERNAL_CONTRACT_WAS_CALLED

```solidity
uint256 EXTERNAL_CONTRACT_WAS_CALLED
```

## ICreditFacadeV3Multicall

_Unless specified otherwise, all these methods are only available in `openCreditAccount`,
     `closeCreditAccount`, `multicall`, and, with account owner's permission, `botMulticall`_

### onDemandPriceUpdate

```solidity
function onDemandPriceUpdate(address token, bool reserve, bytes data) external
```

Updates the price for a token with on-demand updatable price feed

_Calls of this type must be placed before all other calls in the multicall not to revert
This method is available in all kinds of multicalls_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | Token to push the price update for |
| reserve | bool | Whether to update reserve price feed or main price feed |
| data | bytes | Data to call `updatePrice` with |

### storeExpectedBalances

```solidity
function storeExpectedBalances(struct BalanceDelta[] balanceDeltas) external
```

Stores expected token balances (current balance + delta) after operations for a slippage check.
        Normally, a check is performed automatically at the end of the multicall, but more fine-grained
        behavior can be achieved by placing `storeExpectedBalances` and `compareBalances` where needed.

_Reverts if expected balances are already set
This method is available in all kinds of multicalls_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| balanceDeltas | struct BalanceDelta[] | Array of (token, minBalanceDelta) pairs, deltas are allowed to be negative |

### compareBalances

```solidity
function compareBalances() external
```

Performs a slippage check ensuring that current token balances are greater than saved expected ones

_Resets stored expected balances
Reverts if expected balances are not stored
This method is available in all kinds of multicalls_

### addCollateral

```solidity
function addCollateral(address token, uint256 amount) external
```

Adds collateral to account

_Requires token approval from caller to the credit manager
This method can also be called during liquidation_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | Token to add |
| amount | uint256 | Amount to add |

### addCollateralWithPermit

```solidity
function addCollateralWithPermit(address token, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

Adds collateral to account using signed EIP-2612 permit message

_`v`, `r`, `s` must be a valid signature of the permit message from caller to the credit manager
This method can also be called during liquidation_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | Token to add |
| amount | uint256 | Amount to add |
| deadline | uint256 | Permit deadline |
| v | uint8 |  |
| r | bytes32 |  |
| s | bytes32 |  |

### increaseDebt

```solidity
function increaseDebt(uint256 amount) external
```

Increases account's debt

_Increasing debt is prohibited when closing an account
Increasing debt is prohibited if it was previously updated in the same block
The resulting debt amount must be within allowed range
Increasing debt is prohibited if there are forbidden tokens enabled as collateral on the account
After debt increase, total amount borrowed by the credit manager in the current block must not exceed
     the limit defined in the facade_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | Underlying amount to borrow |

### decreaseDebt

```solidity
function decreaseDebt(uint256 amount) external
```

Decreases account's debt

_Decreasing debt is prohibited when opening an account
Decreasing debt is prohibited if it was previously updated in the same block
The resulting debt amount must be within allowed range or zero
Full repayment brings account into a special mode that skips collateral checks and thus requires
     an account to have no potential debt sources, e.g., all quotas must be disabled_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | Underlying amount to repay, value above account's total debt indicates full repayment |

### updateQuota

```solidity
function updateQuota(address token, int96 quotaChange, uint96 minQuota) external
```

Updates account's quota for a token

_Enables token as collateral if quota is increased from zero, disables if decreased to zero
Quota increase is prohibited if there are forbidden tokens enabled as collateral on the account
Quota update is prohibited if account has zero debt
Resulting account's quota for token must not exceed the limit defined in the facade_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | Token to update the quota for |
| quotaChange | int96 | Desired quota change in underlying token units (`type(int96).min` to disable quota) |
| minQuota | uint96 | Minimum resulting account's quota for token required not to revert |

### withdrawCollateral

```solidity
function withdrawCollateral(address token, uint256 amount, address to) external
```

Withdraws collateral from account

_This method can also be called during liquidation
Withdrawals are prohibited in multicalls if there are forbidden tokens enabled as collateral on the account
Withdrawals activate safe pricing (min of main and reserve feeds) in collateral check_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | Token to withdraw |
| amount | uint256 | Amount to withdraw, `type(uint256).max` to withdraw all balance |
| to | address | Token recipient |

### setFullCheckParams

```solidity
function setFullCheckParams(uint256[] collateralHints, uint16 minHealthFactor) external
```

Sets advanced collateral check parameters

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| collateralHints | uint256[] | Optional array of token masks to check first to reduce the amount of computation        when known subset of account's collateral tokens covers all the debt |
| minHealthFactor | uint16 | Min account's health factor in bps in order not to revert, must be at least 10000 |

### enableToken

```solidity
function enableToken(address token) external
```

Enables token as account's collateral, which makes it count towards account's total value

_Enabling forbidden tokens is prohibited
Quoted tokens can only be enabled via `updateQuota`, this method is no-op for them_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | Token to enable as collateral |

### disableToken

```solidity
function disableToken(address token) external
```

Disables token as account's collateral

_Quoted tokens can only be disabled via `updateQuota`, this method is no-op for them_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | Token to disable as collateral |

### revokeAdapterAllowances

```solidity
function revokeAdapterAllowances(struct RevocationPair[] revocations) external
```

Revokes account's allowances for specified spender/token pairs

_Exists primarily to allow users to revoke allowances on accounts from old account factory on mainnet_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| revocations | struct RevocationPair[] | Array of spender/token pairs |

## BOT_PERMISSIONS_SET_FLAG

```solidity
uint8 BOT_PERMISSIONS_SET_FLAG
```

## DEFAULT_MAX_ENABLED_TOKENS

```solidity
uint8 DEFAULT_MAX_ENABLED_TOKENS
```

## INACTIVE_CREDIT_ACCOUNT_ADDRESS

```solidity
address INACTIVE_CREDIT_ACCOUNT_ADDRESS
```

## ManageDebtAction

Debt management type
        - `INCREASE_DEBT` borrows additional funds from the pool, updates account's debt and cumulative interest index
        - `DECREASE_DEBT` repays debt components (quota interest and fees -> base interest and fees -> debt principal)
          and updates all corresponding state varibles (base interest index, quota interest and fees, debt).
          When repaying all the debt, ensures that account has no enabled quotas.

```solidity
enum ManageDebtAction {
  INCREASE_DEBT,
  DECREASE_DEBT
}
```

## CollateralCalcTask

Collateral/debt calculation mode
        - `GENERIC_PARAMS` returns generic data like account debt and cumulative indexes
        - `DEBT_ONLY` is same as `GENERIC_PARAMS` but includes more detailed debt info, like accrued base/quota
          interest and fees
        - `FULL_COLLATERAL_CHECK_LAZY` checks whether account is sufficiently collateralized in a lazy fashion,
          i.e. it stops iterating over collateral tokens once TWV reaches the desired target.
          Since it may return underestimated TWV, it's only available for internal use.
        - `DEBT_COLLATERAL` is same as `DEBT_ONLY` but also returns total value and total LT-weighted value of
          account's tokens, this mode is used during account liquidation
        - `DEBT_COLLATERAL_SAFE_PRICES` is same as `DEBT_COLLATERAL` but uses safe prices from price oracle

```solidity
enum CollateralCalcTask {
  GENERIC_PARAMS,
  DEBT_ONLY,
  FULL_COLLATERAL_CHECK_LAZY,
  DEBT_COLLATERAL,
  DEBT_COLLATERAL_SAFE_PRICES
}
```

## CreditAccountInfo

```solidity
struct CreditAccountInfo {
  uint256 debt;
  uint256 cumulativeIndexLastUpdate;
  uint128 cumulativeQuotaInterest;
  uint128 quotaFees;
  uint256 enabledTokensMask;
  uint16 flags;
  uint64 lastDebtUpdate;
  address borrower;
}
```

## CollateralDebtData

```solidity
struct CollateralDebtData {
  uint256 debt;
  uint256 cumulativeIndexNow;
  uint256 cumulativeIndexLastUpdate;
  uint128 cumulativeQuotaInterest;
  uint256 accruedInterest;
  uint256 accruedFees;
  uint256 totalDebtUSD;
  uint256 totalValue;
  uint256 totalValueUSD;
  uint256 twvUSD;
  uint256 enabledTokensMask;
  uint256 quotedTokensMask;
  address[] quotedTokens;
  address _poolQuotaKeeper;
}
```

## CollateralTokenData

```solidity
struct CollateralTokenData {
  address token;
  uint16 ltInitial;
  uint16 ltFinal;
  uint40 timestampRampStart;
  uint24 rampDuration;
}
```

## RevocationPair

```solidity
struct RevocationPair {
  address spender;
  address token;
}
```

## ICreditManagerV3Events

### SetCreditConfigurator

```solidity
event SetCreditConfigurator(address newConfigurator)
```

Emitted when new credit configurator is set

## ICreditManagerV3

### pool

```solidity
function pool() external view returns (address)
```

### underlying

```solidity
function underlying() external view returns (address)
```

### creditFacade

```solidity
function creditFacade() external view returns (address)
```

### creditConfigurator

```solidity
function creditConfigurator() external view returns (address)
```

### addressProvider

```solidity
function addressProvider() external view returns (address)
```

### accountFactory

```solidity
function accountFactory() external view returns (address)
```

### name

```solidity
function name() external view returns (string)
```

### openCreditAccount

```solidity
function openCreditAccount(address onBehalfOf) external returns (address)
```

### closeCreditAccount

```solidity
function closeCreditAccount(address creditAccount) external
```

### liquidateCreditAccount

```solidity
function liquidateCreditAccount(address creditAccount, struct CollateralDebtData collateralDebtData, address to, bool isExpired) external returns (uint256 remainingFunds, uint256 loss)
```

### manageDebt

```solidity
function manageDebt(address creditAccount, uint256 amount, uint256 enabledTokensMask, enum ManageDebtAction action) external returns (uint256 newDebt, uint256 tokensToEnable, uint256 tokensToDisable)
```

### addCollateral

```solidity
function addCollateral(address payer, address creditAccount, address token, uint256 amount) external returns (uint256 tokensToEnable)
```

### withdrawCollateral

```solidity
function withdrawCollateral(address creditAccount, address token, uint256 amount, address to) external returns (uint256 tokensToDisable)
```

### externalCall

```solidity
function externalCall(address creditAccount, address target, bytes callData) external returns (bytes result)
```

### approveToken

```solidity
function approveToken(address creditAccount, address token, address spender, uint256 amount) external
```

### revokeAdapterAllowances

```solidity
function revokeAdapterAllowances(address creditAccount, struct RevocationPair[] revocations) external
```

### adapterToContract

```solidity
function adapterToContract(address adapter) external view returns (address targetContract)
```

### contractToAdapter

```solidity
function contractToAdapter(address targetContract) external view returns (address adapter)
```

### execute

```solidity
function execute(bytes data) external returns (bytes result)
```

### approveCreditAccount

```solidity
function approveCreditAccount(address token, uint256 amount) external
```

### setActiveCreditAccount

```solidity
function setActiveCreditAccount(address creditAccount) external
```

### getActiveCreditAccountOrRevert

```solidity
function getActiveCreditAccountOrRevert() external view returns (address creditAccount)
```

### priceOracle

```solidity
function priceOracle() external view returns (address)
```

### fullCollateralCheck

```solidity
function fullCollateralCheck(address creditAccount, uint256 enabledTokensMask, uint256[] collateralHints, uint16 minHealthFactor, bool useSafePrices) external returns (uint256 enabledTokensMaskAfter)
```

### isLiquidatable

```solidity
function isLiquidatable(address creditAccount, uint16 minHealthFactor) external view returns (bool)
```

### calcDebtAndCollateral

```solidity
function calcDebtAndCollateral(address creditAccount, enum CollateralCalcTask task) external view returns (struct CollateralDebtData cdd)
```

### poolQuotaKeeper

```solidity
function poolQuotaKeeper() external view returns (address)
```

### quotedTokensMask

```solidity
function quotedTokensMask() external view returns (uint256)
```

### updateQuota

```solidity
function updateQuota(address creditAccount, address token, int96 quotaChange, uint96 minQuota, uint96 maxQuota) external returns (uint256 tokensToEnable, uint256 tokensToDisable)
```

### maxEnabledTokens

```solidity
function maxEnabledTokens() external view returns (uint8)
```

### fees

```solidity
function fees() external view returns (uint16 feeInterest, uint16 feeLiquidation, uint16 liquidationDiscount, uint16 feeLiquidationExpired, uint16 liquidationDiscountExpired)
```

### collateralTokensCount

```solidity
function collateralTokensCount() external view returns (uint8)
```

### getTokenMaskOrRevert

```solidity
function getTokenMaskOrRevert(address token) external view returns (uint256 tokenMask)
```

### getTokenByMask

```solidity
function getTokenByMask(uint256 tokenMask) external view returns (address token)
```

### liquidationThresholds

```solidity
function liquidationThresholds(address token) external view returns (uint16 lt)
```

### ltParams

```solidity
function ltParams(address token) external view returns (uint16 ltInitial, uint16 ltFinal, uint40 timestampRampStart, uint24 rampDuration)
```

### collateralTokenByMask

```solidity
function collateralTokenByMask(uint256 tokenMask) external view returns (address token, uint16 liquidationThreshold)
```

### creditAccountInfo

```solidity
function creditAccountInfo(address creditAccount) external view returns (uint256 debt, uint256 cumulativeIndexLastUpdate, uint128 cumulativeQuotaInterest, uint128 quotaFees, uint256 enabledTokensMask, uint16 flags, uint64 lastDebtUpdate, address borrower)
```

### getBorrowerOrRevert

```solidity
function getBorrowerOrRevert(address creditAccount) external view returns (address borrower)
```

### flagsOf

```solidity
function flagsOf(address creditAccount) external view returns (uint16)
```

### setFlagFor

```solidity
function setFlagFor(address creditAccount, uint16 flag, bool value) external
```

### enabledTokensMaskOf

```solidity
function enabledTokensMaskOf(address creditAccount) external view returns (uint256)
```

### creditAccounts

```solidity
function creditAccounts() external view returns (address[])
```

### creditAccounts

```solidity
function creditAccounts(uint256 offset, uint256 limit) external view returns (address[])
```

### creditAccountsLen

```solidity
function creditAccountsLen() external view returns (uint256)
```

### addToken

```solidity
function addToken(address token) external
```

### setCollateralTokenData

```solidity
function setCollateralTokenData(address token, uint16 ltInitial, uint16 ltFinal, uint40 timestampRampStart, uint24 rampDuration) external
```

### setFees

```solidity
function setFees(uint16 feeInterest, uint16 feeLiquidation, uint16 liquidationDiscount, uint16 feeLiquidationExpired, uint16 liquidationDiscountExpired) external
```

### setQuotedMask

```solidity
function setQuotedMask(uint256 quotedTokensMask) external
```

### setMaxEnabledTokens

```solidity
function setMaxEnabledTokens(uint8 maxEnabledTokens) external
```

### setContractAllowance

```solidity
function setContractAllowance(address adapter, address targetContract) external
```

### setCreditFacade

```solidity
function setCreditFacade(address creditFacade) external
```

### setPriceOracle

```solidity
function setPriceOracle(address priceOracle) external
```

### setCreditConfigurator

```solidity
function setCreditConfigurator(address creditConfigurator) external
```

## ILido

### submit

```solidity
function submit(address _refferal) external payable returns (uint256)
```

## ILidoWithdrawal

### requestWithdrawals

```solidity
function requestWithdrawals(uint256[] _amounts, address _owner) external returns (uint256[] requestIds)
```

### claimWithdrawal

```solidity
function claimWithdrawal(uint256 _requestId) external
```

## IWETH

### deposit

```solidity
function deposit() external payable
```

### withdraw

```solidity
function withdraw(uint256 wad) external
```

## AddLiquidityParams

```solidity
struct AddLiquidityParams {
  uint8 kind;
  int32 pos;
  bool isDelta;
  uint128 deltaA;
  uint128 deltaB;
}
```

## RemoveLiquidityParams

```solidity
struct RemoveLiquidityParams {
  uint128 binId;
  uint128 amount;
}
```

## BinDelta

```solidity
struct BinDelta {
  uint128 deltaA;
  uint128 deltaB;
  uint256 deltaLpBalance;
  uint128 binId;
  uint8 kind;
  int32 lowerTick;
  bool isActive;
}
```

## IMaverickPool

### tokenA

```solidity
function tokenA() external view returns (address)
```

### tokenB

```solidity
function tokenB() external view returns (address)
```

## IMaverickPosition

### approve

```solidity
function approve(address to, uint256 tokenId) external
```

## IMaverickReward

### EarnedInfo

```solidity
struct EarnedInfo {
  address account;
  uint256 earned;
  contract IERC20 rewardToken;
}
```

### earned

```solidity
function earned(address account) external view returns (struct IMaverickReward.EarnedInfo[] earnedInfo)
```

### tokenIndex

```solidity
function tokenIndex(address tokenAddress) external view returns (uint8)
```

### getReward

```solidity
function getReward(address recipient, uint8 rewardTokenIndex) external returns (uint256)
```

## IMaverickRouter

### position

```solidity
function position() external view returns (contract IMaverickPosition)
```

### removeLiquidity

```solidity
function removeLiquidity(contract IMaverickPool, address, uint256, struct RemoveLiquidityParams[], uint256, uint256, uint256) external returns (uint256 tokenAAmount, uint256 tokenBAmount, struct BinDelta[] binDeltas)
```

### addLiquidityToPool

```solidity
function addLiquidityToPool(contract IMaverickPool, uint256, struct AddLiquidityParams[], uint256, uint256, uint256) external payable returns (uint256, uint256, uint256, struct BinDelta[])
```

## IPositionInspector

### addressBinReservesByKind

```solidity
function addressBinReservesByKind(address owner, uint256 tokenIdIndex, contract IMaverickPool pool, uint8 kind) external view returns (uint256 amountA, uint256 amountB)
```

_May revert with out of gas if there are too many bins._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | Position NFT owner address |
| tokenIdIndex | uint256 | of the tokenIs that the owner has |
| pool | contract IMaverickPool | Mav pool |
| kind | uint8 | of bin to search for (0=static, 1=right, 2=left, 3=both) |

### addressBinReservesByKindAllTokenIds

```solidity
function addressBinReservesByKindAllTokenIds(address owner, contract IMaverickPool pool, uint8 kind) external view returns (uint256 amountA, uint256 amountB)
```

_May revert with out of gas if there are too many bins._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | Position NFT owner address |
| pool | contract IMaverickPool | Mav pool |
| kind | uint8 | of bin to search for (0=static, 1=right, 2=left, 3=both) |

### addressBinReservesAllKindsAllTokenIds

```solidity
function addressBinReservesAllKindsAllTokenIds(address owner, contract IMaverickPool pool) external view returns (uint256 amountA, uint256 amountB)
```

_May revert with out of gas if there are too many bins._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | Position NFT owner address |
| pool | contract IMaverickPool | Mav pool |

### addressBinReservesAllKinds

```solidity
function addressBinReservesAllKinds(address owner, uint256 tokenIdIndex, contract IMaverickPool pool) external view returns (uint256 amountA, uint256 amountB)
```

_May revert with out of gas if there are too many bins._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| owner | address | Position NFT owner address |
| tokenIdIndex | uint256 | of the tokenIs that the owner has |
| pool | contract IMaverickPool | Mav pool |

### tokenBinReservesAllKinds

```solidity
function tokenBinReservesAllKinds(uint256 tokenId, contract IMaverickPool pool) external view returns (uint256 amountA, uint256 amountB)
```

_May revert with out of gas if there are too many bins._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | Position NFT ID of the LP |
| pool | contract IMaverickPool | Mav pool |

### tokenBinReservesByKind

```solidity
function tokenBinReservesByKind(uint256 tokenId, contract IMaverickPool pool, uint8 kind) external view returns (uint256 amountA, uint256 amountB)
```

_May revert with out of gas if there are too many bins._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | Position NFT ID of the LP |
| pool | contract IMaverickPool | Mav pool |
| kind | uint8 | of bin to search for (0=static, 1=right, 2=left, 3=both) |

### tokenBinReservesByKind

```solidity
function tokenBinReservesByKind(uint256 tokenId, contract IMaverickPool pool, uint8 kind, uint128 startBin, uint128 endBin) external view returns (uint256 amountA, uint256 amountB)
```

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 |  |
| pool | contract IMaverickPool |  |
| kind | uint8 |  |
| startBin | uint128 |  |
| endBin | uint128 | end search bin ussed for pagination if needed.  endBin = |

### tokenBinReservesAllKinds

```solidity
function tokenBinReservesAllKinds(uint256 tokenId, contract IMaverickPool pool, uint128 startBin, uint128 endBin) external view returns (uint256 amountA, uint256 amountB)
```

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 |  |
| pool | contract IMaverickPool |  |
| startBin | uint128 |  |
| endBin | uint128 | end search bin ussed for pagination if needed.  endBin = |

### tokenBinReservesByBinList

```solidity
function tokenBinReservesByBinList(uint256 tokenId, contract IMaverickPool pool, uint128[] userBins) external view returns (uint256 amountA, uint256 amountB)
```

Returns reserve amounts a tokenId owns in a pool

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | Position NFT ID of the LP |
| pool | contract IMaverickPool | Mav pool |
| userBins | uint128[] | array of binIds that will be checked for reserves |

### getTokenBinIds

```solidity
function getTokenBinIds(uint256 tokenId, contract IMaverickPool pool, uint128 startBin, uint128 endBin) external view returns (uint128[] bins)
```

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 |  |
| pool | contract IMaverickPool |  |
| startBin | uint128 |  |
| endBin | uint128 | end search bin ussed for pagination if needed.  endBin = |

## IveMAV

### stake

```solidity
function stake(uint256 amount, uint256 duration, bool doDelegation) external
```

### unstake

```solidity
function unstake(uint256 lockupId) external
```

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

## Id

## MarketParams

```solidity
struct MarketParams {
  address loanToken;
  address collateralToken;
  address oracle;
  address irm;
  uint256 lltv;
}
```

## Position

_Warning: For `feeRecipient`, `supplyShares` does not contain the accrued shares since the last interest
accrual._

```solidity
struct Position {
  uint256 supplyShares;
  uint128 borrowShares;
  uint128 collateral;
}
```

## Market

_Warning: `totalSupplyAssets` does not contain the accrued interest since the last interest accrual.
Warning: `totalBorrowAssets` does not contain the accrued interest since the last interest accrual.
Warning: `totalSupplyShares` does not contain the additional shares accrued by `feeRecipient` since the last
interest accrual._

```solidity
struct Market {
  uint128 totalSupplyAssets;
  uint128 totalSupplyShares;
  uint128 totalBorrowAssets;
  uint128 totalBorrowShares;
  uint128 lastUpdate;
  uint128 fee;
}
```

## Authorization

```solidity
struct Authorization {
  address authorizer;
  address authorized;
  bool isAuthorized;
  uint256 nonce;
  uint256 deadline;
}
```

## Signature

```solidity
struct Signature {
  uint8 v;
  bytes32 r;
  bytes32 s;
}
```

## IMorphoBase

_This interface is used for factorizing IMorphoStaticTyping and IMorpho.
Consider using the IMorpho interface instead of this one._

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

The EIP-712 domain separator.

_Warning: Every EIP-712 signed message based on this domain separator can be reused on another chain sharing
the same chain id because the domain separator would be the same._

### owner

```solidity
function owner() external view returns (address)
```

The owner of the contract.

_It has the power to change the owner.
It has the power to set fees on markets and set the fee recipient.
It has the power to enable but not disable IRMs and LLTVs._

### feeRecipient

```solidity
function feeRecipient() external view returns (address)
```

The fee recipient of all markets.

_The recipient receives the fees of a given market through a supply position on that market._

### isIrmEnabled

```solidity
function isIrmEnabled(address irm) external view returns (bool)
```

Whether the `irm` is enabled.

### isLltvEnabled

```solidity
function isLltvEnabled(uint256 lltv) external view returns (bool)
```

Whether the `lltv` is enabled.

### isAuthorized

```solidity
function isAuthorized(address authorizer, address authorized) external view returns (bool)
```

Whether `authorized` is authorized to modify `authorizer`'s positions.

_Anyone is authorized to modify their own positions, regardless of this variable._

### nonce

```solidity
function nonce(address authorizer) external view returns (uint256)
```

The `authorizer`'s current nonce. Used to prevent replay attacks with EIP-712 signatures.

### setOwner

```solidity
function setOwner(address newOwner) external
```

Sets `newOwner` as `owner` of the contract.

_Warning: No two-step transfer ownership.
Warning: The owner can be set to the zero address._

### enableIrm

```solidity
function enableIrm(address irm) external
```

Enables `irm` as a possible IRM for market creation.

_Warning: It is not possible to disable an IRM._

### enableLltv

```solidity
function enableLltv(uint256 lltv) external
```

Enables `lltv` as a possible LLTV for market creation.

_Warning: It is not possible to disable a LLTV._

### setFee

```solidity
function setFee(struct MarketParams marketParams, uint256 newFee) external
```

Sets the `newFee` for the given market `marketParams`.

_Warning: The recipient can be the zero address._

### setFeeRecipient

```solidity
function setFeeRecipient(address newFeeRecipient) external
```

Sets `newFeeRecipient` as `feeRecipient` of the fee.

_Warning: If the fee recipient is set to the zero address, fees will accrue there and will be lost.
Modifying the fee recipient will allow the new recipient to claim any pending fees not yet accrued. To
ensure that the current recipient receives all due fees, accrue interest manually prior to making any changes._

### createMarket

```solidity
function createMarket(struct MarketParams marketParams) external
```

Creates the market `marketParams`.

_Here is the list of assumptions on the market's dependencies (tokens, IRM and oracle) that guarantees
Morpho behaves as expected:
- The token should be ERC-20 compliant, except that it can omit return values on `transfer` and `transferFrom`.
- The token balance of Morpho should only decrease on `transfer` and `transferFrom`. In particular, tokens with
burn functions are not supported.
- The token should not re-enter Morpho on `transfer` nor `transferFrom`.
- The token balance of the sender (resp. receiver) should decrease (resp. increase) by exactly the given amount
on `transfer` and `transferFrom`. In particular, tokens with fees on transfer are not supported.
- The IRM should not re-enter Morpho.
- The oracle should return a price with the correct scaling.
Here is a list of properties on the market's dependencies that could break Morpho's liveness properties
(funds could get stuck):
- The token can revert on `transfer` and `transferFrom` for a reason other than an approval or balance issue.
- A very high amount of assets (~1e35) supplied or borrowed can make the computation of `toSharesUp` and
`toSharesDown` overflow.
- The IRM can revert on `borrowRate`.
- A very high borrow rate returned by the IRM can make the computation of `interest` in `_accrueInterest`
overflow.
- The oracle can revert on `price`. Note that this can be used to prevent `borrow`, `withdrawCollateral` and
`liquidate` from being used under certain market conditions.
- A very high price returned by the oracle can make the computation of `maxBorrow` in `_isHealthy` overflow, or
the computation of `assetsRepaid` in `liquidate` overflow.
The borrow share price of a market with less than 1e4 assets borrowed can be decreased by manipulations, to
the point where `totalBorrowShares` is very large and borrowing overflows._

### supply

```solidity
function supply(struct MarketParams marketParams, uint256 assets, uint256 shares, address onBehalf, bytes data) external returns (uint256 assetsSupplied, uint256 sharesSupplied)
```

Supplies `assets` or `shares` on behalf of `onBehalf`, optionally calling back the caller's
`onMorphoSupply` function with the given `data`.

_Either `assets` or `shares` should be zero. Most usecases should rely on `assets` as an input so the caller
is guaranteed to have `assets` tokens pulled from their balance, but the possibility to mint a specific amount
of shares is given for full compatibility and precision.
If the supply of a market gets depleted, the supply share price instantly resets to
`VIRTUAL_ASSETS`:`VIRTUAL_SHARES`.
Supplying a large amount can revert for overflow._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to supply assets to. |
| assets | uint256 | The amount of assets to supply. |
| shares | uint256 | The amount of shares to mint. |
| onBehalf | address | The address that will own the increased supply position. |
| data | bytes | Arbitrary data to pass to the `onMorphoSupply` callback. Pass empty data if not needed. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetsSupplied | uint256 | The amount of assets supplied. |
| sharesSupplied | uint256 | The amount of shares minted. |

### withdraw

```solidity
function withdraw(struct MarketParams marketParams, uint256 assets, uint256 shares, address onBehalf, address receiver) external returns (uint256 assetsWithdrawn, uint256 sharesWithdrawn)
```

Withdraws `assets` or `shares` on behalf of `onBehalf` to `receiver`.

_Either `assets` or `shares` should be zero. To withdraw max, pass the `shares`'s balance of `onBehalf`.
`msg.sender` must be authorized to manage `onBehalf`'s positions.
Withdrawing an amount corresponding to more shares than supplied will revert for underflow.
It is advised to use the `shares` input when withdrawing the full position to avoid reverts due to
conversion roundings between shares and assets._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to withdraw assets from. |
| assets | uint256 | The amount of assets to withdraw. |
| shares | uint256 | The amount of shares to burn. |
| onBehalf | address | The address of the owner of the supply position. |
| receiver | address | The address that will receive the withdrawn assets. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetsWithdrawn | uint256 | The amount of assets withdrawn. |
| sharesWithdrawn | uint256 | The amount of shares burned. |

### borrow

```solidity
function borrow(struct MarketParams marketParams, uint256 assets, uint256 shares, address onBehalf, address receiver) external returns (uint256 assetsBorrowed, uint256 sharesBorrowed)
```

Borrows `assets` or `shares` on behalf of `onBehalf` to `receiver`.

_Either `assets` or `shares` should be zero. Most usecases should rely on `assets` as an input so the caller
is guaranteed to borrow `assets` of tokens, but the possibility to mint a specific amount of shares is given for
full compatibility and precision.
If the borrow of a market gets depleted, the borrow share price instantly resets to
`VIRTUAL_ASSETS`:`VIRTUAL_SHARES`.
`msg.sender` must be authorized to manage `onBehalf`'s positions.
Borrowing a large amount can revert for overflow._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to borrow assets from. |
| assets | uint256 | The amount of assets to borrow. |
| shares | uint256 | The amount of shares to mint. |
| onBehalf | address | The address that will own the increased borrow position. |
| receiver | address | The address that will receive the borrowed assets. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetsBorrowed | uint256 | The amount of assets borrowed. |
| sharesBorrowed | uint256 | The amount of shares minted. |

### repay

```solidity
function repay(struct MarketParams marketParams, uint256 assets, uint256 shares, address onBehalf, bytes data) external returns (uint256 assetsRepaid, uint256 sharesRepaid)
```

Repays `assets` or `shares` on behalf of `onBehalf`, optionally calling back the caller's
`onMorphoReplay` function with the given `data`.

_Either `assets` or `shares` should be zero. To repay max, pass the `shares`'s balance of `onBehalf`.
Repaying an amount corresponding to more shares than borrowed will revert for underflow.
It is advised to use the `shares` input when repaying the full position to avoid reverts due to conversion
roundings between shares and assets._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to repay assets to. |
| assets | uint256 | The amount of assets to repay. |
| shares | uint256 | The amount of shares to burn. |
| onBehalf | address | The address of the owner of the debt position. |
| data | bytes | Arbitrary data to pass to the `onMorphoRepay` callback. Pass empty data if not needed. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetsRepaid | uint256 | The amount of assets repaid. |
| sharesRepaid | uint256 | The amount of shares burned. |

### supplyCollateral

```solidity
function supplyCollateral(struct MarketParams marketParams, uint256 assets, address onBehalf, bytes data) external
```

Supplies `assets` of collateral on behalf of `onBehalf`, optionally calling back the caller's
`onMorphoSupplyCollateral` function with the given `data`.

_Interest are not accrued since it's not required and it saves gas.
Supplying a large amount can revert for overflow._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to supply collateral to. |
| assets | uint256 | The amount of collateral to supply. |
| onBehalf | address | The address that will own the increased collateral position. |
| data | bytes | Arbitrary data to pass to the `onMorphoSupplyCollateral` callback. Pass empty data if not needed. |

### withdrawCollateral

```solidity
function withdrawCollateral(struct MarketParams marketParams, uint256 assets, address onBehalf, address receiver) external
```

Withdraws `assets` of collateral on behalf of `onBehalf` to `receiver`.

_`msg.sender` must be authorized to manage `onBehalf`'s positions.
Withdrawing an amount corresponding to more collateral than supplied will revert for underflow._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to withdraw collateral from. |
| assets | uint256 | The amount of collateral to withdraw. |
| onBehalf | address | The address of the owner of the collateral position. |
| receiver | address | The address that will receive the collateral assets. |

### liquidate

```solidity
function liquidate(struct MarketParams marketParams, address borrower, uint256 seizedAssets, uint256 repaidShares, bytes data) external returns (uint256, uint256)
```

Liquidates the given `repaidShares` of debt asset or seize the given `seizedAssets` of collateral on the
given market `marketParams` of the given `borrower`'s position, optionally calling back the caller's
`onMorphoLiquidate` function with the given `data`.

_Either `seizedAssets` or `repaidShares` should be zero.
Seizing more than the collateral balance will underflow and revert without any error message.
Repaying more than the borrow balance will underflow and revert without any error message._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market of the position. |
| borrower | address | The owner of the position. |
| seizedAssets | uint256 | The amount of collateral to seize. |
| repaidShares | uint256 | The amount of shares to repay. |
| data | bytes | Arbitrary data to pass to the `onMorphoLiquidate` callback. Pass empty data if not needed. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The amount of assets seized. |
| [1] | uint256 | The amount of assets repaid. |

### flashLoan

```solidity
function flashLoan(address token, uint256 assets, bytes data) external
```

Executes a flash loan.

_Flash loans have access to the whole balance of the contract (the liquidity and deposited collateral of all
markets combined, plus donations).
Warning: Not ERC-3156 compliant but compatibility is easily reached:
- `flashFee` is zero.
- `maxFlashLoan` is the token's balance of this contract.
- The receiver of `assets` is the caller._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | The token to flash loan. |
| assets | uint256 | The amount of assets to flash loan. |
| data | bytes | Arbitrary data to pass to the `onMorphoFlashLoan` callback. |

### setAuthorization

```solidity
function setAuthorization(address authorized, bool newIsAuthorized) external
```

Sets the authorization for `authorized` to manage `msg.sender`'s positions.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| authorized | address | The authorized address. |
| newIsAuthorized | bool | The new authorization status. |

### setAuthorizationWithSig

```solidity
function setAuthorizationWithSig(struct Authorization authorization, struct Signature signature) external
```

Sets the authorization for `authorization.authorized` to manage `authorization.authorizer`'s positions.

_Warning: Reverts if the signature has already been submitted.
The signature is malleable, but it has no impact on the security here.
The nonce is passed as argument to be able to revert with a different error message._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| authorization | struct Authorization | The `Authorization` struct. |
| signature | struct Signature | The signature. |

### accrueInterest

```solidity
function accrueInterest(struct MarketParams marketParams) external
```

Accrues interest for the given market `marketParams`.

### extSloads

```solidity
function extSloads(bytes32[] slots) external view returns (bytes32[])
```

Returns the data stored on the different `slots`.

## IMorphoStaticTyping

_This interface is inherited by Morpho so that function signatures are checked by the compiler.
Consider using the IMorpho interface instead of this one._

### position

```solidity
function position(Id id, address user) external view returns (uint256 supplyShares, uint128 borrowShares, uint128 collateral)
```

The state of the position of `user` on the market corresponding to `id`.

_Warning: For `feeRecipient`, `supplyShares` does not contain the accrued shares since the last interest
accrual._

### market

```solidity
function market(Id id) external view returns (uint128 totalSupplyAssets, uint128 totalSupplyShares, uint128 totalBorrowAssets, uint128 totalBorrowShares, uint128 lastUpdate, uint128 fee)
```

The state of the market corresponding to `id`.

_Warning: `totalSupplyAssets` does not contain the accrued interest since the last interest accrual.
Warning: `totalBorrowAssets` does not contain the accrued interest since the last interest accrual.
Warning: `totalSupplyShares` does not contain the accrued shares by `feeRecipient` since the last interest
accrual._

### idToMarketParams

```solidity
function idToMarketParams(Id id) external view returns (address loanToken, address collateralToken, address oracle, address irm, uint256 lltv)
```

The market params corresponding to `id`.

_This mapping is not used in Morpho. It is there to enable reducing the cost associated to calldata on layer
2s by creating a wrapper contract with functions that take `id` as input instead of `marketParams`._

## IMorpho

_Use this interface for Morpho to have access to all the functions with the appropriate function signatures._

### position

```solidity
function position(Id id, address user) external view returns (struct Position p)
```

The state of the position of `user` on the market corresponding to `id`.

_Warning: For `feeRecipient`, `p.supplyShares` does not contain the accrued shares since the last interest
accrual._

### market

```solidity
function market(Id id) external view returns (struct Market m)
```

The state of the market corresponding to `id`.

_Warning: `m.totalSupplyAssets` does not contain the accrued interest since the last interest accrual.
Warning: `m.totalBorrowAssets` does not contain the accrued interest since the last interest accrual.
Warning: `m.totalSupplyShares` does not contain the accrued shares by `feeRecipient` since the last
interest accrual._

### idToMarketParams

```solidity
function idToMarketParams(Id id) external view returns (struct MarketParams)
```

The market params corresponding to `id`.

_This mapping is not used in Morpho. It is there to enable reducing the cost associated to calldata on layer
2s by creating a wrapper contract with functions that take `id` as input instead of `marketParams`._

## IOracle

Interface that oracles used by Morpho must implement.

_It is the user's responsibility to select markets with safe oracles._

### price

```solidity
function price() external view returns (uint256)
```

Returns the price of 1 asset of collateral token quoted in 1 asset of loan token, scaled by 1e36.

_It corresponds to the price of 10**(collateral token decimals) assets of collateral token quoted in
10**(loan token decimals) assets of loan token with `36 + loan token decimals - collateral token decimals`
decimals of precision._

## IMasterchefV3

### updateLiquidity

```solidity
function updateLiquidity(uint256 _tokenId) external
```

### CAKE

```solidity
function CAKE() external view returns (address)
```

### withdraw

```solidity
function withdraw(uint256 _tokenId, address _to) external
```

## IPActionSwapPTV3

### SwapPtAndSy

```solidity
event SwapPtAndSy(address caller, address market, address receiver, int256 netPtToAccount, int256 netSyToAccount)
```

### SwapPtAndToken

```solidity
event SwapPtAndToken(address caller, address market, address token, address receiver, int256 netPtToAccount, int256 netTokenToAccount, uint256 netSyInterm)
```

### swapExactTokenForPt

```solidity
function swapExactTokenForPt(address receiver, address market, uint256 minPtOut, struct ApproxParams guessPtOut, struct TokenInput input, struct LimitOrderData limit) external payable returns (uint256 netPtOut, uint256 netSyFee, uint256 netSyInterm)
```

### swapExactSyForPt

```solidity
function swapExactSyForPt(address receiver, address market, uint256 exactSyIn, uint256 minPtOut, struct ApproxParams guessPtOut, struct LimitOrderData limit) external returns (uint256 netPtOut, uint256 netSyFee)
```

### swapExactPtForToken

```solidity
function swapExactPtForToken(address receiver, address market, uint256 exactPtIn, struct TokenOutput output, struct LimitOrderData limit) external returns (uint256 netTokenOut, uint256 netSyFee, uint256 netSyInterm)
```

### swapExactPtForSy

```solidity
function swapExactPtForSy(address receiver, address market, uint256 exactPtIn, uint256 minSyOut, struct LimitOrderData limit) external returns (uint256 netSyOut, uint256 netSyFee)
```

## IPActionSwapYTV3

### SwapYtAndSy

```solidity
event SwapYtAndSy(address caller, address market, address receiver, int256 netYtToAccount, int256 netSyToAccount)
```

### SwapYtAndToken

```solidity
event SwapYtAndToken(address caller, address market, address token, address receiver, int256 netYtToAccount, int256 netTokenToAccount, uint256 netSyInterm)
```

### SwapPtAndYt

```solidity
event SwapPtAndYt(address caller, address market, address receiver, int256 netPtToAccount, int256 netYtToAccount)
```

### swapExactTokenForYt

```solidity
function swapExactTokenForYt(address receiver, address market, uint256 minYtOut, struct ApproxParams guessYtOut, struct TokenInput input, struct LimitOrderData limit) external payable returns (uint256 netYtOut, uint256 netSyFee, uint256 netSyInterm)
```

### swapExactSyForYt

```solidity
function swapExactSyForYt(address receiver, address market, uint256 exactSyIn, uint256 minYtOut, struct ApproxParams guessYtOut, struct LimitOrderData limit) external returns (uint256 netYtOut, uint256 netSyFee)
```

### swapExactYtForToken

```solidity
function swapExactYtForToken(address receiver, address market, uint256 exactYtIn, struct TokenOutput output, struct LimitOrderData limit) external returns (uint256 netTokenOut, uint256 netSyFee, uint256 netSyInterm)
```

### swapExactYtForSy

```solidity
function swapExactYtForSy(address receiver, address market, uint256 exactYtIn, uint256 minSyOut, struct LimitOrderData limit) external returns (uint256 netSyOut, uint256 netSyFee)
```

### swapExactPtForYt

```solidity
function swapExactPtForYt(address receiver, address market, uint256 exactPtIn, uint256 minYtOut, struct ApproxParams guessTotalPtToSwap) external returns (uint256 netYtOut, uint256 netSyFee)
```

### swapExactYtForPt

```solidity
function swapExactYtForPt(address receiver, address market, uint256 exactYtIn, uint256 minPtOut, struct ApproxParams guessTotalPtFromSwap) external returns (uint256 netPtOut, uint256 netSyFee)
```

## SwapData

```solidity
struct SwapData {
  enum SwapType swapType;
  address extRouter;
  bytes extCalldata;
  bool needScale;
}
```

## SwapType

```solidity
enum SwapType {
  NONE,
  KYBERSWAP,
  ONE_INCH,
  ETH_WETH
}
```

## ApproxParams

```solidity
struct ApproxParams {
  uint256 guessMin;
  uint256 guessMax;
  uint256 guessOffchain;
  uint256 maxIteration;
  uint256 eps;
}
```

## TokenInput

```solidity
struct TokenInput {
  address tokenIn;
  uint256 netTokenIn;
  address tokenMintSy;
  address pendleSwap;
  struct SwapData swapData;
}
```

## TokenOutput

```solidity
struct TokenOutput {
  address tokenOut;
  uint256 minTokenOut;
  address tokenRedeemSy;
  address pendleSwap;
  struct SwapData swapData;
}
```

## LimitOrderData

```solidity
struct LimitOrderData {
  address limitRouter;
  uint256 epsSkipMarket;
  struct FillOrderParams[] normalFills;
  struct FillOrderParams[] flashFills;
  bytes optData;
}
```

## IPLimitOrderType

### OrderType

```solidity
enum OrderType {
  SY_FOR_PT,
  PT_FOR_SY,
  SY_FOR_YT,
  YT_FOR_SY
}
```

### StaticOrder

```solidity
struct StaticOrder {
  uint256 salt;
  uint256 expiry;
  uint256 nonce;
  enum IPLimitOrderType.OrderType orderType;
  address token;
  address YT;
  address maker;
  address receiver;
  uint256 makingAmount;
  uint256 lnImpliedRate;
  uint256 failSafeRate;
}
```

### FillResults

```solidity
struct FillResults {
  uint256 totalMaking;
  uint256 totalTaking;
  uint256 totalFee;
  uint256 totalNotionalVolume;
  uint256[] netMakings;
  uint256[] netTakings;
  uint256[] netFees;
  uint256[] notionalVolumes;
}
```

## Order

```solidity
struct Order {
  uint256 salt;
  uint256 expiry;
  uint256 nonce;
  enum IPLimitOrderType.OrderType orderType;
  address token;
  address YT;
  address maker;
  address receiver;
  uint256 makingAmount;
  uint256 lnImpliedRate;
  uint256 failSafeRate;
  bytes permit;
}
```

## FillOrderParams

```solidity
struct FillOrderParams {
  struct Order order;
  bytes signature;
  uint256 makingAmount;
}
```

## IPLimitRouterCallback

### limitRouterCallback

```solidity
function limitRouterCallback(uint256 actualMaking, uint256 actualTaking, uint256 totalFee, bytes data) external returns (bytes)
```

## IPLimitRouter

### OrderStatus

```solidity
struct OrderStatus {
  uint128 filledAmount;
  uint128 remaining;
}
```

### fill

```solidity
function fill(struct FillOrderParams[] params, address receiver, uint256 maxTaking, bytes optData, bytes callback) external returns (uint256 actualMaking, uint256 actualTaking, uint256 totalFee, bytes callbackReturn)
```

### feeRecipient

```solidity
function feeRecipient() external view returns (address)
```

### hashOrder

```solidity
function hashOrder(struct Order order) external view returns (bytes32)
```

### cancelSingle

```solidity
function cancelSingle(struct Order order) external
```

### cancelBatch

```solidity
function cancelBatch(struct Order[] orders) external
```

### orderStatusesRaw

```solidity
function orderStatusesRaw(bytes32[] orderHashes) external view returns (uint256[] remainingsRaw, uint256[] filledAmounts)
```

### orderStatuses

```solidity
function orderStatuses(bytes32[] orderHashes) external view returns (uint256[] remainings, uint256[] filledAmounts)
```

### simulate

```solidity
function simulate(address target, bytes data) external payable
```

### OrderFilled

```solidity
event OrderFilled(bytes32 orderHash, enum IPLimitOrderType.OrderType orderType, address YT, address token, uint256 netInputFromMaker, uint256 netOutputToMaker, uint256 feeAmount, uint256 notionalVolume)
```

## IPMarket

### Mint

```solidity
event Mint(address receiver, uint256 netLpMinted, uint256 netSyUsed, uint256 netPtUsed)
```

### Burn

```solidity
event Burn(address receiverSy, address receiverPt, uint256 netLpBurned, uint256 netSyOut, uint256 netPtOut)
```

### Swap

```solidity
event Swap(address caller, address receiver, int256 netPtOut, int256 netSyOut, uint256 netSyFee, uint256 netSyToReserve)
```

### UpdateImpliedRate

```solidity
event UpdateImpliedRate(uint256 timestamp, uint256 lnLastImpliedRate)
```

### IncreaseObservationCardinalityNext

```solidity
event IncreaseObservationCardinalityNext(uint16 observationCardinalityNextOld, uint16 observationCardinalityNextNew)
```

### mint

```solidity
function mint(address receiver, uint256 netSyDesired, uint256 netPtDesired) external returns (uint256 netLpOut, uint256 netSyUsed, uint256 netPtUsed)
```

### burn

```solidity
function burn(address receiverSy, address receiverPt, uint256 netLpToBurn) external returns (uint256 netSyOut, uint256 netPtOut)
```

### swapExactPtForSy

```solidity
function swapExactPtForSy(address receiver, uint256 exactPtIn, bytes data) external returns (uint256 netSyOut, uint256 netSyFee)
```

### swapSyForExactPt

```solidity
function swapSyForExactPt(address receiver, uint256 exactPtOut, bytes data) external returns (uint256 netSyIn, uint256 netSyFee)
```

### redeemRewards

```solidity
function redeemRewards(address user) external returns (uint256[])
```

### readState

```solidity
function readState(address router) external view returns (struct MarketState market)
```

### observe

```solidity
function observe(uint32[] secondsAgos) external view returns (uint216[] lnImpliedRateCumulative)
```

### increaseObservationsCardinalityNext

```solidity
function increaseObservationsCardinalityNext(uint16 cardinalityNext) external
```

### readTokens

```solidity
function readTokens() external view returns (contract IPStandardizedYield _SY, contract IPPrincipalToken _PT, contract IPYieldToken _YT)
```

### getRewardTokens

```solidity
function getRewardTokens() external view returns (address[])
```

### isExpired

```solidity
function isExpired() external view returns (bool)
```

### skim

```solidity
function skim() external
```

### expiry

```solidity
function expiry() external view returns (uint256)
```

### observations

```solidity
function observations(uint256 index) external view returns (uint32 blockTimestamp, uint216 lnImpliedRateCumulative, bool initialized)
```

### _storage

```solidity
function _storage() external view returns (int128 totalPt, int128 totalSy, uint96 lastLnImpliedRate, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext)
```

## IPPrincipalToken

### burnByYT

```solidity
function burnByYT(address user, uint256 amount) external
```

### mintByYT

```solidity
function mintByYT(address user, uint256 amount) external
```

### initialize

```solidity
function initialize(address _YT) external
```

### SY

```solidity
function SY() external view returns (address)
```

### YT

```solidity
function YT() external view returns (address)
```

### factory

```solidity
function factory() external view returns (address)
```

### expiry

```solidity
function expiry() external view returns (uint256)
```

### isExpired

```solidity
function isExpired() external view returns (bool)
```

## IPStandardizedYield

### Deposit

```solidity
event Deposit(address caller, address receiver, address tokenIn, uint256 amountDeposited, uint256 amountSyOut)
```

_Emitted when any base tokens is deposited to mint shares_

### Redeem

```solidity
event Redeem(address caller, address receiver, address tokenOut, uint256 amountSyToRedeem, uint256 amountTokenOut)
```

_Emitted when any shares are redeemed for base tokens_

### AssetType

_check `assetInfo()` for more information_

```solidity
enum AssetType {
  TOKEN,
  LIQUIDITY
}
```

### ClaimRewards

```solidity
event ClaimRewards(address user, address[] rewardTokens, uint256[] rewardAmounts)
```

_Emitted when (`user`) claims their rewards_

### deposit

```solidity
function deposit(address receiver, address tokenIn, uint256 amountTokenToDeposit, uint256 minSharesOut) external payable returns (uint256 amountSharesOut)
```

mints an amount of shares by depositing a base token.

_Emits a {Deposit} event

Requirements:
- (`tokenIn`) must be a valid base token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| receiver | address | shares recipient address |
| tokenIn | address | address of the base tokens to mint shares |
| amountTokenToDeposit | uint256 | amount of base tokens to be transferred from (`msg.sender`) |
| minSharesOut | uint256 | reverts if amount of shares minted is lower than this |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountSharesOut | uint256 | amount of shares minted |

### redeem

```solidity
function redeem(address receiver, uint256 amountSharesToRedeem, address tokenOut, uint256 minTokenOut, bool burnFromInternalBalance) external returns (uint256 amountTokenOut)
```

redeems an amount of base tokens by burning some shares

_Emits a {Redeem} event

Requirements:
- (`tokenOut`) must be a valid base token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| receiver | address | recipient address |
| amountSharesToRedeem | uint256 | amount of shares to be burned |
| tokenOut | address | address of the base token to be redeemed |
| minTokenOut | uint256 | reverts if amount of base token redeemed is lower than this |
| burnFromInternalBalance | bool | if true, burns from balance of `address(this)`, otherwise burns from `msg.sender` |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountTokenOut | uint256 | amount of base tokens redeemed |

### exchangeRate

```solidity
function exchangeRate() external view returns (uint256 res)
```

exchangeRate * syBalance / 1e18 must return the asset balance of the account
vice-versa, if a user uses some amount of tokens equivalent to X asset, the amount of sy
 he can mint must be X * exchangeRate / 1e18

_SYUtils's assetToSy & syToAsset should be used instead of raw multiplication
 & division_

### claimRewards

```solidity
function claimRewards(address user) external returns (uint256[] rewardAmounts)
```

claims reward for (`user`)

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| user | address | the user receiving their rewards |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rewardAmounts | uint256[] | an array of reward amounts in the same order as `getRewardTokens` @dev Emits a `ClaimRewards` event See {getRewardTokens} for list of reward tokens |

### accruedRewards

```solidity
function accruedRewards(address user) external view returns (uint256[] rewardAmounts)
```

get the amount of unclaimed rewards for (`user`)

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| user | address | the user to check for |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rewardAmounts | uint256[] | an array of reward amounts in the same order as `getRewardTokens` |

### rewardIndexesCurrent

```solidity
function rewardIndexesCurrent() external returns (uint256[] indexes)
```

### rewardIndexesStored

```solidity
function rewardIndexesStored() external view returns (uint256[] indexes)
```

### getRewardTokens

```solidity
function getRewardTokens() external view returns (address[])
```

returns the list of reward token addresses

### underlying

```solidity
function underlying() external view returns (address)
```

returns the address of the underlying yield token

### getTokensIn

```solidity
function getTokensIn() external view returns (address[] res)
```

returns all tokens that can mint this SY

### getTokensOut

```solidity
function getTokensOut() external view returns (address[] res)
```

returns all tokens that can be redeemed by this SY

### isValidTokenIn

```solidity
function isValidTokenIn(address token) external view returns (bool)
```

### isValidTokenOut

```solidity
function isValidTokenOut(address token) external view returns (bool)
```

### previewDeposit

```solidity
function previewDeposit(address tokenIn, uint256 amountTokenToDeposit) external view returns (uint256 amountSharesOut)
```

### previewRedeem

```solidity
function previewRedeem(address tokenOut, uint256 amountSharesToRedeem) external view returns (uint256 amountTokenOut)
```

### assetInfo

```solidity
function assetInfo() external view returns (enum IPStandardizedYield.AssetType assetType, address assetAddress, uint8 assetDecimals)
```

This function contains information to interpret what the asset is

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetType | enum IPStandardizedYield.AssetType | the type of the asset (0 for ERC20 tokens, 1 for AMM liquidity tokens) |
| assetAddress | address | the address of the asset |
| assetDecimals | uint8 | the decimals of the asset |

## IPYieldToken

### Mint

```solidity
event Mint(address caller, address receiverPT, address receiverYT, uint256 amountSyToMint, uint256 amountPYOut)
```

### Burn

```solidity
event Burn(address caller, address receiver, uint256 amountPYToRedeem, uint256 amountSyOut)
```

### mintPY

```solidity
function mintPY(address receiverPT, address receiverYT) external returns (uint256 amountPYOut)
```

### redeemPY

```solidity
function redeemPY(address receiver) external returns (uint256 amountSyOut)
```

### rewardIndexesCurrent

```solidity
function rewardIndexesCurrent() external returns (uint256[])
```

### pyIndexCurrent

```solidity
function pyIndexCurrent() external returns (uint256)
```

### pyIndexStored

```solidity
function pyIndexStored() external view returns (uint256)
```

### getRewardTokens

```solidity
function getRewardTokens() external view returns (address[])
```

### SY

```solidity
function SY() external view returns (address)
```

### PT

```solidity
function PT() external view returns (address)
```

### factory

```solidity
function factory() external view returns (address)
```

### expiry

```solidity
function expiry() external view returns (uint256)
```

### isExpired

```solidity
function isExpired() external view returns (bool)
```

### doCacheIndexSameBlock

```solidity
function doCacheIndexSameBlock() external view returns (bool)
```

### pyIndexLastUpdatedBlock

```solidity
function pyIndexLastUpdatedBlock() external view returns (uint128)
```

## IPendleMarketDepositHelper

### totalStaked

```solidity
function totalStaked(address _market) external view returns (uint256)
```

### balance

```solidity
function balance(address _market, address _address) external view returns (uint256)
```

### depositMarket

```solidity
function depositMarket(address _market, uint256 _amount) external
```

### depositMarketFor

```solidity
function depositMarketFor(address _market, address _for, uint256 _amount) external
```

### withdrawMarket

```solidity
function withdrawMarket(address _market, uint256 _amount) external
```

### withdrawMarketWithClaim

```solidity
function withdrawMarketWithClaim(address _market, uint256 _amount, bool _doClaim) external
```

### harvest

```solidity
function harvest(address _market) external
```

### setPoolInfo

```solidity
function setPoolInfo(address poolAddress, address rewarder, bool isActive) external
```

### setOperator

```solidity
function setOperator(address _address, bool _value) external
```

### setmasterPenpie

```solidity
function setmasterPenpie(address _masterPenpie) external
```

### pendleStaking

```solidity
function pendleStaking() external returns (address)
```

## IPAllActionV3

## IPendleStaticRouter

### swapExactYtForSyStatic

```solidity
function swapExactYtForSyStatic(address market, uint256 exactYtIn) external view returns (uint256 netSyOut, uint256 netSyFee, uint256 priceImpact, uint256 exchangeRateAfter, uint256 netSyOwedInt, uint256 netPYToRepaySyOwedInt, uint256 netPYToRedeemSyOutInt)
```

## IBorrowerOperations

### TroveManagerData

```solidity
struct TroveManagerData {
  address collateralToken;
  uint16 index;
}
```

### addColl

```solidity
function addColl(address, address, uint256, address, address) external
```

### openTrove

```solidity
function openTrove(address, address, uint256, uint256, uint256, address, address) external
```

### closeTrove

```solidity
function closeTrove(address troveManager, address account) external
```

### adjustTrove

```solidity
function adjustTrove(address, address, uint256, uint256, uint256, uint256, bool, address, address) external
```

### setDelegateApproval

```solidity
function setDelegateApproval(address _delegate, bool _isApproved) external
```

### troveManagersData

```solidity
function troveManagersData(address troveManager) external view returns (struct IBorrowerOperations.TroveManagerData)
```

## IDepositToken

### deposit

```solidity
function deposit(address receiver, uint256 amount) external returns (bool)
```

### withdraw

```solidity
function withdraw(address receiver, uint256 amount) external returns (bool)
```

### lpToken

```solidity
function lpToken() external view returns (address)
```

### claimReward

```solidity
function claimReward(address) external returns (uint256, uint256, uint256)
```

## IStakeNTroveZap

### TroveManagerData

```solidity
struct TroveManagerData {
  address collateralToken;
  uint16 index;
}
```

### addColl

```solidity
function addColl(address, uint256, address, address) external
```

### openTrove

```solidity
function openTrove(address troveManager, uint256 _maxFeePercentage, uint256 ethAmount, uint256 _debtAmount, address _upperHint, address _lowerHint) external
```

### borrowerOps

```solidity
function borrowerOps() external view returns (contract IBorrowerOperations)
```

### adjustTrove

```solidity
function adjustTrove(address, uint256, uint256, uint256, bool, address, address) external
```

### troveManagersData

```solidity
function troveManagersData(address troveManager) external view returns (struct IStakeNTroveZap.TroveManagerData)
```

## ITroveManager

### getTroveCollAndDebt

```solidity
function getTroveCollAndDebt(address _borrower) external view returns (uint256, uint256)
```

### debtToken

```solidity
function debtToken() external view returns (address)
```

### getNominalICR

```solidity
function getNominalICR(address _borrower) external view returns (uint256)
```

## IBaseSilo

### AssetStatus

```solidity
enum AssetStatus {
  Undefined,
  Active,
  Removed
}
```

### AssetStorage

_Storage struct that holds all required data for a single token market_

```solidity
struct AssetStorage {
  contract IShareToken collateralToken;
  contract IShareToken collateralOnlyToken;
  contract IShareToken debtToken;
  uint256 totalDeposits;
  uint256 collateralOnlyDeposits;
  uint256 totalBorrowAmount;
}
```

### AssetInterestData

_Storage struct that holds data related to fees and interest_

```solidity
struct AssetInterestData {
  uint256 harvestedProtocolFees;
  uint256 protocolFees;
  uint64 interestRateTimestamp;
  enum IBaseSilo.AssetStatus status;
}
```

### UtilizationData

data that InterestModel needs for calculations

```solidity
struct UtilizationData {
  uint256 totalDeposits;
  uint256 totalBorrowAmount;
  uint64 interestRateTimestamp;
}
```

### AssetSharesMetadata

_Shares names and symbols that are generated while asset initialization_

```solidity
struct AssetSharesMetadata {
  string collateralName;
  string collateralSymbol;
  string protectedName;
  string protectedSymbol;
  string debtName;
  string debtSymbol;
}
```

### Deposit

```solidity
event Deposit(address asset, address depositor, uint256 amount, bool collateralOnly)
```

Emitted when deposit is made

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | asset address that was deposited |
| depositor | address | wallet address that deposited asset |
| amount | uint256 | amount of asset that was deposited |
| collateralOnly | bool | type of deposit, true if collateralOnly deposit was used |

### Withdraw

```solidity
event Withdraw(address asset, address depositor, address receiver, uint256 amount, bool collateralOnly)
```

Emitted when withdraw is made

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | asset address that was withdrawn |
| depositor | address | wallet address that deposited asset |
| receiver | address | wallet address that received asset |
| amount | uint256 | amount of asset that was withdrew |
| collateralOnly | bool | type of withdraw, true if collateralOnly deposit was used |

### Borrow

```solidity
event Borrow(address asset, address user, uint256 amount)
```

Emitted on asset borrow

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | asset address that was borrowed |
| user | address | wallet address that borrowed asset |
| amount | uint256 | amount of asset that was borrowed |

### Repay

```solidity
event Repay(address asset, address user, uint256 amount)
```

Emitted on asset repay

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | asset address that was repaid |
| user | address | wallet address that repaid asset |
| amount | uint256 | amount of asset that was repaid |

### Liquidate

```solidity
event Liquidate(address asset, address user, uint256 shareAmountRepaid, uint256 seizedCollateral)
```

Emitted on user liquidation

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | asset address that was liquidated |
| user | address | wallet address that was liquidated |
| shareAmountRepaid | uint256 | amount of collateral-share token that was repaid. This is collateral token representing ownership of underlying deposit. |
| seizedCollateral | uint256 | amount of underlying token that was seized by liquidator |

### AssetStatusUpdate

```solidity
event AssetStatusUpdate(address asset, enum IBaseSilo.AssetStatus status)
```

Emitted when the status for an asset is updated

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | asset address that was updated |
| status | enum IBaseSilo.AssetStatus | new asset status |

### VERSION

```solidity
function VERSION() external returns (uint128)
```

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint128 | version of the silo contract |

### syncBridgeAssets

```solidity
function syncBridgeAssets() external
```

Synchronize current bridge assets with Silo

_This function needs to be called on Silo deployment to setup all assets for Silo. It needs to be
called every time a bridged asset is added or removed. When bridge asset is removed, depositing and borrowing
should be disabled during asset sync._

### siloRepository

```solidity
function siloRepository() external view returns (contract ISiloRepository)
```

Get Silo Repository contract address

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | contract ISiloRepository | Silo Repository contract address |

### assetStorage

```solidity
function assetStorage(address _asset) external view returns (struct IBaseSilo.AssetStorage)
```

Get asset storage data

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | asset address |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct IBaseSilo.AssetStorage | AssetStorage struct |

### interestData

```solidity
function interestData(address _asset) external view returns (struct IBaseSilo.AssetInterestData)
```

Get asset interest data

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | asset address |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct IBaseSilo.AssetInterestData | AssetInterestData struct |

### utilizationData

```solidity
function utilizationData(address _asset) external view returns (struct IBaseSilo.UtilizationData data)
```

_helper method for InterestRateModel calculations_

### isSolvent

```solidity
function isSolvent(address _user) external view returns (bool)
```

Calculates solvency of an account

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _user | address | wallet address for which solvency is calculated |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if solvent, false otherwise |

### getAssets

```solidity
function getAssets() external view returns (address[] assets)
```

Returns all initialized (synced) assets of Silo including current and removed bridge assets

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assets | address[] | array of initialized assets of Silo |

### getAssetsWithState

```solidity
function getAssetsWithState() external view returns (address[] assets, struct IBaseSilo.AssetStorage[] assetsStorage)
```

Returns all initialized (synced) assets of Silo including current and removed bridge assets
with corresponding state

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assets | address[] | array of initialized assets of Silo |
| assetsStorage | struct IBaseSilo.AssetStorage[] | array of assets state corresponding to `assets` array |

### depositPossible

```solidity
function depositPossible(address _asset, address _depositor) external view returns (bool)
```

Check if depositing an asset for given account is possible

_Depositing an asset that has been already borrowed (and vice versa) is disallowed_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | asset we want to deposit |
| _depositor | address | depositor address |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if asset can be deposited by depositor |

### borrowPossible

```solidity
function borrowPossible(address _asset, address _borrower) external view returns (bool)
```

Check if borrowing an asset for given account is possible

_Borrowing an asset that has been already deposited (and vice versa) is disallowed_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | asset we want to deposit |
| _borrower | address | borrower address |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if asset can be borrowed by borrower |

### liquidity

```solidity
function liquidity(address _asset) external view returns (uint256)
```

_Amount of token that is available for borrowing_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | asset to get liquidity for |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | Silo liquidity |

## IInterestRateModel

### Config

```solidity
struct Config {
  int256 uopt;
  int256 ucrit;
  int256 ulow;
  int256 ki;
  int256 kcrit;
  int256 klow;
  int256 klin;
  int256 beta;
  int256 ri;
  int256 Tcrit;
}
```

### setConfig

```solidity
function setConfig(address _silo, address _asset, struct IInterestRateModel.Config _config) external
```

_Set dedicated config for given asset in a Silo. Config is per asset per Silo so different assets
in different Silo can have different configs.
It will try to call `_silo.accrueInterest(_asset)` before updating config, but it is not guaranteed,
that this call will be successful, if it fail config will be set anyway._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | Silo address for which config should be set |
| _asset | address | asset address for which config should be set |
| _config | struct IInterestRateModel.Config |  |

### getCompoundInterestRateAndUpdate

```solidity
function getCompoundInterestRateAndUpdate(address _asset, uint256 _blockTimestamp) external returns (uint256 rcomp)
```

_get compound interest rate and update model storage_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | address of an asset in Silo for which interest rate should be calculated |
| _blockTimestamp | uint256 | current block timestamp |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rcomp | uint256 | compounded interest rate from last update until now (1e18 == 100%) |

### getConfig

```solidity
function getConfig(address _silo, address _asset) external view returns (struct IInterestRateModel.Config)
```

_Get config for given asset in a Silo. If dedicated config is not set, default one will be returned._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | Silo address for which config should be set |
| _asset | address | asset address for which config should be set |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct IInterestRateModel.Config | Config struct for asset in Silo |

### getCompoundInterestRate

```solidity
function getCompoundInterestRate(address _silo, address _asset, uint256 _blockTimestamp) external view returns (uint256 rcomp)
```

_get compound interest rate_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | address of Silo |
| _asset | address | address of an asset in Silo for which interest rate should be calculated |
| _blockTimestamp | uint256 | current block timestamp |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rcomp | uint256 | compounded interest rate from last update until now (1e18 == 100%) |

### getCurrentInterestRate

```solidity
function getCurrentInterestRate(address _silo, address _asset, uint256 _blockTimestamp) external view returns (uint256 rcur)
```

_get current annual interest rate_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | address of Silo |
| _asset | address | address of an asset in Silo for which interest rate should be calculated |
| _blockTimestamp | uint256 | current block timestamp |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rcur | uint256 | current annual interest rate (1e18 == 100%) |

### overflowDetected

```solidity
function overflowDetected(address _silo, address _asset, uint256 _blockTimestamp) external view returns (bool overflow)
```

get the flag to detect rcomp restriction (zero current interest) due to overflow
overflow boolean flag to detect rcomp restriction

### calculateCurrentInterestRate

```solidity
function calculateCurrentInterestRate(struct IInterestRateModel.Config _c, uint256 _totalDeposits, uint256 _totalBorrowAmount, uint256 _interestRateTimestamp, uint256 _blockTimestamp) external pure returns (uint256 rcur)
```

_pure function that calculates current annual interest rate_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _c | struct IInterestRateModel.Config | configuration object, InterestRateModel.Config |
| _totalDeposits | uint256 | current total deposits for asset |
| _totalBorrowAmount | uint256 | current total borrows for asset |
| _interestRateTimestamp | uint256 | timestamp of last interest rate update |
| _blockTimestamp | uint256 | current block timestamp |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rcur | uint256 | current annual interest rate (1e18 == 100%) |

### calculateCompoundInterestRateWithOverflowDetection

```solidity
function calculateCompoundInterestRateWithOverflowDetection(struct IInterestRateModel.Config _c, uint256 _totalDeposits, uint256 _totalBorrowAmount, uint256 _interestRateTimestamp, uint256 _blockTimestamp) external pure returns (uint256 rcomp, int256 ri, int256 Tcrit, bool overflow)
```

_pure function that calculates interest rate based on raw input data_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _c | struct IInterestRateModel.Config | configuration object, InterestRateModel.Config |
| _totalDeposits | uint256 | current total deposits for asset |
| _totalBorrowAmount | uint256 | current total borrows for asset |
| _interestRateTimestamp | uint256 | timestamp of last interest rate update |
| _blockTimestamp | uint256 | current block timestamp |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rcomp | uint256 | compounded interest rate from last update until now (1e18 == 100%) |
| ri | int256 | current integral part of the rate |
| Tcrit | int256 | time during which the utilization exceeds the critical value |
| overflow | bool | boolean flag to detect rcomp restriction |

### calculateCompoundInterestRate

```solidity
function calculateCompoundInterestRate(struct IInterestRateModel.Config _c, uint256 _totalDeposits, uint256 _totalBorrowAmount, uint256 _interestRateTimestamp, uint256 _blockTimestamp) external pure returns (uint256 rcomp, int256 ri, int256 Tcrit)
```

_pure function that calculates interest rate based on raw input data_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _c | struct IInterestRateModel.Config | configuration object, InterestRateModel.Config |
| _totalDeposits | uint256 | current total deposits for asset |
| _totalBorrowAmount | uint256 | current total borrows for asset |
| _interestRateTimestamp | uint256 | timestamp of last interest rate update |
| _blockTimestamp | uint256 | current block timestamp |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rcomp | uint256 | compounded interest rate from last update until now (1e18 == 100%) |
| ri | int256 | current integral part of the rate |
| Tcrit | int256 | time during which the utilization exceeds the critical value |

### DP

```solidity
function DP() external pure returns (uint256)
```

_returns decimal points used by model_

### interestRateModelPing

```solidity
function interestRateModelPing() external pure returns (bytes4)
```

_just a helper method to see if address is a InterestRateModel_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes4 | always true |

## INotificationReceiver

### onAfterTransfer

```solidity
function onAfterTransfer(address _token, address _from, address _to, uint256 _amount) external
```

_Informs the contract about token transfer_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _token | address | address of the token that was transferred |
| _from | address | sender |
| _to | address | receiver |
| _amount | uint256 | amount that was transferred |

### notificationReceiverPing

```solidity
function notificationReceiverPing() external pure returns (bytes4)
```

_Sanity check function_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes4 | always true |

## IPriceProvider

### getPrice

```solidity
function getPrice(address _asset) external view returns (uint256 price)
```

Returns "Time-Weighted Average Price" for an asset. Calculates TWAP price for quote/asset.
It unifies all tokens decimal to 18, examples:
- if asses == quote it returns 1e18
- if asset is USDC and quote is ETH and ETH costs ~$3300 then it returns ~0.0003e18 WETH per 1 USDC

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | address of an asset for which to read price |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| price | uint256 | of asses with 18 decimals, throws when pool is not ready yet to provide price |

### assetSupported

```solidity
function assetSupported(address _asset) external view returns (bool)
```

_Informs if PriceProvider is setup for asset. It does not means PriceProvider can provide price right away.
Some providers implementations need time to "build" buffer for TWAP price,
so price may not be available yet but this method will return true._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | asset in question |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | TRUE if asset has been setup, otherwise false |

### quoteToken

```solidity
function quoteToken() external view returns (address)
```

Gets token address in which prices are quoted

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | quoteToken address |

### priceProviderPing

```solidity
function priceProviderPing() external pure returns (bytes4)
```

Helper method that allows easily detects, if contract is PriceProvider

_this can save us from simple human errors, in case we use invalid address
but this should NOT be treated as security check_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes4 | always true |

## IPriceProvidersRepository

### NewPriceProvider

```solidity
event NewPriceProvider(contract IPriceProvider newPriceProvider)
```

Emitted when price provider is added

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newPriceProvider | contract IPriceProvider | new price provider address |

### PriceProviderRemoved

```solidity
event PriceProviderRemoved(contract IPriceProvider priceProvider)
```

Emitted when price provider is removed

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| priceProvider | contract IPriceProvider | removed price provider address |

### PriceProviderForAsset

```solidity
event PriceProviderForAsset(address asset, contract IPriceProvider priceProvider)
```

Emitted when asset is assigned to price provider

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | assigned asset   address |
| priceProvider | contract IPriceProvider | price provider address |

### addPriceProvider

```solidity
function addPriceProvider(contract IPriceProvider _priceProvider) external
```

Register new price provider

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _priceProvider | contract IPriceProvider | address of price provider |

### removePriceProvider

```solidity
function removePriceProvider(contract IPriceProvider _priceProvider) external
```

Unregister price provider

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _priceProvider | contract IPriceProvider | address of price provider to be removed |

### setPriceProviderForAsset

```solidity
function setPriceProviderForAsset(address _asset, contract IPriceProvider _priceProvider) external
```

Sets price provider for asset

_Request for asset price is forwarded to the price provider assigned to that asset_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | address of an asset for which price provider will be used |
| _priceProvider | contract IPriceProvider | address of price provider |

### getPrice

```solidity
function getPrice(address _asset) external view returns (uint256 price)
```

Returns "Time-Weighted Average Price" for an asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | address of an asset for which to read price |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| price | uint256 | TWAP price of a token with 18 decimals |

### priceProviders

```solidity
function priceProviders(address _asset) external view returns (contract IPriceProvider priceProvider)
```

Gets price provider assigned to an asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | address of an asset for which to get price provider |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| priceProvider | contract IPriceProvider | address of price provider |

### quoteToken

```solidity
function quoteToken() external view returns (address)
```

Gets token address in which prices are quoted

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | quoteToken address |

### manager

```solidity
function manager() external view returns (address)
```

Gets manager role address

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | manager role address |

### providersReadyForAsset

```solidity
function providersReadyForAsset(address _asset) external view returns (bool)
```

Checks if providers are available for an asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | asset address to check |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | returns TRUE if price feed is ready, otherwise false |

### isPriceProvider

```solidity
function isPriceProvider(contract IPriceProvider _provider) external view returns (bool)
```

Returns true if address is a registered price provider

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _provider | contract IPriceProvider | address of price provider to be removed |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if address is a registered price provider, otherwise false |

### providersCount

```solidity
function providersCount() external view returns (uint256)
```

Gets number of price providers registered

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | number of price providers registered |

### providerList

```solidity
function providerList() external view returns (address[])
```

Gets an array of price providers

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address[] | array of price providers |

### priceProvidersRepositoryPing

```solidity
function priceProvidersRepositoryPing() external pure returns (bytes4)
```

Sanity check function

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes4 | returns always TRUE |

## IShareToken

### NotificationSent

```solidity
event NotificationSent(contract INotificationReceiver notificationReceiver, bool success)
```

Emitted every time receiver is notified about token transfer

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| notificationReceiver | contract INotificationReceiver | receiver address |
| success | bool | false if TX reverted on `notificationReceiver` side, otherwise true |

### mint

```solidity
function mint(address _account, uint256 _amount) external
```

Mint method for Silo to create debt position

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _account | address | wallet for which to mint token |
| _amount | uint256 | amount of token to be minted |

### burn

```solidity
function burn(address _account, uint256 _amount) external
```

Burn method for Silo to close debt position

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _account | address | wallet for which to burn token |
| _amount | uint256 | amount of token to be burned |

## ISilo

### deposit

```solidity
function deposit(address _asset, uint256 _amount, bool _collateralOnly) external returns (uint256 collateralAmount, uint256 collateralShare)
```

Deposit `_amount` of `_asset` tokens from `msg.sender` to the Silo

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | The address of the token to deposit |
| _amount | uint256 | The amount of the token to deposit |
| _collateralOnly | bool | True if depositing collateral only |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| collateralAmount | uint256 | deposited amount |
| collateralShare | uint256 | user collateral shares based on deposited amount |

### depositFor

```solidity
function depositFor(address _asset, address _depositor, uint256 _amount, bool _collateralOnly) external returns (uint256 collateralAmount, uint256 collateralShare)
```

Router function to deposit `_amount` of `_asset` tokens to the Silo for the `_depositor`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | The address of the token to deposit |
| _depositor | address | The address of the recipient of collateral tokens |
| _amount | uint256 | The amount of the token to deposit |
| _collateralOnly | bool | True if depositing collateral only |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| collateralAmount | uint256 | deposited amount |
| collateralShare | uint256 | `_depositor` collateral shares based on deposited amount |

### withdraw

```solidity
function withdraw(address _asset, uint256 _amount, bool _collateralOnly) external returns (uint256 withdrawnAmount, uint256 withdrawnShare)
```

Withdraw `_amount` of `_asset` tokens from the Silo to `msg.sender`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | The address of the token to withdraw |
| _amount | uint256 | The amount of the token to withdraw |
| _collateralOnly | bool | True if withdrawing collateral only deposit |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| withdrawnAmount | uint256 | withdrawn amount that was transferred to user |
| withdrawnShare | uint256 | burned share based on `withdrawnAmount` |

### withdrawFor

```solidity
function withdrawFor(address _asset, address _depositor, address _receiver, uint256 _amount, bool _collateralOnly) external returns (uint256 withdrawnAmount, uint256 withdrawnShare)
```

Router function to withdraw `_amount` of `_asset` tokens from the Silo for the `_depositor`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | The address of the token to withdraw |
| _depositor | address | The address that originally deposited the collateral tokens being withdrawn, it should be the one initiating the withdrawal through the router |
| _receiver | address | The address that will receive the withdrawn tokens |
| _amount | uint256 | The amount of the token to withdraw |
| _collateralOnly | bool | True if withdrawing collateral only deposit |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| withdrawnAmount | uint256 | withdrawn amount that was transferred to `_receiver` |
| withdrawnShare | uint256 | burned share based on `withdrawnAmount` |

### borrow

```solidity
function borrow(address _asset, uint256 _amount) external returns (uint256 debtAmount, uint256 debtShare)
```

Borrow `_amount` of `_asset` tokens from the Silo to `msg.sender`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | The address of the token to borrow |
| _amount | uint256 | The amount of the token to borrow |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| debtAmount | uint256 | borrowed amount |
| debtShare | uint256 | user debt share based on borrowed amount |

### borrowFor

```solidity
function borrowFor(address _asset, address _borrower, address _receiver, uint256 _amount) external returns (uint256 debtAmount, uint256 debtShare)
```

Router function to borrow `_amount` of `_asset` tokens from the Silo for the `_receiver`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | The address of the token to borrow |
| _borrower | address | The address that will take the loan, it should be the one initiating the borrowing through the router |
| _receiver | address | The address of the asset receiver |
| _amount | uint256 | The amount of the token to borrow |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| debtAmount | uint256 | borrowed amount |
| debtShare | uint256 | `_receiver` debt share based on borrowed amount |

### repay

```solidity
function repay(address _asset, uint256 _amount) external returns (uint256 repaidAmount, uint256 burnedShare)
```

Repay `_amount` of `_asset` tokens from `msg.sender` to the Silo

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | The address of the token to repay |
| _amount | uint256 | amount of asset to repay, includes interests |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| repaidAmount | uint256 | amount repaid |
| burnedShare | uint256 | burned debt share |

### repayFor

```solidity
function repayFor(address _asset, address _borrower, uint256 _amount) external returns (uint256 repaidAmount, uint256 burnedShare)
```

Allows to repay in behalf of borrower to execute liquidation

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | The address of the token to repay |
| _borrower | address | The address of the user to have debt tokens burned |
| _amount | uint256 | amount of asset to repay, includes interests |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| repaidAmount | uint256 | amount repaid |
| burnedShare | uint256 | burned debt share |

### harvestProtocolFees

```solidity
function harvestProtocolFees() external returns (uint256[] harvestedAmounts)
```

_harvest protocol fees from an array of assets_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| harvestedAmounts | uint256[] | amount harvested during tx execution for each of silo asset |

### accrueInterest

```solidity
function accrueInterest(address _asset) external returns (uint256 interest)
```

Function to update interests for `_asset` token since the last saved state

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | The address of the token to be updated |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| interest | uint256 | accrued interest |

### flashLiquidate

```solidity
function flashLiquidate(address[] _users, bytes _flashReceiverData) external returns (address[] assets, uint256[][] receivedCollaterals, uint256[][] shareAmountsToRepaid)
```

this methods does not requires to have tokens in order to liquidate user

_during liquidation process, msg.sender will be notified once all collateral will be send to him
msg.sender needs to be `IFlashLiquidationReceiver`_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _users | address[] | array of users to liquidate |
| _flashReceiverData | bytes | this data will be forward to msg.sender on notification |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assets | address[] | array of all processed assets (collateral + debt, including removed) |
| receivedCollaterals | uint256[][] | receivedCollaterals[userId][assetId] => amount amounts of collaterals send to `_flashReceiver` |
| shareAmountsToRepaid | uint256[][] | shareAmountsToRepaid[userId][assetId] => amount required amounts of debt to be repaid |

## ISiloRepository

### Fees

_protocol fees in precision points (Solvency._PRECISION_DECIMALS), we do allow for fee == 0_

```solidity
struct Fees {
  uint64 entryFee;
  uint64 protocolShareFee;
  uint64 protocolLiquidationFee;
}
```

### SiloVersion

```solidity
struct SiloVersion {
  uint128 byDefault;
  uint128 latest;
}
```

### AssetConfig

_AssetConfig struct represents configurable parameters for each Silo_

```solidity
struct AssetConfig {
  uint64 maxLoanToValue;
  uint64 liquidationThreshold;
  contract IInterestRateModel interestRateModel;
}
```

### NewDefaultMaximumLTV

```solidity
event NewDefaultMaximumLTV(uint64 defaultMaximumLTV)
```

### NewDefaultLiquidationThreshold

```solidity
event NewDefaultLiquidationThreshold(uint64 defaultLiquidationThreshold)
```

### NewSilo

```solidity
event NewSilo(address silo, address asset, uint128 siloVersion)
```

Emitted on new Silo creation

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| silo | address | deployed Silo address |
| asset | address | unique asset for deployed Silo |
| siloVersion | uint128 | version of deployed Silo |

### BridgePool

```solidity
event BridgePool(address pool)
```

Emitted when new Silo (or existing one) becomes a bridge pool (pool with only bridge tokens).

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | address of the bridge pool, It can be zero address when bridge asset is removed and pool no longer is treated as bridge pool |

### BridgeAssetAdded

```solidity
event BridgeAssetAdded(address newBridgeAsset)
```

Emitted on new bridge asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newBridgeAsset | address | address of added bridge asset |

### BridgeAssetRemoved

```solidity
event BridgeAssetRemoved(address bridgeAssetRemoved)
```

Emitted on removed bridge asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| bridgeAssetRemoved | address | address of removed bridge asset |

### InterestRateModel

```solidity
event InterestRateModel(contract IInterestRateModel newModel)
```

Emitted when default interest rate model is changed

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newModel | contract IInterestRateModel | address of new interest rate model |

### PriceProvidersRepositoryUpdate

```solidity
event PriceProvidersRepositoryUpdate(contract IPriceProvidersRepository newProvider)
```

Emitted on price provider repository address update

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newProvider | contract IPriceProvidersRepository | address of new oracle repository |

### TokensFactoryUpdate

```solidity
event TokensFactoryUpdate(address newTokensFactory)
```

Emitted on token factory address update

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newTokensFactory | address | address of new token factory |

### RouterUpdate

```solidity
event RouterUpdate(address newRouter)
```

Emitted on router address update

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newRouter | address | address of new router |

### NotificationReceiverUpdate

```solidity
event NotificationReceiverUpdate(contract INotificationReceiver newIncentiveContract)
```

Emitted on INotificationReceiver address update

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newIncentiveContract | contract INotificationReceiver | address of new INotificationReceiver |

### RegisterSiloVersion

```solidity
event RegisterSiloVersion(address factory, uint128 siloLatestVersion, uint128 siloDefaultVersion)
```

Emitted when new Silo version is registered

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| factory | address | factory address that deploys registered Silo version |
| siloLatestVersion | uint128 | Silo version of registered Silo |
| siloDefaultVersion | uint128 | current default Silo version |

### UnregisterSiloVersion

```solidity
event UnregisterSiloVersion(address factory, uint128 siloVersion)
```

Emitted when Silo version is unregistered

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| factory | address | factory address that deploys unregistered Silo version |
| siloVersion | uint128 | version that was unregistered |

### SiloDefaultVersion

```solidity
event SiloDefaultVersion(uint128 newDefaultVersion)
```

Emitted when default Silo version is updated

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newDefaultVersion | uint128 | new default version |

### FeeUpdate

```solidity
event FeeUpdate(uint64 newEntryFee, uint64 newProtocolShareFee, uint64 newProtocolLiquidationFee)
```

Emitted when default fee is updated

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newEntryFee | uint64 | new entry fee |
| newProtocolShareFee | uint64 | new protocol share fee |
| newProtocolLiquidationFee | uint64 | new protocol liquidation fee |

### AssetConfigUpdate

```solidity
event AssetConfigUpdate(address silo, address asset, struct ISiloRepository.AssetConfig assetConfig)
```

Emitted when asset config is updated for a silo

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| silo | address | silo for which asset config is being set |
| asset | address | asset for which asset config is being set |
| assetConfig | struct ISiloRepository.AssetConfig | new asset config |

### VersionForAsset

```solidity
event VersionForAsset(address asset, uint128 version)
```

Emitted when silo (silo factory) version is set for asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | asset for which asset config is being set |
| version | uint128 | Silo version |

### getVersionForAsset

```solidity
function getVersionForAsset(address _siloAsset) external returns (uint128)
```

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _siloAsset | address | silo asset |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint128 | version of Silo that is assigned for provided asset, if not assigned it returns zero (default) |

### setVersionForAsset

```solidity
function setVersionForAsset(address _siloAsset, uint128 _version) external
```

setter for `getVersionForAsset` mapping

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _siloAsset | address | silo asset |
| _version | uint128 | version of Silo that will be assigned for `_siloAsset`, zero (default) is acceptable |

### newSilo

```solidity
function newSilo(address _siloAsset, bytes _siloData) external returns (address createdSilo)
```

use this method only when off-chain verification is OFF

_Silo does NOT support rebase and deflationary tokens_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _siloAsset | address | silo asset |
| _siloData | bytes | (optional) data that may be needed during silo creation |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| createdSilo | address | address of created silo |

### replaceSilo

```solidity
function replaceSilo(address _siloAsset, uint128 _siloVersion, bytes _siloData) external returns (address createdSilo)
```

use this method to deploy new version of Silo for an asset that already has Silo deployed.
Only owner (DAO) can replace.

_Silo does NOT support rebase and deflationary tokens_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _siloAsset | address | silo asset |
| _siloVersion | uint128 | version of silo implementation. Use 0 for default version which is fine for 99% of cases. |
| _siloData | bytes | (optional) data that may be needed during silo creation |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| createdSilo | address | address of created silo |

### setTokensFactory

```solidity
function setTokensFactory(address _tokensFactory) external
```

Set factory contract for debt and collateral tokens for each Silo asset

_Callable only by owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _tokensFactory | address | address of TokensFactory contract that deploys debt and collateral tokens |

### setFees

```solidity
function setFees(struct ISiloRepository.Fees _fees) external
```

Set default fees

_Callable only by owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _fees | struct ISiloRepository.Fees |  |

### setAssetConfig

```solidity
function setAssetConfig(address _silo, address _asset, struct ISiloRepository.AssetConfig _assetConfig) external
```

Set configuration for given asset in given Silo

_Callable only by owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | Silo address for which config applies |
| _asset | address | asset address for which config applies |
| _assetConfig | struct ISiloRepository.AssetConfig |  |

### setDefaultInterestRateModel

```solidity
function setDefaultInterestRateModel(contract IInterestRateModel _defaultInterestRateModel) external
```

Set default interest rate model

_Callable only by owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _defaultInterestRateModel | contract IInterestRateModel | default interest rate model |

### setDefaultMaximumLTV

```solidity
function setDefaultMaximumLTV(uint64 _defaultMaxLTV) external
```

Set default maximum LTV

_Callable only by owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _defaultMaxLTV | uint64 | default maximum LTV in precision points (Solvency._PRECISION_DECIMALS) |

### setDefaultLiquidationThreshold

```solidity
function setDefaultLiquidationThreshold(uint64 _defaultLiquidationThreshold) external
```

Set default liquidation threshold

_Callable only by owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _defaultLiquidationThreshold | uint64 | default liquidation threshold in precision points (Solvency._PRECISION_DECIMALS) |

### setPriceProvidersRepository

```solidity
function setPriceProvidersRepository(contract IPriceProvidersRepository _repository) external
```

Set price provider repository

_Callable only by owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _repository | contract IPriceProvidersRepository | price provider repository address |

### setRouter

```solidity
function setRouter(address _router) external
```

Set router contract

_Callable only by owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _router | address | router address |

### setNotificationReceiver

```solidity
function setNotificationReceiver(address _silo, contract INotificationReceiver _notificationReceiver) external
```

Set NotificationReceiver contract

_Callable only by owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | silo address for which to set `_notificationReceiver` |
| _notificationReceiver | contract INotificationReceiver | NotificationReceiver address |

### addBridgeAsset

```solidity
function addBridgeAsset(address _newBridgeAsset) external
```

Adds new bridge asset

_New bridge asset must be unique. Duplicates in bridge assets are not allowed. It's possible to add
bridge asset that has been removed in the past. Note that all Silos must be synced manually. Callable
only by owner._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _newBridgeAsset | address | bridge asset address |

### removeBridgeAsset

```solidity
function removeBridgeAsset(address _bridgeAssetToRemove) external
```

Removes bridge asset

_Note that all Silos must be synced manually. Callable only by owner._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _bridgeAssetToRemove | address | bridge asset address to be removed |

### unregisterSiloVersion

```solidity
function unregisterSiloVersion(uint128 _siloVersion) external
```

Unregisters Silo version

_Callable only by owner._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _siloVersion | uint128 | Silo version to be unregistered |

### setDefaultSiloVersion

```solidity
function setDefaultSiloVersion(uint128 _defaultVersion) external
```

Sets default Silo version

_Callable only by owner._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _defaultVersion | uint128 | Silo version to be set as default |

### isSilo

```solidity
function isSilo(address _silo) external view returns (bool)
```

Check if contract address is a Silo deployment

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | address of expected Silo |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if address is Silo deployment, otherwise false |

### getSilo

```solidity
function getSilo(address _asset) external view returns (address)
```

Get Silo address of asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | address of asset |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | address of corresponding Silo deployment |

### router

```solidity
function router() external view returns (address)
```

Get Router contract

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | address of router contract |

### getBridgeAssets

```solidity
function getBridgeAssets() external view returns (address[])
```

Get current bridge assets

_Keep in mind that not all Silos may be synced with current bridge assets so it's possible that some
assets in that list are not part of given Silo._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address[] | address array of bridge assets |

### getRemovedBridgeAssets

```solidity
function getRemovedBridgeAssets() external view returns (address[])
```

Get removed bridge assets

_Keep in mind that not all Silos may be synced with bridge assets so it's possible that some
assets in that list are still part of given Silo._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address[] | address array of bridge assets |

### getMaximumLTV

```solidity
function getMaximumLTV(address _silo, address _asset) external view returns (uint256)
```

Get maximum LTV for asset in given Silo

_If dedicated config is not set, method returns default config_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | address of Silo |
| _asset | address | address of an asset |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | maximum LTV in precision points (Solvency._PRECISION_DECIMALS) |

### getInterestRateModel

```solidity
function getInterestRateModel(address _silo, address _asset) external view returns (contract IInterestRateModel)
```

Get Interest Rate Model address for asset in given Silo

_If dedicated config is not set, method returns default config_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | address of Silo |
| _asset | address | address of an asset |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | contract IInterestRateModel | address of interest rate model |

### getLiquidationThreshold

```solidity
function getLiquidationThreshold(address _silo, address _asset) external view returns (uint256)
```

Get liquidation threshold for asset in given Silo

_If dedicated config is not set, method returns default config_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | address of Silo |
| _asset | address | address of an asset |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | liquidation threshold in precision points (Solvency._PRECISION_DECIMALS) |

### getNotificationReceiver

```solidity
function getNotificationReceiver(address _silo) external view returns (contract INotificationReceiver)
```

Get incentive contract address. Incentive contracts are responsible for distributing rewards
to debt and/or collateral token holders of given Silo

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | address | address of Silo |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | contract INotificationReceiver | incentive contract address |

### owner

```solidity
function owner() external view returns (address)
```

Get owner role address of Repository

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | owner role address |

### priceProvidersRepository

```solidity
function priceProvidersRepository() external view returns (contract IPriceProvidersRepository)
```

get PriceProvidersRepository contract that manages price providers implementations

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | contract IPriceProvidersRepository | IPriceProvidersRepository address |

### entryFee

```solidity
function entryFee() external view returns (uint256)
```

_Get protocol fee for opening a borrow position_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | fee in precision points (Solvency._PRECISION_DECIMALS == 100%) |

### protocolShareFee

```solidity
function protocolShareFee() external view returns (uint256)
```

_Get protocol share fee_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | protocol share fee in precision points (Solvency._PRECISION_DECIMALS == 100%) |

### protocolLiquidationFee

```solidity
function protocolLiquidationFee() external view returns (uint256)
```

_Get protocol liquidation fee_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | protocol liquidation fee in precision points (Solvency._PRECISION_DECIMALS == 100%) |

### ensureCanCreateSiloFor

```solidity
function ensureCanCreateSiloFor(address _asset, bool _assetIsABridge) external view
```

_Checks all conditions for new silo creation and throws when not possible to create_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _asset | address | address of asset for which you want to create silo |
| _assetIsABridge | bool | bool TRUE when `_asset` is bridge asset, FALSE when it is not |

### siloRepositoryPing

```solidity
function siloRepositoryPing() external pure returns (bytes4)
```

## UserInfo

```solidity
struct UserInfo {
  uint256 amount;
  uint256 rewardDebt;
}
```

## PoolInfo

```solidity
struct PoolInfo {
  address lpToken;
  uint256 allocPoint;
  uint256 lastRewardTime;
  uint256 accEmissionPerShare;
}
```

## IStargateLPStaking

### stargate

```solidity
function stargate() external view returns (address)
```

### poolInfo

```solidity
function poolInfo(uint256 _pid) external view returns (struct PoolInfo)
```

### userInfo

```solidity
function userInfo(uint256 _pid, address _user) external view returns (struct UserInfo)
```

### pendingEmissionToken

```solidity
function pendingEmissionToken(uint256 _pid, address _user) external view returns (uint256)
```

### deposit

```solidity
function deposit(uint256 _pid, uint256 _amount) external
```

### withdraw

```solidity
function withdraw(uint256 _pid, uint256 _amount) external
```

### emergencyWithdraw

```solidity
function emergencyWithdraw(uint256 _pid) external
```

## IStargatePool

### amountLPtoLD

```solidity
function amountLPtoLD(uint256 _amountLP) external view returns (uint256)
```

### token

```solidity
function token() external view returns (address)
```

## IStargateRouter

### addLiquidity

```solidity
function addLiquidity(uint256 _poolId, uint256 _amountLD, address _to) external
```

### instantRedeemLocal

```solidity
function instantRedeemLocal(uint16 _srcPoolId, uint256 _amountLP, address _to) external returns (uint256)
```

## MintParams

```solidity
struct MintParams {
  address token0;
  address token1;
  uint24 fee;
  int24 tickLower;
  int24 tickUpper;
  uint256 amount0Desired;
  uint256 amount1Desired;
  uint256 amount0Min;
  uint256 amount1Min;
  address recipient;
  uint256 deadline;
}
```

## DecreaseLiquidityParams

```solidity
struct DecreaseLiquidityParams {
  uint256 tokenId;
  uint128 liquidity;
  uint256 amount0Min;
  uint256 amount1Min;
  uint256 deadline;
}
```

## CollectParams

```solidity
struct CollectParams {
  uint256 tokenId;
  address recipient;
  uint128 amount0Max;
  uint128 amount1Max;
}
```

## IncreaseLiquidityParams

```solidity
struct IncreaseLiquidityParams {
  uint256 tokenId;
  uint256 amount0Desired;
  uint256 amount1Desired;
  uint256 amount0Min;
  uint256 amount1Min;
  uint256 deadline;
}
```

## INonfungiblePositionManager

Wraps Uniswap V3 positions in a non-fungible token interface which allows for them to be transferred
and authorized.

### positions

```solidity
function positions(uint256 tokenId) external view returns (uint96, address, address, address, uint24, int24, int24, uint128, uint256, uint256, uint128, uint128)
```

Returns the position information associated with a given token ID.

_Throws if the token ID is not valid._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token that represents the position |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint96 | nonce The nonce for permits |
| [1] | address | operator The address that is approved for spending |
| [2] | address | token0 The address of the token0 for a specific pool |
| [3] | address | token1 The address of the token1 for a specific pool |
| [4] | uint24 | fee The fee associated with the pool |
| [5] | int24 | tickLower The lower end of the tick range for the position |
| [6] | int24 | tickUpper The higher end of the tick range for the position |
| [7] | uint128 | liquidity The liquidity of the position |
| [8] | uint256 | feeGrowthInside0LastX128 The fee growth of token0 as of the last action on the individual position |
| [9] | uint256 | feeGrowthInside1LastX128 The fee growth of token1 as of the last action on the individual position |
| [10] | uint128 | tokensOwed0 The uncollected amount of token0 owed to the position as of the last computation |
| [11] | uint128 | tokensOwed1 The uncollected amount of token1 owed to the position as of the last computation |

### mint

```solidity
function mint(struct MintParams params) external payable returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1)
```

Creates a new position wrapped in a NFT

_Call this when the pool does exist and is initialized. Note that if the pool is created but not initialized
a method does not exist, i.e. the pool is assumed to be initialized._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct MintParams | The params necessary to mint a position, encoded as `MintParams` in calldata |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token that represents the minted position |
| liquidity | uint128 | The amount of liquidity for this position |
| amount0 | uint256 | The amount of token0 |
| amount1 | uint256 | The amount of token1 |

### increaseLiquidity

```solidity
function increaseLiquidity(struct IncreaseLiquidityParams params) external payable returns (uint128 liquidity, uint256 amount0, uint256 amount1)
```

Increases the amount of liquidity in a position, with tokens paid by the `msg.sender`

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct IncreaseLiquidityParams | tokenId The ID of the token for which liquidity is being increased, amount0Desired The desired amount of token0 to be spent, amount1Desired The desired amount of token1 to be spent, amount0Min The minimum amount of token0 to spend, which serves as a slippage check, amount1Min The minimum amount of token1 to spend, which serves as a slippage check, deadline The time by which the transaction must be included to effect the change |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| liquidity | uint128 | The new liquidity amount as a result of the increase |
| amount0 | uint256 | The amount of token0 to acheive resulting liquidity |
| amount1 | uint256 | The amount of token1 to acheive resulting liquidity |

### decreaseLiquidity

```solidity
function decreaseLiquidity(struct DecreaseLiquidityParams params) external payable returns (uint256 amount0, uint256 amount1)
```

Decreases the amount of liquidity in a position and accounts it to the position

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct DecreaseLiquidityParams | tokenId The ID of the token for which liquidity is being decreased, amount The amount by which liquidity will be decreased, amount0Min The minimum amount of token0 that should be accounted for the burned liquidity, amount1Min The minimum amount of token1 that should be accounted for the burned liquidity, deadline The time by which the transaction must be included to effect the change |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | uint256 | The amount of token0 accounted to the position's tokens owed |
| amount1 | uint256 | The amount of token1 accounted to the position's tokens owed |

### collect

```solidity
function collect(struct CollectParams params) external payable returns (uint256 amount0, uint256 amount1)
```

Collects up to a maximum amount of fees owed to a specific position to the recipient

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| params | struct CollectParams | tokenId The ID of the NFT for which tokens are being collected, recipient The account that should receive the tokens, amount0Max The maximum amount of token0 to collect, amount1Max The maximum amount of token1 to collect |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | uint256 | The amount of fees collected in token0 |
| amount1 | uint256 | The amount of fees collected in token1 |

### burn

```solidity
function burn(uint256 tokenId) external payable
```

Burns a token ID, which deletes it from the NFT contract. The token must have 0 liquidity and all tokens
must be collected first.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | The ID of the token that is being burned |

## IUniswapV3Factory

The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees

### getPool

```solidity
function getPool(address tokenA, address tokenB, uint24 fee) external view returns (address pool)
```

Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist

_tokenA and tokenB may be passed in either token0/token1 or token1/token0 order_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenA | address | The contract address of either token0 or token1 |
| tokenB | address | The contract address of the other token |
| fee | uint24 | The fee collected upon every swap in the pool, denominated in hundredths of a bip |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | The pool address |

## IUniswapV3Pool

These parameters are fixed for a pool forever, i.e., the methods will always return the same values

### slot0

```solidity
function slot0() external view returns (uint160, int24, uint16, uint16, uint16, uint8, bool)
```

### positions

```solidity
function positions(bytes32 key) external view returns (uint128 _liquidity, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, uint128 tokensOwed0, uint128 tokensOwed1)
```

### tickSpacing

```solidity
function tickSpacing() external view returns (int24)
```

## BalanceWithMask

```solidity
struct BalanceWithMask {
  address token;
  uint256 tokenMask;
  uint256 balance;
}
```

## BalanceDelta

```solidity
struct BalanceDelta {
  address token;
  int256 amount;
}
```

## Comparison

```solidity
enum Comparison {
  GREATER,
  LESS
}
```

## BalancesLogic

Implements functions for before-and-after balance comparisons

### checkBalance

```solidity
function checkBalance(address creditAccount, address token, uint256 value, enum Comparison comparison) internal view returns (bool)
```

_Compares current `token` balance with `value`_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| creditAccount | address |  |
| token | address | Token to check balance for |
| value | uint256 | Value to compare current token balance with |
| comparison | enum Comparison | Whether current balance must be greater/less than or equal to `value` |

### storeBalances

```solidity
function storeBalances(address creditAccount, struct BalanceDelta[] deltas) internal view returns (struct Balance[] balances)
```

_Returns an array of expected token balances after operations_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| creditAccount | address | Credit account to compute balances for |
| deltas | struct BalanceDelta[] | Array of expected token balance changes |

### compareBalances

```solidity
function compareBalances(address creditAccount, struct Balance[] balances, enum Comparison comparison) internal view returns (bool success)
```

_Compares current balances with the previously stored ones_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| creditAccount | address | Credit account to compare balances for |
| balances | struct Balance[] | Array of previously stored balances |
| comparison | enum Comparison | Whether current balances must be greater/less than or equal to stored ones |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | True if condition specified by `comparison` holds for all tokens, false otherwise |

### storeBalances

```solidity
function storeBalances(address creditAccount, uint256 tokensMask, function (uint256) view returns (address) getTokenByMaskFn) internal view returns (struct BalanceWithMask[] balances)
```

_Returns balances of specified tokens on the credit account_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| creditAccount | address | Credit account to compute balances for |
| tokensMask | uint256 | Bit mask of tokens to compute balances for |
| getTokenByMaskFn | function (uint256) view returns (address) | Function that returns token's address by its mask |

### compareBalances

```solidity
function compareBalances(address creditAccount, uint256 tokensMask, struct BalanceWithMask[] balances, enum Comparison comparison) internal view returns (bool)
```

_Compares current balances of specified tokens with the previously stored ones_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| creditAccount | address | Credit account to compare balances for |
| tokensMask | uint256 | Bit mask of tokens to compare balances for |
| balances | struct BalanceWithMask[] | Array of previously stored balances |
| comparison | enum Comparison | Whether current balances must be greater/less than or equal to stored ones |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | success True if condition specified by `comparison` holds for all tokens, false otherwise |

## UNDERLYING_TOKEN_MASK

```solidity
uint256 UNDERLYING_TOKEN_MASK
```

## BitMask

Implements functions that manipulate bit masks
        Bit masks are utilized extensively by Gearbox to efficiently store token sets (enabled tokens on accounts
        or forbidden tokens) and check for set inclusion. A mask is a uint256 number that has its i-th bit set to
        1 if i-th item is included into the set. For example, each token has a mask equal to 2**i, so set inclusion
        can be checked by checking tokenMask & setMask != 0.

### calcIndex

```solidity
function calcIndex(uint256 mask) internal pure returns (uint8 index)
```

_Calculates an index of an item based on its mask (using a binary search)
The input should always have only 1 bit set, otherwise the result may be unpredictable_

### calcEnabledTokens

```solidity
function calcEnabledTokens(uint256 enabledTokensMask) internal pure returns (uint256 totalTokensEnabled)
```

_Calculates the number of `1` bits_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| enabledTokensMask | uint256 | Bit mask to compute the number of `1` bits in |

### enable

```solidity
function enable(uint256 enabledTokenMask, uint256 bitsToEnable) internal pure returns (uint256)
```

_Enables bits from the second mask in the first mask_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| enabledTokenMask | uint256 | The initial mask |
| bitsToEnable | uint256 | Mask of bits to enable |

### disable

```solidity
function disable(uint256 enabledTokenMask, uint256 bitsToDisable) internal pure returns (uint256)
```

_Disables bits from the second mask in the first mask_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| enabledTokenMask | uint256 | The initial mask |
| bitsToDisable | uint256 | Mask of bits to disable |

### enableDisable

```solidity
function enableDisable(uint256 enabledTokensMask, uint256 bitsToEnable, uint256 bitsToDisable) internal pure returns (uint256)
```

_Computes a new mask with sets of new enabled and disabled bits
bitsToEnable and bitsToDisable are applied sequentially to original mask_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| enabledTokensMask | uint256 | The initial mask |
| bitsToEnable | uint256 | Mask with bits to enable |
| bitsToDisable | uint256 | Mask with bits to disable |

### enable

```solidity
function enable(uint256 enabledTokenMask, uint256 bitsToEnable, uint256 invertedSkipMask) internal pure returns (uint256)
```

_Enables bits from the second mask in the first mask, skipping specified bits_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| enabledTokenMask | uint256 | The initial mask |
| bitsToEnable | uint256 | Mask with bits to enable |
| invertedSkipMask | uint256 | An inversion of mask of immutable bits |

### disable

```solidity
function disable(uint256 enabledTokenMask, uint256 bitsToDisable, uint256 invertedSkipMask) internal pure returns (uint256)
```

_Disables bits from the second mask in the first mask, skipping specified bits_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| enabledTokenMask | uint256 | The initial mask |
| bitsToDisable | uint256 | Mask with bits to disable |
| invertedSkipMask | uint256 | An inversion of mask of immutable bits |

### enableDisable

```solidity
function enableDisable(uint256 enabledTokensMask, uint256 bitsToEnable, uint256 bitsToDisable, uint256 invertedSkipMask) internal pure returns (uint256)
```

_Computes a new mask with sets of new enabled and disabled bits, skipping some bits
bitsToEnable and bitsToDisable are applied sequentially to original mask. Skipmask is applied in both cases._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| enabledTokensMask | uint256 | The initial mask |
| bitsToEnable | uint256 | Mask with bits to enable |
| bitsToDisable | uint256 | Mask with bits to disable |
| invertedSkipMask | uint256 | An inversion of mask of immutable bits |

## WAD

```solidity
uint256 WAD
```

## MathLib

Library to manage fixed-point arithmetic.

### wMulDown

```solidity
function wMulDown(uint256 x, uint256 y) internal pure returns (uint256)
```

_Returns (`x` * `y`) / `WAD` rounded down._

### wDivDown

```solidity
function wDivDown(uint256 x, uint256 y) internal pure returns (uint256)
```

_Returns (`x` * `WAD`) / `y` rounded down._

### wDivUp

```solidity
function wDivUp(uint256 x, uint256 y) internal pure returns (uint256)
```

_Returns (`x` * `WAD`) / `y` rounded up._

### mulDivDown

```solidity
function mulDivDown(uint256 x, uint256 y, uint256 d) internal pure returns (uint256)
```

_Returns (`x` * `y`) / `d` rounded down._

### mulDivUp

```solidity
function mulDivUp(uint256 x, uint256 y, uint256 d) internal pure returns (uint256)
```

_Returns (`x` * `y`) / `d` rounded up._

### wTaylorCompounded

```solidity
function wTaylorCompounded(uint256 x, uint256 n) internal pure returns (uint256)
```

_Returns the sum of the first three non-zero terms of a Taylor expansion of e^(nx) - 1, to approximate a
continuous compound interest rate._

## SharesMathLib

Shares management library.

_This implementation mitigates share price manipulations, using OpenZeppelin's method of virtual shares:
https://docs.openzeppelin.com/contracts/4.x/erc4626#inflation-attack._

### VIRTUAL_SHARES

```solidity
uint256 VIRTUAL_SHARES
```

_The number of virtual shares has been chosen low enough to prevent overflows, and high enough to ensure
high precision computations._

### VIRTUAL_ASSETS

```solidity
uint256 VIRTUAL_ASSETS
```

_A number of virtual assets of 1 enforces a conversion rate between shares and assets when a market is
empty._

### toSharesDown

```solidity
function toSharesDown(uint256 assets, uint256 totalAssets, uint256 totalShares) internal pure returns (uint256)
```

_Calculates the value of `assets` quoted in shares, rounding down._

### toAssetsDown

```solidity
function toAssetsDown(uint256 shares, uint256 totalAssets, uint256 totalShares) internal pure returns (uint256)
```

_Calculates the value of `shares` quoted in assets, rounding down._

### toSharesUp

```solidity
function toSharesUp(uint256 assets, uint256 totalAssets, uint256 totalShares) internal pure returns (uint256)
```

_Calculates the value of `assets` quoted in shares, rounding up._

### toAssetsUp

```solidity
function toAssetsUp(uint256 shares, uint256 totalAssets, uint256 totalShares) internal pure returns (uint256)
```

_Calculates the value of `shares` quoted in assets, rounding up._

## Errors

### BulkInsufficientSyForTrade

```solidity
error BulkInsufficientSyForTrade(uint256 currentAmount, uint256 requiredAmount)
```

### BulkInsufficientTokenForTrade

```solidity
error BulkInsufficientTokenForTrade(uint256 currentAmount, uint256 requiredAmount)
```

### BulkInSufficientSyOut

```solidity
error BulkInSufficientSyOut(uint256 actualSyOut, uint256 requiredSyOut)
```

### BulkInSufficientTokenOut

```solidity
error BulkInSufficientTokenOut(uint256 actualTokenOut, uint256 requiredTokenOut)
```

### BulkInsufficientSyReceived

```solidity
error BulkInsufficientSyReceived(uint256 actualBalance, uint256 requiredBalance)
```

### BulkNotMaintainer

```solidity
error BulkNotMaintainer()
```

### BulkNotAdmin

```solidity
error BulkNotAdmin()
```

### BulkSellerAlreadyExisted

```solidity
error BulkSellerAlreadyExisted(address token, address SY, address bulk)
```

### BulkSellerInvalidToken

```solidity
error BulkSellerInvalidToken(address token, address SY)
```

### BulkBadRateTokenToSy

```solidity
error BulkBadRateTokenToSy(uint256 actualRate, uint256 currentRate, uint256 eps)
```

### BulkBadRateSyToToken

```solidity
error BulkBadRateSyToToken(uint256 actualRate, uint256 currentRate, uint256 eps)
```

### ApproxFail

```solidity
error ApproxFail()
```

### ApproxParamsInvalid

```solidity
error ApproxParamsInvalid(uint256 guessMin, uint256 guessMax, uint256 eps)
```

### ApproxBinarySearchInputInvalid

```solidity
error ApproxBinarySearchInputInvalid(uint256 approxGuessMin, uint256 approxGuessMax, uint256 minGuessMin, uint256 maxGuessMax)
```

### MarketExpired

```solidity
error MarketExpired()
```

### MarketZeroAmountsInput

```solidity
error MarketZeroAmountsInput()
```

### MarketZeroAmountsOutput

```solidity
error MarketZeroAmountsOutput()
```

### MarketZeroLnImpliedRate

```solidity
error MarketZeroLnImpliedRate()
```

### MarketInsufficientPtForTrade

```solidity
error MarketInsufficientPtForTrade(int256 currentAmount, int256 requiredAmount)
```

### MarketInsufficientPtReceived

```solidity
error MarketInsufficientPtReceived(uint256 actualBalance, uint256 requiredBalance)
```

### MarketInsufficientSyReceived

```solidity
error MarketInsufficientSyReceived(uint256 actualBalance, uint256 requiredBalance)
```

### MarketZeroTotalPtOrTotalAsset

```solidity
error MarketZeroTotalPtOrTotalAsset(int256 totalPt, int256 totalAsset)
```

### MarketExchangeRateBelowOne

```solidity
error MarketExchangeRateBelowOne(int256 exchangeRate)
```

### MarketProportionMustNotEqualOne

```solidity
error MarketProportionMustNotEqualOne()
```

### MarketRateScalarBelowZero

```solidity
error MarketRateScalarBelowZero(int256 rateScalar)
```

### MarketScalarRootBelowZero

```solidity
error MarketScalarRootBelowZero(int256 scalarRoot)
```

### MarketProportionTooHigh

```solidity
error MarketProportionTooHigh(int256 proportion, int256 maxProportion)
```

### OracleUninitialized

```solidity
error OracleUninitialized()
```

### OracleTargetTooOld

```solidity
error OracleTargetTooOld(uint32 target, uint32 oldest)
```

### OracleZeroCardinality

```solidity
error OracleZeroCardinality()
```

### MarketFactoryExpiredPt

```solidity
error MarketFactoryExpiredPt()
```

### MarketFactoryInvalidPt

```solidity
error MarketFactoryInvalidPt()
```

### MarketFactoryMarketExists

```solidity
error MarketFactoryMarketExists()
```

### MarketFactoryLnFeeRateRootTooHigh

```solidity
error MarketFactoryLnFeeRateRootTooHigh(uint80 lnFeeRateRoot, uint256 maxLnFeeRateRoot)
```

### MarketFactoryReserveFeePercentTooHigh

```solidity
error MarketFactoryReserveFeePercentTooHigh(uint8 reserveFeePercent, uint8 maxReserveFeePercent)
```

### MarketFactoryZeroTreasury

```solidity
error MarketFactoryZeroTreasury()
```

### MarketFactoryInitialAnchorTooLow

```solidity
error MarketFactoryInitialAnchorTooLow(int256 initialAnchor, int256 minInitialAnchor)
```

### RouterInsufficientLpOut

```solidity
error RouterInsufficientLpOut(uint256 actualLpOut, uint256 requiredLpOut)
```

### RouterInsufficientSyOut

```solidity
error RouterInsufficientSyOut(uint256 actualSyOut, uint256 requiredSyOut)
```

### RouterInsufficientPtOut

```solidity
error RouterInsufficientPtOut(uint256 actualPtOut, uint256 requiredPtOut)
```

### RouterInsufficientYtOut

```solidity
error RouterInsufficientYtOut(uint256 actualYtOut, uint256 requiredYtOut)
```

### RouterInsufficientPYOut

```solidity
error RouterInsufficientPYOut(uint256 actualPYOut, uint256 requiredPYOut)
```

### RouterInsufficientTokenOut

```solidity
error RouterInsufficientTokenOut(uint256 actualTokenOut, uint256 requiredTokenOut)
```

### RouterExceededLimitSyIn

```solidity
error RouterExceededLimitSyIn(uint256 actualSyIn, uint256 limitSyIn)
```

### RouterExceededLimitPtIn

```solidity
error RouterExceededLimitPtIn(uint256 actualPtIn, uint256 limitPtIn)
```

### RouterExceededLimitYtIn

```solidity
error RouterExceededLimitYtIn(uint256 actualYtIn, uint256 limitYtIn)
```

### RouterInsufficientSyRepay

```solidity
error RouterInsufficientSyRepay(uint256 actualSyRepay, uint256 requiredSyRepay)
```

### RouterInsufficientPtRepay

```solidity
error RouterInsufficientPtRepay(uint256 actualPtRepay, uint256 requiredPtRepay)
```

### RouterNotAllSyUsed

```solidity
error RouterNotAllSyUsed(uint256 netSyDesired, uint256 netSyUsed)
```

### RouterTimeRangeZero

```solidity
error RouterTimeRangeZero()
```

### RouterCallbackNotPendleMarket

```solidity
error RouterCallbackNotPendleMarket(address caller)
```

### RouterInvalidAction

```solidity
error RouterInvalidAction(bytes4 selector)
```

### RouterInvalidFacet

```solidity
error RouterInvalidFacet(address facet)
```

### RouterKyberSwapDataZero

```solidity
error RouterKyberSwapDataZero()
```

### YCExpired

```solidity
error YCExpired()
```

### YCNotExpired

```solidity
error YCNotExpired()
```

### YieldContractInsufficientSy

```solidity
error YieldContractInsufficientSy(uint256 actualSy, uint256 requiredSy)
```

### YCNothingToRedeem

```solidity
error YCNothingToRedeem()
```

### YCPostExpiryDataNotSet

```solidity
error YCPostExpiryDataNotSet()
```

### YCNoFloatingSy

```solidity
error YCNoFloatingSy()
```

### YCFactoryInvalidExpiry

```solidity
error YCFactoryInvalidExpiry()
```

### YCFactoryYieldContractExisted

```solidity
error YCFactoryYieldContractExisted()
```

### YCFactoryZeroExpiryDivisor

```solidity
error YCFactoryZeroExpiryDivisor()
```

### YCFactoryZeroTreasury

```solidity
error YCFactoryZeroTreasury()
```

### YCFactoryInterestFeeRateTooHigh

```solidity
error YCFactoryInterestFeeRateTooHigh(uint256 interestFeeRate, uint256 maxInterestFeeRate)
```

### YCFactoryRewardFeeRateTooHigh

```solidity
error YCFactoryRewardFeeRateTooHigh(uint256 newRewardFeeRate, uint256 maxRewardFeeRate)
```

### SYInvalidTokenIn

```solidity
error SYInvalidTokenIn(address token)
```

### SYInvalidTokenOut

```solidity
error SYInvalidTokenOut(address token)
```

### SYZeroDeposit

```solidity
error SYZeroDeposit()
```

### SYZeroRedeem

```solidity
error SYZeroRedeem()
```

### SYInsufficientSharesOut

```solidity
error SYInsufficientSharesOut(uint256 actualSharesOut, uint256 requiredSharesOut)
```

### SYInsufficientTokenOut

```solidity
error SYInsufficientTokenOut(uint256 actualTokenOut, uint256 requiredTokenOut)
```

### SYQiTokenMintFailed

```solidity
error SYQiTokenMintFailed(uint256 errCode)
```

### SYQiTokenRedeemFailed

```solidity
error SYQiTokenRedeemFailed(uint256 errCode)
```

### SYQiTokenRedeemRewardsFailed

```solidity
error SYQiTokenRedeemRewardsFailed(uint256 rewardAccruedType0, uint256 rewardAccruedType1)
```

### SYQiTokenBorrowRateTooHigh

```solidity
error SYQiTokenBorrowRateTooHigh(uint256 borrowRate, uint256 borrowRateMax)
```

### SYCurveInvalidPid

```solidity
error SYCurveInvalidPid()
```

### SYCurve3crvPoolNotFound

```solidity
error SYCurve3crvPoolNotFound()
```

### SYApeDepositAmountTooSmall

```solidity
error SYApeDepositAmountTooSmall(uint256 amountDeposited)
```

### SYBalancerInvalidPid

```solidity
error SYBalancerInvalidPid()
```

### SYInvalidRewardToken

```solidity
error SYInvalidRewardToken(address token)
```

### SYStargateRedeemCapExceeded

```solidity
error SYStargateRedeemCapExceeded(uint256 amountLpDesired, uint256 amountLpRedeemable)
```

### SYBalancerReentrancy

```solidity
error SYBalancerReentrancy()
```

### VCInactivePool

```solidity
error VCInactivePool(address pool)
```

### VCPoolAlreadyActive

```solidity
error VCPoolAlreadyActive(address pool)
```

### VCZeroVePendle

```solidity
error VCZeroVePendle(address user)
```

### VCExceededMaxWeight

```solidity
error VCExceededMaxWeight(uint256 totalWeight, uint256 maxWeight)
```

### VCEpochNotFinalized

```solidity
error VCEpochNotFinalized(uint256 wTime)
```

### VCPoolAlreadyAddAndRemoved

```solidity
error VCPoolAlreadyAddAndRemoved(address pool)
```

### VEInvalidNewExpiry

```solidity
error VEInvalidNewExpiry(uint256 newExpiry)
```

### VEExceededMaxLockTime

```solidity
error VEExceededMaxLockTime()
```

### VEInsufficientLockTime

```solidity
error VEInsufficientLockTime()
```

### VENotAllowedReduceExpiry

```solidity
error VENotAllowedReduceExpiry()
```

### VEZeroAmountLocked

```solidity
error VEZeroAmountLocked()
```

### VEPositionNotExpired

```solidity
error VEPositionNotExpired()
```

### VEZeroPosition

```solidity
error VEZeroPosition()
```

### VEZeroSlope

```solidity
error VEZeroSlope(uint128 bias, uint128 slope)
```

### VEReceiveOldSupply

```solidity
error VEReceiveOldSupply(uint256 msgTime)
```

### GCNotPendleMarket

```solidity
error GCNotPendleMarket(address caller)
```

### GCNotVotingController

```solidity
error GCNotVotingController(address caller)
```

### InvalidWTime

```solidity
error InvalidWTime(uint256 wTime)
```

### ExpiryInThePast

```solidity
error ExpiryInThePast(uint256 expiry)
```

### ChainNotSupported

```solidity
error ChainNotSupported(uint256 chainId)
```

### FDTotalAmountFundedNotMatch

```solidity
error FDTotalAmountFundedNotMatch(uint256 actualTotalAmount, uint256 expectedTotalAmount)
```

### FDEpochLengthMismatch

```solidity
error FDEpochLengthMismatch()
```

### FDInvalidPool

```solidity
error FDInvalidPool(address pool)
```

### FDPoolAlreadyExists

```solidity
error FDPoolAlreadyExists(address pool)
```

### FDInvalidNewFinishedEpoch

```solidity
error FDInvalidNewFinishedEpoch(uint256 oldFinishedEpoch, uint256 newFinishedEpoch)
```

### FDInvalidStartEpoch

```solidity
error FDInvalidStartEpoch(uint256 startEpoch)
```

### FDInvalidWTimeFund

```solidity
error FDInvalidWTimeFund(uint256 lastFunded, uint256 wTime)
```

### FDFutureFunding

```solidity
error FDFutureFunding(uint256 lastFunded, uint256 currentWTime)
```

### BDInvalidEpoch

```solidity
error BDInvalidEpoch(uint256 epoch, uint256 startTime)
```

### MsgNotFromSendEndpoint

```solidity
error MsgNotFromSendEndpoint(uint16 srcChainId, bytes path)
```

### MsgNotFromReceiveEndpoint

```solidity
error MsgNotFromReceiveEndpoint(address sender)
```

### InsufficientFeeToSendMsg

```solidity
error InsufficientFeeToSendMsg(uint256 currentFee, uint256 requiredFee)
```

### ApproxDstExecutionGasNotSet

```solidity
error ApproxDstExecutionGasNotSet()
```

### InvalidRetryData

```solidity
error InvalidRetryData()
```

### ArrayLengthMismatch

```solidity
error ArrayLengthMismatch()
```

### ArrayEmpty

```solidity
error ArrayEmpty()
```

### ArrayOutOfBounds

```solidity
error ArrayOutOfBounds()
```

### ZeroAddress

```solidity
error ZeroAddress()
```

### FailedToSendEther

```solidity
error FailedToSendEther()
```

### InvalidMerkleProof

```solidity
error InvalidMerkleProof()
```

### OnlyLayerZeroEndpoint

```solidity
error OnlyLayerZeroEndpoint()
```

### OnlyYT

```solidity
error OnlyYT()
```

### OnlyYCFactory

```solidity
error OnlyYCFactory()
```

### OnlyWhitelisted

```solidity
error OnlyWhitelisted()
```

### SAInsufficientTokenIn

```solidity
error SAInsufficientTokenIn(address tokenIn, uint256 amountExpected, uint256 amountActual)
```

### UnsupportedSelector

```solidity
error UnsupportedSelector(uint256 aggregatorType, bytes4 selector)
```

## LogExpMath

_Exponentiation and logarithm functions for 18 decimal fixed point numbers (both base and exponent/argument).

Exponentiation and logarithm with arbitrary bases (x^y and log_x(y)) are implemented by conversion to natural
exponentiation and logarithm (where the base is Euler's number)._

### ONE_18

```solidity
int256 ONE_18
```

### ONE_20

```solidity
int256 ONE_20
```

### ONE_36

```solidity
int256 ONE_36
```

### MAX_NATURAL_EXPONENT

```solidity
int256 MAX_NATURAL_EXPONENT
```

### MIN_NATURAL_EXPONENT

```solidity
int256 MIN_NATURAL_EXPONENT
```

### LN_36_LOWER_BOUND

```solidity
int256 LN_36_LOWER_BOUND
```

### LN_36_UPPER_BOUND

```solidity
int256 LN_36_UPPER_BOUND
```

### MILD_EXPONENT_BOUND

```solidity
uint256 MILD_EXPONENT_BOUND
```

### x0

```solidity
int256 x0
```

### a0

```solidity
int256 a0
```

### x1

```solidity
int256 x1
```

### a1

```solidity
int256 a1
```

### x2

```solidity
int256 x2
```

### a2

```solidity
int256 a2
```

### x3

```solidity
int256 x3
```

### a3

```solidity
int256 a3
```

### x4

```solidity
int256 x4
```

### a4

```solidity
int256 a4
```

### x5

```solidity
int256 x5
```

### a5

```solidity
int256 a5
```

### x6

```solidity
int256 x6
```

### a6

```solidity
int256 a6
```

### x7

```solidity
int256 x7
```

### a7

```solidity
int256 a7
```

### x8

```solidity
int256 x8
```

### a8

```solidity
int256 a8
```

### x9

```solidity
int256 x9
```

### a9

```solidity
int256 a9
```

### x10

```solidity
int256 x10
```

### a10

```solidity
int256 a10
```

### x11

```solidity
int256 x11
```

### a11

```solidity
int256 a11
```

### exp

```solidity
function exp(int256 x) internal pure returns (int256)
```

_Natural exponentiation (e^x) with signed 18 decimal fixed point exponent.

Reverts if `x` is smaller than MIN_NATURAL_EXPONENT, or larger than `MAX_NATURAL_EXPONENT`._

### ln

```solidity
function ln(int256 a) internal pure returns (int256)
```

_Natural logarithm (ln(a)) with signed 18 decimal fixed point argument._

### pow

```solidity
function pow(uint256 x, uint256 y) internal pure returns (uint256)
```

_Exponentiation (x^y) with unsigned 18 decimal fixed point base and exponent.

Reverts if ln(x) * y is smaller than `MIN_NATURAL_EXPONENT`, or larger than `MAX_NATURAL_EXPONENT`._

## ApproxParams

```solidity
struct ApproxParams {
  uint256 guessMin;
  uint256 guessMax;
  uint256 guessOffchain;
  uint256 maxIteration;
  uint256 eps;
}
```

## MarketApproxPtInLib

for guessOffchain, this is to provide a shortcut to guessing. The offchain SDK can precalculate the exact result
before the tx is sent. When the tx reaches the contract, the guessOffchain will be checked first, and if it satisfies the
approximation, it will be used (and save all the guessing). It's expected that this shortcut will be used in most cases
except in cases that there is a trade in the same market right before the tx

### approxSwapExactSyForYt

```solidity
function approxSwapExactSyForYt(struct MarketState market, PYIndex index, uint256 exactSyIn, uint256 blockTime, struct ApproxParams approx) internal pure returns (uint256, uint256)
```

_algorithm:
    - Bin search the amount of PT to swap in
    - Flashswap the corresponding amount of SY out
    - Pair those amount with exactSyIn SY to tokenize into PT & YT
    - PT to repay the flashswap, YT transferred to user
    - Stop when the amount of SY to be pulled to tokenize PT to repay loan approx the exactSyIn
    - guess & approx is for netYtOut (also netPtIn)_

### approxSwapPtToAddLiquidity

```solidity
function approxSwapPtToAddLiquidity(struct MarketState market, PYIndex index, uint256 totalPtIn, uint256 blockTime, struct ApproxParams approx) internal pure returns (uint256, uint256, uint256)
```

_algorithm:
    - Bin search the amount of PT to swap to SY
    - Swap PT to SY
    - Pair the remaining PT with the SY to add liquidity
    - Stop when the ratio of PT / totalPt & SY / totalSy is approx
    - guess & approx is for netPtSwap_

### calcNumerators

```solidity
function calcNumerators(struct MarketState market, PYIndex index, uint256 totalPtIn, struct MarketPreCompute comp, uint256 guess) internal pure returns (uint256 syNumerator, uint256 ptNumerator, uint256 netSyOut, uint256 netSyFee, uint256 netSyToReserve)
```

### Args7

```solidity
struct Args7 {
  struct MarketState market;
  PYIndex index;
  uint256 exactPtIn;
  uint256 blockTime;
}
```

### approxSwapExactPtForYt

```solidity
function approxSwapExactPtForYt(struct MarketState market, PYIndex index, uint256 exactPtIn, uint256 blockTime, struct ApproxParams approx) internal pure returns (uint256, uint256, uint256)
```

_algorithm:
    - Bin search the amount of PT to swap to SY
    - Flashswap the corresponding amount of SY out
    - Tokenize all the SY into PT + YT
    - PT to repay the flashswap, YT transferred to user
    - Stop when the additional amount of PT to pull to repay the loan approx the exactPtIn
    - guess & approx is for totalPtToSwap_

### calcSyOut

```solidity
function calcSyOut(struct MarketState market, struct MarketPreCompute comp, PYIndex index, uint256 netPtIn) internal pure returns (uint256 netSyOut, uint256 netSyFee, uint256 netSyToReserve)
```

### nextGuess

```solidity
function nextGuess(struct ApproxParams approx, uint256 iter) internal pure returns (uint256)
```

### validateApprox

```solidity
function validateApprox(struct ApproxParams approx) internal pure
```

INTENDED TO BE CALLED BY WHEN GUESS.OFFCHAIN == 0 ONLY ///

### calcMaxPtIn

```solidity
function calcMaxPtIn(struct MarketState market, struct MarketPreCompute comp) internal pure returns (uint256)
```

### calcSlope

```solidity
function calcSlope(struct MarketPreCompute comp, int256 totalPt, int256 ptToMarket) internal pure returns (int256)
```

## MarketApproxPtOutLib

### approxSwapExactSyForPt

```solidity
function approxSwapExactSyForPt(struct MarketState market, PYIndex index, uint256 exactSyIn, uint256 blockTime, struct ApproxParams approx) internal pure returns (uint256, uint256)
```

_algorithm:
    - Bin search the amount of PT to swapExactOut
    - Calculate the amount of SY needed
    - Stop when the netSyIn is smaller approx exactSyIn
    - guess & approx is for netSyIn_

### approxSwapYtForExactSy

```solidity
function approxSwapYtForExactSy(struct MarketState market, PYIndex index, uint256 minSyOut, uint256 blockTime, struct ApproxParams approx) internal pure returns (uint256, uint256, uint256)
```

_algorithm:
    - Bin search the amount of PT to swapExactOut
    - Flashswap that amount of PT & pair with YT to redeem SY
    - Use the SY to repay the flashswap debt and the remaining is transferred to user
    - Stop when the netSyOut is greater approx the minSyOut
    - guess & approx is for netSyOut_

### Args6

```solidity
struct Args6 {
  struct MarketState market;
  PYIndex index;
  uint256 totalSyIn;
  uint256 blockTime;
  struct ApproxParams approx;
}
```

### approxSwapSyToAddLiquidity

```solidity
function approxSwapSyToAddLiquidity(struct MarketState _market, PYIndex _index, uint256 _totalSyIn, uint256 _blockTime, struct ApproxParams _approx) internal pure returns (uint256, uint256, uint256)
```

_algorithm:
    - Bin search the amount of PT to swapExactOut
    - Swap that amount of PT out
    - Pair the remaining PT with the SY to add liquidity
    - Stop when the ratio of PT / totalPt & SY / totalSy is approx
    - guess & approx is for netPtFromSwap_

### calcSyIn

```solidity
function calcSyIn(struct MarketState market, struct MarketPreCompute comp, PYIndex index, uint256 netPtOut) internal pure returns (uint256 netSyIn, uint256 netSyFee, uint256 netSyToReserve)
```

### calcMaxPtOut

```solidity
function calcMaxPtOut(struct MarketPreCompute comp, int256 totalPt) internal pure returns (uint256)
```

### nextGuess

```solidity
function nextGuess(struct ApproxParams approx, uint256 iter) internal pure returns (uint256)
```

### validateApprox

```solidity
function validateApprox(struct ApproxParams approx) internal pure
```

## MarketState

```solidity
struct MarketState {
  int256 totalPt;
  int256 totalSy;
  int256 totalLp;
  address treasury;
  int256 scalarRoot;
  uint256 expiry;
  uint256 lnFeeRateRoot;
  uint256 reserveFeePercent;
  uint256 lastLnImpliedRate;
}
```

## MarketPreCompute

```solidity
struct MarketPreCompute {
  int256 rateScalar;
  int256 totalAsset;
  int256 rateAnchor;
  int256 feeRate;
}
```

## MarketMathCore

### MINIMUM_LIQUIDITY

```solidity
int256 MINIMUM_LIQUIDITY
```

### PERCENTAGE_DECIMALS

```solidity
int256 PERCENTAGE_DECIMALS
```

### DAY

```solidity
uint256 DAY
```

### IMPLIED_RATE_TIME

```solidity
uint256 IMPLIED_RATE_TIME
```

### MAX_MARKET_PROPORTION

```solidity
int256 MAX_MARKET_PROPORTION
```

### addLiquidity

```solidity
function addLiquidity(struct MarketState market, uint256 syDesired, uint256 ptDesired, uint256 blockTime) internal pure returns (uint256 lpToReserve, uint256 lpToAccount, uint256 syUsed, uint256 ptUsed)
```

### removeLiquidity

```solidity
function removeLiquidity(struct MarketState market, uint256 lpToRemove) internal pure returns (uint256 netSyToAccount, uint256 netPtToAccount)
```

### swapExactPtForSy

```solidity
function swapExactPtForSy(struct MarketState market, PYIndex index, uint256 exactPtToMarket, uint256 blockTime) internal pure returns (uint256 netSyToAccount, uint256 netSyFee, uint256 netSyToReserve)
```

### swapSyForExactPt

```solidity
function swapSyForExactPt(struct MarketState market, PYIndex index, uint256 exactPtToAccount, uint256 blockTime) internal pure returns (uint256 netSyToMarket, uint256 netSyFee, uint256 netSyToReserve)
```

### addLiquidityCore

```solidity
function addLiquidityCore(struct MarketState market, int256 syDesired, int256 ptDesired, uint256 blockTime) internal pure returns (int256 lpToReserve, int256 lpToAccount, int256 syUsed, int256 ptUsed)
```

### removeLiquidityCore

```solidity
function removeLiquidityCore(struct MarketState market, int256 lpToRemove) internal pure returns (int256 netSyToAccount, int256 netPtToAccount)
```

### executeTradeCore

```solidity
function executeTradeCore(struct MarketState market, PYIndex index, int256 netPtToAccount, uint256 blockTime) internal pure returns (int256 netSyToAccount, int256 netSyFee, int256 netSyToReserve)
```

### getMarketPreCompute

```solidity
function getMarketPreCompute(struct MarketState market, PYIndex index, uint256 blockTime) internal pure returns (struct MarketPreCompute res)
```

### calcTrade

```solidity
function calcTrade(struct MarketState market, struct MarketPreCompute comp, PYIndex index, int256 netPtToAccount) internal pure returns (int256 netSyToAccount, int256 netSyFee, int256 netSyToReserve)
```

### _setNewMarketStateTrade

```solidity
function _setNewMarketStateTrade(struct MarketState market, struct MarketPreCompute comp, PYIndex index, int256 netPtToAccount, int256 netSyToAccount, int256 netSyToReserve, uint256 blockTime) internal pure
```

### _getRateAnchor

```solidity
function _getRateAnchor(int256 totalPt, uint256 lastLnImpliedRate, int256 totalAsset, int256 rateScalar, uint256 timeToExpiry) internal pure returns (int256 rateAnchor)
```

### _getLnImpliedRate

```solidity
function _getLnImpliedRate(int256 totalPt, int256 totalAsset, int256 rateScalar, int256 rateAnchor, uint256 timeToExpiry) internal pure returns (uint256 lnImpliedRate)
```

Calculates the current market implied rate.

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| lnImpliedRate | uint256 | the implied rate |

### _getExchangeRateFromImpliedRate

```solidity
function _getExchangeRateFromImpliedRate(uint256 lnImpliedRate, uint256 timeToExpiry) internal pure returns (int256 exchangeRate)
```

Converts an implied rate to an exchange rate given a time to expiry. The
formula is E = e^rt

### _getExchangeRate

```solidity
function _getExchangeRate(int256 totalPt, int256 totalAsset, int256 rateScalar, int256 rateAnchor, int256 netPtToAccount) internal pure returns (int256 exchangeRate)
```

### _logProportion

```solidity
function _logProportion(int256 proportion) internal pure returns (int256 res)
```

### _getRateScalar

```solidity
function _getRateScalar(struct MarketState market, uint256 timeToExpiry) internal pure returns (int256 rateScalar)
```

### setInitialLnImpliedRate

```solidity
function setInitialLnImpliedRate(struct MarketState market, PYIndex index, int256 initialAnchor, uint256 blockTime) internal pure
```

## Math

### ONE

```solidity
uint256 ONE
```

### IONE

```solidity
int256 IONE
```

### subMax0

```solidity
function subMax0(uint256 a, uint256 b) internal pure returns (uint256)
```

### subNoNeg

```solidity
function subNoNeg(int256 a, int256 b) internal pure returns (int256)
```

### mulDown

```solidity
function mulDown(uint256 a, uint256 b) internal pure returns (uint256)
```

### mulDown

```solidity
function mulDown(int256 a, int256 b) internal pure returns (int256)
```

### divDown

```solidity
function divDown(uint256 a, uint256 b) internal pure returns (uint256)
```

### divDown

```solidity
function divDown(int256 a, int256 b) internal pure returns (int256)
```

### rawDivUp

```solidity
function rawDivUp(uint256 a, uint256 b) internal pure returns (uint256)
```

### sqrt

```solidity
function sqrt(uint256 y) internal pure returns (uint256 z)
```

### square

```solidity
function square(uint256 x) internal pure returns (uint256)
```

### abs

```solidity
function abs(int256 x) internal pure returns (uint256)
```

### neg

```solidity
function neg(int256 x) internal pure returns (int256)
```

### neg

```solidity
function neg(uint256 x) internal pure returns (int256)
```

### max

```solidity
function max(uint256 x, uint256 y) internal pure returns (uint256)
```

### max

```solidity
function max(int256 x, int256 y) internal pure returns (int256)
```

### min

```solidity
function min(uint256 x, uint256 y) internal pure returns (uint256)
```

### min

```solidity
function min(int256 x, int256 y) internal pure returns (int256)
```

### Int

```solidity
function Int(uint256 x) internal pure returns (int256)
```

### Int128

```solidity
function Int128(int256 x) internal pure returns (int128)
```

### Int128

```solidity
function Int128(uint256 x) internal pure returns (int128)
```

### Uint

```solidity
function Uint(int256 x) internal pure returns (uint256)
```

### Uint32

```solidity
function Uint32(uint256 x) internal pure returns (uint32)
```

### Uint112

```solidity
function Uint112(uint256 x) internal pure returns (uint112)
```

### Uint96

```solidity
function Uint96(uint256 x) internal pure returns (uint96)
```

### Uint128

```solidity
function Uint128(uint256 x) internal pure returns (uint128)
```

### isAApproxB

```solidity
function isAApproxB(uint256 a, uint256 b, uint256 eps) internal pure returns (bool)
```

### isAGreaterApproxB

```solidity
function isAGreaterApproxB(uint256 a, uint256 b, uint256 eps) internal pure returns (bool)
```

### isASmallerApproxB

```solidity
function isASmallerApproxB(uint256 a, uint256 b, uint256 eps) internal pure returns (bool)
```

## MiniHelpers

### isCurrentlyExpired

```solidity
function isCurrentlyExpired(uint256 expiry) internal view returns (bool)
```

### isExpired

```solidity
function isExpired(uint256 expiry, uint256 blockTime) internal pure returns (bool)
```

### isTimeInThePast

```solidity
function isTimeInThePast(uint256 timestamp) internal view returns (bool)
```

## PYIndex

## PYIndexLib

### newIndex

```solidity
function newIndex(contract IPYieldToken YT) internal returns (PYIndex)
```

### syToAsset

```solidity
function syToAsset(PYIndex index, uint256 syAmount) internal pure returns (uint256)
```

### assetToSy

```solidity
function assetToSy(PYIndex index, uint256 assetAmount) internal pure returns (uint256)
```

### assetToSyUp

```solidity
function assetToSyUp(PYIndex index, uint256 assetAmount) internal pure returns (uint256)
```

### syToAssetUp

```solidity
function syToAssetUp(PYIndex index, uint256 syAmount) internal pure returns (uint256)
```

### syToAsset

```solidity
function syToAsset(PYIndex index, int256 syAmount) internal pure returns (int256)
```

### assetToSy

```solidity
function assetToSy(PYIndex index, int256 assetAmount) internal pure returns (int256)
```

### assetToSyUp

```solidity
function assetToSyUp(PYIndex index, int256 assetAmount) internal pure returns (int256)
```

## PendleLpOracleLib

### getLpToAssetRate

```solidity
function getLpToAssetRate(contract IPMarket market, uint32 duration) internal view returns (uint256 lpToAssetRate)
```

This function returns the approximated twap rate LP/Asset on market

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | contract IPMarket | market to get rate from |
| duration | uint32 | twap duration |

## PendlePtOracleLib

### getPtToAssetRate

```solidity
function getPtToAssetRate(contract IPMarket market, uint32 duration) internal view returns (uint256 ptToAssetRate)
```

This function returns the twap rate PT/Asset on market

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| market | contract IPMarket | market to get rate from |
| duration | uint32 | twap duration |

## SYUtils

### ONE

```solidity
uint256 ONE
```

### syToAsset

```solidity
function syToAsset(uint256 exchangeRate, uint256 syAmount) internal pure returns (uint256)
```

### syToAssetUp

```solidity
function syToAssetUp(uint256 exchangeRate, uint256 syAmount) internal pure returns (uint256)
```

### assetToSy

```solidity
function assetToSy(uint256 exchangeRate, uint256 assetAmount) internal pure returns (uint256)
```

### assetToSyUp

```solidity
function assetToSyUp(uint256 exchangeRate, uint256 assetAmount) internal pure returns (uint256)
```

## EasyMathV2

_EasyMathV2 is optimised version of EasyMath, many places was `unchecked` for lower gas cost.
There is also fixed version of `calculateUtilization()` method._

### ZeroAssets

```solidity
error ZeroAssets()
```

### ZeroShares

```solidity
error ZeroShares()
```

### toShare

```solidity
function toShare(uint256 amount, uint256 totalAmount, uint256 totalShares) internal pure returns (uint256 result)
```

### toShareRoundUp

```solidity
function toShareRoundUp(uint256 amount, uint256 totalAmount, uint256 totalShares) internal pure returns (uint256 result)
```

### toAmount

```solidity
function toAmount(uint256 share, uint256 totalAmount, uint256 totalShares) internal pure returns (uint256 result)
```

### toAmountRoundUp

```solidity
function toAmountRoundUp(uint256 share, uint256 totalAmount, uint256 totalShares) internal pure returns (uint256 result)
```

### toValue

```solidity
function toValue(uint256 _assetAmount, uint256 _assetPrice, uint256 _assetDecimals) internal pure returns (uint256 value)
```

### sum

```solidity
function sum(uint256[] _numbers) internal pure returns (uint256 s)
```

### calculateUtilization

```solidity
function calculateUtilization(uint256 _dp, uint256 _totalDeposits, uint256 _totalBorrowAmount) internal pure returns (uint256 utilization)
```

Calculates fraction between borrowed and deposited amount of tokens denominated in percentage

_It assumes `_dp` = 100%._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _dp | uint256 | decimal points used by model |
| _totalDeposits | uint256 | current total deposits for assets |
| _totalBorrowAmount | uint256 | current total borrows for assets |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| utilization | uint256 | value, capped to 100% Limiting utilisation ratio by 100% max will allows us to perform better interest rate computations and should not affect any other part of protocol. |

## SolvencyV2

### TypeofLTV

@notice
MaximumLTV - Maximum Loan-to-Value ratio represents the maximum borrowing power of all user's collateral
positions in a Silo
LiquidationThreshold - Liquidation Threshold represents the threshold at which all user's borrow positions
in a Silo will be considered under collateralized and subject to liquidation

```solidity
enum TypeofLTV {
  MaximumLTV,
  LiquidationThreshold
}
```

### DifferentArrayLength

```solidity
error DifferentArrayLength()
```

### UnsupportedLTVType

```solidity
error UnsupportedLTVType()
```

### UserIsZero

```solidity
error UserIsZero()
```

### UserIsNotSolvent

```solidity
error UserIsNotSolvent()
```

### SolvencyParams

```solidity
struct SolvencyParams {
  contract ISiloRepository siloRepository;
  contract ISilo silo;
  address[] assets;
  struct IBaseSilo.AssetStorage[] assetStates;
  address user;
}
```

### _PRECISION_DECIMALS

```solidity
uint256 _PRECISION_DECIMALS
```

_is value that used for integer calculations and decimal points for utilization ratios, LTV, protocol fees_

### _INFINITY

```solidity
uint256 _INFINITY
```

### isSolvent

```solidity
function isSolvent(contract ISilo pool, address _user, uint256 liquidationThresholdMultilpier) public view returns (bool)
```

### getData

```solidity
function getData(contract ISilo pool, address _user, uint256 liquidationThresholdMultilpier) public view returns (uint256 userLTV, uint256 LiquidationThreshold, bool isSolvent)
```

### calculateLTVs

```solidity
function calculateLTVs(struct SolvencyV2.SolvencyParams _params, enum SolvencyV2.TypeofLTV _secondLtvType) internal view returns (uint256 currentUserLTV, uint256 secondLTV)
```

Returns current user LTV and second LTV chosen in params

_This function is optimized for protocol use. In some cases there is no need to keep the calculation
going and predefined results can be returned._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _params | struct SolvencyV2.SolvencyParams | `SolvencyV2.SolvencyParams` struct with needed params for calculation |
| _secondLtvType | enum SolvencyV2.TypeofLTV | type of LTV to be returned as second value |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| currentUserLTV | uint256 | Loan-to-Value ratio represents current user's proportion of debt to collateral |
| secondLTV | uint256 | second type of LTV which depends on _secondLtvType, zero is returned if the value of the loan or the collateral are zero |

### calculateLTVLimit

```solidity
function calculateLTVLimit(struct SolvencyV2.SolvencyParams _params, enum SolvencyV2.TypeofLTV _ltvType) internal view returns (uint256 limit)
```

Calculates chosen LTV limit

_This function should be used by external actors like SiloLens and UI/subgraph. `calculateLTVs` is
optimized for protocol use and may not return second LVT calculation when they are not needed._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _params | struct SolvencyV2.SolvencyParams | `SolvencyV2.SolvencyParams` struct with needed params for calculation |
| _ltvType | enum SolvencyV2.TypeofLTV | acceptable values are only TypeofLTV.MaximumLTV or TypeofLTV.LiquidationThreshold |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| limit | uint256 | theoretical LTV limit of `_ltvType` |

### getUserCollateralValues

```solidity
function getUserCollateralValues(contract IPriceProvidersRepository _priceProvidersRepository, struct SolvencyV2.SolvencyParams _params) internal view returns (uint256[] collateralValues)
```

Returns worth (in quote token) of each collateral deposit of a user

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _priceProvidersRepository | contract IPriceProvidersRepository | address of IPriceProvidersRepository where prices are read |
| _params | struct SolvencyV2.SolvencyParams | `SolvencyV2.SolvencyParams` struct with needed params for calculation |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| collateralValues | uint256[] | worth of each collateral deposit of a user as an array |

### convertAmountsToValues

```solidity
function convertAmountsToValues(contract IPriceProvidersRepository _priceProviderRepo, address[] _assets, uint256[] _amounts) internal view returns (uint256[] values)
```

Convert assets amounts to values in quote token (amount * price)

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _priceProviderRepo | contract IPriceProvidersRepository | address of IPriceProvidersRepository where prices are read |
| _assets | address[] | array with assets for which prices are read |
| _amounts | uint256[] | array of amounts |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| values | uint256[] | array of values for corresponding assets |

### getCollateralAmounts

```solidity
function getCollateralAmounts(struct SolvencyV2.SolvencyParams _params) internal view returns (uint256[] collateralAmounts)
```

Get amount of collateral for each asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _params | struct SolvencyV2.SolvencyParams | `SolvencyV2.SolvencyParams` struct with needed params for calculation |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| collateralAmounts | uint256[] | array of amounts for each token in Silo. May contain zero values if user did not deposit given collateral token. |

### getBorrowAmounts

```solidity
function getBorrowAmounts(struct SolvencyV2.SolvencyParams _params) internal view returns (uint256[] totalBorrowAmounts)
```

Get amount of debt for each asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _params | struct SolvencyV2.SolvencyParams | `SolvencyV2.SolvencyParams` struct with needed params for calculation |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| totalBorrowAmounts | uint256[] | array of amounts for each token in Silo. May contain zero values if user did not borrow given token. |

### getUserCollateralAmount

```solidity
function getUserCollateralAmount(struct IBaseSilo.AssetStorage _assetStates, uint256 _userCollateralTokenBalance, uint256 _userCollateralOnlyTokenBalance, uint256 _rcomp, contract ISiloRepository _siloRepository) internal view returns (uint256)
```

Get amount of deposited token, including collateralOnly deposits

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _assetStates | struct IBaseSilo.AssetStorage | state of deposited asset in Silo |
| _userCollateralTokenBalance | uint256 | balance of user's share collateral token |
| _userCollateralOnlyTokenBalance | uint256 | balance of user's share collateralOnly token |
| _rcomp | uint256 | compounded interest rate to account for during calculations, could be 0 |
| _siloRepository | contract ISiloRepository | SiloRepository address |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | amount of underlying token deposited, including collateralOnly deposit |

### getUserBorrowAmount

```solidity
function getUserBorrowAmount(struct IBaseSilo.AssetStorage _assetStates, address _user, uint256 _rcomp) internal view returns (uint256)
```

Get amount of borrowed token

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _assetStates | struct IBaseSilo.AssetStorage | state of borrowed asset in Silo |
| _user | address | user wallet address for which to read debt |
| _rcomp | uint256 | compounded interest rate to account for during calculations, could be 0 |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | amount of borrowed token |

### getRcomp

```solidity
function getRcomp(contract ISilo _silo, contract ISiloRepository _siloRepository, address _asset, uint256 _timestamp) internal view returns (uint256 rcomp)
```

Get compounded interest rate from the model

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _silo | contract ISilo | Silo address |
| _siloRepository | contract ISiloRepository | SiloRepository address |
| _asset | address | address of asset for which to read interest rate |
| _timestamp | uint256 | used to determine amount of time from last rate update |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rcomp | uint256 | compounded interest rate for an asset |

### totalDepositsWithInterest

```solidity
function totalDepositsWithInterest(uint256 _assetTotalDeposits, uint256 _assetTotalBorrows, uint256 _protocolShareFee, uint256 _rcomp) internal pure returns (uint256 _totalDepositsWithInterests)
```

Returns total deposits with interest dynamically calculated with the provided rComp

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _assetTotalDeposits | uint256 | total deposits for asset |
| _assetTotalBorrows | uint256 | total borrows for asset |
| _protocolShareFee | uint256 | `siloRepository.protocolShareFee()` |
| _rcomp | uint256 | compounded interest rate |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| _totalDepositsWithInterests | uint256 | total deposits amount with interest |

### totalBorrowAmountWithInterest

```solidity
function totalBorrowAmountWithInterest(uint256 _totalBorrowAmount, uint256 _rcomp) internal pure returns (uint256 totalBorrowAmountWithInterests)
```

Returns total borrow amount with interest dynamically calculated with the provided rComp

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _totalBorrowAmount | uint256 | total borrow amount |
| _rcomp | uint256 | compounded interest rate |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| totalBorrowAmountWithInterests | uint256 | total borrow amount with interest |

### calculateLiquidationFee

```solidity
function calculateLiquidationFee(uint256 _protocolEarnedFees, uint256 _amount, uint256 _liquidationFee) internal pure returns (uint256 liquidationFeeAmount, uint256 newProtocolEarnedFees)
```

Calculates protocol liquidation fee and new protocol total fees collected

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _protocolEarnedFees | uint256 | amount of total collected fees so far |
| _amount | uint256 | amount on which we will apply fee |
| _liquidationFee | uint256 | liquidation fee in SolvencyV2._PRECISION_DECIMALS |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| liquidationFeeAmount | uint256 | calculated interest |
| newProtocolEarnedFees | uint256 | the new total amount of protocol fees |

## FixedPoint96

A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)

_Used in SqrtPriceMath.sol_

### RESOLUTION

```solidity
uint8 RESOLUTION
```

### Q96

```solidity
uint256 Q96
```

## FullMath

Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision

_Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits_

### mulDiv

```solidity
function mulDiv(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result)
```

Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0

_Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| a | uint256 | The multiplicand |
| b | uint256 | The multiplier |
| denominator | uint256 | The divisor |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | uint256 | The 256-bit result |

### mulDivRoundingUp

```solidity
function mulDivRoundingUp(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result)
```

Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| a | uint256 | The multiplicand |
| b | uint256 | The multiplier |
| denominator | uint256 | The divisor |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| result | uint256 | The 256-bit result |

## LiquidityAmounts

Provides functions for computing liquidity amounts from token amounts and prices

### getLiquidityForAmount0

```solidity
function getLiquidityForAmount0(uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint256 amount0) internal pure returns (uint128 liquidity)
```

Computes the amount of liquidity received for a given amount of token0 and price range

_Calculates amount0 * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtRatioAX96 | uint160 | A sqrt price representing the first tick boundary |
| sqrtRatioBX96 | uint160 | A sqrt price representing the second tick boundary |
| amount0 | uint256 | The amount0 being sent in |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| liquidity | uint128 | The amount of returned liquidity |

### getLiquidityForAmount1

```solidity
function getLiquidityForAmount1(uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint256 amount1) internal pure returns (uint128 liquidity)
```

Computes the amount of liquidity received for a given amount of token1 and price range

_Calculates amount1 / (sqrt(upper) - sqrt(lower))._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtRatioAX96 | uint160 | A sqrt price representing the first tick boundary |
| sqrtRatioBX96 | uint160 | A sqrt price representing the second tick boundary |
| amount1 | uint256 | The amount1 being sent in |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| liquidity | uint128 | The amount of returned liquidity |

### getLiquidityForAmounts

```solidity
function getLiquidityForAmounts(uint160 sqrtRatioX96, uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint256 amount0, uint256 amount1) internal pure returns (uint128 liquidity)
```

Computes the maximum amount of liquidity received for a given amount of token0, token1, the current
pool prices and the prices at the tick boundaries

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtRatioX96 | uint160 | A sqrt price representing the current pool prices |
| sqrtRatioAX96 | uint160 | A sqrt price representing the first tick boundary |
| sqrtRatioBX96 | uint160 | A sqrt price representing the second tick boundary |
| amount0 | uint256 | The amount of token0 being sent in |
| amount1 | uint256 | The amount of token1 being sent in |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| liquidity | uint128 | The maximum amount of liquidity received |

### getAmount0ForLiquidity

```solidity
function getAmount0ForLiquidity(uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint128 liquidity) internal pure returns (uint256 amount0)
```

Computes the amount of token0 for a given amount of liquidity and a price range

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtRatioAX96 | uint160 | A sqrt price representing the first tick boundary |
| sqrtRatioBX96 | uint160 | A sqrt price representing the second tick boundary |
| liquidity | uint128 | The liquidity being valued |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | uint256 | The amount of token0 |

### getAmount1ForLiquidity

```solidity
function getAmount1ForLiquidity(uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint128 liquidity) internal pure returns (uint256 amount1)
```

Computes the amount of token1 for a given amount of liquidity and a price range

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtRatioAX96 | uint160 | A sqrt price representing the first tick boundary |
| sqrtRatioBX96 | uint160 | A sqrt price representing the second tick boundary |
| liquidity | uint128 | The liquidity being valued |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount1 | uint256 | The amount of token1 |

### getAmountsForLiquidity

```solidity
function getAmountsForLiquidity(uint160 sqrtRatioX96, uint160 sqrtRatioAX96, uint160 sqrtRatioBX96, uint128 liquidity) internal pure returns (uint256 amount0, uint256 amount1)
```

Computes the token0 and token1 value for a given amount of liquidity, the current
pool prices and the prices at the tick boundaries

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtRatioX96 | uint160 | A sqrt price representing the current pool prices |
| sqrtRatioAX96 | uint160 | A sqrt price representing the first tick boundary |
| sqrtRatioBX96 | uint160 | A sqrt price representing the second tick boundary |
| liquidity | uint128 | The liquidity being valued |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount0 | uint256 | The amount of token0 |
| amount1 | uint256 | The amount of token1 |

## OracleLibrary

Provides functions to integrate with V3 pool oracle

### consult

```solidity
function consult(address pool, uint32 secondsAgo) internal view returns (int24 arithmeticMeanTick, uint128 harmonicMeanLiquidity)
```

Calculates time-weighted means of tick and liquidity for a given Uniswap V3 pool

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | Address of the pool that we want to observe |
| secondsAgo | uint32 | Number of seconds in the past from which to calculate the time-weighted means |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| arithmeticMeanTick | int24 | The arithmetic mean tick from (block.timestamp - secondsAgo) to block.timestamp |
| harmonicMeanLiquidity | uint128 | The harmonic mean liquidity from (block.timestamp - secondsAgo) to block.timestamp |

### getQuoteAtTick

```solidity
function getQuoteAtTick(int24 tick, uint128 baseAmount, address baseToken, address quoteToken) internal pure returns (uint256 quoteAmount)
```

Given a tick and a token amount, calculates the amount of token received in exchange

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tick | int24 | Tick value used to calculate the quote |
| baseAmount | uint128 | Amount of token to be converted |
| baseToken | address | Address of an ERC20 token contract used as the baseAmount denomination |
| quoteToken | address | Address of an ERC20 token contract used as the quoteAmount denomination |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| quoteAmount | uint256 | Amount of quoteToken received for baseAmount of baseToken |

### getOldestObservationSecondsAgo

```solidity
function getOldestObservationSecondsAgo(address pool) internal view returns (uint32 secondsAgo)
```

Given a pool, it returns the number of seconds ago of the oldest stored observation

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | Address of Uniswap V3 pool that we want to observe |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| secondsAgo | uint32 | The number of seconds ago of the oldest observation stored for the pool |

### getBlockStartingTickAndLiquidity

```solidity
function getBlockStartingTickAndLiquidity(address pool) internal view returns (int24, uint128)
```

Given a pool, it returns the tick value as of the start of the current block

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | Address of Uniswap V3 pool |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | int24 | The tick that the pool was in at the start of the current block |
| [1] | uint128 |  |

### WeightedTickData

Information for calculating a weighted arithmetic mean tick

```solidity
struct WeightedTickData {
  int24 tick;
  uint128 weight;
}
```

### getWeightedArithmeticMeanTick

```solidity
function getWeightedArithmeticMeanTick(struct OracleLibrary.WeightedTickData[] weightedTickData) internal pure returns (int24 weightedArithmeticMeanTick)
```

Given an array of ticks and weights, calculates the weighted arithmetic mean tick

_Each entry of `weightedTickData` should represents ticks from pools with the same underlying pool tokens. If they do not,
extreme care must be taken to ensure that ticks are comparable (including decimal differences).
Note that the weighted arithmetic mean tick corresponds to the weighted geometric mean price._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| weightedTickData | struct OracleLibrary.WeightedTickData[] | An array of ticks and weights |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| weightedArithmeticMeanTick | int24 | The weighted arithmetic mean tick |

### getChainedPrice

```solidity
function getChainedPrice(address[] tokens, int24[] ticks) internal pure returns (int256 syntheticTick)
```

Returns the "synthetic" tick which represents the price of the first entry in `tokens` in terms of the last

_Useful for calculating relative prices along routes.
There must be one tick for each pairwise set of tokens._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokens | address[] | The token contract addresses |
| ticks | int24[] | The ticks, representing the price of each token pair in `tokens` |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| syntheticTick | int256 | The synthetic tick, representing the relative price of the outermost tokens in `tokens` |

## PoolAddress

### POOL_INIT_CODE_HASH

```solidity
bytes32 POOL_INIT_CODE_HASH
```

### PoolKey

The identifying key of the pool

```solidity
struct PoolKey {
  address token0;
  address token1;
  uint24 fee;
}
```

### getPoolKey

```solidity
function getPoolKey(address tokenA, address tokenB, uint24 fee) internal pure returns (struct PoolAddress.PoolKey)
```

Returns PoolKey: the ordered tokens with the matched fee levels

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenA | address | The first token of a pool, unsorted |
| tokenB | address | The second token of a pool, unsorted |
| fee | uint24 | The fee level of the pool |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | struct PoolAddress.PoolKey | Poolkey The pool details with ordered token0 and token1 assignments |

### computeAddress

```solidity
function computeAddress(address factory, struct PoolAddress.PoolKey key) internal pure returns (address pool)
```

Deterministically computes the pool address given the factory and PoolKey

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| factory | address | The Uniswap V3 factory contract address |
| key | struct PoolAddress.PoolKey | The PoolKey |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | address | The contract address of the V3 pool |

## TickMath

Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
prices between 2**-128 and 2**128

### MIN_TICK

```solidity
int24 MIN_TICK
```

_The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128_

### MAX_TICK

```solidity
int24 MAX_TICK
```

_The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128_

### MIN_SQRT_RATIO

```solidity
uint160 MIN_SQRT_RATIO
```

_The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)_

### MAX_SQRT_RATIO

```solidity
uint160 MAX_SQRT_RATIO
```

_The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)_

### getSqrtRatioAtTick

```solidity
function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96)
```

Calculates sqrt(1.0001^tick) * 2^96

_Throws if |tick| > max tick_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tick | int24 | The input tick for the above formula |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtPriceX96 | uint160 | A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0) at the given tick |

### getTickAtSqrtRatio

```solidity
function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick)
```

Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio

_Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
ever return._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sqrtPriceX96 | uint160 | The sqrt ratio for which to compute the tick as a Q64.96 |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| tick | int24 | The greatest tick for which the ratio is less than or equal to the input ratio |

## Keepers

Keepers multisignature wallet with a set of owners and a threshold for transaction execution

### isOwner

```solidity
mapping(address => bool) isOwner
```

### TXTYPE_HASH

```solidity
bytes32 TXTYPE_HASH
```

### nonce

```solidity
uint256 nonce
```

### threshold

```solidity
uint8 threshold
```

### numOwners

```solidity
uint256 numOwners
```

### constructor

```solidity
constructor(address[] _owners, uint8 _threshold) public
```

Constructs the Keepers multisignature wallet with a set of owners and a threshold for transaction execution

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owners | address[] | An array of addresses that will be the initial owners of the multisig wallet |
| _threshold | uint8 | The number of required approvals for a transaction to be executed |

### updateOwners

```solidity
function updateOwners(address[] _owners, bool[] addOrRemove) public
```

Updates the set of owners for the multisig wallet, allowing addition or removal of owners

_Can only be called by the wallet owner. Ensures the number of owners and the threshold are always valid._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owners | address[] | An array of addresses to be added or removed from the set of owners |
| addOrRemove | bool[] | An array of booleans corresponding to the addresses in _owners; `true` to add, `false` to remove |

### setThreshold

```solidity
function setThreshold(uint8 _threshold) public
```

Sets the threshold number of approvals required for transactions to be executed

_Can only be called by the wallet owner. The threshold must be valid within the current set of owners._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _threshold | uint8 | The new threshold number |

### execute

```solidity
function execute(address destination, uint256 value, bytes data, uint256 gasLimit, address executor, bytes32[] sigR, bytes32[] sigS, uint8[] sigV) public
```

Executes a transaction if it has been approved by the required number of owners

_Validates the signatures against the transaction details and the current nonce to prevent replay attacks.
The execute function incorporates several security measures, including:
    - Verification that the msg.sender is an owner.
    - Ensuring that the number of signatures (sigR, sigS, sigV) matches the threshold.
    - Sequentially verifying each signature to confirm it's valid, from an owner, and not reused within the same transaction (guarding against replay attacks)._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| destination | address | The address to which the transaction will be sent |
| value | uint256 | The amount of ETH (in wei) to be sent |
| data | bytes | The data payload of the transaction (same as msg.data (https://github.com/safe-global/safe-smart-account/blob/2278f7ccd502878feb5cec21dd6255b82df374b5/contracts/base/Executor.sol#L24)) |
| gasLimit | uint256 | The maximum amount of gas that the transaction is allowed to use |
| executor | address | The address executing the transaction, must be an owner |
| sigR | bytes32[] | Array of 'r' components of the signatures |
| sigS | bytes32[] | Array of 's' components of the signatures |
| sigV | uint8[] | Array of 'v' components of the signatures |

### domainSeparatorV4

```solidity
function domainSeparatorV4() public view returns (bytes32)
```

Returns the domain separator used in the EIP712 typed data signing

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes32 | The domain separator for the contract |

## NoyaGovernanceBase

### registry

```solidity
contract PositionRegistry registry
```

### vaultId

```solidity
uint256 vaultId
```

### NoyaGovernance_Unauthorized

```solidity
error NoyaGovernance_Unauthorized(address sender)
```

Reports an unauthorized access attempt

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The address of the caller attempting to access a restricted function |

### constructor

```solidity
constructor(contract PositionRegistry _registry, uint256 _vaultId) public
```

Initializes a new NoyaGovernanceBase contract with a registry and a vault ID

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _registry | contract PositionRegistry | The PositionRegistry contract that stores governance addresses and other configurations for vaults |
| _vaultId | uint256 | The unique identifier of the vault this contract will interact with |

### onlyManager

```solidity
modifier onlyManager()
```

Ensures the caller is the designated manager for the vault, either the keeper contract or the emergency manager

_Uses governance addresses from the registry to validate the caller's role_

### onlyEmergency

```solidity
modifier onlyEmergency()
```

Ensures the caller is the emergency manager for the vault

_Uses governance addresses from the registry to validate the caller's role_

### onlyEmergencyOrWatcher

```solidity
modifier onlyEmergencyOrWatcher()
```

Ensures the caller is either the emergency manager or the watcher contract for the vault

_Uses governance addresses from the registry to validate the caller's role_

### onlyMaintainerOrEmergency

```solidity
modifier onlyMaintainerOrEmergency()
```

Ensures the caller is either the maintainer or the emergency manager for the vault

_Uses governance addresses from the registry to validate the caller's role_

### onlyMaintainer

```solidity
modifier onlyMaintainer()
```

Ensures the caller is the maintainer for the vault

_Uses governance addresses from the registry to validate the caller's role_

### onlyGovernance

```solidity
modifier onlyGovernance()
```

Ensures the caller is the governance (governer) for the vault

_Uses governance addresses from the registry to validate the caller's role_

## Watchers

### verifyRemoveLiquidity

```solidity
function verifyRemoveLiquidity(uint256 withdrawAmount, uint256 sentAmount, bytes data) external view
```

## BaseConnectorCP

```solidity
struct BaseConnectorCP {
  contract PositionRegistry registry;
  uint256 vaultId;
  contract SwapAndBridgeHandler swapHandler;
  contract INoyaValueOracle valueOracle;
}
```

## BaseConnector

### swapHandler

```solidity
contract SwapAndBridgeHandler swapHandler
```

### valueOracle

```solidity
contract INoyaValueOracle valueOracle
```

### MINIMUM_HEALTH_FACTOR

```solidity
uint256 MINIMUM_HEALTH_FACTOR
```

### minimumHealthFactor

```solidity
uint256 minimumHealthFactor
```

### DUST_LEVEL

```solidity
uint256 DUST_LEVEL
```

### constructor

```solidity
constructor(struct BaseConnectorCP params) public
```

### updateMinimumHealthFactor

```solidity
function updateMinimumHealthFactor(uint256 _minimumHealthFactor) external
```

Updates the minimum health factor required for operations

_Can only be called by the contract maintainer
for the connectors that borrowing is allowed, the health factor should be higher than this value (so we keep a safe margin)_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _minimumHealthFactor | uint256 | The new minimum health factor |

### updateSwapHandler

```solidity
function updateSwapHandler(address payable _swapHandler) external
```

Updates the SwapAndBridgeHandler contract address

_swap handler is used to execute swaps and bridges_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _swapHandler | address payable | The new SwapAndBridgeHandler contract address |

### updateValueOracle

```solidity
function updateValueOracle(address _valueOracle) external
```

Updates the ValueOracle contract address

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _valueOracle | address | The new ValueOracle contract address |

### sendTokensToTrustedAddress

```solidity
function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes data) external returns (uint256)
```

Sends tokens to a trusted address

_This function is used to send tokens to trusted addresses (vault, accounting manager, swap handler)
in case the caller is the accounting manager, the function will check with the watcher contract the number of tokens to withdraw
in case the caller is a connector, the function will check if the caller is an active connector
in case the caller is the swap handler, the function will check if the caller is a valid route_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | The token address |
| amount | uint256 | The amount of tokens to send |
| caller | address | The caller address (used to verify the caller is this contract in the swapHandler) |
| data | bytes | Additional data used in the transfer |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The actual amount of tokens sent |

### transferPositionToAnotherConnector

```solidity
function transferPositionToAnotherConnector(address[] tokens, uint256[] amounts, bytes data, address connector) external
```

Transfers position to another connector

_the flow is :
1. check if the connector is active
2. call the addLiquidity function in the target connector
3. destination connector will call the sendTokensToTrustedAddress function to transfer the tokens
4. update the position in the registry for both connectors_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokens | address[] | The addresses of tokens involved |
| amounts | uint256[] | The amounts for each token |
| data | bytes | Additional data for liquidity adding |
| connector | address | The target connector address |

### _updateTokenInRegistry

```solidity
function _updateTokenInRegistry(address token, bool remove) internal
```

### updateTokenInRegistry

```solidity
function updateTokenInRegistry(address token) public
```

Updates the token registry to reflect the current balance of a specified token. It can add a new token to the registry or remove a token with zero balance.

_This function is called to ensure the registry is accurate after liquidity is added, removed, or swaps are performed. It should reflect the current state of tokens held by this connector._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | The address of the token to update in the registry. |

### _updateTokenInRegistry

```solidity
function _updateTokenInRegistry(address token) internal
```

adds or removes the token position to the registry based on the balance of the token

### addLiquidity

```solidity
function addLiquidity(address[] tokens, uint256[] amounts, bytes data) external
```

Adds liquidity to this connector

_This function is called to add liquidity to this connector. It should be implemented in the connector contract to handle the specific liquidity adding process for the connector by overriding the _addLiquidity function (optional)._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokens | address[] | The addresses of tokens to add as liquidity |
| amounts | uint256[] | The amounts of each token to add |
| data | bytes | Additional data needed for adding liquidity |

### swapHoldings

```solidity
function swapHoldings(address[] tokensIn, address[] tokensOut, uint256[] amountsIn, bytes[] swapData, uint256[] routeIds) external
```

Executes swaps for holdings from one set of tokens to another

_the check slippage is set to true, so the swapHandler will revert if the slippage is higher than the allowed_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokensIn | address[] | The addresses of input tokens for the swaps |
| tokensOut | address[] | The addresses of output tokens for the swaps |
| amountsIn | uint256[] | The input amounts for each swap |
| swapData | bytes[] | The data required for executing each swap |
| routeIds | uint256[] | The route IDs for each swap (used to verify the route in the swapHandler) |

### _executeSwap

```solidity
function _executeSwap(struct SwapRequest swapRequest) internal returns (uint256 amountOut)
```

### getUnderlyingTokens

```solidity
function getUnderlyingTokens(uint256 positionTypeId, bytes data) public view returns (address[])
```

Retrieves the underlying tokens associated with a position type and data

_each connector should implement this function to return the underlying tokens for the position type and data_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| positionTypeId | uint256 | The type ID of the position |
| data | bytes | Additional data relevant to the position |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address[] | An array of addresses of the underlying tokens |

### getPositionTVL

```solidity
function getPositionTVL(struct HoldingPI p, address baseToken) public view returns (uint256)
```

the TVLHelper library uses this function to calculate the TVL of a position

_each connector should implement this function to calculate the TVL of the position
the holding position is the data that was sent to the connector to create the position_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| p | struct HoldingPI | The holding position information |
| baseToken | address | The base currency for the TVL calculation |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The TVL of the position in the base currency units |

### _getValue

```solidity
function _getValue(address token, address baseToken, uint256 amount) internal view returns (uint256)
```

### _getUnderlyingTokens

```solidity
function _getUnderlyingTokens(uint256, bytes) public view virtual returns (address[])
```

### _addLiquidity

```solidity
function _addLiquidity(address[], uint256[], bytes) internal virtual returns (bool)
```

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI, address) public view virtual returns (uint256 tvl)
```

### _approveOperations

```solidity
function _approveOperations(address _token, address _spender, uint256 _amount) internal virtual
```

is used to approve the _spender to spend the _amount of the _token

_It uses the forceApprove function so it's safe to use it with tokens with special approval logic (USDT)_

### _revokeApproval

```solidity
function _revokeApproval(address _token, address _spender) internal virtual
```

## ChainInfo

```solidity
struct ChainInfo {
  uint256 chainId;
  address lzHelperAddress;
}
```

## VaultInfo

```solidity
struct VaultInfo {
  uint256 baseChainId;
  address omniChainManager;
}
```

## LZHelperReceiver

### chainInfo

```solidity
mapping(uint32 => struct ChainInfo) chainInfo
```

### vaultIdToVaultInfo

```solidity
mapping(uint256 => struct VaultInfo) vaultIdToVaultInfo
```

### InvalidPayload

```solidity
error InvalidPayload()
```

### TVL_UPDATE

```solidity
uint32 TVL_UPDATE
```

### constructor

```solidity
constructor(address _endpoint, address _owner) public
```

Constructs the LZHelperReceiver contract

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _endpoint | address | The LayerZero endpoint address for cross-chain communication |
| _owner | address | The address that will own the LZHelperReceiver contract, typically a governance or deployer address with the ability to execute administrative functions |

### setChainInfo

```solidity
function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public
```

Sets the information for a chain where LayerZero messages can be received from

_This function allows the contract owner to map a LayerZero chain ID to its corresponding chain information, including the native chain ID and the address of a helper contract specific to LayerZero on that chain._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| chainId | uint256 | The native chain ID of the blockchain (e.g., Ethereum Mainnet, Binance Smart Chain) |
| lzChainId | uint32 | The LayerZero chain ID corresponding to the chainId |
| lzHelperAddress | address | The address of the helper contract deployed on the chainId that interacts with LayerZero for cross-chain messaging |

### addVaultInfo

```solidity
function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public
```

Sets the information for a vault where TVL updates can be received from

_This function allows the contract owner to map a vault ID to its corresponding chain information, including the base chain ID and the address of the OmniChainManager contract that manages the vault on the base chain._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| vaultId | uint256 | The ID of the vault |
| baseChainId | uint256 | The native chain ID of the blockchain where the vault is managed |
| omniChainManager | address | The address of the OmniChainManager contract that manages the vault on the base chain |

### _lzReceive

```solidity
function _lzReceive(struct Origin _origin, bytes32, bytes _message, address, bytes) internal
```

Handles the receipt of a cross-chain message via LayerZero

_Overrides the `_lzReceive` function from `OAppReceiver` to process incoming messages. It's designed to decode the received message containing TVL update information for a specific vault and then call the associated OmnichainManager to update the TVL accordingly._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _origin | struct Origin | Struct containing information about the origin chain of the message, including the LayerZero chain ID and other metadata |
|  | bytes32 |  |
| _message | bytes | The encoded message data containing the vault ID, updated TVL value, and the timestamp of the update This function decodes the message and then utilizes the `OmnichainManagerBaseChain` contract associated with the specified vault to update its TVL. It ensures that messages are processed only from configured chains and vaults to maintain data integrity and security. |
|  | address |  |
|  | bytes |  |

## ChainInfo

```solidity
struct ChainInfo {
  uint32 lzChainId;
  address lzHelperAddress;
}
```

## VaultInfo

```solidity
struct VaultInfo {
  uint256 baseChainId;
  address omniChainManager;
}
```

## LZHelperSender

### chainInfo

```solidity
mapping(uint256 => struct ChainInfo) chainInfo
```

### vaultIdToVaultInfo

```solidity
mapping(uint256 => struct VaultInfo) vaultIdToVaultInfo
```

### messageSetting

```solidity
bytes messageSetting
```

### InvalidSender

```solidity
error InvalidSender()
```

### receive

```solidity
receive() external payable
```

### constructor

```solidity
constructor(address _endpoint, address _owner) public
```

### updateMessageSetting

```solidity
function updateMessageSetting(bytes _messageSetting) public
```

Updates the message setting for LayerZero sends

_Allows the owner to configure how messages are sent through LayerZero, adjusting parameters like gas limits or message fees._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _messageSetting | bytes | The new message settings to be used for LayerZero sends (see https://docs.layerzero.network/contracts/options) |

### _payNative

```solidity
function _payNative(uint256 amount) internal returns (uint256)
```

### setChainInfo

```solidity
function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public
```

Registers the destination chain information for a specific blockchain

_Stores LayerZero-specific identifiers and helper contract addresses for cross-chain communication to a specified chain._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| chainId | uint256 | The native blockchain ID being registered |
| lzChainId | uint32 | The corresponding LayerZero chain ID |
| lzHelperAddress | address | The address of the helper contract on the destination chain |

### addVaultInfo

```solidity
function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public
```

Adds information about a vault to enable TVL updates

_Maps a vault ID to its corresponding base chain ID and omnichain manager contract, setting up the infrastructure for cross-chain TVL updates._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| vaultId | uint256 | The unique identifier for the vault |
| baseChainId | uint256 | The blockchain ID where the vault primarily operates (where the accountingManager is deployed) |
| omniChainManager | address | The address of the omnichain manager contract associated with the vault |

### updateTVL

```solidity
function updateTVL(uint256 vaultId, uint256 tvl, uint256 updateTime) public
```

Sends a TVL update for a specified vault to its base chain

_Constructs and sends a message containing the vault ID, new TVL, and the time of the update through LayerZero. This function can only be called by the vault's omnichain manager.
only the omnichain manager of this vault can call this function_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| vaultId | uint256 | The ID of the vault for which TVL is being updated |
| tvl | uint256 | The new Total Value Locked amount |
| updateTime | uint256 | The timestamp of the TVL update |

## OmnichainLogic

OmnichainLogic is a base contract for OmnichainManagerBaseChain and OmnichainManagerNormalChain, which are used to manage cross-chain communication and transactions.
    Key Components and Design Considerations
    - Mapping Addresses for Cross-Chain Bridges: At its core, the contract uses something called destChainAddress mapping. This is essentially a way to keep track of where assets should be sent across different blockchain networks. It's a crucial part of making sure that when assets are bridged, they end up exactly where they're supposed to, maintaining accuracy across a complex web of chains.

    - A Two-Step Approval for Transactions: Before any asset can make the jump to another chain, the contract requires each transaction to be approved not once, but twice. First, someone needs to give the green light indicating that the transaction is okay (that's where updateBridgeTransactionApproval comes into play). Then, and only then, can the actual transaction process begin (startBridgeTransaction). This double-check adds an extra layer of security, ensuring every transaction is intended and verified.

### lzHelper

```solidity
address payable lzHelper
```

### BRIDGE_TXN_WAITING_TIME

```solidity
uint256 BRIDGE_TXN_WAITING_TIME
```

### destChainAddress

```solidity
mapping(uint256 => address) destChainAddress
```

### approvedBridgeTXN

```solidity
mapping(bytes32 => uint256) approvedBridgeTXN
```

### constructor

```solidity
constructor(address payable _lzHelper, struct BaseConnectorCP baseConnectorParams) internal
```

Initializes the OmnichainLogic contract with the address of the LayerZero helper contract and base connector parameters

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _lzHelper | address payable | Address of the LayerZero helper contract responsible for managing cross-chain communication (in OmnichainManagerNormalChain this is LZHelperSender and in OmnichainManagerBaseChain this is LZHelperReceiver) |
| baseConnectorParams | struct BaseConnectorCP | Parameters for initializing the base connector functionalities |

### updateChainInfo

```solidity
function updateChainInfo(uint256 chainId, address destinationAddress) external
```

Updates the address to which bridge transactions will be sent on a specified destination chain

_This function allows the maintainer to set or update the destination address for each supported chain, facilitating targeted cross-chain transactions._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| chainId | uint256 | The identifier of the destination chain |
| destinationAddress | address | The address on the destination chain to which assets will be bridged |

### updateBridgeTransactionApproval

```solidity
function updateBridgeTransactionApproval(bytes32 transactionHash) public
```

Marks a bridge transaction as approved or revokes approval based on its current state

_This toggles the approval state of a bridge transaction identified by its hash. If previously unapproved or expired, it approves it; if already approved, it revokes approval._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| transactionHash | bytes32 | The hash of the bridge transaction to be toggled |

### startBridgeTransaction

```solidity
function startBridgeTransaction(struct BridgeRequest bridgeRequest) public
```

Initiates a bridge transaction if it has been approved and the waiting time has passed

_Validates the bridge request against approvals and destination chain information before executing the bridge transaction via the `GenericSwapAndBridgeHandler`._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| bridgeRequest | struct BridgeRequest | A struct containing details of the bridge transaction, including source and destination chain IDs, addresses, and token information |

## OmnichainManagerBaseChain

### OMNICHAIN_POSITION_ID

```solidity
uint256 OMNICHAIN_POSITION_ID
```

### constructor

```solidity
constructor(uint256 dl, address payable _lzHelper, struct BaseConnectorCP baseConnectorParams) public
```

Initializes the OmnichainManagerBaseChain with specific parameters for omnichain operations.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| dl | uint256 | The threshold below which the TVL is considered negligible or "dust." |
| _lzHelper | address payable | The address of the LayerZero helper contract, facilitating cross-chain communications. |
| baseConnectorParams | struct BaseConnectorCP | Struct containing parameters needed for initializing the base connector. |

### updateTVL

```solidity
function updateTVL(uint256 chainId, uint256 tvl, uint256 updateTime) external
```

Updates the TVL for a specific chain ID based on cross-chain data received and adds it to the position.

_This function is called by the LayerZero helper to adjust the TVL in response to changes detected on other chains. It's critical for maintaining an accurate and up-to-date reflection of the assets managed across the entire ecosystem._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| chainId | uint256 | The ID of the chain where the TVL update originated. |
| tvl | uint256 | The new TVL figure to be recorded. |
| updateTime | uint256 | The timestamp when the update was made, ensuring that the data remains timely and relevant. |

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI position, address) public view returns (uint256)
```

Calculates the TVL for a position identified by the OMNICHAIN_POSITION_ID.

_Overrides the `_getPositionTVL` function from `OmnichainLogic` to provide specific logic for interpreting TVL data related to omnichain positions on the base chain._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| position | struct HoldingPI | Struct containing details about the specific holding position being queried. |
|  | address |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The TVL associated with the specified omnichain position, derived from additional data stored in the position. |

## OmnichainManagerNormalChain

### constructor

```solidity
constructor(address payable _lzHelper, struct BaseConnectorCP baseConnectorParams) public
```

### getTVL

```solidity
function getTVL() public view returns (uint256)
```

Fetches the current TVL of the vault associated with this contract on the normal (non-base) chain.

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The current TVL calculated using the TVLHelper utility, which aggregates the value of assets managed by the vault on this chain. |

### updateTVLInfo

```solidity
function updateTVLInfo() external
```

Triggers an update of the vault's TVL information, sending the latest data to the base chain via the LZHelperSender contract.
This function is restricted to be called by managers only, ensuring that TVL updates are controlled and authorized.

### _getPositionTVL

```solidity
function _getPositionTVL(struct HoldingPI position, address base) public view returns (uint256)
```

## SwapAndBridgeHandler

### isEligibleToUse

```solidity
mapping(address => bool) isEligibleToUse
```

### valueOracle

```solidity
contract INoyaValueOracle valueOracle
```

### slippageTolerance

```solidity
mapping(address => mapping(address => uint256)) slippageTolerance
```

### genericSlippageTolerance

```solidity
uint256 genericSlippageTolerance
```

### routes

```solidity
struct RouteData[] routes
```

### onlyEligibleUser

```solidity
modifier onlyEligibleUser()
```

### onlyExistingRoute

```solidity
modifier onlyExistingRoute(uint256 _routeId)
```

### constructor

```solidity
constructor(address[] usersAddresses, address _valueOracle, contract PositionRegistry _registry, uint256 _vaultId) public
```

### setValueOracle

```solidity
function setValueOracle(address _valueOracle) external
```

### setGeneralSlippageTolerance

```solidity
function setGeneralSlippageTolerance(uint256 _slippageTolerance) external
```

### setSlippageTolerance

```solidity
function setSlippageTolerance(address _inputToken, address _outputToken, uint256 _slippageTolerance) external
```

### addEligibleUser

```solidity
function addEligibleUser(address _user) external
```

### executeSwap

```solidity
function executeSwap(struct SwapRequest _swapRequest) external payable returns (uint256 _amountOut)
```

// @notice function responsible for calling the respective implementation
    // depending on the dex to be used
    // @param _swapRequest calldata follows the input data struct

### executeBridge

```solidity
function executeBridge(struct BridgeRequest _bridgeRequest) external payable
```

### _isNative

```solidity
function _isNative(address token) internal pure returns (bool isNative)
```

### addRoutes

```solidity
function addRoutes(struct RouteData[] _routes) public
```

### setEnableRoute

```solidity
function setEnableRoute(uint256 _routeId, bool enable) external
```

disables the route  if required.

### verifyRoute

```solidity
function verifyRoute(uint256 _routeId, address addr) external view
```

## TVLHelper

### getTVL

```solidity
function getTVL(uint256 vaultId, contract PositionRegistry registry, address baseToken) public view returns (uint256)
```

Get the total value locked in the vault

_This function gets the holding positions from the registry and loops through them to get the TVL_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| vaultId | uint256 | The vault id |
| registry | contract PositionRegistry | The position registry |
| baseToken | address | The base token |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The total value locked based on the base token |

### getLatestUpdateTime

```solidity
function getLatestUpdateTime(uint256 vaultId, contract PositionRegistry registry) public view returns (uint256)
```

Get the oldest update time of the holding positions

_in case we have a position that we can't fetch the latest update at the moment, we get the oldest update time of all of them to avoid any issues with the TVL_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| vaultId | uint256 | The vault id |
| registry | contract PositionRegistry | The position registry |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The oldest update time |

## NoyaValueOracle

This contract is used to get the value of an asset in terms of a base Token

### registry

```solidity
contract PositionRegistry registry
```

### defaultPriceSource

```solidity
mapping(address => contract INoyaValueOracle) defaultPriceSource
```

Default price sources for base currencies

### priceRoutes

```solidity
mapping(address => mapping(address => address[])) priceRoutes
```

### priceSource

```solidity
mapping(address => mapping(address => contract INoyaValueOracle)) priceSource
```

Price sources for assets

### NoyaOracle_PriceOracleUnavailable

```solidity
error NoyaOracle_PriceOracleUnavailable(address asset, address baseToken)
```

### onlyMaintainer

```solidity
modifier onlyMaintainer()
```

### constructor

```solidity
constructor(contract PositionRegistry _registry) public
```

### updateDefaultPriceSource

```solidity
function updateDefaultPriceSource(address[] baseCurrencies, contract INoyaValueOracle[] oracles) public
```

Adds a default price source for a base Token

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| baseCurrencies | address[] | The address of the base Token |
| oracles | contract INoyaValueOracle[] | The array of oracle connectors |

### updateAssetPriceSource

```solidity
function updateAssetPriceSource(address[] asset, address[] baseToken, address[] oracle) external
```

Adds a price source for an asset

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address[] | The address of the asset |
| baseToken | address[] | The address of the base Token |
| oracle | address[] | The array of oracle connectors |

### updatePriceRoute

```solidity
function updatePriceRoute(address asset, address base, address[] s) external
```

### getValue

```solidity
function getValue(address asset, address baseToken, uint256 amount) public view returns (uint256)
```

Gets the value of an asset in terms of a base Token, considering a specific number of sources

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| asset | address | The address of the asset |
| baseToken | address | The address of the base Token |
| amount | uint256 | The amount of the asset |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The value of the asset in terms of the base Token |

### _getValue

```solidity
function _getValue(address asset, address baseToken, uint256 amount, address[] sources) internal view returns (uint256 value)
```

### _getValue

```solidity
function _getValue(address quotingToken, address baseToken, uint256 amount) internal view returns (uint256)
```

## ChainlinkOracleConnector

### registry

```solidity
contract PositionRegistry registry
```

### chainlinkPriceAgeThreshold

```solidity
uint256 chainlinkPriceAgeThreshold
```

The threshold for the age of the price data

### ETH

```solidity
address ETH
```

### USD

```solidity
address USD
```

### AssetSourceUpdated

```solidity
event AssetSourceUpdated(address asset, address baseToken, address source)
```

-----------------------------------------------------------------------
Events
-----------------------------------------------------------------------

### NoyaChainlinkOracle_DATA_OUT_OF_DATE

```solidity
error NoyaChainlinkOracle_DATA_OUT_OF_DATE()
```

-----------------------------------------------------------------------
Errors
-----------------------------------------------------------------------

### NoyaChainlinkOracle_PRICE_ORACLE_UNAVAILABLE

```solidity
error NoyaChainlinkOracle_PRICE_ORACLE_UNAVAILABLE(address asset, address baseToken, address source)
```

### NoyaChainlinkOracle_INVALID_INPUT

```solidity
error NoyaChainlinkOracle_INVALID_INPUT()
```

### onlyMaintainer

```solidity
modifier onlyMaintainer()
```

### constructor

```solidity
constructor(address _reg) public
```

### updateChainlinkPriceAgeThreshold

```solidity
function updateChainlinkPriceAgeThreshold(uint256 _chainlinkPriceAgeThreshold) external
```

### setAssetSources

```solidity
function setAssetSources(address[] assets, address[] baseTokens, address[] sources) external
```

### getValue

```solidity
function getValue(address asset, address baseToken, uint256 amount) public view returns (uint256)
```

### getValueFromChainlinkFeed

```solidity
function getValueFromChainlinkFeed(contract AggregatorV3Interface source, uint256 amountIn, uint256 sourceTokenUnit, bool isInverse) public view returns (uint256)
```

### getTokenDecimals

```solidity
function getTokenDecimals(address token) public view returns (uint256)
```

Gets the decimals of a token

### getSourceOfAsset

```solidity
function getSourceOfAsset(address asset, address baseToken) public view returns (address source, bool isInverse)
```

## UniswapValueOracle

This contract is used to get the Value of a token from Uniswap V3

### assetToBaseToPool

```solidity
mapping(address => mapping(address => address)) assetToBaseToPool
```

### factory

```solidity
address factory
```

### registry

```solidity
contract PositionRegistry registry
```

### period

```solidity
uint32 period
```

### NewPeriod

```solidity
event NewPeriod(uint32 period)
```

### PoolsForAsset

```solidity
event PoolsForAsset(address asset, address base, address pool)
```

### onlyMaintainer

```solidity
modifier onlyMaintainer()
```

### constructor

```solidity
constructor(address _factory, contract PositionRegistry _registry) public
```

Constructor

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _factory | address | The address of the Uniswap V3 factory |
| _registry | contract PositionRegistry |  |

### setPeriod

```solidity
function setPeriod(uint32 _period) external
```

Sets the period for the oracle

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _period | uint32 | The new period |

### addPool

```solidity
function addPool(address tokenIn, address baseToken, uint24 fee) external
```

Adds a pool for a token

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIn | address | The address of the token |
| baseToken | address | The address of the base token |
| fee | uint24 | The fee tier of the pool |

### getValue

```solidity
function getValue(address tokenIn, address baseToken, uint256 amount) public view returns (uint256 _amountOut)
```

Gets the value of a token in terms of the base currency

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenIn | address | The address of the token |
| baseToken | address | The address of the base token |
| amount | uint256 | The amount of the token |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| _amountOut | uint256 | The value of the token in terms of the base currency |

## DepositRequest

```solidity
struct DepositRequest {
  address receiver;
  uint256 recordTime;
  uint256 calculationTime;
  uint256 amount;
  uint256 shares;
}
```

## RetrieveData

```solidity
struct RetrieveData {
  uint256 withdrawAmount;
  address connectorAddress;
  bytes data;
}
```

## WithdrawRequest

```solidity
struct WithdrawRequest {
  address owner;
  address receiver;
  uint256 recordTime;
  uint256 calculationTime;
  uint256 shares;
  uint256 amount;
}
```

## DepositQueue

```solidity
struct DepositQueue {
  mapping(uint256 => struct DepositRequest) queue;
  uint256 first;
  uint256 middle;
  uint256 last;
  uint256 totalAWFDeposit;
}
```

## WithdrawQueue

```solidity
struct WithdrawQueue {
  mapping(uint256 => struct WithdrawRequest) queue;
  uint256 first;
  uint256 middle;
  uint256 last;
}
```

## WithdrawGroup

```solidity
struct WithdrawGroup {
  uint256 lastId;
  uint256 totalCBAmount;
  uint256 totalABAmount;
  bool isStarted;
  bool isFullfilled;
}
```

## IAccountingManager

### RecordDeposit

```solidity
event RecordDeposit(uint256 depositId, address receiver, uint256 recordTime, uint256 amount, address referrer)
```

### CalculateDeposit

```solidity
event CalculateDeposit(uint256 depositId, address receiver, uint256 recordTime, uint256 amount, uint256 shares, uint256 sharePrice)
```

### MoveTheMiddle

```solidity
event MoveTheMiddle(uint256 newMiddle, bool depositOrWithdraw)
```

### ExecuteDeposit

```solidity
event ExecuteDeposit(uint256 depositId, address receiver, uint256 recordTime, uint256 amount, uint256 shares, uint256 sharePrice)
```

### RecordWithdraw

```solidity
event RecordWithdraw(uint256 withdrawId, address owner, address receiver, uint256 shares, uint256 recordTime)
```

### CalculateWithdraw

```solidity
event CalculateWithdraw(uint256 withdrawId, address owner, address receiver, uint256 shares, uint256 calculatedAmount, uint256 recordTime)
```

### ExecuteWithdraw

```solidity
event ExecuteWithdraw(uint256 withdrawId, address owner, address receiver, uint256 shares, uint256 calculatedAmount, uint256 sendedAmount, uint256 recordTime)
```

### FeeRecepientsChanged

```solidity
event FeeRecepientsChanged(address, address, address)
```

### FeeRatesChanged

```solidity
event FeeRatesChanged(uint256, uint256, uint256)
```

### WithdrawGroupStarted

```solidity
event WithdrawGroupStarted(uint256 lastId, uint256 totalCBAmount)
```

### WithdrawGroupFulfilled

```solidity
event WithdrawGroupFulfilled(uint256 lastId, uint256 totalCBAmount, uint256 totalABAmount)
```

### ValueOracleUpdated

```solidity
event ValueOracleUpdated(address valueOracle)
```

### SetDepositLimits

```solidity
event SetDepositLimits(uint256 depositLimitPerTransaction, uint256 depositTotalAmount)
```

### SetDepositWaitingTime

```solidity
event SetDepositWaitingTime(uint256 depositWaitingTime)
```

### SetWithdrawWaitingTime

```solidity
event SetWithdrawWaitingTime(uint256 withdrawWaitingTime)
```

### NoyaAccounting_INSUFFICIENT_FUNDS

```solidity
error NoyaAccounting_INSUFFICIENT_FUNDS(uint256 balance, uint256 amount, uint256 amountForWithdraw)
```

### NoyaAccounting_INVALID_AMOUNT

```solidity
error NoyaAccounting_INVALID_AMOUNT()
```

### NoyaAccounting_TotalDepositLimitExceeded

```solidity
error NoyaAccounting_TotalDepositLimitExceeded()
```

### NoyaAccounting_DepositLimitPerTransactionExceeded

```solidity
error NoyaAccounting_DepositLimitPerTransactionExceeded()
```

### NoyaAccounting_ThereIsAnActiveWithdrawGroup

```solidity
error NoyaAccounting_ThereIsAnActiveWithdrawGroup()
```

### NoyaAccounting_InvalidTimeForCalculation

```solidity
error NoyaAccounting_InvalidTimeForCalculation()
```

### NoyaAccounting_RequestIsNotCalculated

```solidity
error NoyaAccounting_RequestIsNotCalculated()
```

### NoyaAccounting_NOT_READY_TO_FULFILL

```solidity
error NoyaAccounting_NOT_READY_TO_FULFILL()
```

### NoyaAccounting_banalceAfterIsNotEnough

```solidity
error NoyaAccounting_banalceAfterIsNotEnough()
```

### NoyaAccounting_InvalidPositionType

```solidity
error NoyaAccounting_InvalidPositionType()
```

## HoldingPI

@Title: HoldingPI

_This struct is used to store the information of an holding position that we have_

### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct HoldingPI {
  address calculatorConnector;
  address ownerConnector;
  bytes32 positionId;
  bytes data;
  bytes additionalData;
  uint256 positionTimestamp;
}
```

## IConnector

### ValueOracleUpdated

```solidity
event ValueOracleUpdated(address _oracle)
```

### SwapHandlerUpdated

```solidity
event SwapHandlerUpdated(address _addr)
```

### IConnector_InvalidAddress

```solidity
error IConnector_InvalidAddress(address addr)
```

### IConnector_InvalidPositionType

```solidity
error IConnector_InvalidPositionType(address connector, uint256 positionTypeId, bytes data)
```

### IConnector_InvalidInput

```solidity
error IConnector_InvalidInput()
```

### IConnector_RouteDisabled

```solidity
error IConnector_RouteDisabled()
```

### IConnector_InvalidAmount

```solidity
error IConnector_InvalidAmount()
```

### IConnector_InvalidTarget

```solidity
error IConnector_InvalidTarget(address target)
```

### IConnector_UntrustedToken

```solidity
error IConnector_UntrustedToken(address token)
```

### IConnector_InsufficientDepositAmount

```solidity
error IConnector_InsufficientDepositAmount(uint256 amount, uint256 expectedAmount)
```

### IConnector_InvalidPosition

```solidity
error IConnector_InvalidPosition(bytes32 positionId)
```

### IConnector_LowHealthFactor

```solidity
error IConnector_LowHealthFactor(uint256 healthFactor)
```

### IConnector_BridgeTransactionNotApproved

```solidity
error IConnector_BridgeTransactionNotApproved(bytes32 txn)
```

### IConnector_InvalidDestinationChain

```solidity
error IConnector_InvalidDestinationChain()
```

### IConnector_InvalidSender

```solidity
error IConnector_InvalidSender()
```

### addLiquidity

```solidity
function addLiquidity(address[] tokens, uint256[] amounts, bytes data) external
```

### getUnderlyingTokens

```solidity
function getUnderlyingTokens(uint256 positionTypeId, bytes data) external view returns (address[])
```

### getPositionTVL

```solidity
function getPositionTVL(struct HoldingPI, address) external view returns (uint256)
```

## PositionBP

@Title: TrustedPositionInfo

_This struct is used to store the information of a trusted position_

### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct PositionBP {
  address calculatorConnector;
  uint256 positionTypeId;
  bool onlyOwner;
  bool isEnabled;
  bool isDebt;
  bytes data;
  bytes additionalData;
}
```

## ConnectorData

@Title: ConnectorData

_This struct is used to store the information of a connector_

### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct ConnectorData {
  bool enabled;
  mapping(address => bool) trustedTokens;
}
```

## Vault

@Title: Vault

_This struct is used to store the information of a vault_

### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct Vault {
  address accountManager;
  address baseToken;
  mapping(address => struct ConnectorData) connectors;
  mapping(bytes32 => struct PositionBP) trustedPositionsBP;
  mapping(bytes32 => uint256) isPositionUsed;
  struct HoldingPI[] holdingPositions;
  address governer;
  address maintainer;
  address maintainerWithoutTimeLock;
  address keeperContract;
  address watcherContract;
  address emergency;
  bool enabled;
}
```

## IPositionRegistry

### VaultAdded

```solidity
event VaultAdded(uint256 v, address _accountingManager, address _baseToken, address _governer, address _maintainer, address[] _trustedTokens)
```

### VaultAddressesChanged

```solidity
event VaultAddressesChanged(uint256 v, address _governer, address _maintainer, address _maintainerWithoutTimelock, address _keeperContract, address _watcherContract, address _emergency)
```

### ConnectorAdded

```solidity
event ConnectorAdded(uint256 v, address _connectorAddress)
```

### ConnectorTrustedTokensUpdated

```solidity
event ConnectorTrustedTokensUpdated(uint256 v, address _connectorAddress, address[] _tokens, bool trusted)
```

### TrustedPositionAdded

```solidity
event TrustedPositionAdded(uint256 vaultId, bytes32 positionId, address calculatorConnector, uint256 _positionTypeId, bool onlyOwner, bool _isDebt, bytes _data)
```

### HoldingPositionUpdated

```solidity
event HoldingPositionUpdated(uint256 vaultId, bytes32 _positionId, bytes _data, bytes additionalData, bool removePosition, uint256 positionIndex)
```

### UnauthorizedAccess

```solidity
error UnauthorizedAccess()
```

### TokenNotTrusted

```solidity
error TokenNotTrusted(address token)
```

### NotExist

```solidity
error NotExist()
```

### AlreadyExists

```solidity
error AlreadyExists()
```

### CannotRemovePosition

```solidity
error CannotRemovePosition(uint256 v, bytes32 positionId)
```

### CannotDisableConnector

```solidity
error CannotDisableConnector()
```

## ITokenTransferCallBack

### sendTokensToTrustedAddress

```solidity
function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes data) external returns (uint256)
```

## ILiFi

### BridgeData

Structs ///

```solidity
struct BridgeData {
  bytes32 transactionId;
  string bridge;
  string integrator;
  address referrer;
  address sendingAssetId;
  address receiver;
  uint256 minAmount;
  uint256 destinationChainId;
  bool hasSourceSwaps;
  bool hasDestinationCall;
}
```

### SwapData

```solidity
struct SwapData {
  address callTo;
  address approveTo;
  address sendingAssetId;
  address receivingAssetId;
  uint256 fromAmount;
  bytes callData;
  bool requiresDeposit;
}
```

### extractBridgeData

```solidity
function extractBridgeData(bytes data) external pure returns (struct ILiFi.BridgeData bridgeData)
```

### extractGenericSwapParameters

```solidity
function extractGenericSwapParameters(bytes data) external pure returns (address, uint256, address, address, uint256)
```

## RouteData

RouteData stores information for a route

```solidity
struct RouteData {
  address route;
  bool isEnabled;
  bool isBridge;
}
```

## ISwapAndBridgeHandler

### NewRouteAdded

```solidity
event NewRouteAdded(uint256 routeID, address route, bool isEnabled, bool isBridge)
```

### RouteUpdate

```solidity
event RouteUpdate(uint256 routeID, bool isEnabled)
```

### ExecutionCompleted

```solidity
event ExecutionCompleted(uint256 routeID, uint256 inputAmount, uint256 outputAmount, address inputToken, address outputToken)
```

### RouteAlreadyExists

```solidity
error RouteAlreadyExists()
```

### RouteNotFound

```solidity
error RouteNotFound()
```

### invalidAddress

```solidity
error invalidAddress()
```

### RouteDisabled

```solidity
error RouteDisabled()
```

### SlippageExceedsTolerance

```solidity
error SlippageExceedsTolerance()
```

### SpenderIsInvalid

```solidity
error SpenderIsInvalid()
```

### InvalidAmount

```solidity
error InvalidAmount()
```

### RouteNotAllowedForThisAction

```solidity
error RouteNotAllowedForThisAction()
```

### executeSwap

```solidity
function executeSwap(struct SwapRequest _swapRequest) external payable returns (uint256 _amountOut)
```

### executeBridge

```solidity
function executeBridge(struct BridgeRequest _bridgeRequest) external payable
```

### routes

```solidity
function routes(uint256 _routeId) external view returns (address route, bool isEnabled, bool isBridge)
```

## SwapRequest

```solidity
struct SwapRequest {
  address from;
  uint256 routeId;
  uint256 amount;
  address inputToken;
  address outputToken;
  bytes data;
  bool checkForSlippage;
  uint256 minAmount;
}
```

## BridgeRequest

```solidity
struct BridgeRequest {
  uint256 destChainId;
  address from;
  uint256 routeId;
  uint256 amount;
  address inputToken;
  address receiverAddress;
  bytes data;
}
```

## ISwapAndBridgeImplementation

### Forwarded

```solidity
event Forwarded(address lifi, address token, uint256 amount, bytes data)
```

### Swapped

```solidity
event Swapped(uint256 amountIn, uint256 amountOut, address toToken)
```

### SpenderIsInvalid

```solidity
error SpenderIsInvalid()
```

### FailedToForward

```solidity
error FailedToForward(bytes)
```

### InvalidSelector

```solidity
error InvalidSelector()
```

### InvalidReceiver

```solidity
error InvalidReceiver(address receiverInData, address receiverInRequest)
```

### InvalidBridge

```solidity
error InvalidBridge()
```

### InvalidMinAmount

```solidity
error InvalidMinAmount()
```

### InvalidInputToken

```solidity
error InvalidInputToken()
```

### InvalidOutputToken

```solidity
error InvalidOutputToken()
```

### InvalidAmount

```solidity
error InvalidAmount()
```

### BridgeBlacklisted

```solidity
error BridgeBlacklisted()
```

### InvalidChainId

```solidity
error InvalidChainId()
```

### InvalidFromToken

```solidity
error InvalidFromToken()
```

### InvalidToChainId

```solidity
error InvalidToChainId()
```

### performSwapAction

```solidity
function performSwapAction(address caller, struct SwapRequest _request) external payable returns (uint256)
```

### verifySwapData

```solidity
function verifySwapData(struct SwapRequest _request) external view returns (bool)
```

### performBridgeAction

```solidity
function performBridgeAction(address caller, struct BridgeRequest _request) external payable
```

### verifyBridgeData

```solidity
function verifyBridgeData(struct BridgeRequest _request) external view returns (bool)
```

## AggregatorV3Interface

### decimals

```solidity
function decimals() external view returns (uint8)
```

### description

```solidity
function description() external view returns (string)
```

### version

```solidity
function version() external view returns (uint256)
```

### getRoundData

```solidity
function getRoundData(uint80 _roundId) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
```

### latestRoundData

```solidity
function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
```

## INoyaValueOracle

### INoyaValueOracle_Unauthorized

```solidity
error INoyaValueOracle_Unauthorized(address sender)
```

### INoyaOracle_ValueOracleUnavailable

```solidity
error INoyaOracle_ValueOracleUnavailable(address asset, address baseToken)
```

### INoyaValueOracle_InvalidInput

```solidity
error INoyaValueOracle_InvalidInput()
```

### getValue

```solidity
function getValue(address asset, address baseCurrency, uint256 amount) external view returns (uint256)
```

## ICamelotFactory

### PairCreated

```solidity
event PairCreated(address token0, address token1, address pair, uint256)
```

### owner

```solidity
function owner() external view returns (address)
```

### feePercentOwner

```solidity
function feePercentOwner() external view returns (address)
```

### setStableOwner

```solidity
function setStableOwner() external view returns (address)
```

### feeTo

```solidity
function feeTo() external view returns (address)
```

### ownerFeeShare

```solidity
function ownerFeeShare() external view returns (uint256)
```

### referrersFeeShare

```solidity
function referrersFeeShare(address) external view returns (uint256)
```

### getPair

```solidity
function getPair(address tokenA, address tokenB) external view returns (address pair)
```

### allPairs

```solidity
function allPairs(uint256) external view returns (address pair)
```

### allPairsLength

```solidity
function allPairsLength() external view returns (uint256)
```

### createPair

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair)
```

### setFeeTo

```solidity
function setFeeTo(address) external
```

### feeInfo

```solidity
function feeInfo() external view returns (uint256 _ownerFeeShare, address _feeTo)
```

## ICamelotPair

### precisionMultiplier0

```solidity
function precisionMultiplier0() external pure returns (uint256)
```

### precisionMultiplier1

```solidity
function precisionMultiplier1() external pure returns (uint256)
```

### factory

```solidity
function factory() external view returns (address)
```

### token0

```solidity
function token0() external view returns (address)
```

### token1

```solidity
function token1() external view returns (address)
```

### getReserves

```solidity
function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint16 token0feePercent, uint16 token1FeePercent)
```

### getAmountOut

```solidity
function getAmountOut(uint256 amountIn, address tokenIn) external view returns (uint256)
```

### kLast

```solidity
function kLast() external view returns (uint256)
```

### mint

```solidity
function mint(address to) external returns (uint256 liquidity)
```

### burn

```solidity
function burn(address to) external returns (uint256 amount0, uint256 amount1)
```

### stableSwap

```solidity
function stableSwap() external view returns (bool)
```

## ICamelotRouter

### factory

```solidity
function factory() external pure returns (address)
```

### WETH

```solidity
function WETH() external pure returns (address)
```

### addLiquidity

```solidity
function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity)
```

### addLiquidityETH

```solidity
function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
```

### removeLiquidity

```solidity
function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETH

```solidity
function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH)
```

### removeLiquidityWithPermit

```solidity
function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETHWithPermit

```solidity
function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH)
```

### quote

```solidity
function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB)
```

### removeLiquidityETHSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH)
```

### removeLiquidityETHWithPermitSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH)
```

### swapExactTokensForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, address referrer, uint256 deadline) external
```

### swapExactETHForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] path, address to, address referrer, uint256 deadline) external payable
```

### swapExactTokensForETHSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, address referrer, uint256 deadline) external
```

## AccountBalanceHelper

### FILE

```solidity
bytes32 FILE
```

### BalanceCheckFlag

Checks that either BOTH, FROM, or TO accounts all have non-negative balances

```solidity
enum BalanceCheckFlag {
  Both,
  From,
  To,
  None
}
```

## IDolomiteAmmPair

This interface defines the functions callable on Dolomite's native AMM pools.

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### Mint

```solidity
event Mint(address sender, uint256 amount0Wei, uint256 amount1Wei)
```

### Burn

```solidity
event Burn(address sender, uint256 amount0Wei, uint256 amount1Wei, address to)
```

### Swap

```solidity
event Swap(address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address to)
```

### Sync

```solidity
event Sync(uint112 reserve0, uint112 reserve1)
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

### mint

```solidity
function mint(address to) external returns (uint256 liquidity)
```

### burn

```solidity
function burn(address to, uint256 toAccountNumber) external returns (uint256 amount0Wei, uint256 amount1Wei)
```

### skim

```solidity
function skim(address to, uint256 toAccountNumber) external
```

### sync

```solidity
function sync() external
```

### initialize

```solidity
function initialize(address _token0, address _token1, address _transferProxy) external
```

### name

```solidity
function name() external view returns (string)
```

### symbol

```solidity
function symbol() external view returns (string)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

### nonces

```solidity
function nonces(address owner) external view returns (uint256)
```

### factory

```solidity
function factory() external view returns (address)
```

### token0

```solidity
function token0() external view returns (address)
```

### token1

```solidity
function token1() external view returns (address)
```

### getReservesWei

```solidity
function getReservesWei() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)
```

### getReservesPar

```solidity
function getReservesPar() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)
```

### price0CumulativeLast

```solidity
function price0CumulativeLast() external view returns (uint256)
```

### price1CumulativeLast

```solidity
function price1CumulativeLast() external view returns (uint256)
```

### kLast

```solidity
function kLast() external view returns (uint256)
```

### PERMIT_TYPEHASH

```solidity
function PERMIT_TYPEHASH() external pure returns (bytes32)
```

### MINIMUM_LIQUIDITY

```solidity
function MINIMUM_LIQUIDITY() external pure returns (uint256)
```

### decimals

```solidity
function decimals() external pure returns (uint8)
```

## IDolomiteAmmFactory

### getPair

```solidity
function getPair(address tokenA, address tokenB) external view returns (address pair)
```

## IIrm

Interface that Interest Rate Models (IRMs) used by Morpho must implement.

### borrowRate

```solidity
function borrowRate(struct MarketParams marketParams, struct Market market) external returns (uint256)
```

Returns the borrow rate of the market `marketParams`.

_Assumes that `market` corresponds to `marketParams`._

### borrowRateView

```solidity
function borrowRateView(struct MarketParams marketParams, struct Market market) external view returns (uint256)
```

Returns the borrow rate of the market `marketParams` without modifying any storage.

_Assumes that `market` corresponds to `marketParams`._

## IIrm

Interface that Interest Rate Models (IRMs) used by Morpho must implement.

### borrowRate

```solidity
function borrowRate(struct MarketParams marketParams, struct Market market) external returns (uint256)
```

Returns the borrow rate of the market `marketParams`.

_Assumes that `market` corresponds to `marketParams`._

### borrowRateView

```solidity
function borrowRateView(struct MarketParams marketParams, struct Market market) external view returns (uint256)
```

Returns the borrow rate of the market `marketParams` without modifying any storage.

_Assumes that `market` corresponds to `marketParams`._

## Id

## MarketParams

```solidity
struct MarketParams {
  address loanToken;
  address collateralToken;
  address oracle;
  address irm;
  uint256 lltv;
}
```

## Market

```solidity
struct Market {
  uint128 totalSupplyAssets;
  uint128 totalSupplyShares;
  uint128 totalBorrowAssets;
  uint128 totalBorrowShares;
  uint128 lastUpdate;
  uint128 fee;
}
```

## Position

_Warning: For `feeRecipient`, `supplyShares` does not contain the accrued shares since the last interest
accrual._

```solidity
struct Position {
  uint256 supplyShares;
  uint128 borrowShares;
  uint128 collateral;
}
```

## IMorphoBase

_This interface is used for factorizing IMorphoStaticTyping and IMorpho.
Consider using the IMorpho interface instead of this one._

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

The EIP-712 domain separator.

_Warning: Every EIP-712 signed message based on this domain separator can be reused on another chain sharing
the same chain id because the domain separator would be the same._

### owner

```solidity
function owner() external view returns (address)
```

The owner of the contract.

_It has the power to change the owner.
It has the power to set fees on markets and set the fee recipient.
It has the power to enable but not disable IRMs and LLTVs._

### feeRecipient

```solidity
function feeRecipient() external view returns (address)
```

The fee recipient of all markets.

_The recipient receives the fees of a given market through a supply position on that market._

### isIrmEnabled

```solidity
function isIrmEnabled(address irm) external view returns (bool)
```

Whether the `irm` is enabled.

### isLltvEnabled

```solidity
function isLltvEnabled(uint256 lltv) external view returns (bool)
```

Whether the `lltv` is enabled.

### isAuthorized

```solidity
function isAuthorized(address authorizer, address authorized) external view returns (bool)
```

Whether `authorized` is authorized to modify `authorizer`'s positions.

_Anyone is authorized to modify their own positions, regardless of this variable._

### nonce

```solidity
function nonce(address authorizer) external view returns (uint256)
```

The `authorizer`'s current nonce. Used to prevent replay attacks with EIP-712 signatures.

### setOwner

```solidity
function setOwner(address newOwner) external
```

Sets `newOwner` as `owner` of the contract.

_Warning: No two-step transfer ownership.
Warning: The owner can be set to the zero address._

### enableIrm

```solidity
function enableIrm(address irm) external
```

Enables `irm` as a possible IRM for market creation.

_Warning: It is not possible to disable an IRM._

### enableLltv

```solidity
function enableLltv(uint256 lltv) external
```

Enables `lltv` as a possible LLTV for market creation.

_Warning: It is not possible to disable a LLTV._

### setFee

```solidity
function setFee(struct MarketParams marketParams, uint256 newFee) external
```

Sets the `newFee` for the given market `marketParams`.

_Warning: The recipient can be the zero address._

### setFeeRecipient

```solidity
function setFeeRecipient(address newFeeRecipient) external
```

Sets `newFeeRecipient` as `feeRecipient` of the fee.

_Warning: If the fee recipient is set to the zero address, fees will accrue there and will be lost.
Modifying the fee recipient will allow the new recipient to claim any pending fees not yet accrued. To
ensure that the current recipient receives all due fees, accrue interest manually prior to making any changes._

### createMarket

```solidity
function createMarket(struct MarketParams marketParams) external
```

Creates the market `marketParams`.

_Here is the list of assumptions on the market's dependencies (tokens, IRM and oracle) that guarantees
Morpho behaves as expected:
- The token should be ERC-20 compliant, except that it can omit return values on `transfer` and `transferFrom`.
- The token balance of Morpho should only decrease on `transfer` and `transferFrom`. In particular, tokens with
burn functions are not supported.
- The token should not re-enter Morpho on `transfer` nor `transferFrom`.
- The token balance of the sender (resp. receiver) should decrease (resp. increase) by exactly the given amount
on `transfer` and `transferFrom`. In particular, tokens with fees on transfer are not supported.
- The IRM should not re-enter Morpho.
- The oracle should return a price with the correct scaling.
Here is a list of properties on the market's dependencies that could break Morpho's liveness properties
(funds could get stuck):
- The token can revert on `transfer` and `transferFrom` for a reason other than an approval or balance issue.
- A very high amount of assets (~1e35) supplied or borrowed can make the computation of `toSharesUp` and
`toSharesDown` overflow.
- The IRM can revert on `borrowRate`.
- A very high borrow rate returned by the IRM can make the computation of `interest` in `_accrueInterest`
overflow.
- The oracle can revert on `price`. Note that this can be used to prevent `borrow`, `withdrawCollateral` and
`liquidate` from being used under certain market conditions.
- A very high price returned by the oracle can make the computation of `maxBorrow` in `_isHealthy` overflow, or
the computation of `assetsRepaid` in `liquidate` overflow.
The borrow share price of a market with less than 1e4 assets borrowed can be decreased by manipulations, to
the point where `totalBorrowShares` is very large and borrowing overflows._

### supply

```solidity
function supply(struct MarketParams marketParams, uint256 assets, uint256 shares, address onBehalf, bytes data) external returns (uint256 assetsSupplied, uint256 sharesSupplied)
```

Supplies `assets` or `shares` on behalf of `onBehalf`, optionally calling back the caller's
`onMorphoSupply` function with the given `data`.

_Either `assets` or `shares` should be zero. Most usecases should rely on `assets` as an input so the caller
is guaranteed to have `assets` tokens pulled from their balance, but the possibility to mint a specific amount
of shares is given for full compatibility and precision.
If the supply of a market gets depleted, the supply share price instantly resets to
`VIRTUAL_ASSETS`:`VIRTUAL_SHARES`.
Supplying a large amount can revert for overflow._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to supply assets to. |
| assets | uint256 | The amount of assets to supply. |
| shares | uint256 | The amount of shares to mint. |
| onBehalf | address | The address that will own the increased supply position. |
| data | bytes | Arbitrary data to pass to the `onMorphoSupply` callback. Pass empty data if not needed. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetsSupplied | uint256 | The amount of assets supplied. |
| sharesSupplied | uint256 | The amount of shares minted. |

### withdraw

```solidity
function withdraw(struct MarketParams marketParams, uint256 assets, uint256 shares, address onBehalf, address receiver) external returns (uint256 assetsWithdrawn, uint256 sharesWithdrawn)
```

Withdraws `assets` or `shares` on behalf of `onBehalf` to `receiver`.

_Either `assets` or `shares` should be zero. To withdraw max, pass the `shares`'s balance of `onBehalf`.
`msg.sender` must be authorized to manage `onBehalf`'s positions.
Withdrawing an amount corresponding to more shares than supplied will revert for underflow.
It is advised to use the `shares` input when withdrawing the full position to avoid reverts due to
conversion roundings between shares and assets._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to withdraw assets from. |
| assets | uint256 | The amount of assets to withdraw. |
| shares | uint256 | The amount of shares to burn. |
| onBehalf | address | The address of the owner of the supply position. |
| receiver | address | The address that will receive the withdrawn assets. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetsWithdrawn | uint256 | The amount of assets withdrawn. |
| sharesWithdrawn | uint256 | The amount of shares burned. |

### borrow

```solidity
function borrow(struct MarketParams marketParams, uint256 assets, uint256 shares, address onBehalf, address receiver) external returns (uint256 assetsBorrowed, uint256 sharesBorrowed)
```

Borrows `assets` or `shares` on behalf of `onBehalf` to `receiver`.

_Either `assets` or `shares` should be zero. Most usecases should rely on `assets` as an input so the caller
is guaranteed to borrow `assets` of tokens, but the possibility to mint a specific amount of shares is given for
full compatibility and precision.
If the borrow of a market gets depleted, the borrow share price instantly resets to
`VIRTUAL_ASSETS`:`VIRTUAL_SHARES`.
`msg.sender` must be authorized to manage `onBehalf`'s positions.
Borrowing a large amount can revert for overflow._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to borrow assets from. |
| assets | uint256 | The amount of assets to borrow. |
| shares | uint256 | The amount of shares to mint. |
| onBehalf | address | The address that will own the increased borrow position. |
| receiver | address | The address that will receive the borrowed assets. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetsBorrowed | uint256 | The amount of assets borrowed. |
| sharesBorrowed | uint256 | The amount of shares minted. |

### repay

```solidity
function repay(struct MarketParams marketParams, uint256 assets, uint256 shares, address onBehalf, bytes data) external returns (uint256 assetsRepaid, uint256 sharesRepaid)
```

Repays `assets` or `shares` on behalf of `onBehalf`, optionally calling back the caller's
`onMorphoReplay` function with the given `data`.

_Either `assets` or `shares` should be zero. To repay max, pass the `shares`'s balance of `onBehalf`.
Repaying an amount corresponding to more shares than borrowed will revert for underflow.
It is advised to use the `shares` input when repaying the full position to avoid reverts due to conversion
roundings between shares and assets._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to repay assets to. |
| assets | uint256 | The amount of assets to repay. |
| shares | uint256 | The amount of shares to burn. |
| onBehalf | address | The address of the owner of the debt position. |
| data | bytes | Arbitrary data to pass to the `onMorphoRepay` callback. Pass empty data if not needed. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetsRepaid | uint256 | The amount of assets repaid. |
| sharesRepaid | uint256 | The amount of shares burned. |

### supplyCollateral

```solidity
function supplyCollateral(struct MarketParams marketParams, uint256 assets, address onBehalf, bytes data) external
```

Supplies `assets` of collateral on behalf of `onBehalf`, optionally calling back the caller's
`onMorphoSupplyCollateral` function with the given `data`.

_Interest are not accrued since it's not required and it saves gas.
Supplying a large amount can revert for overflow._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to supply collateral to. |
| assets | uint256 | The amount of collateral to supply. |
| onBehalf | address | The address that will own the increased collateral position. |
| data | bytes | Arbitrary data to pass to the `onMorphoSupplyCollateral` callback. Pass empty data if not needed. |

### withdrawCollateral

```solidity
function withdrawCollateral(struct MarketParams marketParams, uint256 assets, address onBehalf, address receiver) external
```

Withdraws `assets` of collateral on behalf of `onBehalf` to `receiver`.

_`msg.sender` must be authorized to manage `onBehalf`'s positions.
Withdrawing an amount corresponding to more collateral than supplied will revert for underflow._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market to withdraw collateral from. |
| assets | uint256 | The amount of collateral to withdraw. |
| onBehalf | address | The address of the owner of the collateral position. |
| receiver | address | The address that will receive the collateral assets. |

### liquidate

```solidity
function liquidate(struct MarketParams marketParams, address borrower, uint256 seizedAssets, uint256 repaidShares, bytes data) external returns (uint256, uint256)
```

Liquidates the given `repaidShares` of debt asset or seize the given `seizedAssets` of collateral on the
given market `marketParams` of the given `borrower`'s position, optionally calling back the caller's
`onMorphoLiquidate` function with the given `data`.

_Either `seizedAssets` or `repaidShares` should be zero.
Seizing more than the collateral balance will underflow and revert without any error message.
Repaying more than the borrow balance will underflow and revert without any error message._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| marketParams | struct MarketParams | The market of the position. |
| borrower | address | The owner of the position. |
| seizedAssets | uint256 | The amount of collateral to seize. |
| repaidShares | uint256 | The amount of shares to repay. |
| data | bytes | Arbitrary data to pass to the `onMorphoLiquidate` callback. Pass empty data if not needed. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | The amount of assets seized. |
| [1] | uint256 | The amount of assets repaid. |

### flashLoan

```solidity
function flashLoan(address token, uint256 assets, bytes data) external
```

Executes a flash loan.

_Flash loans have access to the whole balance of the contract (the liquidity and deposited collateral of all
markets combined, plus donations).
Warning: Not ERC-3156 compliant but compatibility is easily reached:
- `flashFee` is zero.
- `maxFlashLoan` is the token's balance of this contract.
- The receiver of `assets` is the caller._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| token | address | The token to flash loan. |
| assets | uint256 | The amount of assets to flash loan. |
| data | bytes | Arbitrary data to pass to the `onMorphoFlashLoan` callback. |

### setAuthorization

```solidity
function setAuthorization(address authorized, bool newIsAuthorized) external
```

Sets the authorization for `authorized` to manage `msg.sender`'s positions.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| authorized | address | The authorized address. |
| newIsAuthorized | bool | The new authorization status. |

### accrueInterest

```solidity
function accrueInterest(struct MarketParams marketParams) external
```

Accrues interest for the given market `marketParams`.

### extSloads

```solidity
function extSloads(bytes32[] slots) external view returns (bytes32[])
```

Returns the data stored on the different `slots`.

## IMorpho

_Use this interface for Morpho to have access to all the functions with the appropriate function signatures._

### position

```solidity
function position(Id id, address user) external view returns (struct Position p)
```

The state of the position of `user` on the market corresponding to `id`.

_Warning: For `feeRecipient`, `p.supplyShares` does not contain the accrued shares since the last interest
accrual._

### idToMarketParams

```solidity
function idToMarketParams(Id id) external view returns (struct MarketParams)
```

The market params corresponding to `id`.

_This mapping is not used in Morpho. It is there to enable reducing the cost associated to calldata on layer
2s by creating a wrapper contract with functions that take `id` as input instead of `marketParams`._

## IOracle

Interface that oracles used by Morpho must implement.

_It is the user's responsibility to select markets with safe oracles._

### price

```solidity
function price() external view returns (uint256)
```

Returns the price of 1 asset of collateral token quoted in 1 asset of loan token, scaled by 1e36.

_It corresponds to the price of 10**(collateral token decimals) assets of collateral token quoted in
10**(loan token decimals) assets of loan token with `36 + loan token decimals - collateral token decimals`
decimals of precision._

## IPPtOracle

### SetBlockCycleNumerator

```solidity
event SetBlockCycleNumerator(uint16 newBlockCycleNumerator)
```

### getPtToAssetRate

```solidity
function getPtToAssetRate(address market, uint32 duration) external view returns (uint256 ptToAssetRate)
```

### getOracleState

```solidity
function getOracleState(address market, uint32 duration) external view returns (bool increaseCardinalityRequired, uint16 cardinalityRequired, bool oldestObservationSatisfied)
```

## ErrorsLib

Library exposing error messages.

### NOT_OWNER

```solidity
string NOT_OWNER
```

Thrown when the caller is not the owner.

### MAX_LLTV_EXCEEDED

```solidity
string MAX_LLTV_EXCEEDED
```

Thrown when the LLTV to enable exceeds the maximum LLTV.

### MAX_FEE_EXCEEDED

```solidity
string MAX_FEE_EXCEEDED
```

Thrown when the fee to set exceeds the maximum fee.

### ALREADY_SET

```solidity
string ALREADY_SET
```

Thrown when the value is already set.

### IRM_NOT_ENABLED

```solidity
string IRM_NOT_ENABLED
```

Thrown when the IRM is not enabled at market creation.

### LLTV_NOT_ENABLED

```solidity
string LLTV_NOT_ENABLED
```

Thrown when the LLTV is not enabled at market creation.

### MARKET_ALREADY_CREATED

```solidity
string MARKET_ALREADY_CREATED
```

Thrown when the market is already created.

### MARKET_NOT_CREATED

```solidity
string MARKET_NOT_CREATED
```

Thrown when the market is not created.

### INCONSISTENT_INPUT

```solidity
string INCONSISTENT_INPUT
```

Thrown when not exactly one of the input amount is zero.

### ZERO_ASSETS

```solidity
string ZERO_ASSETS
```

Thrown when zero assets is passed as input.

### ZERO_ADDRESS

```solidity
string ZERO_ADDRESS
```

Thrown when a zero address is passed as input.

### UNAUTHORIZED

```solidity
string UNAUTHORIZED
```

Thrown when the caller is not authorized to conduct an action.

### INSUFFICIENT_COLLATERAL

```solidity
string INSUFFICIENT_COLLATERAL
```

Thrown when the collateral is insufficient to `borrow` or `withdrawCollateral`.

### INSUFFICIENT_LIQUIDITY

```solidity
string INSUFFICIENT_LIQUIDITY
```

Thrown when the liquidity is insufficient to `withdraw` or `borrow`.

### HEALTHY_POSITION

```solidity
string HEALTHY_POSITION
```

Thrown when the position to liquidate is healthy.

### INVALID_SIGNATURE

```solidity
string INVALID_SIGNATURE
```

Thrown when the authorization signature is invalid.

### SIGNATURE_EXPIRED

```solidity
string SIGNATURE_EXPIRED
```

Thrown when the authorization signature is expired.

### INVALID_NONCE

```solidity
string INVALID_NONCE
```

Thrown when the nonce is invalid.

### TRANSFER_REVERTED

```solidity
string TRANSFER_REVERTED
```

Thrown when a token transfer reverted.

### TRANSFER_RETURNED_FALSE

```solidity
string TRANSFER_RETURNED_FALSE
```

Thrown when a token transfer returned false.

### TRANSFER_FROM_REVERTED

```solidity
string TRANSFER_FROM_REVERTED
```

Thrown when a token transferFrom reverted.

### TRANSFER_FROM_RETURNED_FALSE

```solidity
string TRANSFER_FROM_RETURNED_FALSE
```

Thrown when a token transferFrom returned false

### MAX_UINT128_EXCEEDED

```solidity
string MAX_UINT128_EXCEEDED
```

Thrown when the maximum uint128 is exceeded.

## MarketParamsLib

Library to convert a market to its id.

### MARKET_PARAMS_BYTES_LENGTH

```solidity
uint256 MARKET_PARAMS_BYTES_LENGTH
```

The length of the data used to compute the id of a market.

_The length is 5 * 32 because `MarketParams` has 5 variables of 32 bytes each._

### id

```solidity
function id(struct MarketParams marketParams) internal pure returns (Id marketParamsId)
```

Returns the id of the market `marketParams`.

## UtilsLib

Library exposing helpers.

_Inspired by https://github.com/morpho-org/morpho-utils._

### exactlyOneZero

```solidity
function exactlyOneZero(uint256 x, uint256 y) internal pure returns (bool z)
```

_Returns true if there is exactly one zero among `x` and `y`._

### min

```solidity
function min(uint256 x, uint256 y) internal pure returns (uint256 z)
```

_Returns the min of `x` and `y`._

### toUint128

```solidity
function toUint128(uint256 x) internal pure returns (uint128)
```

_Returns `x` safely cast to uint128._

### zeroFloorSub

```solidity
function zeroFloorSub(uint256 x, uint256 y) internal pure returns (uint256 z)
```

_Returns max(x - y, 0)._

## MorphoLib

Helper library to access Morpho storage variables.

_Warning: Supply and borrow getters may return outdated values that do not include accrued interest._

### supplyShares

```solidity
function supplyShares(contract IMorpho morpho, Id id, address user) internal view returns (uint256)
```

### borrowShares

```solidity
function borrowShares(contract IMorpho morpho, Id id, address user) internal view returns (uint256)
```

### collateral

```solidity
function collateral(contract IMorpho morpho, Id id, address user) internal view returns (uint256)
```

### totalSupplyAssets

```solidity
function totalSupplyAssets(contract IMorpho morpho, Id id) internal view returns (uint256)
```

### totalSupplyShares

```solidity
function totalSupplyShares(contract IMorpho morpho, Id id) internal view returns (uint256)
```

### totalBorrowAssets

```solidity
function totalBorrowAssets(contract IMorpho morpho, Id id) internal view returns (uint256)
```

### totalBorrowShares

```solidity
function totalBorrowShares(contract IMorpho morpho, Id id) internal view returns (uint256)
```

### lastUpdate

```solidity
function lastUpdate(contract IMorpho morpho, Id id) internal view returns (uint256)
```

### fee

```solidity
function fee(contract IMorpho morpho, Id id) internal view returns (uint256)
```

## MorphoStorageLib

Helper library exposing getters to access Morpho storage variables' slot.

_This library is not used in Morpho itself and is intended to be used by integrators._

### OWNER_SLOT

```solidity
uint256 OWNER_SLOT
```

### FEE_RECIPIENT_SLOT

```solidity
uint256 FEE_RECIPIENT_SLOT
```

### POSITION_SLOT

```solidity
uint256 POSITION_SLOT
```

### MARKET_SLOT

```solidity
uint256 MARKET_SLOT
```

### IS_IRM_ENABLED_SLOT

```solidity
uint256 IS_IRM_ENABLED_SLOT
```

### IS_LLTV_ENABLED_SLOT

```solidity
uint256 IS_LLTV_ENABLED_SLOT
```

### IS_AUTHORIZED_SLOT

```solidity
uint256 IS_AUTHORIZED_SLOT
```

### NONCE_SLOT

```solidity
uint256 NONCE_SLOT
```

### ID_TO_MARKET_PARAMS_SLOT

```solidity
uint256 ID_TO_MARKET_PARAMS_SLOT
```

### LOAN_TOKEN_OFFSET

```solidity
uint256 LOAN_TOKEN_OFFSET
```

### COLLATERAL_TOKEN_OFFSET

```solidity
uint256 COLLATERAL_TOKEN_OFFSET
```

### ORACLE_OFFSET

```solidity
uint256 ORACLE_OFFSET
```

### IRM_OFFSET

```solidity
uint256 IRM_OFFSET
```

### LLTV_OFFSET

```solidity
uint256 LLTV_OFFSET
```

### SUPPLY_SHARES_OFFSET

```solidity
uint256 SUPPLY_SHARES_OFFSET
```

### BORROW_SHARES_AND_COLLATERAL_OFFSET

```solidity
uint256 BORROW_SHARES_AND_COLLATERAL_OFFSET
```

### TOTAL_SUPPLY_ASSETS_AND_SHARES_OFFSET

```solidity
uint256 TOTAL_SUPPLY_ASSETS_AND_SHARES_OFFSET
```

### TOTAL_BORROW_ASSETS_AND_SHARES_OFFSET

```solidity
uint256 TOTAL_BORROW_ASSETS_AND_SHARES_OFFSET
```

### LAST_UPDATE_AND_FEE_OFFSET

```solidity
uint256 LAST_UPDATE_AND_FEE_OFFSET
```

### ownerSlot

```solidity
function ownerSlot() internal pure returns (bytes32)
```

### feeRecipientSlot

```solidity
function feeRecipientSlot() internal pure returns (bytes32)
```

### positionSupplySharesSlot

```solidity
function positionSupplySharesSlot(Id id, address user) internal pure returns (bytes32)
```

### positionBorrowSharesAndCollateralSlot

```solidity
function positionBorrowSharesAndCollateralSlot(Id id, address user) internal pure returns (bytes32)
```

### marketTotalSupplyAssetsAndSharesSlot

```solidity
function marketTotalSupplyAssetsAndSharesSlot(Id id) internal pure returns (bytes32)
```

### marketTotalBorrowAssetsAndSharesSlot

```solidity
function marketTotalBorrowAssetsAndSharesSlot(Id id) internal pure returns (bytes32)
```

### marketLastUpdateAndFeeSlot

```solidity
function marketLastUpdateAndFeeSlot(Id id) internal pure returns (bytes32)
```

### isIrmEnabledSlot

```solidity
function isIrmEnabledSlot(address irm) internal pure returns (bytes32)
```

### isLltvEnabledSlot

```solidity
function isLltvEnabledSlot(uint256 lltv) internal pure returns (bytes32)
```

### isAuthorizedSlot

```solidity
function isAuthorizedSlot(address authorizer, address authorizee) internal pure returns (bytes32)
```

### nonceSlot

```solidity
function nonceSlot(address authorizer) internal pure returns (bytes32)
```

### idToLoanTokenSlot

```solidity
function idToLoanTokenSlot(Id id) internal pure returns (bytes32)
```

### idToCollateralTokenSlot

```solidity
function idToCollateralTokenSlot(Id id) internal pure returns (bytes32)
```

### idToOracleSlot

```solidity
function idToOracleSlot(Id id) internal pure returns (bytes32)
```

### idToIrmSlot

```solidity
function idToIrmSlot(Id id) internal pure returns (bytes32)
```

### idToLltvSlot

```solidity
function idToLltvSlot(Id id) internal pure returns (bytes32)
```

## IPMarket

### Mint

```solidity
event Mint(address receiver, uint256 netLpMinted, uint256 netSyUsed, uint256 netPtUsed)
```

### Burn

```solidity
event Burn(address receiverSy, address receiverPt, uint256 netLpBurned, uint256 netSyOut, uint256 netPtOut)
```

### Swap

```solidity
event Swap(address caller, address receiver, int256 netPtOut, int256 netSyOut, uint256 netSyFee, uint256 netSyToReserve)
```

### UpdateImpliedRate

```solidity
event UpdateImpliedRate(uint256 timestamp, uint256 lnLastImpliedRate)
```

### IncreaseObservationCardinalityNext

```solidity
event IncreaseObservationCardinalityNext(uint16 observationCardinalityNextOld, uint16 observationCardinalityNextNew)
```

### mint

```solidity
function mint(address receiver, uint256 netSyDesired, uint256 netPtDesired) external returns (uint256 netLpOut, uint256 netSyUsed, uint256 netPtUsed)
```

### burn

```solidity
function burn(address receiverSy, address receiverPt, uint256 netLpToBurn) external returns (uint256 netSyOut, uint256 netPtOut)
```

### swapExactPtForSy

```solidity
function swapExactPtForSy(address receiver, uint256 exactPtIn, bytes data) external returns (uint256 netSyOut, uint256 netSyFee)
```

### swapSyForExactPt

```solidity
function swapSyForExactPt(address receiver, uint256 exactPtOut, bytes data) external returns (uint256 netSyIn, uint256 netSyFee)
```

### redeemRewards

```solidity
function redeemRewards(address user) external returns (uint256[])
```

### readState

```solidity
function readState(address router) external view returns (struct MarketState market)
```

### observe

```solidity
function observe(uint32[] secondsAgos) external view returns (uint216[] lnImpliedRateCumulative)
```

### increaseObservationsCardinalityNext

```solidity
function increaseObservationsCardinalityNext(uint16 cardinalityNext) external
```

### readTokens

```solidity
function readTokens() external view returns (contract IPStandardizedYield _SY, contract IPPrincipalToken _PT, contract IPYieldToken _YT)
```

### getRewardTokens

```solidity
function getRewardTokens() external view returns (address[])
```

### isExpired

```solidity
function isExpired() external view returns (bool)
```

### expiry

```solidity
function expiry() external view returns (uint256)
```

### observations

```solidity
function observations(uint256 index) external view returns (uint32 blockTimestamp, uint216 lnImpliedRateCumulative, bool initialized)
```

### _storage

```solidity
function _storage() external view returns (int128 totalPt, int128 totalSy, uint96 lastLnImpliedRate, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext)
```

## IPPrincipalToken

### burnByYT

```solidity
function burnByYT(address user, uint256 amount) external
```

### mintByYT

```solidity
function mintByYT(address user, uint256 amount) external
```

### initialize

```solidity
function initialize(address _YT) external
```

### SY

```solidity
function SY() external view returns (address)
```

### YT

```solidity
function YT() external view returns (address)
```

### factory

```solidity
function factory() external view returns (address)
```

### expiry

```solidity
function expiry() external view returns (uint256)
```

### isExpired

```solidity
function isExpired() external view returns (bool)
```

## IPPtOracle

### SetBlockCycleNumerator

```solidity
event SetBlockCycleNumerator(uint16 newBlockCycleNumerator)
```

### getPtToAssetRate

```solidity
function getPtToAssetRate(address market, uint32 duration) external view returns (uint256 ptToAssetRate)
```

### getOracleState

```solidity
function getOracleState(address market, uint32 duration) external view returns (bool increaseCardinalityRequired, uint16 cardinalityRequired, bool oldestObservationSatisfied)
```

## IPStandardizedYield

### Deposit

```solidity
event Deposit(address caller, address receiver, address tokenIn, uint256 amountDeposited, uint256 amountSyOut)
```

_Emitted when any base tokens is deposited to mint shares_

### Redeem

```solidity
event Redeem(address caller, address receiver, address tokenOut, uint256 amountSyToRedeem, uint256 amountTokenOut)
```

_Emitted when any shares are redeemed for base tokens_

### AssetType

_check `assetInfo()` for more information_

```solidity
enum AssetType {
  TOKEN,
  LIQUIDITY
}
```

### ClaimRewards

```solidity
event ClaimRewards(address user, address[] rewardTokens, uint256[] rewardAmounts)
```

_Emitted when (`user`) claims their rewards_

### deposit

```solidity
function deposit(address receiver, address tokenIn, uint256 amountTokenToDeposit, uint256 minSharesOut) external payable returns (uint256 amountSharesOut)
```

mints an amount of shares by depositing a base token.

_Emits a {Deposit} event

Requirements:
- (`tokenIn`) must be a valid base token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| receiver | address | shares recipient address |
| tokenIn | address | address of the base tokens to mint shares |
| amountTokenToDeposit | uint256 | amount of base tokens to be transferred from (`msg.sender`) |
| minSharesOut | uint256 | reverts if amount of shares minted is lower than this |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountSharesOut | uint256 | amount of shares minted |

### redeem

```solidity
function redeem(address receiver, uint256 amountSharesToRedeem, address tokenOut, uint256 minTokenOut, bool burnFromInternalBalance) external returns (uint256 amountTokenOut)
```

redeems an amount of base tokens by burning some shares

_Emits a {Redeem} event

Requirements:
- (`tokenOut`) must be a valid base token._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| receiver | address | recipient address |
| amountSharesToRedeem | uint256 | amount of shares to be burned |
| tokenOut | address | address of the base token to be redeemed |
| minTokenOut | uint256 | reverts if amount of base token redeemed is lower than this |
| burnFromInternalBalance | bool | if true, burns from balance of `address(this)`, otherwise burns from `msg.sender` |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| amountTokenOut | uint256 | amount of base tokens redeemed |

### exchangeRate

```solidity
function exchangeRate() external view returns (uint256 res)
```

exchangeRate * syBalance / 1e18 must return the asset balance of the account
vice-versa, if a user uses some amount of tokens equivalent to X asset, the amount of sy
 he can mint must be X * exchangeRate / 1e18

_SYUtils's assetToSy & syToAsset should be used instead of raw multiplication
 & division_

### claimRewards

```solidity
function claimRewards(address user) external returns (uint256[] rewardAmounts)
```

claims reward for (`user`)

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| user | address | the user receiving their rewards |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rewardAmounts | uint256[] | an array of reward amounts in the same order as `getRewardTokens` @dev Emits a `ClaimRewards` event See {getRewardTokens} for list of reward tokens |

### accruedRewards

```solidity
function accruedRewards(address user) external view returns (uint256[] rewardAmounts)
```

get the amount of unclaimed rewards for (`user`)

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| user | address | the user to check for |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| rewardAmounts | uint256[] | an array of reward amounts in the same order as `getRewardTokens` |

### rewardIndexesCurrent

```solidity
function rewardIndexesCurrent() external returns (uint256[] indexes)
```

### rewardIndexesStored

```solidity
function rewardIndexesStored() external view returns (uint256[] indexes)
```

### getRewardTokens

```solidity
function getRewardTokens() external view returns (address[])
```

returns the list of reward token addresses

### underlying

```solidity
function underlying() external view returns (address)
```

returns the address of the underlying yield token

### getTokensIn

```solidity
function getTokensIn() external view returns (address[] res)
```

returns all tokens that can mint this SY

### getTokensOut

```solidity
function getTokensOut() external view returns (address[] res)
```

returns all tokens that can be redeemed by this SY

### isValidTokenIn

```solidity
function isValidTokenIn(address token) external view returns (bool)
```

### isValidTokenOut

```solidity
function isValidTokenOut(address token) external view returns (bool)
```

### previewDeposit

```solidity
function previewDeposit(address tokenIn, uint256 amountTokenToDeposit) external view returns (uint256 amountSharesOut)
```

### previewRedeem

```solidity
function previewRedeem(address tokenOut, uint256 amountSharesToRedeem) external view returns (uint256 amountTokenOut)
```

### assetInfo

```solidity
function assetInfo() external view returns (enum IPStandardizedYield.AssetType assetType, address assetAddress, uint8 assetDecimals)
```

This function contains information to interpret what the asset is

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| assetType | enum IPStandardizedYield.AssetType | the type of the asset (0 for ERC20 tokens, 1 for AMM liquidity tokens) |
| assetAddress | address | the address of the asset |
| assetDecimals | uint8 | the decimals of the asset |

## IPYieldToken

### Mint

```solidity
event Mint(address caller, address receiverPT, address receiverYT, uint256 amountSyToMint, uint256 amountPYOut)
```

### Burn

```solidity
event Burn(address caller, address receiver, uint256 amountPYToRedeem, uint256 amountSyOut)
```

### mintPY

```solidity
function mintPY(address receiverPT, address receiverYT) external returns (uint256 amountPYOut)
```

### redeemPY

```solidity
function redeemPY(address receiver) external returns (uint256 amountSyOut)
```

### rewardIndexesCurrent

```solidity
function rewardIndexesCurrent() external returns (uint256[])
```

### pyIndexCurrent

```solidity
function pyIndexCurrent() external returns (uint256)
```

### pyIndexStored

```solidity
function pyIndexStored() external view returns (uint256)
```

### getRewardTokens

```solidity
function getRewardTokens() external view returns (address[])
```

### SY

```solidity
function SY() external view returns (address)
```

### PT

```solidity
function PT() external view returns (address)
```

### factory

```solidity
function factory() external view returns (address)
```

### expiry

```solidity
function expiry() external view returns (uint256)
```

### isExpired

```solidity
function isExpired() external view returns (bool)
```

### doCacheIndexSameBlock

```solidity
function doCacheIndexSameBlock() external view returns (bool)
```

### pyIndexLastUpdatedBlock

```solidity
function pyIndexLastUpdatedBlock() external view returns (uint128)
```

## IPendleMarketDepositHelper

### totalStaked

```solidity
function totalStaked(address _market) external view returns (uint256)
```

### balance

```solidity
function balance(address _market, address _address) external view returns (uint256)
```

### depositMarket

```solidity
function depositMarket(address _market, uint256 _amount) external
```

### depositMarketFor

```solidity
function depositMarketFor(address _market, address _for, uint256 _amount) external
```

### withdrawMarket

```solidity
function withdrawMarket(address _market, uint256 _amount) external
```

### withdrawMarketWithClaim

```solidity
function withdrawMarketWithClaim(address _market, uint256 _amount, bool _doClaim) external
```

### harvest

```solidity
function harvest(address _market) external
```

### setPoolInfo

```solidity
function setPoolInfo(address poolAddress, address rewarder, bool isActive) external
```

### setOperator

```solidity
function setOperator(address _address, bool _value) external
```

### setmasterPenpie

```solidity
function setmasterPenpie(address _masterPenpie) external
```

### pendleStaking

```solidity
function pendleStaking() external returns (address)
```

## NoyaTimeLock

### constructor

```solidity
constructor(uint256 minDelay, address[] proposers, address[] executors, address owner) public
```

## LifiImplementation

### isHandler

```solidity
mapping(address => bool) isHandler
```

### isBridgeWhiteListed

```solidity
mapping(string => bool) isBridgeWhiteListed
```

### isChainSupported

```solidity
mapping(uint256 => bool) isChainSupported
```

### lifi

```solidity
address lifi
```

### LI_FI_GENERIC_SWAP_SELECTOR

```solidity
bytes4 LI_FI_GENERIC_SWAP_SELECTOR
```

### constructor

```solidity
constructor(address swapHandler) public
```

### onlyHandler

```solidity
modifier onlyHandler()
```

### addHandler

```solidity
function addHandler(address _handler, bool state) external
```

### addChain

```solidity
function addChain(uint256 _chainId, bool state) external
```

### addBridgeBlacklist

```solidity
function addBridgeBlacklist(string _chainId, bool state) external
```

### performSwapAction

```solidity
function performSwapAction(address caller, struct SwapRequest _request) external payable returns (uint256)
```

### verifySwapData

```solidity
function verifySwapData(struct SwapRequest _request) public view returns (bool)
```

### performBridgeAction

```solidity
function performBridgeAction(address caller, struct BridgeRequest _request) external payable
```

### verifyBridgeData

```solidity
function verifyBridgeData(struct BridgeRequest _request) public view returns (bool)
```

### _forward

```solidity
function _forward(contract IERC20 token, address from, uint256 amount, address caller, bytes data, uint256 routeId) internal virtual
```

### _setAllowance

```solidity
function _setAllowance(contract IERC20 token, address spender, uint256 amount) internal
```

### _isNative

```solidity
function _isNative(contract IERC20 token) internal pure returns (bool isNative)
```

### rescueFunds

```solidity
function rescueFunds(address token, address userAddress, uint256 amount) external
```

## WETH_Oracle

### latestRoundData

```solidity
function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
```

