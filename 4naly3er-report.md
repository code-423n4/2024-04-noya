# Report

- [Report](#report)
  - [Gas Optimizations](#gas-optimizations)
    - [\[GAS-1\] Use ERC721A instead ERC721](#gas-1-use-erc721a-instead-erc721)
    - [\[GAS-2\] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)](#gas-2-a--a--b-is-more-gas-effective-than-a--b-for-state-variables-excluding-arrays-and-mappings)
    - [\[GAS-3\] Use assembly to check for `address(0)`](#gas-3-use-assembly-to-check-for-address0)
    - [\[GAS-4\] Comparing to a Boolean constant](#gas-4-comparing-to-a-boolean-constant)
    - [\[GAS-5\] Using bools for storage incurs overhead](#gas-5-using-bools-for-storage-incurs-overhead)
    - [\[GAS-6\] Cache array length outside of loop](#gas-6-cache-array-length-outside-of-loop)
    - [\[GAS-7\] State variables should be cached in stack variables rather than re-reading them from storage](#gas-7-state-variables-should-be-cached-in-stack-variables-rather-than-re-reading-them-from-storage)
    - [\[GAS-8\] Use calldata instead of memory for function arguments that do not get mutated](#gas-8-use-calldata-instead-of-memory-for-function-arguments-that-do-not-get-mutated)
    - [\[GAS-9\] For Operations that will not overflow, you could use unchecked](#gas-9-for-operations-that-will-not-overflow-you-could-use-unchecked)
    - [\[GAS-10\] Use Custom Errors instead of Revert Strings to save Gas](#gas-10-use-custom-errors-instead-of-revert-strings-to-save-gas)
    - [\[GAS-11\] Avoid contract existence checks by using low level calls](#gas-11-avoid-contract-existence-checks-by-using-low-level-calls)
    - [\[GAS-12\] State variables only set in the constructor should be declared `immutable`](#gas-12-state-variables-only-set-in-the-constructor-should-be-declared-immutable)
    - [\[GAS-13\] Functions guaranteed to revert when called by normal users can be marked `payable`](#gas-13-functions-guaranteed-to-revert-when-called-by-normal-users-can-be-marked-payable)
    - [\[GAS-14\] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)](#gas-14-i-costs-less-gas-compared-to-i-or-i--1-same-for---i-vs-i---or-i---1)
    - [\[GAS-15\] Using `private` rather than `public` for constants, saves gas](#gas-15-using-private-rather-than-public-for-constants-saves-gas)
    - [\[GAS-16\] Splitting require() statements that use \&\& saves gas](#gas-16-splitting-require-statements-that-use--saves-gas)
    - [\[GAS-17\] Superfluous event fields](#gas-17-superfluous-event-fields)
    - [\[GAS-18\] `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas](#gas-18-uint256-to-bool-mapping-utilizing-bitmaps-to-dramatically-save-on-gas)
    - [\[GAS-19\] Increments/decrements can be unchecked in for-loops](#gas-19-incrementsdecrements-can-be-unchecked-in-for-loops)
    - [\[GAS-20\] Use != 0 instead of \> 0 for unsigned integer comparison](#gas-20-use--0-instead-of--0-for-unsigned-integer-comparison)
    - [\[GAS-21\] WETH address definition can be use directly](#gas-21-weth-address-definition-can-be-use-directly)
  - [Non Critical Issues](#non-critical-issues)
    - [\[NC-1\] Missing checks for `address(0)` when assigning values to address state variables](#nc-1-missing-checks-for-address0-when-assigning-values-to-address-state-variables)
    - [\[NC-2\] Array indices should be referenced via `enum`s rather than via numeric literals](#nc-2-array-indices-should-be-referenced-via-enums-rather-than-via-numeric-literals)
    - [\[NC-3\] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`](#nc-3-use-stringconcat-or-bytesconcat-instead-of-abiencodepacked)
    - [\[NC-4\] Constants should be in CONSTANT\_CASE](#nc-4-constants-should-be-in-constant_case)
    - [\[NC-5\] `constant`s should be defined rather than using magic numbers](#nc-5-constants-should-be-defined-rather-than-using-magic-numbers)
    - [\[NC-6\] Control structures do not follow the Solidity Style Guide](#nc-6-control-structures-do-not-follow-the-solidity-style-guide)
    - [\[NC-7\] Default Visibility for constants](#nc-7-default-visibility-for-constants)
    - [\[NC-8\] Consider disabling `renounceOwnership()`](#nc-8-consider-disabling-renounceownership)
    - [\[NC-9\] Unused `error` definition](#nc-9-unused-error-definition)
    - [\[NC-10\] Event is never emitted](#nc-10-event-is-never-emitted)
    - [\[NC-11\] Event missing indexed field](#nc-11-event-missing-indexed-field)
    - [\[NC-12\] Events that mark critical parameter changes should contain both the old and the new value](#nc-12-events-that-mark-critical-parameter-changes-should-contain-both-the-old-and-the-new-value)
    - [\[NC-13\] Function ordering does not follow the Solidity style guide](#nc-13-function-ordering-does-not-follow-the-solidity-style-guide)
    - [\[NC-14\] Functions should not be longer than 50 lines](#nc-14-functions-should-not-be-longer-than-50-lines)
    - [\[NC-15\] Lack of checks in setters](#nc-15-lack-of-checks-in-setters)
    - [\[NC-16\] Missing Event for critical parameters change](#nc-16-missing-event-for-critical-parameters-change)
    - [\[NC-17\] NatSpec is completely non-existent on functions that should have them](#nc-17-natspec-is-completely-non-existent-on-functions-that-should-have-them)
    - [\[NC-18\] Incomplete NatSpec: `@param` is missing on actually documented functions](#nc-18-incomplete-natspec-param-is-missing-on-actually-documented-functions)
    - [\[NC-19\] Incomplete NatSpec: `@return` is missing on actually documented functions](#nc-19-incomplete-natspec-return-is-missing-on-actually-documented-functions)
    - [\[NC-20\] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor](#nc-20-use-a-modifier-instead-of-a-requireif-statement-for-a-special-msgsender-actor)
    - [\[NC-21\] Consider using named mappings](#nc-21-consider-using-named-mappings)
    - [\[NC-22\] Adding a `return` statement when the function defines a named return variable, is redundant](#nc-22-adding-a-return-statement-when-the-function-defines-a-named-return-variable-is-redundant)
    - [\[NC-23\] `require()` / `revert()` statements should have descriptive reason strings](#nc-23-requirerevertstatements-should-have-descriptive-reason-strings)
    - [\[NC-24\] Take advantage of Custom Error's return value property](#nc-24-take-advantage-of-custom-errors-return-value-property)
    - [\[NC-25\] Avoid the use of sensitive terms](#nc-25-avoid-the-use-of-sensitive-terms)
    - [\[NC-26\] Contract does not follow the Solidity style guide's suggested layout ordering](#nc-26-contract-does-not-follow-the-solidity-style-guides-suggested-layout-ordering)
    - [\[NC-27\] TODO Left in the code](#nc-27-todo-left-in-the-code)
    - [\[NC-28\] Use Underscores for Number Literals (add an underscore every 3 digits)](#nc-28-use-underscores-for-number-literals-add-an-underscore-every-3-digits)
    - [\[NC-29\] Internal and private variables and functions names should begin with an underscore](#nc-29-internal-and-private-variables-and-functions-names-should-begin-with-an-underscore)
    - [\[NC-30\] Event is missing `indexed` fields](#nc-30-event-is-missing-indexed-fields)
    - [\[NC-31\] Constants should be defined rather than using magic numbers](#nc-31-constants-should-be-defined-rather-than-using-magic-numbers)
    - [\[NC-32\] `override` function arguments that are unused should have the variable name removed or commented out to avoid compiler warnings](#nc-32-override-function-arguments-that-are-unused-should-have-the-variable-name-removed-or-commented-out-to-avoid-compiler-warnings)
    - [\[NC-33\] `public` functions not called by the contract should be declared `external` instead](#nc-33-public-functions-not-called-by-the-contract-should-be-declared-external-instead)
    - [\[NC-34\] Variables need not be initialized to zero](#nc-34-variables-need-not-be-initialized-to-zero)
  - [Low Issues](#low-issues)
    - [\[L-1\] `approve()`/`safeApprove()` may revert if the current approval is not zero](#l-1-approvesafeapprove-may-revert-if-the-current-approval-is-not-zero)
    - [\[L-2\] Use a 2-step ownership transfer pattern](#l-2-use-a-2-step-ownership-transfer-pattern)
    - [\[L-3\] Some tokens may revert when zero value transfers are made](#l-3-some-tokens-may-revert-when-zero-value-transfers-are-made)
    - [\[L-4\] Missing checks for `address(0)` when assigning values to address state variables](#l-4-missing-checks-for-address0-when-assigning-values-to-address-state-variables)
    - [\[L-5\] `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`](#l-5-abiencodepacked-should-not-be-used-with-dynamic-types-when-passing-the-result-to-a-hash-function-such-as-keccak256)
    - [\[L-6\] `decimals()` is not a part of the ERC-20 standard](#l-6-decimals-is-not-a-part-of-the-erc-20-standard)
    - [\[L-7\] Deprecated approve() function](#l-7-deprecated-approve-function)
    - [\[L-8\] Division by zero not prevented](#l-8-division-by-zero-not-prevented)
    - [\[L-9\] `domainSeparator()` isn't protected against replay attacks in case of a future chain split](#l-9-domainseparator-isnt-protected-against-replay-attacks-in-case-of-a-future-chain-split)
    - [\[L-10\] Empty Function Body - Consider commenting why](#l-10-empty-function-body---consider-commenting-why)
    - [\[L-11\] Empty `receive()/payable fallback()` function does not authenticate requests](#l-11-empty-receivepayable-fallback-function-does-not-authenticate-requests)
    - [\[L-12\] External calls in an un-bounded `for-`loop may result in a DOS](#l-12-external-calls-in-an-un-bounded-for-loop-may-result-in-a-dos)
    - [\[L-13\] External call recipient may consume all transaction gas](#l-13-external-call-recipient-may-consume-all-transaction-gas)
    - [\[L-14\] Signature use at deadlines should be allowed](#l-14-signature-use-at-deadlines-should-be-allowed)
    - [\[L-15\] Prevent accidentally burning tokens](#l-15-prevent-accidentally-burning-tokens)
    - [\[L-16\] Possible rounding issue](#l-16-possible-rounding-issue)
    - [\[L-17\] Loss of precision](#l-17-loss-of-precision)
    - [\[L-18\] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`](#l-18-solidity-version-0820-may-not-work-on-other-chains-due-to-push0)
    - [\[L-19\] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`](#l-19-use-ownable2steptransferownership-instead-of-ownabletransferownership)
    - [\[L-20\] Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting](#l-20-consider-using-openzeppelins-safecast-library-to-prevent-unexpected-overflows-when-downcasting)
    - [\[L-21\] Unsafe ERC20 operation(s)](#l-21-unsafe-erc20-operations)
  - [Medium Issues](#medium-issues)
    - [\[M-1\] Contracts are vulnerable to fee-on-transfer accounting-related issues](#m-1-contracts-are-vulnerable-to-fee-on-transfer-accounting-related-issues)
    - [\[M-2\] Centralization Risk for trusted owners](#m-2-centralization-risk-for-trusted-owners)
      - [Impact](#impact)
    - [\[M-3\] Fees can be set to be greater than 100%](#m-3-fees-can-be-set-to-be-greater-than-100)
    - [\[M-4\] Lack of EIP-712 compliance: using `keccak256()` directly on an array or struct variable](#m-4-lack-of-eip-712-compliance-using-keccak256-directly-on-an-array-or-struct-variable)
    - [\[M-5\] Library function isn't `internal` or `private`](#m-5-library-function-isnt-internal-or-private)

## Gas Optimizations

| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Use ERC721A instead ERC721 | 1 |
| [GAS-2](#GAS-2) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 40 |
| [GAS-3](#GAS-3) | Use assembly to check for `address(0)` | 95 |
| [GAS-4](#GAS-4) | Comparing to a Boolean constant | 12 |
| [GAS-5](#GAS-5) | Using bools for storage incurs overhead | 5 |
| [GAS-6](#GAS-6) | Cache array length outside of loop | 38 |
| [GAS-7](#GAS-7) | State variables should be cached in stack variables rather than re-reading them from storage | 32 |
| [GAS-8](#GAS-8) | Use calldata instead of memory for function arguments that do not get mutated | 93 |
| [GAS-9](#GAS-9) | For Operations that will not overflow, you could use unchecked | 322 |
| [GAS-10](#GAS-10) | Use Custom Errors instead of Revert Strings to save Gas | 14 |
| [GAS-11](#GAS-11) | Avoid contract existence checks by using low level calls | 40 |
| [GAS-12](#GAS-12) | State variables only set in the constructor should be declared `immutable` | 52 |
| [GAS-13](#GAS-13) | Functions guaranteed to revert when called by normal users can be marked `payable` | 121 |
| [GAS-14](#GAS-14) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 43 |
| [GAS-15](#GAS-15) | Using `private` rather than `public` for constants, saves gas | 29 |
| [GAS-16](#GAS-16) | Splitting require() statements that use && saves gas | 7 |
| [GAS-17](#GAS-17) | Superfluous event fields | 1 |
| [GAS-18](#GAS-18) | `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas | 1 |
| [GAS-19](#GAS-19) | Increments/decrements can be unchecked in for-loops | 39 |
| [GAS-20](#GAS-20) | Use != 0 instead of > 0 for unsigned integer comparison | 23 |
| [GAS-21](#GAS-21) | WETH address definition can be use directly | 1 |

### <a name="GAS-1"></a>[GAS-1] Use ERC721A instead ERC721

ERC721A standard, ERC721A is an improvement standard for ERC721 tokens. It was proposed by the Azuki team and used for developing their NFT collection. Compared with ERC721, ERC721A is a more gas-efficient standard to mint a lot of of NFTs simultaneously. It allows developers to mint multiple NFTs at the same gas price. This has been a great improvement due to Ethereum's sky-rocketing gas fee.

    Reference: https://nextrope.com/erc721-vs-erc721a-2/

*Instances (1)*:

```solidity
File: contracts/connectors/PancakeswapConnector.sol

6: import "@openzeppelin/contracts-5.0/token/ERC721/IERC721.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

### <a name="GAS-2"></a>[GAS-2] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)

This saves **16 gas per instance.**

*Instances (40)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

217:         depositQueue.last += 1;

218:         depositQueue.totalAWFDeposit += amount;

236:             i += 1;

246:             middleTemp += 1;

271:             i += 1;

280:             processedBaseTokenAmount += data.amount;

282:             firstTemp += 1;

286:         totalDepositedAmount += processedBaseTokenAmount;

310:         withdrawRequestsByAddress[msg.sender] += share;

315:         withdrawQueue.last += 1;

342:             i += 1;

347:             assetsNeededForWithdraw += assets;

348:             processedShares += data.shares;

351:             middleTemp += 1;

353:         currentWithdrawGroup.totalCBAmount += assetsNeededForWithdraw;

411:             i += 1;

421:             processedBaseTokenAmount += data.amount;

424:                 withdrawFeeAmount += feeAmount;

434:             firstTemp += 1;

436:         totalWithdrawnAmount += processedBaseTokenAmount;

561:             amountAskedForWithdraw_temp += retrieveData[i].withdrawAmount;

569:         amountAskedForWithdraw += amountAskedForWithdraw_temp;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

102:             CollValue += principalInBase;

119:                 if (riskAdjusted) CollValue += collateralValueInVirtualBase * info.liquidateCollateralFactor / 1e18;

120:                 else CollValue += collateralValueInVirtualBase;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

116:                 totalCollateral += value;

118:                 totalDebt += value;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

271:                 SYAmount += lpBalance * IPMarket(market).getLpToAssetRate(10) / 1e18;

275:             if (PTAmount > 0) SYAmount += PTAmount * IPMarket(market).getPtToAssetRate(10) / 1e18;

278:             if (YTBalance > 0) SYAmount += getYTValue(market, YTBalance);

280:             if (SYAmount > 0) underlyingBalance += SYAmount * _SY.exchangeRate() / 1e18;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

118:             depositAmount += IERC20(assetsS[i].collateralOnlyToken).balanceOf(address(this));

124:             totalDepositAmount += depositAmount * price / 1e18;

125:             totalBAmount += borrowAmount * price / 1e18;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

144:             amount0 += tokensOwed0;

145:             amount1 += tokensOwed1;

148:         tvl += valueOracle.getValue(token0, base, amount0);

149:         tvl += valueOracle.getValue(token1, base, amount1);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

25:                 totalDebt += tvl;

27:                 totalTVL += tvl;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

### <a name="GAS-3"></a>[GAS-3] Use assembly to check for `address(0)`

*Saves 6 gas per instance*

*Instances (95)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

106:         require(p._baseTokenAddress != address(0));

107:         require(p._valueOracle != address(0));

108:         require(p._withdrawFeeReceiver != address(0));

109:         require(p._performanceFeeReceiver != address(0));

110:         require(p._managementFeeReceiver != address(0));

125:         require(address(_valueOracle) != address(0));

140:         require(_withdrawFeeReceiver != address(0));

141:         require(_performanceFeeReceiver != address(0));

142:         require(_managementFeeReceiver != address(0));

186:         if (!(from == address(0)) && balanceOf(from) < amount + withdrawRequestsByAddress[from]) {

684:         if (token == address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

15:         require(_accountingManager != address(0));

16:         require(_baseToken != address(0));

17:         require(_receiver != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/accountingManager/Registry.sol

54:         if (vaults[_vaultId].accountManager == address(0)) revert NotExist();

67:         require(_governer != address(0));

68:         require(_maintainer != address(0));

69:         require(_emergency != address(0));

118:         if (vaults[vaultId].accountManager != address(0)) revert AlreadyExists();

120:         require(_governer != address(0));

121:         require(_accountingManager != address(0));

122:         require(_baseToken != address(0));

123:         require(_maintainer != address(0));

124:         require(_keeperContract != address(0));

125:         require(_watcher != address(0));

167:         require(_governer != address(0));

168:         require(_maintainer != address(0));

169:         require(_keeperContract != address(0));

170:         require(_watcher != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

36:         require(_pool != address(0));

37:         require(_poolBaseToken != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

43:         require(_router != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

45:         require(_balancerVault != address(0));

46:         require(bal != address(0));

47:         require(aura != address(0));

177:         if (pool.auraPoolAddress != address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

25:         require(_balancerVault != address(0));

26:         require(address(_registry) != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

37:         require(_router != address(0));

38:         require(_factory != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

52:         require(_convexBooster != address(0));

53:         require(cvx != address(0));

54:         require(crv != address(0));

55:         require(prisma != address(0));

126:         address poolAddress = (poolInfo.tokens.length > 2 && poolInfo.zap != address(0)) ? poolInfo.zap : pool;

283:         if (info.poolAddressIfDefaultWithdrawTokenIsAnotherPosition != address(0)) {

326:         if (info.convexRewardPool == address(0)) return 0;

345:         if (info.gauge == address(0)) return 0;

355:         if (prismaPool == address(0)) return 0;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

24:         require(_depositWithdrawalProxy != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

78:         if (approvalToken != address(0)) {

82:         if (approvalToken != address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

23:         require(_lido != address(0));

24:         require(_lidoW != address(0));

25:         require(_steth != address(0));

26:         require(w != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

46:         require(_mav != address(0));

47:         require(_veMav != address(0));

48:         require(mr != address(0));

49:         require(pi != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

24:         require(MB != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

22:         require(MC != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

60:         require(_pendleMarketDepositHelper != address(0));

61:         require(_pendleRouter != address(0));

62:         require(SR != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

21:         require(_SNXCoreProxy != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

18:         require(SR != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

36:         require(lpStacking != address(0));

37:         require(_stargateRouter != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/governance/NoyaGovernanceBase.sol

22:         require(address(_registry) != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/NoyaGovernanceBase.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

41:         require(lzHelperAddress != address(0));

53:         require(omniChainManager != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

52:         require(lzHelperAddress != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

37:         require(_lzHelper != address(0));

47:         require(destinationAddress != address(0));

76:             destChainAddress[bridgeRequest.destChainId] == address(0)

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

30:         if (routes[_routeId].route == address(0) && !routes[_routeId].isEnabled) revert RouteNotFound();

41:         require(_valueOracle != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

86:         if (_request.outputToken == address(0)) {

93:         if (_request.outputToken == address(0)) {

190:         return address(token) == address(0);

194:         if (token == address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

19:             if (positions[i].calculatorConnector == address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

30:         require(address(_registry) != address(0));

97:         if (address(oracle) == address(0)) {

100:         if (address(oracle) == address(0)) {

103:         if (address(oracle) == address(0)) {

106:         if (address(oracle) == address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

47:         require(_reg != address(0));

95:         if (primarySource == address(0)) {

144:         if (assetsSources[asset][baseToken] != address(0)) {

146:         } else if (assetsSources[baseToken][asset] != address(0)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

50:         require(pool != address(0), "pool doesn't exist");

63:         if (pool == address(0)) {

66:         if (pool == address(0)) revert INoyaOracle_ValueOracleUnavailable(tokenIn, baseToken);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="GAS-4"></a>[GAS-4] Comparing to a Boolean constant

Comparing to a constant (`true` or `false`) is a bit more expensive than directly checking the returned boolean value.

Consider using `if(directValue)` instead of `if(directValue == true)` and `if(!directValue)` instead of `if(directValue == false)`

*Instances (12)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

335:         if (currentWithdrawGroup.isFullfilled == false && currentWithdrawGroup.isStarted == true) {

361:         require(currentWithdrawGroup.isStarted == false && currentWithdrawGroup.isFullfilled == false);

371:         require(currentWithdrawGroup.isStarted == true && currentWithdrawGroup.isFullfilled == false);

397:         if (currentWithdrawGroup.isFullfilled == false) {

619:             currentWithdrawGroup.isStarted == false || currentWithdrawGroup.isFullfilled == true

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

33:         if (msg.sender != vaults[_vaultId].maintainer || hasRole(EMERGENCY_ROLE, msg.sender) == false) {

40:         if (msg.sender != vaults[_vaultId].maintainerWithoutTimeLock && hasRole(EMERGENCY_ROLE, msg.sender) == false) {

47:         if (msg.sender != vaults[_vaultId].governer && hasRole(EMERGENCY_ROLE, msg.sender) == false) {

251:             if (vault.connectors[calculatorConnector].enabled == false) revert NotExist();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

35:         require(isHandler[msg.sender] == true, "LifiImplementation: INVALID_SENDER");

153:         if (isBridgeWhiteListed[bridgeData.bridge] == false) revert BridgeBlacklisted();

154:         if (isChainSupported[bridgeData.destinationChainId] == false) revert InvalidChainId();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="GAS-5"></a>[GAS-5] Using bools for storage incurs overhead

Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (5)*:

```solidity
File: contracts/governance/Keepers.sol

10:     mapping(address => bool) public isOwner;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

13:     mapping(address => bool) public isEligibleToUse;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

13:     mapping(address => bool) public isHandler;

14:     mapping(string => bool) public isBridgeWhiteListed;

15:     mapping(uint256 => bool) public isChainSupported;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="GAS-6"></a>[GAS-6] Cache array length outside of loop

If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (38)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

551:         for (uint256 i = 0; i < retrieveData.length; i++) {

603:             for (uint256 i = 0; i < items.length; i++) {

608:             for (uint256 i = 0; i < items.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

138:         for (uint256 i = 0; i < _trustedTokens.length; i++) {

194:         for (uint256 i = 0; i < _connectorAddresses.length; i++) {

214:         for (uint256 i = 0; i < _tokens.length; i++) {

253:             for (uint256 i = 0; i < usingTokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

54:         for (uint256 i = 0; i < rewardsPools.length; i++) {

77:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

74:             for (uint256 i = 0; i < tokens.length; i++) {

79:             for (uint256 i = 0; i < destinationConnector.length; i++) {

84:             for (uint256 i = 0; i < tokens.length; i++) {

89:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

222:         for (uint256 i = 0; i < gauges.length; i++) {

234:         for (uint256 i = 0; i < pools.length; i++) {

248:         for (uint256 i = 0; i < rewardsPools.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

113:         for (uint256 i = 0; i < markets.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

69:         for (uint256 i = 0; i < calls.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

140:         for (uint256 i = 0; i < earnedInfo.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

244:         for (uint256 i = 0; i < rewardTokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

116:         for (uint256 i = 0; i < assets.length; i++) {

132:         for (uint256 i = 0; i < assetsS.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

102:         for (uint256 i = 0; i < tokenIds.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

29:         for (uint256 i = 0; i < _owners.length; i++) {

44:         for (uint256 i = 0; i < _owners.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

178:         for (uint256 i = 0; i < tokens.length; i++) {

189:         for (uint256 i = 0; i < tokens.length; i++) {

211:         for (uint256 i = 0; i < tokensIn.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

41:         for (uint256 i = 0; i < tokens.length; i++) {

46:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

37:         for (uint256 i = 0; i < usersAddresses.length; i++) {

148:         for (uint256 i = 0; i < _routes.length;) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

18:         for (uint256 i = 0; i < positions.length; i++) {

44:         for (uint256 i = 0; i < positions.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

41:         for (uint256 i = 0; i < baseCurrencies.length; i++) {

55:         for (uint256 i = 0; i < oracle.length; i++) {

88:         for (uint256 i = 0; i < sources.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

74:         for (uint256 i = 0; i < assets.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="GAS-7"></a>[GAS-7] State variables should be cached in stack variables rather than re-reading them from storage

The instances below point to the second+ access of a state variable within a function. Caching of a state variable replaces each Gwarmaccess (100 gas) with a much cheaper stack read. Other less obvious fixes/optimizations include having local memory caches of state variable structs, or having local caches of state variable contracts/addresses.

*Saves 100 gas per instance*

*Instances (32)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

519:         _mint(managementFeeReceiver, managementFeeAmount);

538:         emit CollectPerformanceFee(preformanceFeeSharesWaitingForDistribution);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

48:         IPool(pool).supply(supplyToken, amount, address(this), 0);

72:         (,,,,, uint256 healthFactor) = IPool(pool).getUserAccountData(address(this));

83:         IPool(pool).repay(asset, amount, i, address(this));

103:         (uint256 totalCollateralBase,,,,, uint256 healthFactor) = IPool(pool).getUserAccountData(address(this));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

56:         _approveOperations(IPool(data.pool).token1(), address(aerodromeRouter), data.amount1);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

75:         address pool = IBalancerVault(balancerVault).getPool(poolId);

78:             if (amounts[i] > 0) _approveOperations(tokens[i], balancerVault, amounts[i]);

81:         IBalancerVault(balancerVault).joinPool(

130:             IBalancerVault(balancerVault).exitPool(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

45:         _approveOperations(p.tokenB, address(router), p.amountB);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

43:         _updateTokenInRegistry(weth);

57:         uint256[] memory requestIds = ILidoWithdrawal(lidoWithdrawal).requestWithdrawals(amounts, address(this));

61:         _updateTokenInRegistry(steth);

71:         ILidoWithdrawal(lidoWithdrawal).approve(lidoWithdrawal, requestId);

75:         ILidoWithdrawal(lidoWithdrawal).claimWithdrawal(requestId);

85:         _updateTokenInRegistry(weth);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

68:         IveMAV(veMav).stake(amount, duration, doDelegation);

69:         _updateTokenInRegistry(mav);

70:         _updateTokenInRegistry(veMav);

82:         _updateTokenInRegistry(veMav);

94:         _approveOperations(p.pool.tokenB(), maverickRouter, p.tokenBRequiredAllowance);

98:             (tokenId,,,) = IMaverickRouter(maverickRouter).addLiquidityToPool{ value: sendEthAmount }(

121:         position.approve(maverickRouter, p.tokenId);

122:         IMaverickRouter(maverickRouter).removeLiquidity(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

42:             _approveOperations(params.collateralToken, address(morphoBlue), amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

46:         _approveOperations(p.token1, address(positionManager), p.amount1Desired);

91:         _approveOperations(token1, address(positionManager), p.amount1Desired);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

85:             registry.getHoldingPositionIndex(vaultId, positionId, address(this), abi.encode(address(this)));

87:             registry.updateHoldingPosition(vaultId, positionId, abi.encode(address(this)), "", remove);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

182:         emit Forwarded(lifi, address(token), amount, data);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="GAS-8"></a>[GAS-8] Use calldata instead of memory for function arguments that do not get mutated

When a function with a `memory` array is called externally, the `abi.decode()` step has to use a for-loop to copy each index of the `calldata` to the `memory` index. Each iteration of this for-loop costs at least 60 gas (i.e. `60 * <mem_array>.length`). Using `calldata` directly bypasses this loop.

If the array is passed to an `internal` function which passes the array to another internal function where the array is modified and therefore `memory` is used in the `external` call, it's still more gas-efficient to use `calldata` when the `external` function uses modifiers, since the modifiers may prevent the internal functions from being called. Structs have the same overhead as an array of length one.

 *Saves 60 gas per instance*

*Instances (93)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

257:     function executeDeposit(uint256 maxI, address connector, bytes memory addLPdata)

596:     function getQueueItems(bool depositOrWithdraw, uint256[] memory items)

632:     function getPositionTVL(HoldingPI memory position, address base) public view returns (uint256) {

649:     function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

394:     function getHoldingPositionIndex(uint256 vaultId, bytes32 _positionId, address _connector, bytes memory data)

486:     function calculatePositionId(address calculatorConnector, uint256 positionTypeId, bytes memory data)

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

114:     function _getPositionTVL(HoldingPI memory, address base) public view override returns (uint256 tvl) {

120:     function _getUnderlyingTokens(uint256, bytes memory) public pure override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

53:     function supply(DepositData memory data) public onlyManager nonReentrant {

79:     function withdraw(WithdrawData memory data) public onlyManager nonReentrant {

117:     function _getUnderlyingTokens(uint256 p, bytes memory data) public view override returns (address[] memory) {

125:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

66:         uint256[] memory amounts,

67:         uint256[] memory amountsWithoutBPT,

115:     function decreasePosition(DecreasePositionParams memory p) public onlyManager nonReentrant {

162:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256) {

175:     function totalLpBalanceOf(PoolInfo memory pool) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

37:     function makeFlashLoan(IERC20[] memory tokens, uint256[] memory amounts, bytes memory userData)

55:         IERC20[] memory tokens,

57:         uint256[] memory feeAmounts,

58:         bytes memory userData

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

88:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

99:     function _getUnderlyingTokens(uint256 id, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

125:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256) {

134:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

265:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

279:     function LPToUnder(PoolInfo memory info, uint256 balance) public view returns (uint256, address) {

311:     function totalLpBalanceOf(PoolInfo memory info) public view returns (uint256) {

325:     function balanceOfConvexRewardPool(PoolInfo memory info) public view returns (uint256) {

335:     function balanceOfLPToken(PoolInfo memory info) public view returns (uint256) {

344:     function balanceOfRewardPool(PoolInfo memory info) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

98:     function closeBorrowPosition(uint256[] memory marketIds, uint256 accountId) public onlyManager nonReentrant {

106:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

142:     function _getUnderlyingTokens(uint256 p, bytes memory data) public view override returns (address[] memory) {

150:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

93:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

91:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

149:     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {

153:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

161:     function _getUnderlyingTokens(uint256 id, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

108:     function getHealthFactor(Id _id, Market memory _market) public view returns (uint256) {

118:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

141:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

149:     function swapYTForPT(address market, uint256 exactYTIn, uint256 min, ApproxParams memory guess)

166:     function swapYTForSY(address market, uint256 exactYTIn, uint256 min, LimitOrderData memory orderData)

257:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

311:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

145:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

164:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

64:     function onERC721Received(address, address, uint256, bytes memory) external pure override returns (bytes4) {

121:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

128:     function _getUnderlyingTokens(uint256, bytes memory) public pure override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

109:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

143:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

110:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

123:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

63:     function decreasePosition(DecreaseLiquidityParams memory p) external onlyManager nonReentrant {

87:     function increasePosition(IncreaseLiquidityParams memory p) external onlyManager nonReentrant {

101:     function collectAllFees(uint256[] memory tokenIds) public onlyManager nonReentrant {

127:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

152:     function _getUnderlyingTokens(uint256, bytes memory data) public pure override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

42:     function updateOwners(address[] memory _owners, bool[] memory addOrRemove) public onlyOwner {

89:         bytes32[] memory sigR,

90:         bytes32[] memory sigS,

91:         uint8[] memory sigV,

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/governance/Watchers.sol

8:     function verifyRemoveLiquidity(uint256 withdrawAmount, uint256 sentAmount, bytes memory data) external view { }

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Watchers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

84:     function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes memory data)

123:         address[] memory tokens,

124:         uint256[] memory amounts,

125:         bytes memory data,

169:     function addLiquidity(address[] memory tokens, uint256[] memory amounts, bytes memory data)

205:         address[] memory tokensIn,

206:         address[] memory tokensOut,

207:         uint256[] memory amountsIn,

208:         bytes[] memory swapData,

209:         uint256[] memory routeIds

232:     function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {

249:     function getPositionTVL(HoldingPI memory p, address baseToken) public view returns (uint256) {

263:     function _getUnderlyingTokens(uint256, bytes memory) public view virtual returns (address[] memory) {

271:     function _getPositionTVL(HoldingPI memory, address) public view virtual returns (uint256 tvl) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

27:     function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes memory data)

40:     function addLiquidity(address[] memory tokens, uint256[] memory amounts, bytes memory data) external {

51:     function updatePositionToRegistryUsingType(bytes32 _positionId, bytes memory data, bool remove) external {

59:     function addPositionToRegistryUsingType(uint256 _positionType, bytes memory data) external {

65:     function addPositionToRegistry(bytes memory data) external {

71:     function getPositionTVL(HoldingPI memory p, address baseToken) public view returns (uint256) {

75:     function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

36:     function updateMessageSetting(bytes memory _messageSetting) public onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

68:     function startBridgeTransaction(BridgeRequest memory bridgeRequest) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol

51:     function _getPositionTVL(HoldingPI memory position, address) public view override returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol

33:     function _getPositionTVL(HoldingPI memory position, address base) public view override returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

147:     function addRoutes(RouteData[] memory _routes) public onlyMaintainer {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

65:     function addBridgeBlacklist(string memory bridgeName, bool state) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="GAS-9"></a>[GAS-9] For Operations that will not overflow, you could use unchecked

*Instances (322)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

4: import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

5: import { ERC4626, ERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/extensions/ERC4626.sol";

6: import "../interface/Accounting/IAccountingManager.sol";

7: import { NoyaGovernanceBase, PositionBP } from "../governance/NoyaGovernanceBase.sol";

8: import "../helpers/TVLHelper.sol";

63:     uint256 public withdrawFee; // 0.0001% = 1

87:     uint256 public depositLimitTotalAmount = 1e6 * 200_000;

89:     uint256 public depositLimitPerTransaction = 1e6 * 2000;

186:         if (!(from == address(0)) && balanceOf(from) < amount + withdrawRequestsByAddress[from]) {

217:         depositQueue.last += 1;

218:         depositQueue.totalAWFDeposit += amount;

236:             i += 1;

243:                 middleTemp, data.receiver, block.timestamp, shares, data.amount, shares * 1e18 / data.amount

246:             middleTemp += 1;

269:                 && depositQueue.queue[firstTemp].calculationTime + depositWaitingTime <= block.timestamp && i < maxI

271:             i += 1;

275:                 firstTemp, data.receiver, block.timestamp, data.shares, data.amount, data.shares * 1e18 / data.amount

280:             processedBaseTokenAmount += data.amount;

282:             firstTemp += 1;

284:         depositQueue.totalAWFDeposit -= processedBaseTokenAmount;

286:         totalDepositedAmount += processedBaseTokenAmount;

305:         if (balanceOf(msg.sender) < share + withdrawRequestsByAddress[msg.sender]) {

310:         withdrawRequestsByAddress[msg.sender] += share;

315:         withdrawQueue.last += 1;

342:             i += 1;

347:             assetsNeededForWithdraw += assets;

348:             processedShares += data.shares;

351:             middleTemp += 1;

353:         currentWithdrawGroup.totalCBAmount += assetsNeededForWithdraw;

379:         uint256 availableAssets = baseToken.balanceOf(address(this)) - depositQueue.totalAWFDeposit;

408:                 && withdrawQueue.queue[firstTemp].calculationTime + withdrawWaitingTime <= block.timestamp

411:             i += 1;

416:                 data.amount * currentWithdrawGroup.totalABAmount / currentWithdrawGroup.totalCBAmountFullfilled;

418:             withdrawRequestsByAddress[data.owner] -= shares;

421:             processedBaseTokenAmount += data.amount;

423:                 uint256 feeAmount = baseTokenAmount * withdrawFee / FEE_PRECISION;

424:                 withdrawFeeAmount += feeAmount;

425:                 baseTokenAmount = baseTokenAmount - feeAmount;

434:             firstTemp += 1;

436:         totalWithdrawnAmount += processedBaseTokenAmount;

484:             previewDeposit(((storedProfitForFee - totalProfitCalculated) * performanceFee) / FEE_PRECISION);

506:         if (block.timestamp - lastFeeDistributionTime < 1 days) {

509:         uint256 timePassed = block.timestamp - lastFeeDistributionTime;

514:         uint256 currentFeeShares = balanceOf(managementFeeReceiver) + balanceOf(performanceFeeReceiver)

515:             + preformanceFeeSharesWaitingForDistribution;

518:             (timePassed * managementFee * (totalShares - currentFeeShares)) / FEE_PRECISION / 365 days;

528:             preformanceFeeSharesWaitingForDistribution == 0 || block.timestamp - profitStoredTime < 12 hours

529:                 || block.timestamp - profitStoredTime > 48 hours

551:         for (uint256 i = 0; i < retrieveData.length; i++) {

560:             if (balanceBefore + amount > balanceAfter) revert NoyaAccounting_banalceAfterIsNotEnough();

561:             amountAskedForWithdraw_temp += retrieveData[i].withdrawAmount;

566:                 amountAskedForWithdraw + amountAskedForWithdraw_temp

569:         amountAskedForWithdraw += amountAskedForWithdraw_temp;

584:         if (tvl + totalWithdrawnAmount > totalDepositedAmount) {

585:             return tvl + totalWithdrawnAmount - totalDepositedAmount;

603:             for (uint256 i = 0; i < items.length; i++) {

608:             for (uint256 i = 0; i < items.length; i++) {

617:         uint256 availableAssets = baseToken.balanceOf(address(this)) - depositQueue.totalAWFDeposit;

618:         if ( // check if the withdraw group is fullfilled

624:         return currentWithdrawGroup.totalCBAmount - availableAssets;

628:         return TVLHelper.getTVL(vaultId, registry, address(baseToken)) + baseToken.balanceOf(address(this))

629:             - depositQueue.totalAWFDeposit;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

4: import { AccountingManager } from "./AccountingManager.sol";

5: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/accountingManager/Registry.sol

4: import "@openzeppelin/contracts-5.0/access/AccessControl.sol";

5: import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

6: import "../interface/IPositionRegistry.sol";

138:         for (uint256 i = 0; i < _trustedTokens.length; i++) {

194:         for (uint256 i = 0; i < _connectorAddresses.length; i++) {

214:         for (uint256 i = 0; i < _tokens.length; i++) {

253:             for (uint256 i = 0; i < usingTokens.length; i++) {

274:         for (uint256 i = 0; i < length; i++) {

322:             return vault.holdingPositions.length - 1;

349:             if (positionIndex < vault.holdingPositions.length - 1) {

350:                 vault.holdingPositions[positionIndex] = vault.holdingPositions[vault.holdingPositions.length - 1];

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import { IPool } from "../external/interfaces/Aave/IPool.sol";

106:         if (totalCollateralBase <= DUST_LEVEL * 1e7) {

116:         uint256 poolBaseAmount = totalCollateralBase - totalDebtBase;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/Aerodrome/IPool.sol";

6: import "../external/interfaces/Aerodrome/IRouter.sol";

7: import "../external/interfaces/Aerodrome/IVoter.sol";

8: import "../external/interfaces/Aerodrome/IGauge.sol";

131:         uint256 amount0 = balance * reserve0 / totalSupply;

132:         uint256 amount1 = balance * reserve1 / totalSupply;

133:         return _getValue(IPool(pool).token0(), base, amount0) + _getValue(IPool(pool).token1(), base, amount1);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/Balancer/IBalancerVault.sol";

54:         for (uint256 i = 0; i < rewardsPools.length; i++) {

77:         for (uint256 i = 0; i < tokens.length; i++) {

83:             address(this), // sender

84:             address(this), // recipient

90:                     amountsWithoutBPT, //_noBptAmounts,

91:                     minBPT // minimumBPT

132:                 address(this), // sender

133:                 payable(address(this)), // recipient

140:                         p.withdrawIndex // enterTokenIndex

172:         return (((1e18 * token1bal * lpBalance) / _weight) / _totalSupply);

181:         return IERC20(pool.pool).balanceOf(address(this)) + auraShares;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

4: import { IBalancerVault, IERC20 } from "../external/interfaces/Balancer/IBalancerVault.sol";

5: import { IFlashLoanRecipient } from "../external/interfaces/Balancer/IFlashLoanRecipient.sol";

6: import { PositionRegistry, PositionBP } from "../accountingManager/Registry.sol";

7: import { BaseConnector } from "../helpers/BaseConnector.sol";

8: import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

10: import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

74:             for (uint256 i = 0; i < tokens.length; i++) {

77:                 amounts[i] = amounts[i] + feeAmounts[i];

79:             for (uint256 i = 0; i < destinationConnector.length; i++) {

84:             for (uint256 i = 0; i < tokens.length; i++) {

89:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

4: import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

6: import "../helpers/BaseConnector.sol";

7: import "../external/interfaces/Camelot/ICamelotRouter.sol";

8: import "../external/interfaces/Camelot/ICamelotFactory.sol";

9: import "../external/interfaces/Camelot/ICamelotPair.sol";

96:         return balanceThis * (_getValue(tokenA, base, reserves0) + _getValue(tokenB, base, reserves1)) / totalSupply;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import { IComet, IRewards } from "../external/interfaces/Compound/ICompound.sol";

78:         return getCollBlanace(comet, true) * 1e18 / borrowBalanceInBase;

89:         borrowBalanceInVirtualBase = (borrowBalanceInBase * basePriceInVirtualBase) / comet.baseScale();

102:             CollValue += principalInBase;

107:         for (uint8 i; i < numberOfAssets; ++i) {

118:                     collateralBalance * collateralPriceInVirtualBase * baseScale / info.scale / basePrice;

119:                 if (riskAdjusted) CollValue += collateralValueInVirtualBase * info.liquidateCollateralFactor / 1e18;

120:                 else CollValue += collateralValueInVirtualBase;

121:             } // else user collateral is zero.

130:         uint256 balance = positiveBalance - negativeBalance;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/Curve/IRewardsGauge.sol";

6: import "../external/interfaces/Convex/IConvexBasicRewards.sol";

7: import { IDepositToken } from "../external/interfaces/Prisma/IDepositToken.sol";

222:         for (uint256 i = 0; i < gauges.length; i++) {

234:         for (uint256 i = 0; i < pools.length; i++) {

248:         for (uint256 i = 0; i < rewardsPools.length; i++) {

317:         return lpBalance + rewardBalance + convexRewardBalance + prismaBalance + prismaConvexBalance;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/Dolomite/IDepositWithdrawalProxy.sol";

6: import "../external/interfaces/Dolomite/IBorrowPositionProxyV1.sol";

7: import "../external/interfaces/Dolomite/IDolomiteMargin.sol";

113:         for (uint256 i = 0; i < markets.length; i++) {

116:                 totalCollateral += value;

118:                 totalDebt += value;

121:         return totalCollateral - totalDebt;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/Frax/IFraxPair.sol";

129:             (((_borrowerAmount * _exchangeRate) * LTV_PRECISION) / EXCHANGE_PRECISION) / _collateralAmount;

133:         if (currentPositionLTV == 0) return type(uint256).max; // loan is small

136:         uint256 currentHF = (fraxlendPairMaxLTV * 1e18) / currentPositionLTV;

160:             return collateralValue - borrowValue;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/Gearbox/ICreditManagerV3.sol";

6: import "../external/interfaces/Gearbox/ICreditFacadeV3.sol";

69:         for (uint256 i = 0; i < calls.length; i++) {

103:         return _getValue(address(840), base, (d.totalValueUSD - d.totalDebtUSD));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

4: import "../external/interfaces/Lido/ILidoWithdrawal.sol";

5: import "../helpers/BaseConnector.sol";

77:         IWETH(weth).deposit{ value: address(this).balance - beforeClaimBalance }();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

4: import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";

5: import "../external/interfaces/Maverick/IMaverickRouter.sol";

7: import "../helpers/BaseConnector.sol";

93:         _approveOperations(p.pool.tokenA(), maverickRouter, p.tokenARequiredAllowance); // TODO: check token A is eth

140:         for (uint256 i = 0; i < earnedInfo.length; i++) {

158:         return _getValue(pool.tokenA(), base, a) + _getValue(pool.tokenB(), base, b);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/Morpho/IMorpho.sol";

6: import "../external/libraries/Morpho/SharesMathLib.sol";

115:         return market.lltv * convertCToL(p.collateral, market.oracle, market.collateralToken) / borrowAmount;

132:                 supplyAmount + borrowAmount + convertCToL(pos.collateral, params.oracle, params.collateralToken)

138:         return amount * IOracle(marketOracle).price() / ORACLE_PRICE_SCALE;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

4: import "./UNIv3Connector.sol";

5: import "../external/interfaces/Pancakeswap/IMasterChefV3.sol";

6: import "@openzeppelin/contracts-5.0/token/ERC721/IERC721.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/libraries/Pendle/PendleLpOracleLib.sol";

6: import { MarketApproxPtInLib, MarketApproxPtOutLib } from "../external/libraries/Pendle/MarketApproxPtInLib.sol";

7: import { IPendleMarketDepositHelper } from "../external/interfaces/Pendle/IPendleMarketDepositHelper.sol";

8: import "../external/interfaces/Pendle/IPendleRouter.sol";

9: import { IPendleStaticRouter } from "../external/interfaces/Pendle/IPendleStaticRouter.sol";

10: import { SafeERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

244:         for (uint256 i = 0; i < rewardTokens.length; i++) {

269:                 IERC20(market).balanceOf(address(this)) + pendleMarketDepositHelper.balance(market, address(this));

271:                 SYAmount += lpBalance * IPMarket(market).getLpToAssetRate(10) / 1e18;

275:             if (PTAmount > 0) SYAmount += PTAmount * IPMarket(market).getPtToAssetRate(10) / 1e18;

278:             if (YTBalance > 0) SYAmount += getYTValue(market, YTBalance);

280:             if (SYAmount > 0) underlyingBalance += SYAmount * _SY.exchangeRate() / 1e18;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

4: import { SafeERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

6: import { IBorrowerOperations } from "../external/interfaces/Prisma/IBorrowerOperations.sol";

7: import { ITroveManager } from "../external/interfaces/Prisma/TroveManager/ITroveManager.sol";

8: import { IStakeNTroveZap } from "../external/interfaces/Prisma/IStakeNTroveZap.sol";

9: import "../helpers/BaseConnector.sol";

154:             return _getValue(collateral, base, collateralBalance) - _getValue(debTtoken, base, debtBalance);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/SNXV3/IV3CoreProxy.sol";

125:         tvl = _getValue(collateralType, base, totalDeposited + totalAssigned);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/Silo/ISilo.sol";

6: import "../external/libraries/Silo/SolvencyV2.sol";

116:         for (uint256 i = 0; i < assets.length; i++) {

118:             depositAmount += IERC20(assetsS[i].collateralOnlyToken).balanceOf(address(this));

124:             totalDepositAmount += depositAmount * price / 1e18;

125:             totalBAmount += borrowAmount * price / 1e18;

127:         tvl = totalDepositAmount - totalBAmount;

132:         for (uint256 i = 0; i < assetsS.length; i++) {

135:                     + IERC20(assetsS[i].collateralOnlyToken).balanceOf(address(this)) > 0

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

4: import "../helpers/BaseConnector.sol";

5: import "../external/interfaces/Stargate/IStargateRouter.sol";

89:         if (IERC20(lpAddress).balanceOf(address(this)) + LPAmount == 0) {

114:         uint256 lpAmount = LPStaking.userInfo(poolId, address(this)).amount + IERC20(lpAddress).balanceOf(address(this));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

4: import "../external/interfaces/UNIv3/INonfungiblePositionManager.sol";

5: import "../external/interfaces/UNIv3/IUniswapV3Factory.sol";

6: import "../helpers/BaseConnector.sol";

102:         for (uint256 i = 0; i < tokenIds.length; i++) {

144:             amount0 += tokensOwed0;

145:             amount1 += tokensOwed1;

148:         tvl += valueOracle.getValue(token0, base, amount0);

149:         tvl += valueOracle.getValue(token1, base, amount1);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

4: import "@openzeppelin/contracts-5.0/utils/cryptography/EIP712.sol";

5: import "@openzeppelin/contracts-5.0/access/Ownable2Step.sol";

6: import "@openzeppelin/contracts-5.0/utils/cryptography/ECDSA.sol";

29:         for (uint256 i = 0; i < _owners.length; i++) {

44:         for (uint256 i = 0; i < _owners.length; i++) {

47:                 numOwnersTemp++;

50:                 numOwnersTemp--;

109:                     ++i;

113:             nonce++;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/governance/NoyaGovernanceBase.sol

4: import { PositionRegistry, PositionBP } from "../accountingManager/Registry.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/NoyaGovernanceBase.sol)

```solidity
File: contracts/governance/TimeLock.sol

4: import "@openzeppelin/contracts-5.0/governance/TimelockController.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/TimeLock.sol)

```solidity
File: contracts/governance/Watchers.sol

4: import "./Keepers.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Watchers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

4: import "../interface/IConnector.sol";

5: import { NoyaGovernanceBase } from "../governance/NoyaGovernanceBase.sol";

6: import { PositionRegistry, PositionBP } from "../accountingManager/Registry.sol";

7: import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

8: import "@openzeppelin/contracts-5.0/token/ERC721/utils/ERC721Holder.sol";

9: import { SwapAndBridgeHandler, SwapRequest } from "../helpers/SwapHandler/GenericSwapAndBridgeHandler.sol";

10: import "../interface/valueOracle/INoyaValueOracle.sol";

11: import "../governance/Watchers.sol";

12: import "@openzeppelin/contracts-5.0/token/ERC721/IERC721Receiver.sol";

13: import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

178:         for (uint256 i = 0; i < tokens.length; i++) {

183:             if (_balanceAfter < amounts[i] + _balance) {

184:                 revert IConnector_InsufficientDepositAmount(_balanceAfter - _balance, amounts[i]);

187:         _addLiquidity(tokens, amounts, data); // call the specific implementation if the connector needs to do something after the liquidity is added

189:         for (uint256 i = 0; i < tokens.length; i++) {

190:             _updateTokenInRegistry(tokens[i]); // update the token in the registry

211:         for (uint256 i = 0; i < tokensIn.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

4: import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

9: } from "contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol";

10: import { ITokenTransferCallBack } from "contracts/interface/ITokenTransferCallBack.sol";

11: import { HoldingPI } from "contracts/interface/IConnector.sol";

12: import { PositionRegistry } from "contracts/accountingManager/Registry.sol";

41:         for (uint256 i = 0; i < tokens.length; i++) {

46:         for (uint256 i = 0; i < tokens.length; i++) {

47:             _updateTokenInRegistry(tokens[i]); // update the token in the registry

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

4: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

5: import "../OmniChainHandler/OmnichainManagerBaseChain.sol";

6: import "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";

19:     mapping(uint32 => ChainInfo) public chainInfo; // chainId => ChainInfo

20:     mapping(uint256 => VaultInfo) public vaultIdToVaultInfo; // vaultId => VaultInfo

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

4: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

5: import "../OmniChainHandler/OmnichainManagerNormalChain.sol";

6: import "../OmniChainHandler/OmnichainManagerBaseChain.sol";

7: import "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol";

20:     mapping(uint256 => ChainInfo) public chainInfo; // chainId => ChainInfo

21:     mapping(uint256 => VaultInfo) public vaultIdToVaultInfo; // vaultId => VaultInfo

80:         _lzSend(lzChainId, data, messageSetting, MessagingFee(address(this).balance, 0), payable(address(this))); // TODO: send event here

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

4: import "../../helpers/SwapHandler/GenericSwapAndBridgeHandler.sol";

5: import "../BaseConnector.sol";

71:         if (approvedBridgeTXN[txn] == 0 || approvedBridgeTXN[txn] + BRIDGE_TXN_WAITING_TIME > block.timestamp) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol

4: import "./OmnichainLogic.sol";

5: import "../../interface/IConnector.sol";

6: import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol

4: import "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

6: import "./OmnichainLogic.sol";

7: import "../TVLHelper.sol";

8: import "../LZHelpers/LZHelperSender.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

4: import "../../interface/valueOracle/INoyaValueOracle.sol";

5: import "../../governance/NoyaGovernanceBase.sol";

6: import "../../interface/SwapHandler/ISwapAndBridgeHandler.sol";

7: import { SafeERC20, IERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

8: import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

16:     uint256 public genericSlippageTolerance = 50_000; // 5% slippage tolerance

37:         for (uint256 i = 0; i < usersAddresses.length; i++) {

112:             _swapRequest.minAmount = (((1e6 - _slippageTolerance) * _outputTokenValue) / 1e6);

152:                 i++;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

4: import "@openzeppelin/contracts-5.0/access/Ownable2Step.sol";

5: import { SafeERC20, IERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

6: import "../../../interface/SwapHandler/ISwapAndBridgeHandler.sol";

7: import "../../../interface/ITokenTransferCallBack.sol";

8: import "@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol";

101:         return balanceOut1 - balanceOut0;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

4: import { PositionRegistry, HoldingPI } from "../accountingManager/Registry.sol";

5: import { IConnector } from "../interface/IConnector.sol";

18:         for (uint256 i = 0; i < positions.length; i++) {

25:                 totalDebt += tvl;

27:                 totalTVL += tvl;

33:         return (totalTVL - totalDebt);

44:         for (uint256 i = 0; i < positions.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

4: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

5: import "../../interface/valueOracle/INoyaValueOracle.sol";

6: import "../../accountingManager/Registry.sol";

41:         for (uint256 i = 0; i < baseCurrencies.length; i++) {

55:         for (uint256 i = 0; i < oracle.length; i++) {

88:         for (uint256 i = 0; i < sources.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

4: import "../../../interface/valueOracle/INoyaValueOracle.sol";

5: import "../../../interface/valueOracle/AggregatorV3Interface.sol";

6: import "../../../accountingManager/Registry.sol";

7: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

8: import "@openzeppelin/contracts-5.0/token/ERC20/extensions/IERC20Metadata.sol";

74:         for (uint256 i = 0; i < assets.length; i++) {

125:         if (block.timestamp - updatedAt > chainlinkPriceAgeThreshold) {

132:             return (amountIn * sourceTokenUnit) / uintprice;

134:         return (amountIn * uintprice) / (sourceTokenUnit);

140:         return 10 ** decimals;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

4: import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

5: import "../../../external/libraries/uniswap/OracleLibrary.sol";

6: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

7: import "../../../interface/valueOracle/INoyaValueOracle.sol";

8: import "../../../accountingManager/Registry.sol";

77:         int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];

81:         int24 timeWeightedAverageTick = int24(tickCumulativesDelta / int56(int32(period)));

83:             timeWeightedAverageTick--;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="GAS-10"></a>[GAS-10] Use Custom Errors instead of Revert Strings to save Gas

Custom errors are available from solidity version 0.8.4. Custom errors save [**~50 gas**](https://gist.github.com/IllIllI000/ad1bd0d29a0101b25e57c293b4b0c746) each time they're hit by [avoiding having to allocate and store the revert string](https://blog.soliditylang.org/2021/04/21/custom-errors/#errors-in-depth). Not defining the strings also save deployment gas

Additionally, custom errors can be used inside and outside of contracts (including interfaces and libraries).

Source: <https://blog.soliditylang.org/2021/04/21/custom-errors/>:

> Starting from [Solidity v0.8.4](https://github.com/ethereum/solidity/releases/tag/v0.8.4), there is a convenient and gas-efficient way to explain to users why an operation failed through the use of custom errors. Until now, you could already use strings to give more information about failures (e.g., `revert("Insufficient funds.");`), but they are rather expensive, especially when it comes to deploy cost, and it is difficult to use dynamic information in them.

Consider replacing **all revert strings** with custom errors in the solution, and particularly those that have multiple occurrences:

*Instances (14)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

686:             require(success, "Transfer failed.");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

82:                 require(success, "BalancerFlashLoan: Flash loan failed");

92:             require(tokens[i].balanceOf(address(this)) == 0, "BalancerFlashLoan: Flash loan extra tokens");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/governance/Keepers.sol

94:         require(isOwner[msg.sender], "Not an owner");

95:         require(sigR.length == threshold, "Not enough signatures");

96:         require(sigR.length == sigS.length && sigR.length == sigV.length, "Lengths do not match");

97:         require(executor == msg.sender, "Invalid executor");

98:         require(block.timestamp <= deadline, "Transaction expired");

117:         require(success, "Transaction execution reverted.");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

25:         require(isEligibleToUse[msg.sender], "NoyaSwapHandler: Not eligible to use");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

35:         require(isHandler[msg.sender] == true, "LifiImplementation: INVALID_SENDER");

84:         require(verifySwapData(_request), "LifiImplementation: INVALID_SWAP_DATA");

196:             require(success, "Transfer failed.");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

50:         require(pool != address(0), "pool doesn't exist");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="GAS-11"></a>[GAS-11] Avoid contract existence checks by using low level calls

Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (40)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

379:         uint256 availableAssets = baseToken.balanceOf(address(this)) - depositQueue.totalAWFDeposit;

555:             uint256 balanceBefore = baseToken.balanceOf(address(this));

559:             uint256 balanceAfter = baseToken.balanceOf(address(this));

617:         uint256 availableAssets = baseToken.balanceOf(address(this)) - depositQueue.totalAWFDeposit;

628:         return TVLHelper.getTVL(vaultId, registry, address(baseToken)) + baseToken.balanceOf(address(this))

636:             uint256 amount = IERC20(token).balanceOf(abi.decode(position.data, (address)));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

92:         if (IERC20(data.pool).balanceOf(address(this)) == 0) {

128:         uint256 balance = IERC20(pool).balanceOf(address(this));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

102:             uint256 amount = IERC20(pool).balanceOf(address(this));

178:             auraShares = IERC20(pool.auraPoolAddress).balanceOf(address(this));

181:         return IERC20(pool.pool).balanceOf(address(this)) + auraShares;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

92:             require(tokens[i].balanceOf(address(this)) == 0, "BalancerFlashLoan: Flash loan extra tokens");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

77:         if (IERC20(pool).balanceOf(address(this)) == 0) {

95:         uint256 balanceThis = IERC20(pool).balanceOf(address(this));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

327:         return IConvexBasicRewards(info.convexRewardPool).balanceOf(address(this));

336:         return IERC20(info.lpToken).balanceOf(address(this));

346:         return IRewardsGauge(info.gauge).balanceOf(address(this));

356:         return IDepositToken(prismaPool).balanceOf(address(this));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

265:             uint256 SYAmount = _SY.balanceOf(address(this));

269:                 IERC20(market).balanceOf(address(this)) + pendleMarketDepositHelper.balance(market, address(this));

274:             uint256 PTAmount = _PT.balanceOf(address(this));

277:             uint256 YTBalance = _YT.balanceOf(address(this));

306:             _SY.balanceOf(address(this)) == 0 && _PT.balanceOf(address(this)) == 0 && _YT.balanceOf(address(this)) == 0

307:                 && market.balanceOf(address(this)) == 0

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

117:             uint256 depositAmount = IERC20(assetsS[i].collateralToken).balanceOf(address(this));

118:             depositAmount += IERC20(assetsS[i].collateralOnlyToken).balanceOf(address(this));

119:             uint256 borrowAmount = IERC20(assetsS[i].debtToken).balanceOf(address(this));

134:                 IERC20(assetsS[i].collateralToken).balanceOf(address(this))

135:                     + IERC20(assetsS[i].collateralOnlyToken).balanceOf(address(this)) > 0

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

60:                 stakingAmount = IERC20(lpAddress).balanceOf(address(this));

89:         if (IERC20(lpAddress).balanceOf(address(this)) + LPAmount == 0) {

114:         uint256 lpAmount = LPStaking.userInfo(poolId, address(this)).amount + IERC20(lpAddress).balanceOf(address(this));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/governance/Keepers.sol

105:                 address recovered = ECDSA.recover(totalHash, sigV[i], sigR[i], sigS[i]);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

159:         _updateTokenInRegistry(token, IERC20(token).balanceOf(address(this)) == 0);

180:             uint256 _balance = IERC20(tokens[i]).balanceOf(address(this));

182:             uint256 _balanceAfter = IERC20(tokens[i]).balanceOf(address(this));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

92:         _updateTokenInRegistry(token, IERC20(token).balanceOf(address(this)) == 0);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol

37:             uint256 amount = IERC20(token).balanceOf(address(this));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

89:             balanceOut0 = IERC20(_request.outputToken).balanceOf(_request.from);

96:             balanceOut1 = IERC20(_request.outputToken).balanceOf(_request.from);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="GAS-12"></a>[GAS-12] State variables only set in the constructor should be declared `immutable`

Variables only set in the constructor and never edited afterwards should be marked as immutable, as it would avoid the expensive storage-writing operation in the constructor (around **20 000 gas** per variable) and replace the expensive storage-reading operations (around **2100 gas** per reading) to a less expensive value reading (**3 gas**)

*Instances (52)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

99:         baseToken = IERC20(p._baseTokenAddress);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

18:         accountingManager = _accountingManager;

19:         baseToken = _baseToken;

20:         receiver = _receiver;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

38:         poolBaseToken = _poolBaseToken;

39:         pool = _pool;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

44:         aerodromeRouter = IRouter(_router);

45:         voter = IVoter(_voter);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

48:         AURA = aura;

49:         BAL = bal;

50:         balancerVault = _balancerVault;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

27:         vault = IBalancerVault(_balancerVault);

28:         registry = _registry;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

39:         router = ICamelotRouter(_router);

40:         factory = ICamelotFactory(_factory);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

56:         convexBooster = IBooster(_convexBooster);

57:         CVX = cvx;

58:         CRV = crv;

59:         PRISMA = prisma;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

25:         depositWithdrawalProxy = IDepositWithdrawalProxy(_depositWithdrawalProxy);

26:         dolomiteMargin = IDolomiteMargin(_dolomiteMargin);

27:         borrowPositionProxy = IBorrowPositionProxyV1(_borrowPositionProxy);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

27:         lido = _lido;

28:         lidoWithdrawal = _lidoW;

29:         steth = _steth;

30:         weth = w;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

50:         mav = _mav;

51:         veMav = _veMav;

52:         maverickRouter = mr;

53:         positionInspector = IPositionInspector(pi);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

25:         morphoBlue = IMorpho(MB);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

23:         masterchef = IMasterchefV3(MC);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

63:         pendleMarketDepositHelper = IPendleMarketDepositHelper(_pendleMarketDepositHelper);

64:         pendleRouter = IPAllActionV3(_pendleRouter);

65:         staticRouter = IPendleStaticRouter(SR);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

22:         SNXCoreProxy = IV3CoreProxy(_SNXCoreProxy);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

20:         siloRepository = ISiloRepository(SR);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

39:         LPStaking = IStargateLPStaking(lpStacking);

40:         stargateRouter = IStargateRouter(_stargateRouter);

41:         rewardToken = LPStaking.stargate();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

30:         positionManager = INonfungiblePositionManager(_positionManager);

31:         factory = IUniswapV3Factory(_factory);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/NoyaGovernanceBase.sol

23:         registry = _registry;

24:         vaultId = _vaultId;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/NoyaGovernanceBase.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

23:         registry = PositionRegistry(_registry);

24:         vaultId = _vaultId;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

36:         lzHelper = _lzHelper;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

29:         lifi = _lifi;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

31:         registry = _registry;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

48:         registry = PositionRegistry(_reg);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

32:         factory = _factory;

33:         registry = _registry;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="GAS-13"></a>[GAS-13] Functions guaranteed to revert when called by normal users can be marked `payable`

If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (121)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

124:     function updateValueOracle(INoyaValueOracle _valueOracle) public onlyMaintainer {

170:     function setFees(uint256 _withdrawFee, uint256 _performanceFee, uint256 _managementFee) public onlyMaintainer {

226:     function calculateDepositShares(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

328:     function calculateWithdrawShares(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

360:     function startCurrentWithdrawGroup() public onlyManager nonReentrant whenNotPaused {

370:     function fulfillCurrentWithdrawGroup() public onlyManager nonReentrant whenNotPaused {

396:     function executeWithdraw(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

453:     function resetMiddle(uint256 newMiddle, bool depositOrWithdraw) public onlyManager {

475:     function recordProfitForFee() public onlyManager nonReentrant {

505:     function collectManagementFees() public onlyManager nonReentrant returns (uint256, uint256) {

526:     function collectPerformanceFees() public onlyManager nonReentrant {

548:     function retrieveTokensForWithdraw(RetrieveData[] calldata retrieveData) public onlyManager nonReentrant {

659:     function emergencyStop() public whenNotPaused onlyEmergency {

663:     function unpause() public whenPaused onlyEmergency {

667:     function setDepositLimits(uint256 _depositLimitPerTransaction, uint256 _depositTotalAmount) public onlyMaintainer {

673:     function changeDepositWaitingTime(uint256 _depositWaitingTime) public onlyMaintainer {

678:     function changeWithdrawWaitingTime(uint256 _withdrawWaitingTime) public onlyMaintainer {

683:     function rescue(address token, uint256 amount) public onlyEmergency nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

23:     function withdrawShares(uint256 amount) external onlyOwner {

27:     function burnShares(uint256 amount) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/accountingManager/Registry.sol

79:     function setMaxNumHoldingPositions(uint256 _maxNumHoldingPositions) external onlyRole(MAINTAINER_ROLE) {

84:     function setFlashLoanAddress(address _flashLoan) external onlyRole(MAINTAINER_ROLE) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

46:     function supply(address supplyToken, uint256 amount) external onlyManager nonReentrant {

81:     function repay(address asset, uint256 amount, uint256 i) external onlyManager nonReentrant {

88:     function repayWithCollateral(uint256 _amount, uint256 i, address _borrowAsset) external onlyManager {

100:     function withdrawCollateral(uint256 _collateralAmount, address _collateral) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

53:     function supply(DepositData memory data) public onlyManager nonReentrant {

79:     function withdraw(WithdrawData memory data) public onlyManager nonReentrant {

100:     function stake(address pool, uint256 liquidity) public onlyManager nonReentrant {

106:     function unstake(address pool, uint256 liquidity) public onlyManager nonReentrant {

111:     function claim(address pool) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

53:     function harvestAuraRewards(address[] calldata rewardsPools) public onlyManager nonReentrant {

109:     function depositIntoAuraBooster(bytes32 poolId, uint256 _amount) public onlyManager nonReentrant {

115:     function decreasePosition(DecreasePositionParams memory p) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

43:     function addLiquidityInCamelotPool(CamelotAddLiquidityParams calldata p) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

29:     function supply(address market, address asset, uint256 amount) external onlyManager nonReentrant {

48:     function withdrawOrBorrow(address _market, address asset, uint256 amount) external onlyManager nonReentrant {

63:     function claimRewards(address rewardContract, address market) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

68:     function depositIntoGauge(address pool, uint256 amount) public onlyManager nonReentrant {

81:     function depositIntoPrisma(address pool, uint256 amount, bool curveOrConvex) public onlyManager nonReentrant {

103:     function depositIntoConvexBooster(address pool, uint256 pid, uint256 amount, bool stake) public onlyManager {

182:     function withdrawFromConvexBooster(uint256 pid, uint256 amount) public onlyManager {

192:     function withdrawFromConvexRewardPool(address pool, uint256 amount) public onlyManager {

202:     function withdrawFromGauge(address pool, uint256 amount) public onlyManager {

212:     function withdrawFromPrisma(address depostiToken, uint256 amount) public onlyManager {

221:     function harvestRewards(address[] calldata gauges) public onlyManager nonReentrant {

233:     function harvestPrismaRewards(address[] calldata pools) public onlyManager nonReentrant {

247:     function harvestConvexRewards(address[] calldata rewardsPools) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

30:     function deposit(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {

43:     function withdraw(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {

98:     function closeBorrowPosition(uint256[] memory marketIds, uint256 accountId) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

68:     function withdraw(IFraxPair pool, uint256 withdrawAmount) public onlyManager nonReentrant {

87:     function repay(IFraxPair pool, uint256 sharesToRepay) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

24:     function openAccount(address facade, uint256 ref) public onlyManager {

41:     function closeAccount(address facade, address creditAccount) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

37:     function deposit(uint256 amountIn) external onlyManager nonReentrant {

51:     function requestWithdrawals(uint256 amount) public onlyManager nonReentrant {

69:     function claimWithdrawal(uint256 requestId) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

64:     function stake(uint256 amount, uint256 duration, bool doDelegation) external onlyManager nonReentrant {

78:     function unstake(uint256 lockupId) external onlyManager nonReentrant {

91:     function addLiquidityInMaverickPool(MavericAddLiquidityParams calldata p) external onlyManager nonReentrant {

137:     function claimBoostedPositionRewards(IMaverickReward rewardContract) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

35:     function supply(uint256 amount, Id id, bool sOrC) external onlyManager nonReentrant {

58:     function withdraw(uint256 amount, Id id, bool sOrC) external onlyManager nonReentrant {

80:     function borrow(uint256 amount, Id id) external onlyManager nonReentrant {

95:     function repay(uint256 amount, Id id) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

31:     function sendPositionToMasterChef(uint256 tokenId) external onlyManager nonReentrant {

40:     function updatePosition(uint256 tokenId) public onlyManager nonReentrant {

50:     function withdraw(uint256 tokenId) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

78:     function supply(address market, uint256 amount) external onlyManager nonReentrant {

97:     function mintPTAndYT(address market, uint256 syAmount) external onlyManager nonReentrant {

112:     function depositIntoMarket(IPMarket market, uint256 SYamount, uint256 PTamount) external onlyManager nonReentrant {

126:     function depositIntoPenpie(address _market, uint256 _amount) public onlyManager nonReentrant {

137:     function withdrawFromPenpie(address _market, uint256 _amount) public onlyManager nonReentrant {

203:     function burnLP(IPMarket market, uint256 amount) external onlyManager nonReentrant {

216:     function decreasePosition(IPMarket market, uint256 _amount, bool closePosition) external onlyManager nonReentrant {

241:     function claimRewards(IPMarket market) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

33:     function approveZap(IStakeNTroveZap zap, address tm, bool approve) public onlyManager nonReentrant {

75:     function addColl(IStakeNTroveZap zapContract, address tm, uint256 amountIn) public onlyManager nonReentrant {

129:     function closeTrove(IStakeNTroveZap zapContract, address troveManager) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

25:     function createAccount() public onlyManager {

30:     function deposit(address _token, uint256 _amount, uint128 _accountId) public onlyManager {

46:     function withdraw(address _token, uint256 _amount, uint128 _accountId) public onlyManager {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

33:     function deposit(address siloToken, address dToken, uint256 amount, bool oC) external onlyManager nonReentrant {

85:     function borrow(address siloToken, address bToken, uint256 amount) external onlyManager nonReentrant {

98:     function repay(address siloToken, address rToken, uint256 amount) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

49:     function depositIntoStargatePool(StargateRequest calldata depositRequest) external onlyManager nonReentrant {

76:     function withdrawFromStargatePool(StargateRequest calldata withdrawRequest) external onlyManager nonReentrant {

103:     function claimStargateRewards(uint256 poolId) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

40:     function openPosition(MintParams memory p) external onlyManager nonReentrant returns (uint256 tokenId) {

63:     function decreasePosition(DecreaseLiquidityParams memory p) external onlyManager nonReentrant {

87:     function increasePosition(IncreaseLiquidityParams memory p) external onlyManager nonReentrant {

101:     function collectAllFees(uint256[] memory tokenIds) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

42:     function updateOwners(address[] memory _owners, bool[] memory addOrRemove) public onlyOwner {

63:     function setThreshold(uint8 _threshold) public onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

45:     function updateMinimumHealthFactor(uint256 _minimumHealthFactor) external onlyMaintainer {

67:     function updateValueOracle(address _valueOracle) external onlyMaintainer {

153:     function updateTokenInRegistry(address token) public onlyManager {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

40:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {

52:     function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

36:     function updateMessageSetting(bytes memory _messageSetting) public onlyOwner {

51:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {

63:     function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

46:     function updateChainInfo(uint256 chainId, address destinationAddress) external onlyMaintainer {

57:     function updateBridgeTransactionApproval(bytes32 transactionHash) public onlyManager {

68:     function startBridgeTransaction(BridgeRequest memory bridgeRequest) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol

28:     function updateTVLInfo() external onlyManager {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

48:     function setValueOracle(address _valueOracle) external onlyMaintainerOrEmergency {

57:     function setGeneralSlippageTolerance(uint256 _slippageTolerance) external onlyMaintainerOrEmergency {

80:     function addEligibleUser(address _user) external onlyMaintainerOrEmergency {

147:     function addRoutes(RouteData[] memory _routes) public onlyMaintainer {

158:     function setEnableRoute(uint256 _routeId, bool enable) external onlyMaintainerOrEmergency {

164:     function verifyRoute(uint256 _routeId, address addr) external view onlyExistingRoute(_routeId) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

45:     function addHandler(address _handler, bool state) external onlyOwner {

55:     function addChain(uint256 _chainId, bool state) external onlyOwner {

65:     function addBridgeBlacklist(string memory bridgeName, bool state) external onlyOwner {

193:     function rescueFunds(address token, address userAddress, uint256 amount) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

61:     function updatePriceRoute(address asset, address base, address[] calldata s) external onlyMaintainer {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

56:     function updateChainlinkPriceAgeThreshold(uint256 _chainlinkPriceAgeThreshold) external onlyMaintainer {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

38:     function setPeriod(uint32 _period) external onlyMaintainer {

48:     function addPool(address tokenIn, address baseToken, uint24 fee) external onlyMaintainer {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="GAS-14"></a>[GAS-14] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)

Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (43)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

551:         for (uint256 i = 0; i < retrieveData.length; i++) {

603:             for (uint256 i = 0; i < items.length; i++) {

608:             for (uint256 i = 0; i < items.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

138:         for (uint256 i = 0; i < _trustedTokens.length; i++) {

194:         for (uint256 i = 0; i < _connectorAddresses.length; i++) {

214:         for (uint256 i = 0; i < _tokens.length; i++) {

253:             for (uint256 i = 0; i < usingTokens.length; i++) {

274:         for (uint256 i = 0; i < length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

54:         for (uint256 i = 0; i < rewardsPools.length; i++) {

77:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

74:             for (uint256 i = 0; i < tokens.length; i++) {

79:             for (uint256 i = 0; i < destinationConnector.length; i++) {

84:             for (uint256 i = 0; i < tokens.length; i++) {

89:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

222:         for (uint256 i = 0; i < gauges.length; i++) {

234:         for (uint256 i = 0; i < pools.length; i++) {

248:         for (uint256 i = 0; i < rewardsPools.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

113:         for (uint256 i = 0; i < markets.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

69:         for (uint256 i = 0; i < calls.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

140:         for (uint256 i = 0; i < earnedInfo.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

244:         for (uint256 i = 0; i < rewardTokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

116:         for (uint256 i = 0; i < assets.length; i++) {

132:         for (uint256 i = 0; i < assetsS.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

102:         for (uint256 i = 0; i < tokenIds.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

29:         for (uint256 i = 0; i < _owners.length; i++) {

44:         for (uint256 i = 0; i < _owners.length; i++) {

47:                 numOwnersTemp++;

50:                 numOwnersTemp--;

113:             nonce++;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

178:         for (uint256 i = 0; i < tokens.length; i++) {

189:         for (uint256 i = 0; i < tokens.length; i++) {

211:         for (uint256 i = 0; i < tokensIn.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

41:         for (uint256 i = 0; i < tokens.length; i++) {

46:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

37:         for (uint256 i = 0; i < usersAddresses.length; i++) {

152:                 i++;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

18:         for (uint256 i = 0; i < positions.length; i++) {

44:         for (uint256 i = 0; i < positions.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

41:         for (uint256 i = 0; i < baseCurrencies.length; i++) {

55:         for (uint256 i = 0; i < oracle.length; i++) {

88:         for (uint256 i = 0; i < sources.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

74:         for (uint256 i = 0; i < assets.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

83:             timeWeightedAverageTick--;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="GAS-15"></a>[GAS-15] Using `private` rather than `public` for constants, saves gas

If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (29)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

52:     uint256 public constant FEE_PRECISION = 1e6;

53:     uint256 public constant WITHDRAWAL_MAX_FEE = 5e4;

54:     uint256 public constant MANAGEMENT_MAX_FEE = 5e5;

55:     uint256 public constant PERFORMANCE_MAX_FEE = 1e5;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

15:     bytes32 public constant MAINTAINER_ROLE = keccak256("MAINTAINER_ROLE");

17:     bytes32 public constant GOVERNER_ROLE = keccak256("GOVERNER_ROLE");

19:     bytes32 public constant EMERGENCY_ROLE = keccak256("EMERGENCY_ROLE");

21:     uint256 public constant MAX_NUM_HOLDING_POSITIONS = 40;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

24:     uint256 public constant AAVE_POSITION_ID = 1;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

31:     uint256 public constant AERODROME_POSITION_TYPE = 1;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

34:     uint256 public constant CAMELOT_POSITION_ID = 1;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

31:     uint256 public constant CURVE_LP_POSITION = 4;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

16:     uint256 public constant DOL_POSITION_ID = 1;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

9:     uint256 public constant GEARBOX_POSITION_ID = 3;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

15:     uint256 public constant MORPHO_POSITION_ID = 1;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

26:     uint256 public constant PENDLE_POSITION_ID = 11;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

14:     uint256 public constant PRISMA_POSITION_ID = 10;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

16:     uint256 public constant SNX_POSITION_ID = 1;

17:     uint256 public constant SNX_POOL_POSITION_ID = 2;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

10:     uint256 public constant SILO_LP_ID = 11;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

26:     uint256 public constant STARGATE_LP_POSITION_TYPE = 1;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

19:     uint256 public constant UNI_LP_POSITION_TYPE = 5;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

11:     bytes32 public constant TXTYPE_HASH = keccak256(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

20:     uint256 public constant positionType = 1;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

19:     uint256 public constant BRIDGE_TXN_WAITING_TIME = 30 minutes;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol

11:     uint256 public constant OMNICHAIN_POSITION_ID = 13;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

18:     bytes4 public constant LI_FI_GENERIC_SWAP_SELECTOR = 0x4630a0d8;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

25:     address public constant ETH = address(0);

26:     address public constant USD = address(840);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="GAS-16"></a>[GAS-16] Splitting require() statements that use && saves gas

*Instances (7)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

361:         require(currentWithdrawGroup.isStarted == false && currentWithdrawGroup.isFullfilled == false);

371:         require(currentWithdrawGroup.isStarted == true && currentWithdrawGroup.isFullfilled == false);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/governance/Keepers.sol

28:         require(_owners.length <= 10 && _threshold <= _owners.length && _threshold > 1);

53:         require(numOwnersTemp <= 10 && threshold <= numOwnersTemp && threshold > 1);

64:         require(_threshold <= numOwners && _threshold > 1);

96:         require(sigR.length == sigS.length && sigR.length == sigV.length, "Lengths do not match");

106:                 require(recovered > lastAdd && isOwner[recovered]);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

### <a name="GAS-17"></a>[GAS-17] Superfluous event fields

`block.timestamp` and `block.number` are added to event information by default so adding them manually wastes gas

*Instances (1)*:

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

25:     event UpdateBridgeTransactionApproval(bytes32 transactionHash, uint256 timestamp);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

### <a name="GAS-18"></a>[GAS-18] `uint256` to `bool` `mapping`: Utilizing Bitmaps to dramatically save on Gas
<https://soliditydeveloper.com/bitmaps>

<https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/BitMaps.sol>

- [BitMaps.sol#L5-L16](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/BitMaps.sol#L5-L16):

```solidity
/**
 * @dev Library for managing uint256 to bool mapping in a compact and efficient way, provided the keys are sequential.
 * Largely inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
 *
 * BitMaps pack 256 booleans across each bit of a single 256-bit slot of `uint256` type.
 * Hence booleans corresponding to 256 _sequential_ indices would only consume a single slot,
 * unlike the regular `bool` which would consume an entire slot for a single value.
 *
 * This results in gas savings in two ways:
 *
 * - Setting a zero value to non-zero only once every 256 times
 * - Accessing the same warm slot for every 256 _sequential_ indices
 */
```

*Instances (1)*:

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

15:     mapping(uint256 => bool) public isChainSupported;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="GAS-19"></a>[GAS-19] Increments/decrements can be unchecked in for-loops

In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (39)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

551:         for (uint256 i = 0; i < retrieveData.length; i++) {

603:             for (uint256 i = 0; i < items.length; i++) {

608:             for (uint256 i = 0; i < items.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

138:         for (uint256 i = 0; i < _trustedTokens.length; i++) {

194:         for (uint256 i = 0; i < _connectorAddresses.length; i++) {

214:         for (uint256 i = 0; i < _tokens.length; i++) {

253:             for (uint256 i = 0; i < usingTokens.length; i++) {

274:         for (uint256 i = 0; i < length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

54:         for (uint256 i = 0; i < rewardsPools.length; i++) {

77:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

74:             for (uint256 i = 0; i < tokens.length; i++) {

79:             for (uint256 i = 0; i < destinationConnector.length; i++) {

84:             for (uint256 i = 0; i < tokens.length; i++) {

89:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

107:         for (uint8 i; i < numberOfAssets; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

222:         for (uint256 i = 0; i < gauges.length; i++) {

234:         for (uint256 i = 0; i < pools.length; i++) {

248:         for (uint256 i = 0; i < rewardsPools.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

113:         for (uint256 i = 0; i < markets.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

69:         for (uint256 i = 0; i < calls.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

140:         for (uint256 i = 0; i < earnedInfo.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

244:         for (uint256 i = 0; i < rewardTokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

116:         for (uint256 i = 0; i < assets.length; i++) {

132:         for (uint256 i = 0; i < assetsS.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

102:         for (uint256 i = 0; i < tokenIds.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

29:         for (uint256 i = 0; i < _owners.length; i++) {

44:         for (uint256 i = 0; i < _owners.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

178:         for (uint256 i = 0; i < tokens.length; i++) {

189:         for (uint256 i = 0; i < tokens.length; i++) {

211:         for (uint256 i = 0; i < tokensIn.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

41:         for (uint256 i = 0; i < tokens.length; i++) {

46:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

37:         for (uint256 i = 0; i < usersAddresses.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

18:         for (uint256 i = 0; i < positions.length; i++) {

44:         for (uint256 i = 0; i < positions.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

41:         for (uint256 i = 0; i < baseCurrencies.length; i++) {

55:         for (uint256 i = 0; i < oracle.length; i++) {

88:         for (uint256 i = 0; i < sources.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

74:         for (uint256 i = 0; i < assets.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="GAS-20"></a>[GAS-20] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (23)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

288:         if (registry.isAnActiveConnector(vaultId, connector) && processedBaseTokenAmount > 0) {

438:         if (withdrawFeeAmount > 0) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

78:             if (amounts[i] > 0) _approveOperations(tokens[i], balancerVault, amounts[i]);

99:         if (auraAmount > 0) {

116:         if (p._auraAmount > 0) {

122:         if (p._lpAmount > 0) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

100:         if (userBasic.principal > 0) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

46:         if (collateralAmount > 0) {

49:         if (borrowAmount > 0) {

52:         } else if (collateralAmount > 0) {

55:         if (collateralAmount > 0) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

270:             if (lpBalance > 0) {

275:             if (PTAmount > 0) SYAmount += PTAmount * IPMarket(market).getPtToAssetRate(10) / 1e18;

278:             if (YTBalance > 0) SYAmount += getYTValue(market, YTBalance);

280:             if (SYAmount > 0) underlyingBalance += SYAmount * _SY.exchangeRate() / 1e18;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

111:         if (bAmount > 0 && !isBorrowing) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

135:                     + IERC20(assetsS[i].collateralOnlyToken).balanceOf(address(this)) > 0

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

52:         if (depositRequest.routerAmount > 0) {

57:         if (depositRequest.LPStakingAmount > 0) {

79:         if (withdrawRequest.LPStakingAmount > 0) {

82:         if (withdrawRequest.routerAmount > 0) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

142:         if ((positionIndex == 0 && !remove) || (positionIndex > 0 && remove)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

86:         if ((positionIndex == 0 && !remove) || (positionIndex > 0 && remove)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

### <a name="GAS-21"></a>[GAS-21] WETH address definition can be use directly

WETH is a wrap Ether contract with a specific address in the Ethereum network, giving the option to define it may cause false recognition, it is healthier to define it directly.

    Advantages of defining a specific contract directly:
    
    It saves gas,
    Prevents incorrect argument definition,
    Prevents execution on a different chain and re-signature issues,
    WETH Address : 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2

*Instances (1)*:

```solidity
File: contracts/connectors/LidoConnector.sol

11:     address public weth;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

## Non Critical Issues

| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Missing checks for `address(0)` when assigning values to address state variables | 4 |
| [NC-2](#NC-2) | Array indices should be referenced via `enum`s rather than via numeric literals | 24 |
| [NC-3](#NC-3) | Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked` | 2 |
| [NC-4](#NC-4) | Constants should be in CONSTANT_CASE | 1 |
| [NC-5](#NC-5) | `constant`s should be defined rather than using magic numbers | 28 |
| [NC-6](#NC-6) | Control structures do not follow the Solidity Style Guide | 89 |
| [NC-7](#NC-7) | Default Visibility for constants | 2 |
| [NC-8](#NC-8) | Consider disabling `renounceOwnership()` | 3 |
| [NC-9](#NC-9) | Unused `error` definition | 1 |
| [NC-10](#NC-10) | Event is never emitted | 1 |
| [NC-11](#NC-11) | Event missing indexed field | 89 |
| [NC-12](#NC-12) | Events that mark critical parameter changes should contain both the old and the new value | 26 |
| [NC-13](#NC-13) | Function ordering does not follow the Solidity style guide | 14 |
| [NC-14](#NC-14) | Functions should not be longer than 50 lines | 275 |
| [NC-15](#NC-15) | Lack of checks in setters | 21 |
| [NC-16](#NC-16) | Missing Event for critical parameters change | 10 |
| [NC-17](#NC-17) | NatSpec is completely non-existent on functions that should have them | 60 |
| [NC-18](#NC-18) | Incomplete NatSpec: `@param` is missing on actually documented functions | 10 |
| [NC-19](#NC-19) | Incomplete NatSpec: `@return` is missing on actually documented functions | 2 |
| [NC-20](#NC-20) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 28 |
| [NC-21](#NC-21) | Consider using named mappings | 19 |
| [NC-22](#NC-22) | Adding a `return` statement when the function defines a named return variable, is redundant | 24 |
| [NC-23](#NC-23) | `require()` / `revert()` statements should have descriptive reason strings | 74 |
| [NC-24](#NC-24) | Take advantage of Custom Error's return value property | 51 |
| [NC-25](#NC-25) | Avoid the use of sensitive terms | 6 |
| [NC-26](#NC-26) | Contract does not follow the Solidity style guide's suggested layout ordering | 4 |
| [NC-27](#NC-27) | TODO Left in the code | 2 |
| [NC-28](#NC-28) | Use Underscores for Number Literals (add an underscore every 3 digits) | 2 |
| [NC-29](#NC-29) | Internal and private variables and functions names should begin with an underscore | 15 |
| [NC-30](#NC-30) | Event is missing `indexed` fields | 91 |
| [NC-31](#NC-31) | Constants should be defined rather than using magic numbers | 2 |
| [NC-32](#NC-32) | `override` function arguments that are unused should have the variable name removed or commented out to avoid compiler warnings | 9 |
| [NC-33](#NC-33) | `public` functions not called by the contract should be declared `external` instead | 113 |
| [NC-34](#NC-34) | Variables need not be initialized to zero | 59 |

### <a name="NC-1"></a>[NC-1] Missing checks for `address(0)` when assigning values to address state variables

*Instances (4)*:

```solidity
File: contracts/accountingManager/Registry.sol

76:         flashLoan = _flashLoan;

86:         flashLoan = _flashLoan;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

29:         lifi = _lifi;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

32:         factory = _factory;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-2"></a>[NC-2] Array indices should be referenced via `enum`s rather than via numeric literals

*Instances (24)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

290:             amounts[0] = processedBaseTokenAmount;

292:             tokens[0] = address(baseToken);

652:             tokens[0] = abi.decode(data, (address));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

120:         tokens[0] = IPool(pool).token0();

121:         tokens[1] = IPool(pool).token1();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

102:         tokens[0] = tokenA;

103:         tokens[1] = tokenB;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

145:         tokens[0] = IFraxPair(pool).collateralContract();

146:         tokens[1] = IFraxPair(pool).asset();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

55:         amounts[0] = amount;

59:         registry.updateHoldingPosition(vaultId, positionId, abi.encode(requestIds[0]), abi.encode(amount), false);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

164:         tokens[0] = IMaverickPool(pool).tokenA();

165:         tokens[1] = IMaverickPool(pool).tokenB();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

145:         tokens[0] = params.loanToken;

146:         tokens[1] = params.collateralToken;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

315:         (, tokens[0],) = SY.assetInfo();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

170:         tokens[0] = collateral;

171:         tokens[1] = debTtoken;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

127:         tokens[0] = IStargatePool(lpAddress).token();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

154:         (tokens[0], tokens[1]) = abi.decode(data, (address, address));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

235:             tokens[0] = abi.decode(data, (address));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

70:         secondsAgos[0] = period;

71:         secondsAgos[1] = 0;

77:         int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-3"></a>[NC-3] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`

Solidity version 0.8.4 introduces `bytes.concat()` (vs `abi.encodePacked(<bytes>,<bytes>)`)

Solidity version 0.8.12 introduces `string.concat()` (vs `abi.encodePacked(<str>,<str>), which catches concatenation errors (in the event of a`bytes`data mixed in the concatenation)`)

*Instances (2)*:

```solidity
File: contracts/connectors/UNIv3Connector.sol

136:             bytes32 key = keccak256(abi.encodePacked(positionManager, tL, tU));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

102:             bytes32 totalHash = keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), txInputHash));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

### <a name="NC-4"></a>[NC-4] Constants should be in CONSTANT_CASE

For `constant` variable names, each word should use all capital letters, with underscores separating each word (CONSTANT_CASE)

*Instances (1)*:

```solidity
File: contracts/helpers/ConnectorMock2.sol

20:     uint256 public constant positionType = 1;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

### <a name="NC-5"></a>[NC-5] `constant`s should be defined rather than using magic numbers

Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (28)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

82:     uint256 public depositWaitingTime = 30 minutes;

84:     uint256 public withdrawWaitingTime = 6 hours;

87:     uint256 public depositLimitTotalAmount = 1e6 * 200_000;

89:     uint256 public depositLimitPerTransaction = 1e6 * 2000;

510:         if (timePassed > 10 days) {

511:             timePassed = 10 days;

518:             (timePassed * managementFee * (totalShares - currentFeeShares)) / FEE_PRECISION / 365 days;

528:             preformanceFeeSharesWaitingForDistribution == 0 || block.timestamp - profitStoredTime < 12 hours

529:                 || block.timestamp - profitStoredTime > 48 hours

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

23:     uint256 public maxNumHoldingPositions = 20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

8:     uint256 public COMPOUND_LP = 2;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

126:         address poolAddress = (poolInfo.tokens.length > 2 && poolInfo.zap != address(0)) ? poolInfo.zap : pool;

128:         if (poolInfo.tokens.length == 2) {

132:         } else if (poolInfo.tokens.length == 3) {

136:         } else if (poolInfo.tokens.length == 4) {

140:         } else if (poolInfo.tokens.length == 5) {

144:         } else if (poolInfo.tokens.length == 6) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

13:     uint256 public LIDO_WITHDRAWAL_REQUEST_ID = 10;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

35:     uint256 public MAVERICK_LP = 10;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

21:         MINIMUM_HEALTH_FACTOR = 5e17;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/governance/Keepers.sol

28:         require(_owners.length <= 10 && _threshold <= _owners.length && _threshold > 1);

53:         require(numOwnersTemp <= 10 && threshold <= numOwnersTemp && threshold > 1);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

28:     uint256 public MINIMUM_HEALTH_FACTOR = 15e17;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

16:     uint256 public genericSlippageTolerance = 50_000; // 5% slippage tolerance

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

14:     uint256 public chainlinkPriceAgeThreshold = 2 hours;

57:         if (_chainlinkPriceAgeThreshold <= 1 hours || _chainlinkPriceAgeThreshold >= 10 days) {

140:         return 10 ** decimals;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

19:     uint32 public period = 1800;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-6"></a>[NC-6] Control structures do not follow the Solidity Style Guide

See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (89)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

112:         if (

171:         if (

527:         if (

560:             if (balanceBefore + amount > balanceAfter) revert NoyaAccounting_banalceAfterIsNotEnough();

618:         if ( // check if the withdraw group is fullfilled

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

54:         if (vaults[_vaultId].accountManager == address(0)) revert NotExist();

118:         if (vaults[vaultId].accountManager != address(0)) revert AlreadyExists();

250:             if (vault.trustedPositionsBP[positionId].isEnabled) revert AlreadyExists();

251:             if (vault.connectors[calculatorConnector].enabled == false) revert NotExist();

272:         if (!vault.trustedPositionsBP[_positionId].isEnabled) revert NotExist();

343:         if (!vault.connectors[msg.sender].enabled) revert UnauthorizedAccess();

344:         if (!vault.trustedPositionsBP[_positionId].isEnabled) revert InvalidPosition(_positionId);

347:         if (positionIndex == 0 && removePosition) return type(uint256).max;

526:         if (addr == vaults[vaultId].accountManager) return true;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

73:         if (healthFactor < minimumHealthFactor) revert IConnector_LowHealthFactor(healthFactor);

104:         if (healthFactor < minimumHealthFactor) revert IConnector_LowHealthFactor(healthFactor);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

78:             if (amounts[i] > 0) _approveOperations(tokens[i], balancerVault, amounts[i]);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

5: import { IFlashLoanRecipient } from "../external/interfaces/Balancer/IFlashLoanRecipient.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

31:         if (!registry.isTokenTrusted(vaultId, asset, address(this))) revert IConnector_UntrustedToken(asset);

50:         if (!registry.isTokenTrusted(vaultId, asset, address(this))) revert IConnector_UntrustedToken(asset);

52:         if (healthFactor < minimumHealthFactor) revert IConnector_LowHealthFactor(healthFactor);

77:         if (borrowBalanceInBase == 0) return type(uint256).max;

86:         if (borrowBalanceInBase == 0) return 0;

119:                 if (riskAdjusted) CollValue += collateralValueInVirtualBase * info.liquidateCollateralFactor / 1e18;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

21:     address poolAddressIfDefaultWithdrawTokenIsAnotherPosition;

280:         if (balance == 0) return (0, info.tokens[info.defaultWithdrawIndex]);

285:                 LPToUnder(_getPoolInfo(info.poolAddressIfDefaultWithdrawTokenIsAnotherPosition), underlyingAssetAmount);

326:         if (info.convexRewardPool == address(0)) return 0;

345:         if (info.gauge == address(0)) return 0;

355:         if (prismaPool == address(0)) return 0;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

45:         depositWithdrawalProxy.withdrawWeiFromDefaultAccount(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

5: import "../external/interfaces/Frax/IFraxPair.sol";

38:     function borrowAndSupply(IFraxPair pool, uint256 borrowAmount, uint256 collateralAmount)

59:         verifyHealthFactor(pool);

78:         verifyHealthFactor(pool);

95:         IFraxPair(pool).repayAsset(sharesToRepay, address(this));

124:         if (_borrowerAmount == 0) return type(uint256).max;

126:         if (_collateralAmount == 0) return 0;

133:         if (currentPositionLTV == 0) return type(uint256).max; // loan is small

145:         tokens[0] = IFraxPair(pool).collateralContract();

146:         tokens[1] = IFraxPair(pool).asset();

152:         IFraxPair pool = IFraxPair(abi.decode(positionInfo.data, (address)));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

70:             if (calls[i].target != facade) revert IConnector_InvalidTarget(calls[i].target);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

112:         if (borrowAmount == 0) return type(uint256).max;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

275:             if (PTAmount > 0) SYAmount += PTAmount * IPMarket(market).getPtToAssetRate(10) / 1e18;

278:             if (YTBalance > 0) SYAmount += getYTValue(market, YTBalance);

280:             if (SYAmount > 0) underlyingBalance += SYAmount * _SY.exchangeRate() / 1e18;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

133:             if (

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/governance/NoyaGovernanceBase.sol

45:         if (msg.sender != emergencyManager) revert NoyaGovernance_Unauthorized(msg.sender);

67:         if (msg.sender != maintainer && msg.sender != emergencyManager) revert NoyaGovernance_Unauthorized(msg.sender);

77:         if (msg.sender != maintainer) revert NoyaGovernance_Unauthorized(msg.sender);

87:         if (msg.sender != governer) revert NoyaGovernance_Unauthorized(msg.sender);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/NoyaGovernanceBase.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

94:             Watchers(watcherContract).verifyRemoveLiquidity(amount, newAmount, newData);

102:             swapHandler.verifyRoute(routeId, msg.sender);

103:             if (caller != address(this)) revert IConnector_InvalidAddress(caller);

187:         _addLiquidity(tokens, amounts, data); // call the specific implementation if the connector needs to do something after the liquidity is added

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

76:         if (msg.sender != vaultIdToVaultInfo[vaultId].omniChainManager) revert InvalidSender();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

58:         if (approvedBridgeTXN[transactionHash] != 0) delete approvedBridgeTXN[transactionHash];

74:         if (bridgeRequest.from != address(this)) revert IConnector_InvalidInput();

75:         if (

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol

33:         if (msg.sender != lzHelper) revert IConnector_InvalidSender();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

30:         if (routes[_routeId].route == address(0) && !routes[_routeId].isEnabled) revert RouteNotFound();

98:         if (_swapRequest.amount == 0) revert InvalidAmount();

100:         if (swapImplInfo.isBridge) revert RouteNotAllowedForThisAction();

135:         if (!bridgeImplInfo.isBridge) revert RouteNotAllowedForThisAction();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

16:     address public lifi;

29:         lifi = _lifi;

35:         require(isHandler[msg.sender] == true, "LifiImplementation: INVALID_SENDER");

84:         require(verifySwapData(_request), "LifiImplementation: INVALID_SWAP_DATA");

116:             ILiFi(lifi).extractGenericSwapParameters(_request.data);

118:         if (from != _request.from) revert InvalidReceiver(from, _request.from);

119:         if (receivingAmount < _request.minAmount) revert InvalidMinAmount();

120:         if (sendingAssetId != _request.inputToken) revert InvalidInputToken();

121:         if (receivingAssetId != _request.outputToken) revert InvalidOutputToken();

122:         if (amount != _request.amount) revert InvalidAmount();

139:         verifyBridgeData(_request);

151:         ILiFi.BridgeData memory bridgeData = ILiFi(lifi).extractBridgeData(_request.data);

153:         if (isBridgeWhiteListed[bridgeData.bridge] == false) revert BridgeBlacklisted();

154:         if (isChainSupported[bridgeData.destinationChainId] == false) revert InvalidChainId();

155:         if (bridgeData.sendingAssetId != _request.inputToken) revert InvalidFromToken();

159:         if (bridgeData.minAmount > _request.amount) revert InvalidMinAmount();

160:         if (bridgeData.destinationChainId != _request.destChainId) revert InvalidToChainId();

173:             _setAllowance(token, lifi, amount);

182:         emit Forwarded(lifi, address(token), amount, data);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

25:         if (!registry.hasRole(registry.MAINTAINER_ROLE(), msg.sender)) revert INoyaValueOracle_Unauthorized(msg.sender);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

42:         if (!registry.hasRole(registry.MAINTAINER_ROLE(), msg.sender)) revert INoyaValueOracle_Unauthorized(msg.sender);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

25:         if (!registry.hasRole(registry.MAINTAINER_ROLE(), msg.sender)) revert INoyaValueOracle_Unauthorized(msg.sender);

39:         if (_period == 0) revert INoyaValueOracle_InvalidInput();

66:         if (pool == address(0)) revert INoyaOracle_ValueOracleUnavailable(tokenIn, baseToken);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-7"></a>[NC-7] Default Visibility for constants

Some constants are using the default visibility. For readability, consider explicitly declaring them as `internal`.

*Instances (2)*:

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

14:     uint256 constant ORACLE_PRICE_SCALE = 1e36;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

24:     uint32 constant TVL_UPDATE = 1;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

### <a name="NC-8"></a>[NC-8] Consider disabling `renounceOwnership()`

If the plan for your project does not include eventually giving up all ownership control, consider overwriting OpenZeppelin's `Ownable`'s `renounceOwnership()` function in order to disable it.

*Instances (3)*:

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

7: contract NoyaFeeReceiver is Ownable {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/governance/Keepers.sol

9: contract Keepers is EIP712, Ownable2Step {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

10: contract LifiImplementation is ISwapAndBridgeImplementation, Ownable2Step, ReentrancyGuard {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="NC-9"></a>[NC-9] Unused `error` definition

Note that there may be cases where an error superficially appears to be used, but this is only because there are multiple definitions of the error in different files. In such cases, the error definition should be moved into a separate file. The instances below are the unused definitions.

*Instances (1)*:

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

22:     error InvalidPayload();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

### <a name="NC-10"></a>[NC-10] Event is never emitted

The following are defined but never emitted. They can be removed to make the code cleaner.

*Instances (1)*:

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

12:     event ManagementFeeReceived(address indexed token, uint256 amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

### <a name="NC-11"></a>[NC-11] Event missing indexed field

Index event fields make the field more quickly accessible [to off-chain tools](https://ethereum.stackexchange.com/questions/40396/can-somebody-please-explain-the-concept-of-event-indexing) that parse events. This is especially useful when it comes to filtering based on an address. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Where applicable, each `event` should use three `indexed` fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three applicable fields, all of the applicable fields should be indexed.

*Instances (89)*:

```solidity
File: contracts/connectors/AaveConnector.sol

26:     event Supply(address supplyToken, uint256 amount);

27:     event Borrow(address borrowToken, uint256 amount);

28:     event Repay(address repayToken, uint256 amount, uint256 i);

29:     event RepayWithCollateral(address repayToken, uint256 amount, uint256 i);

30:     event WithdrawCollateral(address collateral, uint256 amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

36:     event Supply(address pool, uint256 amount0, uint256 amount1);

37:     event Withdraw(address pool, uint256 amountLiquidity);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

34:     event OpenPosition(

37:     event DecreasePosition(DecreasePositionParams p);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

21:     event MakeFlashLoan(IERC20[] tokens, uint256[] amounts);

22:     event ReceiveFlashLoan(IERC20[] tokens, uint256[] amounts, uint256[] feeAmounts, bytes userData);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

10:     event Supply(address market, address asset, uint256 amount);

11:     event WithdrawOrBorrow(address market, address asset, uint256 amount);

12:     event ClaimRewards(address rewardContract, address market);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

33:     event OpenCurvePosition(address pool, uint256 depositIndex, uint256 amount, uint256 minAmount);

34:     event DecreaseCurvePosition(address pool, uint256 withdrawIndex, uint256 amount, uint256 minAmount);

35:     event WithdrawFromConvexBooster(uint256 pid, uint256 amount);

36:     event WithdrawFromConvexRewardPool(address pool, uint256 amount);

37:     event WithdrawFromGauge(address pool, uint256 amount);

38:     event WithdrawFromPrisma(address depostiToken, uint256 amount);

39:     event HarvestRewards(address[] gauges);

40:     event HarvestPrismaRewards(address[] pools);

41:     event HarvestConvexRewards(address[] rewardsPools);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

24:     event BorrowAndSupply(address pool, uint256 borrowAmount, uint256 collateralAmount);

25:     event Withdraw(address pool, uint256 withdrawAmount);

26:     event Repay(address pool, uint256 sharesToRepay);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

11:     event OpenAccount(address facade, uint256 ref);

12:     event CloseAccount(address facade, address creditAccount);

13:     event ExecuteCommands(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

15:     event Deposit(uint256 amountIn);

16:     event RequestWithdrawals(uint256 amount);

17:     event ClaimWithdrawal(uint256 requestId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

37:     event Stake(uint256 amount, uint256 duration, bool doDelegation);

38:     event Unstake(uint256 lockupId);

39:     event AddLiquidityInMaverickPool(MavericAddLiquidityParams p);

40:     event RemoveLiquidityFromMaverickPool(MavericRemoveLiquidityParams p);

41:     event ClaimBoostedPositionRewards(IMaverickReward rewardContract);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

17:     event Supply(uint256 amount, Id id, bool sOrC);

18:     event Withdraw(uint256 amount, Id id, bool sOrC);

19:     event Borrow(uint256 amount, Id id);

20:     event Repay(uint256 amount, Id id);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

14:     event SendPositionToMasterChef(uint256 tokenId);

15:     event UpdatePosition(uint256 tokenId);

16:     event Withdraw(uint256 tokenId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

35:     event Supply(address market, uint256 amount);

36:     event MintPTAndYT(address market, uint256 syAmount);

37:     event DepositIntoMarket(address market, uint256 SYamount, uint256 PTamount);

38:     event DepositIntoPenpie(address market, uint256 amount);

39:     event WithdrawFromPenpie(address market, uint256 amount);

40:     event SwapYTForPT(address market, uint256 exactYTIn, uint256 min, ApproxParams guess);

41:     event SwapYTForSY(address market, uint256 exactYTIn, uint256 min, LimitOrderData orderData);

42:     event SwapExactPTForSY(address market, uint256 exactPTIn, bytes swapData, uint256 minSY);

43:     event BurnLP(address market, uint256 amount);

44:     event DecreasePosition(address market, uint256 amount, bool closePosition);

45:     event ClaimRewards(address market);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

16:     event OpenTrove(address zap, address tm, uint256 maxFee, uint256 dAmount, uint256 bAmount);

17:     event AddColl(address zap, address tm, uint256 amountIn);

18:     event AdjustTrove(address zap, address tm, uint256 mFee, uint256 wAmount, uint256 bAmount, bool isBorrowing);

19:     event CloseTrove(address zap, address troveManager);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

12:     event Deposit(address siloToken, address dToken, uint256 amount, bool oC);

13:     event Withdraw(address siloToken, address wToken, uint256 amount, bool oC, bool closePosition);

14:     event Borrow(address siloToken, address bToken, uint256 amount);

15:     event Repay(address siloToken, address rToken, uint256 amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

28:     event DepositIntoStargatePool(StargateRequest depositRequest);

29:     event WithdrawFromStargatePool(StargateRequest withdrawRequest);

30:     event ClaimStargateRewards(uint256 poolId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

21:     event OpenPosition(MintParams p, uint256 tokenId);

22:     event DecreasePosition(DecreaseLiquidityParams p);

23:     event IncreasePosition(IncreaseLiquidityParams p);

24:     event CollectFees(uint256 tokenId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

19:     event UpdateOwners(address[] owners, bool[] addOrRemove);

20:     event UpdateThreshold(uint8 threshold);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

24:     event UpdateChainInfo(uint256 chainId, address destinationAddress);

25:     event UpdateBridgeTransactionApproval(bytes32 transactionHash, uint256 timestamp);

26:     event StartBridgeTransaction(BridgeRequest bridgeRequest, bytes32 transactionHash);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

19:     event SetValueOracle(address _valueOracle);

20:     event SetSlippageTolerance(address _inputToken, address _outputToken, uint256 _slippageTolerance);

21:     event AddEligibleUser(address _user);

22:     event BridgeExecutionCompleted(BridgeRequest _bridgeRequest);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

20:     event AddedHandler(address _handler, bool state);

21:     event AddedChain(uint256 _chainId, bool state);

22:     event AddedBridgeBlacklist(string bridgeName, bool state);

23:     event Bridged(address bridge, address token, uint256 amount, bytes data);

24:     event Rescued(address token, address userAddress, uint256 amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

20:     event UpdatedDefaultPriceSource(address[] baseCurrencies, INoyaValueOracle[] oracles);

21:     event UpdatedAssetPriceSource(address[] asset, address[] baseToken, address[] oracle);

22:     event UpdatedPriceRoute(address asset, address baseToken, address[] s);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

32:     event ChainlinkPriceAgeThresholdUpdated(uint256 newThreshold);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

21:     event NewPeriod(uint32 period);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-12"></a>[NC-12] Events that mark critical parameter changes should contain both the old and the new value

This should especially be done if the new value is not required to be different from the old value

*Instances (26)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

124:     function updateValueOracle(INoyaValueOracle _valueOracle) public onlyMaintainer {
             require(address(_valueOracle) != address(0));
             valueOracle = _valueOracle;
             emit ValueOracleUpdated(address(_valueOracle));

135:     function setFeeReceivers(
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

170:     function setFees(uint256 _withdrawFee, uint256 _performanceFee, uint256 _managementFee) public onlyMaintainer {
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

667:     function setDepositLimits(uint256 _depositLimitPerTransaction, uint256 _depositTotalAmount) public onlyMaintainer {
             depositLimitPerTransaction = _depositLimitPerTransaction;
             depositLimitTotalAmount = _depositTotalAmount;
             emit SetDepositLimits(_depositLimitPerTransaction, _depositTotalAmount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

84:     function setFlashLoanAddress(address _flashLoan) external onlyRole(MAINTAINER_ROLE) {
            emit updateFlashloanAddress(_flashLoan, flashLoan);

207:     function updateConnectorTrustedTokens(
             uint256 vaultId,
             address _connectorAddress,
             address[] calldata _tokens,
             bool trusted
         ) external onlyVaultMaintainer(vaultId) vaultExists(vaultId) {
             Vault storage vault = vaults[vaultId];
             for (uint256 i = 0; i < _tokens.length; i++) {
                 vault.connectors[_connectorAddress].trustedTokens[_tokens[i]] = trusted;
             }
             emit ConnectorTrustedTokensUpdated(vaultId, _connectorAddress, _tokens, trusted);

293:     function updateHoldingPosition(
             Vault storage vault,
             uint256 vaultId,
             bytes32 _positionId,
             bytes calldata d,
             bytes calldata AD,
             uint256 index,
             bytes32 holdingPositionId
         ) internal returns (uint256) {
             emit HoldingPositionUpdated(vaultId, _positionId, d, AD, false, index);

335:     function updateHoldingPosition(
             uint256 vaultId,
             bytes32 _positionId,
             bytes calldata _data,
             bytes calldata additionalData,
             bool removePosition
         ) public vaultExists(vaultId) returns (uint256) {
             Vault storage vault = vaults[vaultId];
             if (!vault.connectors[msg.sender].enabled) revert UnauthorizedAccess();
             if (!vault.trustedPositionsBP[_positionId].isEnabled) revert InvalidPosition(_positionId);
             bytes32 holdingPositionId = keccak256(abi.encode(msg.sender, _positionId, _data));
             uint256 positionIndex = vault.isPositionUsed[holdingPositionId];
             if (positionIndex == 0 && removePosition) return type(uint256).max;
             if (removePosition) {
                 if (positionIndex < vault.holdingPositions.length - 1) {
                     vault.holdingPositions[positionIndex] = vault.holdingPositions[vault.holdingPositions.length - 1];
                     vault.isPositionUsed[keccak256(
                         abi.encode(
                             vault.holdingPositions[positionIndex].calculatorConnector,
                             vault.holdingPositions[positionIndex].positionId,
                             vault.holdingPositions[positionIndex].data
                         )
                     )] = positionIndex;
                 }
                 vault.holdingPositions.pop();
                 vault.isPositionUsed[holdingPositionId] = 0;
                 emit HoldingPositionUpdated(vaultId, _positionId, _data, additionalData, removePosition, positionIndex);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

40:     function updatePosition(uint256 tokenId) public onlyManager nonReentrant {
            masterchef.updateLiquidity(tokenId);
            _updateTokenInRegistry(masterchef.CAKE());
            emit UpdatePosition(tokenId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/governance/Keepers.sol

42:     function updateOwners(address[] memory _owners, bool[] memory addOrRemove) public onlyOwner {
            uint256 numOwnersTemp = numOwners;
            for (uint256 i = 0; i < _owners.length; i++) {
                if (addOrRemove[i] && !isOwner[_owners[i]]) {
                    isOwner[_owners[i]] = true;
                    numOwnersTemp++;
                } else if (!addOrRemove[i] && isOwner[_owners[i]]) {
                    isOwner[_owners[i]] = false;
                    numOwnersTemp--;
                }
            }
            require(numOwnersTemp <= 10 && threshold <= numOwnersTemp && threshold > 1);
            numOwners = numOwnersTemp;
            emit UpdateOwners(_owners, addOrRemove);

63:     function setThreshold(uint8 _threshold) public onlyOwner {
            require(_threshold <= numOwners && _threshold > 1);
            threshold = _threshold;
            emit UpdateThreshold(_threshold);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

45:     function updateMinimumHealthFactor(uint256 _minimumHealthFactor) external onlyMaintainer {
            if (_minimumHealthFactor < MINIMUM_HEALTH_FACTOR) {
                revert IConnector_LowHealthFactor(_minimumHealthFactor);
            }
            minimumHealthFactor = _minimumHealthFactor;
            emit MinimumHealthFactorUpdated(_minimumHealthFactor);

58:     function updateSwapHandler(address payable _swapHandler) external onlyMaintainer {
            swapHandler = SwapAndBridgeHandler(_swapHandler);
            emit SwapHandlerUpdated(_swapHandler);

67:     function updateValueOracle(address _valueOracle) external onlyMaintainer {
            valueOracle = INoyaValueOracle(_valueOracle);
            emit ValueOracleUpdated(_valueOracle);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

46:     function updateChainInfo(uint256 chainId, address destinationAddress) external onlyMaintainer {
            require(destinationAddress != address(0));
            destChainAddress[chainId] = destinationAddress;
            emit UpdateChainInfo(chainId, destinationAddress);

57:     function updateBridgeTransactionApproval(bytes32 transactionHash) public onlyManager {
            if (approvedBridgeTXN[transactionHash] != 0) delete approvedBridgeTXN[transactionHash];
            else approvedBridgeTXN[transactionHash] = block.timestamp;
            emit UpdateBridgeTransactionApproval(transactionHash, block.timestamp);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

48:     function setValueOracle(address _valueOracle) external onlyMaintainerOrEmergency {
            valueOracle = INoyaValueOracle(_valueOracle);
            emit SetValueOracle(_valueOracle);

57:     function setGeneralSlippageTolerance(uint256 _slippageTolerance) external onlyMaintainerOrEmergency {
            genericSlippageTolerance = _slippageTolerance;
            emit SetSlippageTolerance(address(0), address(0), _slippageTolerance);

68:     function setSlippageTolerance(address _inputToken, address _outputToken, uint256 _slippageTolerance)
            external
            onlyMaintainerOrEmergency
        {
            slippageTolerance[_inputToken][_outputToken] = _slippageTolerance;
            emit SetSlippageTolerance(_inputToken, _outputToken, _slippageTolerance);

158:     function setEnableRoute(uint256 _routeId, bool enable) external onlyMaintainerOrEmergency {
             routes[_routeId].isEnabled = enable;
             emit RouteUpdate(_routeId, false);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

37:     function updateDefaultPriceSource(address[] calldata baseCurrencies, INoyaValueOracle[] calldata oracles)
            public
            onlyMaintainer
        {
            for (uint256 i = 0; i < baseCurrencies.length; i++) {
                defaultPriceSource[baseCurrencies[i]] = oracles[i];
            }
            emit UpdatedDefaultPriceSource(baseCurrencies, oracles);

51:     function updateAssetPriceSource(address[] calldata asset, address[] calldata baseToken, address[] calldata oracle)
            external
            onlyMaintainer
        {
            for (uint256 i = 0; i < oracle.length; i++) {
                priceSource[asset[i]][baseToken[i]] = INoyaValueOracle(oracle[i]);
            }
            emit UpdatedAssetPriceSource(asset, baseToken, oracle);

61:     function updatePriceRoute(address asset, address base, address[] calldata s) external onlyMaintainer {
            priceRoutes[asset][base] = s;
            emit UpdatedPriceRoute(asset, base, s);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

56:     function updateChainlinkPriceAgeThreshold(uint256 _chainlinkPriceAgeThreshold) external onlyMaintainer {
            if (_chainlinkPriceAgeThreshold <= 1 hours || _chainlinkPriceAgeThreshold >= 10 days) {
                revert NoyaChainlinkOracle_INVALID_INPUT();
            }
            chainlinkPriceAgeThreshold = _chainlinkPriceAgeThreshold;
            emit ChainlinkPriceAgeThresholdUpdated(_chainlinkPriceAgeThreshold);

70:     function setAssetSources(address[] calldata assets, address[] calldata baseTokens, address[] calldata sources)
            external
            onlyMaintainer
        {
            for (uint256 i = 0; i < assets.length; i++) {
                assetsSources[assets[i]][baseTokens[i]] = sources[i];
                emit AssetSourceUpdated(assets[i], baseTokens[i], sources[i]);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

38:     function setPeriod(uint32 _period) external onlyMaintainer {
            if (_period == 0) revert INoyaValueOracle_InvalidInput();
            period = _period;
            emit NewPeriod(_period);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-13"></a>[NC-13] Function ordering does not follow the Solidity style guide

According to the [Solidity style guide](https://docs.soliditylang.org/en/v0.8.17/style-guide.html#order-of-functions), functions should be laid out in the following order :`constructor()`, `receive()`, `fallback()`, `external`, `public`, `internal`, `private`, but the cases below do not follow this pattern

*Instances (14)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

1: 
   Current order:
   public updateValueOracle
   public setFeeReceivers
   external sendTokensToTrustedAddress
   public setFees
   internal _update
   public deposit
   public calculateDepositShares
   public executeDeposit
   public withdraw
   public calculateWithdrawShares
   public startCurrentWithdrawGroup
   public fulfillCurrentWithdrawGroup
   public executeWithdraw
   public resetMiddle
   public recordProfitForFee
   public checkIfTVLHasDroped
   public collectManagementFees
   public collectPerformanceFees
   public burnShares
   public retrieveTokensForWithdraw
   public getProfit
   public totalAssets
   public getQueueItems
   public neededAssetsForWithdraw
   public TVL
   public getPositionTVL
   internal _getValue
   public getUnderlyingTokens
   public emergencyStop
   public unpause
   public setDepositLimits
   public changeDepositWaitingTime
   public changeWithdrawWaitingTime
   public rescue
   public mint
   public withdraw
   public redeem
   public deposit
   
   Suggested order:
   external sendTokensToTrustedAddress
   public updateValueOracle
   public setFeeReceivers
   public setFees
   public deposit
   public calculateDepositShares
   public executeDeposit
   public withdraw
   public calculateWithdrawShares
   public startCurrentWithdrawGroup
   public fulfillCurrentWithdrawGroup
   public executeWithdraw
   public resetMiddle
   public recordProfitForFee
   public checkIfTVLHasDroped
   public collectManagementFees
   public collectPerformanceFees
   public burnShares
   public retrieveTokensForWithdraw
   public getProfit
   public totalAssets
   public getQueueItems
   public neededAssetsForWithdraw
   public TVL
   public getPositionTVL
   public getUnderlyingTokens
   public emergencyStop
   public unpause
   public setDepositLimits
   public changeDepositWaitingTime
   public changeWithdrawWaitingTime
   public rescue
   public mint
   public withdraw
   public redeem
   public deposit
   internal _update
   internal _getValue

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

1: 
   Current order:
   external setMaxNumHoldingPositions
   external setFlashLoanAddress
   external addVault
   external changeVaultAddresses
   external addConnector
   external updateConnectorTrustedTokens
   public getPositionBP
   external addTrustedPosition
   external removeTrustedPosition
   internal updateHoldingPosition
   public updateHoldingPosition
   external updateHoldingPostionWithTime
   public getHoldingPositionIndex
   public getHoldingPosition
   public getHoldingPositions
   public isPositionTrusted
   public isPositionTrustedForConnector
   public getGovernanceAddresses
   public isTokenTrusted
   public calculatePositionId
   public isAnActiveConnector
   public isPositionDebt
   public getVaultAddresses
   public isAddressTrusted
   
   Suggested order:
   external setMaxNumHoldingPositions
   external setFlashLoanAddress
   external addVault
   external changeVaultAddresses
   external addConnector
   external updateConnectorTrustedTokens
   external addTrustedPosition
   external removeTrustedPosition
   external updateHoldingPostionWithTime
   public getPositionBP
   public updateHoldingPosition
   public getHoldingPositionIndex
   public getHoldingPosition
   public getHoldingPositions
   public isPositionTrusted
   public isPositionTrustedForConnector
   public getGovernanceAddresses
   public isTokenTrusted
   public calculatePositionId
   public isAnActiveConnector
   public isPositionDebt
   public getVaultAddresses
   public isAddressTrusted
   internal updateHoldingPosition

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

1: 
   Current order:
   public depositIntoGauge
   public depositIntoPrisma
   public depositIntoConvexBooster
   public openCurvePosition
   public decreaseCurvePosition
   public withdrawFromConvexBooster
   public withdrawFromConvexRewardPool
   public withdrawFromGauge
   public withdrawFromPrisma
   public harvestRewards
   public harvestPrismaRewards
   public harvestConvexRewards
   internal _getPoolInfo
   public _getPositionTVL
   public LPToUnder
   public estimateWithdrawAmount
   public totalLpBalanceOf
   public balanceOfConvexRewardPool
   public balanceOfLPToken
   public balanceOfRewardPool
   public balanceOfPrisma
   
   Suggested order:
   public depositIntoGauge
   public depositIntoPrisma
   public depositIntoConvexBooster
   public openCurvePosition
   public decreaseCurvePosition
   public withdrawFromConvexBooster
   public withdrawFromConvexRewardPool
   public withdrawFromGauge
   public withdrawFromPrisma
   public harvestRewards
   public harvestPrismaRewards
   public harvestConvexRewards
   public _getPositionTVL
   public LPToUnder
   public estimateWithdrawAmount
   public totalLpBalanceOf
   public balanceOfConvexRewardPool
   public balanceOfLPToken
   public balanceOfRewardPool
   public balanceOfPrisma
   internal _getPoolInfo

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

1: 
   Current order:
   external borrowAndSupply
   public withdraw
   public repay
   public verifyHealthFactor
   internal _getHealthFactor
   public _getUnderlyingTokens
   public _getPositionTVL
   
   Suggested order:
   external borrowAndSupply
   public withdraw
   public repay
   public verifyHealthFactor
   public _getUnderlyingTokens
   public _getPositionTVL
   internal _getHealthFactor

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

1: 
   Current order:
   external supply
   external mintPTAndYT
   external depositIntoMarket
   public depositIntoPenpie
   public withdrawFromPenpie
   external swapYTForPT
   public swapYTForSY
   external swapExactPTForSY
   external burnLP
   external decreasePosition
   external claimRewards
   public _getPositionTVL
   public getYTValue
   public isMarketEmpty
   public _getUnderlyingTokens
   
   Suggested order:
   external supply
   external mintPTAndYT
   external depositIntoMarket
   external swapYTForPT
   external swapExactPTForSY
   external burnLP
   external decreasePosition
   external claimRewards
   public depositIntoPenpie
   public withdrawFromPenpie
   public swapYTForSY
   public _getPositionTVL
   public getYTValue
   public isMarketEmpty
   public _getUnderlyingTokens

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

1: 
   Current order:
   public createAccount
   public deposit
   public withdraw
   external onERC721Received
   public delegateIntoPreferredPool
   public delegateIntoApprovedPool
   public claimRewards
   public mintOrBurnSUSD
   public _getPositionTVL
   public _getUnderlyingTokens
   
   Suggested order:
   external onERC721Received
   public createAccount
   public deposit
   public withdraw
   public delegateIntoPreferredPool
   public delegateIntoApprovedPool
   public claimRewards
   public mintOrBurnSUSD
   public _getPositionTVL
   public _getUnderlyingTokens

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

1: 
   Current order:
   external deposit
   external withdraw
   public getData
   external borrow
   external repay
   public _getPositionTVL
   public isSiloEmpty
   public _getUnderlyingTokens
   
   Suggested order:
   external deposit
   external withdraw
   external borrow
   external repay
   public getData
   public _getPositionTVL
   public isSiloEmpty
   public _getUnderlyingTokens

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

1: 
   Current order:
   external openPosition
   external decreasePosition
   external increasePosition
   public collectAllFees
   public getCurrentLiquidity
   internal _collectFees
   public _getPositionTVL
   public _getUnderlyingTokens
   
   Suggested order:
   external openPosition
   external decreasePosition
   external increasePosition
   public collectAllFees
   public getCurrentLiquidity
   public _getPositionTVL
   public _getUnderlyingTokens
   internal _collectFees

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

1: 
   Current order:
   external updateMinimumHealthFactor
   external updateSwapHandler
   external updateValueOracle
   external sendTokensToTrustedAddress
   external transferPositionToAnotherConnector
   internal _updateTokenInRegistry
   public updateTokenInRegistry
   internal _updateTokenInRegistry
   external addLiquidity
   external swapHoldings
   internal _executeSwap
   public getUnderlyingTokens
   public getPositionTVL
   internal _getValue
   public _getUnderlyingTokens
   internal _addLiquidity
   public _getPositionTVL
   internal _approveOperations
   internal _revokeApproval
   
   Suggested order:
   external updateMinimumHealthFactor
   external updateSwapHandler
   external updateValueOracle
   external sendTokensToTrustedAddress
   external transferPositionToAnotherConnector
   external addLiquidity
   external swapHoldings
   public updateTokenInRegistry
   public getUnderlyingTokens
   public getPositionTVL
   public _getUnderlyingTokens
   public _getPositionTVL
   internal _updateTokenInRegistry
   internal _updateTokenInRegistry
   internal _executeSwap
   internal _getValue
   internal _addLiquidity
   internal _approveOperations
   internal _revokeApproval

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

1: 
   Current order:
   public updateMessageSetting
   internal _payNative
   public setChainInfo
   public addVaultInfo
   public updateTVL
   
   Suggested order:
   public updateMessageSetting
   public setChainInfo
   public addVaultInfo
   public updateTVL
   internal _payNative

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol

1: 
   Current order:
   public getTVL
   external updateTVLInfo
   public _getPositionTVL
   
   Suggested order:
   external updateTVLInfo
   public getTVL
   public _getPositionTVL

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

1: 
   Current order:
   external setValueOracle
   external setGeneralSlippageTolerance
   external setSlippageTolerance
   external addEligibleUser
   external executeSwap
   external executeBridge
   public addRoutes
   external setEnableRoute
   external verifyRoute
   
   Suggested order:
   external setValueOracle
   external setGeneralSlippageTolerance
   external setSlippageTolerance
   external addEligibleUser
   external executeSwap
   external executeBridge
   external setEnableRoute
   external verifyRoute
   public addRoutes

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

1: 
   Current order:
   external addHandler
   external addChain
   external addBridgeBlacklist
   external performSwapAction
   public verifySwapData
   external performBridgeAction
   public verifyBridgeData
   internal _forward
   internal _setAllowance
   internal _isNative
   external rescueFunds
   
   Suggested order:
   external addHandler
   external addChain
   external addBridgeBlacklist
   external performSwapAction
   external performBridgeAction
   external rescueFunds
   public verifySwapData
   public verifyBridgeData
   internal _forward
   internal _setAllowance
   internal _isNative

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

1: 
   Current order:
   public updateDefaultPriceSource
   external updateAssetPriceSource
   external updatePriceRoute
   public getValue
   internal _getValue
   internal _getValue
   
   Suggested order:
   external updateAssetPriceSource
   external updatePriceRoute
   public updateDefaultPriceSource
   public getValue
   internal _getValue
   internal _getValue

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

### <a name="NC-14"></a>[NC-14] Functions should not be longer than 50 lines

Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability

*Instances (275)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

124:     function updateValueOracle(INoyaValueOracle _valueOracle) public onlyMaintainer {

150:     function sendTokensToTrustedAddress(address token, uint256 amount, address _caller, bytes calldata _data)

170:     function setFees(uint256 _withdrawFee, uint256 _performanceFee, uint256 _managementFee) public onlyMaintainer {

185:     function _update(address from, address to, uint256 amount) internal override {

200:     function deposit(address receiver, uint256 amount, address referrer) public nonReentrant whenNotPaused {

226:     function calculateDepositShares(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

257:     function executeDeposit(uint256 maxI, address connector, bytes memory addLPdata)

304:     function withdraw(uint256 share, address receiver) public nonReentrant whenNotPaused {

328:     function calculateWithdrawShares(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

360:     function startCurrentWithdrawGroup() public onlyManager nonReentrant whenNotPaused {

370:     function fulfillCurrentWithdrawGroup() public onlyManager nonReentrant whenNotPaused {

396:     function executeWithdraw(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

453:     function resetMiddle(uint256 newMiddle, bool depositOrWithdraw) public onlyManager {

475:     function recordProfitForFee() public onlyManager nonReentrant {

493:     function checkIfTVLHasDroped() public nonReentrant {

505:     function collectManagementFees() public onlyManager nonReentrant returns (uint256, uint256) {

526:     function collectPerformanceFees() public onlyManager nonReentrant {

548:     function retrieveTokensForWithdraw(RetrieveData[] calldata retrieveData) public onlyManager nonReentrant {

582:     function getProfit() public view returns (uint256) {

591:     function totalAssets() public view override returns (uint256) {

596:     function getQueueItems(bool depositOrWithdraw, uint256[] memory items)

616:     function neededAssetsForWithdraw() public view returns (uint256) {

632:     function getPositionTVL(HoldingPI memory position, address base) public view returns (uint256) {

642:     function _getValue(address token, address base, uint256 amount) internal view returns (uint256) {

649:     function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {

659:     function emergencyStop() public whenNotPaused onlyEmergency {

663:     function unpause() public whenPaused onlyEmergency {

667:     function setDepositLimits(uint256 _depositLimitPerTransaction, uint256 _depositTotalAmount) public onlyMaintainer {

673:     function changeDepositWaitingTime(uint256 _depositWaitingTime) public onlyMaintainer {

678:     function changeWithdrawWaitingTime(uint256 _withdrawWaitingTime) public onlyMaintainer {

683:     function rescue(address token, uint256 amount) public onlyEmergency nonReentrant {

693:     function mint(uint256 shares, address receiver) public override returns (uint256) {

697:     function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {

701:     function redeem(uint256 shares, address receiver, address shareOwner) public override returns (uint256) {

705:     function deposit(uint256 assets, address receiver) public override returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

23:     function withdrawShares(uint256 amount) external onlyOwner {

27:     function burnShares(uint256 amount) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/accountingManager/Registry.sol

79:     function setMaxNumHoldingPositions(uint256 _maxNumHoldingPositions) external onlyRole(MAINTAINER_ROLE) {

84:     function setFlashLoanAddress(address _flashLoan) external onlyRole(MAINTAINER_ROLE) {

188:     function addConnector(uint256 vaultId, address[] calldata _connectorAddresses, bool[] calldata _enableds)

224:     function getPositionBP(uint256 vaultId, bytes32 _positionId) public view returns (PositionBP memory) {

266:     function removeTrustedPosition(uint256 vaultId, bytes32 _positionId)

394:     function getHoldingPositionIndex(uint256 vaultId, bytes32 _positionId, address _connector, bytes memory data)

408:     function getHoldingPosition(uint256 vaultId, uint256 i) public view returns (HoldingPI memory) {

416:     function getHoldingPositions(uint256 vaultId) public view returns (HoldingPI[] memory) {

426:     function isPositionTrusted(uint256 vaultId, bytes32 _positionId) public view returns (bool) {

436:     function isPositionTrustedForConnector(uint256 vaultId, bytes32 _positionId, address connector)

470:     function isTokenTrusted(uint256 vaultId, address token, address connector) public view returns (bool) {

486:     function calculatePositionId(address calculatorConnector, uint256 positionTypeId, bytes memory data)

499:     function isAnActiveConnector(uint256 vaultId, address connectorAddress) public view returns (bool) {

508:     function isPositionDebt(uint256 vaultId, bytes32 _positionId) public view returns (bool) {

516:     function getVaultAddresses(uint256 vaultId) public view returns (address, address) {

525:     function isAddressTrusted(uint256 vaultId, address addr) public view returns (bool) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

46:     function supply(address supplyToken, uint256 amount) external onlyManager nonReentrant {

62:     function borrow(uint256 _amount, uint256 _interestRateMode, address _borrowAsset)

81:     function repay(address asset, uint256 amount, uint256 i) external onlyManager nonReentrant {

88:     function repayWithCollateral(uint256 _amount, uint256 i, address _borrowAsset) external onlyManager {

100:     function withdrawCollateral(uint256 _collateralAmount, address _collateral) external onlyManager nonReentrant {

114:     function _getPositionTVL(HoldingPI memory, address base) public view override returns (uint256 tvl) {

120:     function _getUnderlyingTokens(uint256, bytes memory) public pure override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

53:     function supply(DepositData memory data) public onlyManager nonReentrant {

79:     function withdraw(WithdrawData memory data) public onlyManager nonReentrant {

100:     function stake(address pool, uint256 liquidity) public onlyManager nonReentrant {

106:     function unstake(address pool, uint256 liquidity) public onlyManager nonReentrant {

111:     function claim(address pool) public onlyManager nonReentrant {

117:     function _getUnderlyingTokens(uint256 p, bytes memory data) public view override returns (address[] memory) {

125:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

53:     function harvestAuraRewards(address[] calldata rewardsPools) public onlyManager nonReentrant {

109:     function depositIntoAuraBooster(bytes32 poolId, uint256 _amount) public onlyManager nonReentrant {

115:     function decreasePosition(DecreasePositionParams memory p) public onlyManager nonReentrant {

162:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256) {

175:     function totalLpBalanceOf(PoolInfo memory pool) public view returns (uint256) {

184:     function totalLpBalanceOf(bytes32 poolId) public view returns (uint256) {

189:     function _getPoolInfo(bytes32 pooId) internal view returns (PoolInfo memory, bytes32) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

37:     function makeFlashLoan(IERC20[] memory tokens, uint256[] memory amounts, bytes memory userData)

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

43:     function addLiquidityInCamelotPool(CamelotAddLiquidityParams calldata p) external onlyManager nonReentrant {

65:     function removeLiquidityFromCamelotPool(CamelotRemoveLiquidityParams calldata p)

88:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

99:     function _getUnderlyingTokens(uint256 id, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

29:     function supply(address market, address asset, uint256 amount) external onlyManager nonReentrant {

48:     function withdrawOrBorrow(address _market, address asset, uint256 amount) external onlyManager nonReentrant {

63:     function claimRewards(address rewardContract, address market) external onlyManager nonReentrant {

74:     function getAccountHealthFactor(IComet comet) public view returns (uint256) {

84:     function getBorrowBalanceInBase(IComet comet) public view returns (uint256 borrowBalanceInVirtualBase) {

95:     function getCollBlanace(IComet comet, bool riskAdjusted) public view returns (uint256 CollValue) {

125:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256) {

134:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

141:     function isInAsset(uint16 assetsIn, uint8 assetOffset) public pure returns (bool) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

68:     function depositIntoGauge(address pool, uint256 amount) public onlyManager nonReentrant {

81:     function depositIntoPrisma(address pool, uint256 amount, bool curveOrConvex) public onlyManager nonReentrant {

103:     function depositIntoConvexBooster(address pool, uint256 pid, uint256 amount, bool stake) public onlyManager {

117:     function openCurvePosition(address pool, uint256 depositIndex, uint256 amount, uint256 minAmount)

160:     function decreaseCurvePosition(address pool, uint256 withdrawIndex, uint256 amount, uint256 minAmount)

182:     function withdrawFromConvexBooster(uint256 pid, uint256 amount) public onlyManager {

192:     function withdrawFromConvexRewardPool(address pool, uint256 amount) public onlyManager {

202:     function withdrawFromGauge(address pool, uint256 amount) public onlyManager {

212:     function withdrawFromPrisma(address depostiToken, uint256 amount) public onlyManager {

221:     function harvestRewards(address[] calldata gauges) public onlyManager nonReentrant {

233:     function harvestPrismaRewards(address[] calldata pools) public onlyManager nonReentrant {

247:     function harvestConvexRewards(address[] calldata rewardsPools) public onlyManager nonReentrant {

258:     function _getPoolInfo(address pool) internal view returns (PoolInfo memory) {

265:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

279:     function LPToUnder(PoolInfo memory info, uint256 balance) public view returns (uint256, address) {

297:     function estimateWithdrawAmount(ICurveSwap curvePool, uint256 amount, uint256 index)

311:     function totalLpBalanceOf(PoolInfo memory info) public view returns (uint256) {

325:     function balanceOfConvexRewardPool(PoolInfo memory info) public view returns (uint256) {

335:     function balanceOfLPToken(PoolInfo memory info) public view returns (uint256) {

344:     function balanceOfRewardPool(PoolInfo memory info) public view returns (uint256) {

354:     function balanceOfPrisma(address prismaPool) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

30:     function deposit(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {

43:     function withdraw(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {

58:     function openBorrowPosition(uint256 marketId, uint256 _amountWei, uint256 accountId)

77:     function transferBetweenAccounts(uint256 accountId, uint256 marketId, uint256 _amountWei, bool borrowOrRepay)

98:     function closeBorrowPosition(uint256[] memory marketIds, uint256 accountId) public onlyManager nonReentrant {

106:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

38:     function borrowAndSupply(IFraxPair pool, uint256 borrowAmount, uint256 collateralAmount)

68:     function withdraw(IFraxPair pool, uint256 withdrawAmount) public onlyManager nonReentrant {

87:     function repay(IFraxPair pool, uint256 sharesToRepay) public onlyManager nonReentrant {

104:     function verifyHealthFactor(IFraxPair pool) public view {

120:     function _getHealthFactor(IFraxPair _fraxlendPair, uint256 _exchangeRate) internal view virtual returns (uint256) {

142:     function _getUnderlyingTokens(uint256 p, bytes memory data) public view override returns (address[] memory) {

150:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

24:     function openAccount(address facade, uint256 ref) public onlyManager {

41:     function closeAccount(address facade, address creditAccount) public onlyManager nonReentrant {

93:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

37:     function deposit(uint256 amountIn) external onlyManager nonReentrant {

51:     function requestWithdrawals(uint256 amount) public onlyManager nonReentrant {

69:     function claimWithdrawal(uint256 requestId) public onlyManager nonReentrant {

91:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

64:     function stake(uint256 amount, uint256 duration, bool doDelegation) external onlyManager nonReentrant {

78:     function unstake(uint256 lockupId) external onlyManager nonReentrant {

91:     function addLiquidityInMaverickPool(MavericAddLiquidityParams calldata p) external onlyManager nonReentrant {

115:     function removeLiquidityFromMaverickPool(MavericRemoveLiquidityParams calldata p)

137:     function claimBoostedPositionRewards(IMaverickReward rewardContract) external onlyManager nonReentrant {

149:     function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {

153:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

161:     function _getUnderlyingTokens(uint256 id, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

35:     function supply(uint256 amount, Id id, bool sOrC) external onlyManager nonReentrant {

58:     function withdraw(uint256 amount, Id id, bool sOrC) external onlyManager nonReentrant {

80:     function borrow(uint256 amount, Id id) external onlyManager nonReentrant {

95:     function repay(uint256 amount, Id id) public onlyManager nonReentrant {

108:     function getHealthFactor(Id _id, Market memory _market) public view returns (uint256) {

118:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

137:     function convertCToL(uint256 amount, address marketOracle, address collateral) public view returns (uint256) {

141:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

31:     function sendPositionToMasterChef(uint256 tokenId) external onlyManager nonReentrant {

40:     function updatePosition(uint256 tokenId) public onlyManager nonReentrant {

50:     function withdraw(uint256 tokenId) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

78:     function supply(address market, uint256 amount) external onlyManager nonReentrant {

97:     function mintPTAndYT(address market, uint256 syAmount) external onlyManager nonReentrant {

112:     function depositIntoMarket(IPMarket market, uint256 SYamount, uint256 PTamount) external onlyManager nonReentrant {

126:     function depositIntoPenpie(address _market, uint256 _amount) public onlyManager nonReentrant {

137:     function withdrawFromPenpie(address _market, uint256 _amount) public onlyManager nonReentrant {

149:     function swapYTForPT(address market, uint256 exactYTIn, uint256 min, ApproxParams memory guess)

166:     function swapYTForSY(address market, uint256 exactYTIn, uint256 min, LimitOrderData memory orderData)

183:     function swapExactPTForSY(IPMarket market, uint256 exactPTIn, bytes calldata swapData, uint256 minSY)

203:     function burnLP(IPMarket market, uint256 amount) external onlyManager nonReentrant {

216:     function decreasePosition(IPMarket market, uint256 _amount, bool closePosition) external onlyManager nonReentrant {

241:     function claimRewards(IPMarket market) external onlyManager nonReentrant {

257:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

293:     function getYTValue(address market, uint256 balance) public view returns (uint256) {

303:     function isMarketEmpty(IPMarket market) public view returns (bool) {

311:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

33:     function approveZap(IStakeNTroveZap zap, address tm, bool approve) public onlyManager nonReentrant {

52:     function openTrove(IStakeNTroveZap zap, address tm, uint256 maxFee, uint256 dAmount, uint256 bAmount)

75:     function addColl(IStakeNTroveZap zapContract, address tm, uint256 amountIn) public onlyManager nonReentrant {

129:     function closeTrove(IStakeNTroveZap zapContract, address troveManager) public onlyManager nonReentrant {

145:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

164:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

30:     function deposit(address _token, uint256 _amount, uint128 _accountId) public onlyManager {

46:     function withdraw(address _token, uint256 _amount, uint128 _accountId) public onlyManager {

64:     function onERC721Received(address, address, uint256, bytes memory) external pure override returns (bytes4) {

94:     function claimRewards(uint128 accountId, uint128 poolId, address collateralType, address distributor)

121:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

128:     function _getUnderlyingTokens(uint256, bytes memory) public pure override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

33:     function deposit(address siloToken, address dToken, uint256 amount, bool oC) external onlyManager nonReentrant {

52:     function withdraw(address siloToken, address wToken, uint256 amount, bool oC, bool closePosition)

85:     function borrow(address siloToken, address bToken, uint256 amount) external onlyManager nonReentrant {

98:     function repay(address siloToken, address rToken, uint256 amount) external onlyManager nonReentrant {

109:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

130:     function isSiloEmpty(ISilo silo) public view returns (bool) {

143:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

49:     function depositIntoStargatePool(StargateRequest calldata depositRequest) external onlyManager nonReentrant {

76:     function withdrawFromStargatePool(StargateRequest calldata withdrawRequest) external onlyManager nonReentrant {

103:     function claimStargateRewards(uint256 poolId) external onlyManager nonReentrant {

110:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

123:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

40:     function openPosition(MintParams memory p) external onlyManager nonReentrant returns (uint256 tokenId) {

63:     function decreasePosition(DecreaseLiquidityParams memory p) external onlyManager nonReentrant {

87:     function increasePosition(IncreaseLiquidityParams memory p) external onlyManager nonReentrant {

101:     function collectAllFees(uint256[] memory tokenIds) public onlyManager nonReentrant {

116:     function getCurrentLiquidity(uint256 tokenId) public view returns (uint128, address, address) {

122:     function _collectFees(uint256 tokenId) internal returns (uint256 amount0, uint256 amount1) {

127:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {

152:     function _getUnderlyingTokens(uint256, bytes memory data) public pure override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

42:     function updateOwners(address[] memory _owners, bool[] memory addOrRemove) public onlyOwner {

63:     function setThreshold(uint8 _threshold) public onlyOwner {

124:     function domainSeparatorV4() public view returns (bytes32) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/governance/Watchers.sol

8:     function verifyRemoveLiquidity(uint256 withdrawAmount, uint256 sentAmount, bytes memory data) external view { }

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Watchers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

45:     function updateMinimumHealthFactor(uint256 _minimumHealthFactor) external onlyMaintainer {

58:     function updateSwapHandler(address payable _swapHandler) external onlyMaintainer {

67:     function updateValueOracle(address _valueOracle) external onlyMaintainer {

84:     function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes memory data)

135:     function _updateTokenInRegistry(address token, bool remove) internal {

153:     function updateTokenInRegistry(address token) public onlyManager {

158:     function _updateTokenInRegistry(address token) internal {

169:     function addLiquidity(address[] memory tokens, uint256[] memory amounts, bytes memory data)

221:     function _executeSwap(SwapRequest memory swapRequest) internal returns (uint256 amountOut) {

232:     function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {

249:     function getPositionTVL(HoldingPI memory p, address baseToken) public view returns (uint256) {

253:     function _getValue(address token, address baseToken, uint256 amount) internal view returns (uint256) {

263:     function _getUnderlyingTokens(uint256, bytes memory) public view virtual returns (address[] memory) {

267:     function _addLiquidity(address[] memory, uint256[] memory, bytes memory) internal virtual returns (bool) {

271:     function _getPositionTVL(HoldingPI memory, address) public view virtual returns (uint256 tvl) {

277:     function _approveOperations(address _token, address _spender, uint256 _amount) internal virtual {

285:     function _revokeApproval(address _token, address _spender) internal virtual {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

27:     function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes memory data)

40:     function addLiquidity(address[] memory tokens, uint256[] memory amounts, bytes memory data) external {

51:     function updatePositionToRegistryUsingType(bytes32 _positionId, bytes memory data, bool remove) external {

59:     function addPositionToRegistryUsingType(uint256 _positionType, bytes memory data) external {

65:     function addPositionToRegistry(bytes memory data) external {

71:     function getPositionTVL(HoldingPI memory p, address baseToken) public view returns (uint256) {

75:     function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {

79:     function _updateTokenInRegistry(address token, bool remove) internal {

91:     function _updateTokenInRegistry(address token) internal {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

40:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {

52:     function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {

65:     function _lzReceive(Origin calldata _origin, bytes32, bytes calldata _message, address, bytes calldata)

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

36:     function updateMessageSetting(bytes memory _messageSetting) public onlyOwner {

40:     function _payNative(uint256 amount) internal override returns (uint256) {

51:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {

63:     function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {

75:     function updateTVL(uint256 vaultId, uint256 tvl, uint256 updateTime) public {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

46:     function updateChainInfo(uint256 chainId, address destinationAddress) external onlyMaintainer {

57:     function updateBridgeTransactionApproval(bytes32 transactionHash) public onlyManager {

68:     function startBridgeTransaction(BridgeRequest memory bridgeRequest) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol

32:     function updateTVL(uint256 chainId, uint256 tvl, uint256 updateTime) external nonReentrant {

51:     function _getPositionTVL(HoldingPI memory position, address) public view override returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol

33:     function _getPositionTVL(HoldingPI memory position, address base) public view override returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

48:     function setValueOracle(address _valueOracle) external onlyMaintainerOrEmergency {

57:     function setGeneralSlippageTolerance(uint256 _slippageTolerance) external onlyMaintainerOrEmergency {

68:     function setSlippageTolerance(address _inputToken, address _outputToken, uint256 _slippageTolerance)

80:     function addEligibleUser(address _user) external onlyMaintainerOrEmergency {

90:     function executeSwap(SwapRequest memory _swapRequest)

126:     function executeBridge(BridgeRequest calldata _bridgeRequest)

147:     function addRoutes(RouteData[] memory _routes) public onlyMaintainer {

158:     function setEnableRoute(uint256 _routeId, bool enable) external onlyMaintainerOrEmergency {

164:     function verifyRoute(uint256 _routeId, address addr) external view onlyExistingRoute(_routeId) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

45:     function addHandler(address _handler, bool state) external onlyOwner {

55:     function addChain(uint256 _chainId, bool state) external onlyOwner {

65:     function addBridgeBlacklist(string memory bridgeName, bool state) external onlyOwner {

77:     function performSwapAction(address caller, SwapRequest calldata _request)

110:     function verifySwapData(SwapRequest calldata _request) public view override returns (bool) {

133:     function performBridgeAction(address caller, BridgeRequest calldata _request)

150:     function verifyBridgeData(BridgeRequest calldata _request) public view override returns (bool) {

165:     function _forward(IERC20 token, address from, uint256 amount, address caller, bytes calldata data, uint256 routeId)

185:     function _setAllowance(IERC20 token, address spender, uint256 amount) internal {

189:     function _isNative(IERC20 token) internal pure returns (bool isNative) {

193:     function rescueFunds(address token, address userAddress, uint256 amount) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

14:     function getTVL(uint256 vaultId, PositionRegistry registry, address baseToken) public view returns (uint256) {

41:     function getLatestUpdateTime(uint256 vaultId, PositionRegistry registry) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

37:     function updateDefaultPriceSource(address[] calldata baseCurrencies, INoyaValueOracle[] calldata oracles)

51:     function updateAssetPriceSource(address[] calldata asset, address[] calldata baseToken, address[] calldata oracle)

61:     function updatePriceRoute(address asset, address base, address[] calldata s) external onlyMaintainer {

71:     function getValue(address asset, address baseToken, uint256 amount) public view returns (uint256) {

81:     function _getValue(address asset, address baseToken, uint256 amount, address[] memory sources)

95:     function _getValue(address quotingToken, address baseToken, uint256 amount) internal view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

56:     function updateChainlinkPriceAgeThreshold(uint256 _chainlinkPriceAgeThreshold) external onlyMaintainer {

70:     function setAssetSources(address[] calldata assets, address[] calldata baseTokens, address[] calldata sources)

89:     function getValue(address asset, address baseToken, uint256 amount) public view returns (uint256) {

138:     function getTokenDecimals(address token) public view returns (uint256) {

143:     function getSourceOfAsset(address asset, address baseToken) public view returns (address source, bool isInverse) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

38:     function setPeriod(uint32 _period) external onlyMaintainer {

48:     function addPool(address tokenIn, address baseToken, uint24 fee) external onlyMaintainer {

60:     function getValue(address tokenIn, address baseToken, uint256 amount) public view returns (uint256 _amountOut) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-15"></a>[NC-15] Lack of checks in setters

Be it sanity checks (like checks against `0`-values) or initial setting checks: it's best for Setter functions to have them

*Instances (21)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

667:     function setDepositLimits(uint256 _depositLimitPerTransaction, uint256 _depositTotalAmount) public onlyMaintainer {
             depositLimitPerTransaction = _depositLimitPerTransaction;
             depositLimitTotalAmount = _depositTotalAmount;
             emit SetDepositLimits(_depositLimitPerTransaction, _depositTotalAmount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

84:     function setFlashLoanAddress(address _flashLoan) external onlyRole(MAINTAINER_ROLE) {
            emit updateFlashloanAddress(_flashLoan, flashLoan);
            flashLoan = _flashLoan;

207:     function updateConnectorTrustedTokens(
             uint256 vaultId,
             address _connectorAddress,
             address[] calldata _tokens,
             bool trusted
         ) external onlyVaultMaintainer(vaultId) vaultExists(vaultId) {
             Vault storage vault = vaults[vaultId];
             for (uint256 i = 0; i < _tokens.length; i++) {
                 vault.connectors[_connectorAddress].trustedTokens[_tokens[i]] = trusted;
             }
             emit ConnectorTrustedTokensUpdated(vaultId, _connectorAddress, _tokens, trusted);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

40:     function updatePosition(uint256 tokenId) public onlyManager nonReentrant {
            masterchef.updateLiquidity(tokenId);
            _updateTokenInRegistry(masterchef.CAKE());
            emit UpdatePosition(tokenId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

58:     function updateSwapHandler(address payable _swapHandler) external onlyMaintainer {
            swapHandler = SwapAndBridgeHandler(_swapHandler);
            emit SwapHandlerUpdated(_swapHandler);

67:     function updateValueOracle(address _valueOracle) external onlyMaintainer {
            valueOracle = INoyaValueOracle(_valueOracle);
            emit ValueOracleUpdated(_valueOracle);

153:     function updateTokenInRegistry(address token) public onlyManager {
             _updateTokenInRegistry(token);

158:     function _updateTokenInRegistry(address token) internal {
             _updateTokenInRegistry(token, IERC20(token).balanceOf(address(this)) == 0);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

51:     function updatePositionToRegistryUsingType(bytes32 _positionId, bytes memory data, bool remove) external {
            registry.updateHoldingPosition(vaultId, _positionId, data, "", remove);

91:     function _updateTokenInRegistry(address token) internal {
            _updateTokenInRegistry(token, IERC20(token).balanceOf(address(this)) == 0);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

36:     function updateMessageSetting(bytes memory _messageSetting) public onlyOwner {
            messageSetting = _messageSetting;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol

28:     function updateTVLInfo() external onlyManager {
            uint256 tvl = getTVL();
            LZHelperSender(lzHelper).updateTVL(vaultId, tvl, block.timestamp);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

48:     function setValueOracle(address _valueOracle) external onlyMaintainerOrEmergency {
            valueOracle = INoyaValueOracle(_valueOracle);
            emit SetValueOracle(_valueOracle);

57:     function setGeneralSlippageTolerance(uint256 _slippageTolerance) external onlyMaintainerOrEmergency {
            genericSlippageTolerance = _slippageTolerance;
            emit SetSlippageTolerance(address(0), address(0), _slippageTolerance);

68:     function setSlippageTolerance(address _inputToken, address _outputToken, uint256 _slippageTolerance)
            external
            onlyMaintainerOrEmergency
        {
            slippageTolerance[_inputToken][_outputToken] = _slippageTolerance;
            emit SetSlippageTolerance(_inputToken, _outputToken, _slippageTolerance);

158:     function setEnableRoute(uint256 _routeId, bool enable) external onlyMaintainerOrEmergency {
             routes[_routeId].isEnabled = enable;
             emit RouteUpdate(_routeId, false);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

185:     function _setAllowance(IERC20 token, address spender, uint256 amount) internal {
             token.forceApprove(spender, amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

37:     function updateDefaultPriceSource(address[] calldata baseCurrencies, INoyaValueOracle[] calldata oracles)
            public
            onlyMaintainer
        {
            for (uint256 i = 0; i < baseCurrencies.length; i++) {
                defaultPriceSource[baseCurrencies[i]] = oracles[i];
            }
            emit UpdatedDefaultPriceSource(baseCurrencies, oracles);

51:     function updateAssetPriceSource(address[] calldata asset, address[] calldata baseToken, address[] calldata oracle)
            external
            onlyMaintainer
        {
            for (uint256 i = 0; i < oracle.length; i++) {
                priceSource[asset[i]][baseToken[i]] = INoyaValueOracle(oracle[i]);
            }
            emit UpdatedAssetPriceSource(asset, baseToken, oracle);

61:     function updatePriceRoute(address asset, address base, address[] calldata s) external onlyMaintainer {
            priceRoutes[asset][base] = s;
            emit UpdatedPriceRoute(asset, base, s);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

70:     function setAssetSources(address[] calldata assets, address[] calldata baseTokens, address[] calldata sources)
            external
            onlyMaintainer
        {
            for (uint256 i = 0; i < assets.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="NC-16"></a>[NC-16] Missing Event for critical parameters change

Events help non-contract tools to track changes, and events prevent users from being surprised by changes.

*Instances (10)*:

```solidity
File: contracts/accountingManager/Registry.sol

79:     function setMaxNumHoldingPositions(uint256 _maxNumHoldingPositions) external onlyRole(MAINTAINER_ROLE) {
            require(_maxNumHoldingPositions <= MAX_NUM_HOLDING_POSITIONS);
            maxNumHoldingPositions = _maxNumHoldingPositions;

370:     function updateHoldingPostionWithTime(
             uint256 vaultId,
             bytes32 _positionId,
             bytes calldata _data,
             bytes calldata additionalData,
             bool removePosition,
             uint256 positionTimestamp
         ) external vaultExists(vaultId) {
             uint256 positionIndex = updateHoldingPosition(vaultId, _positionId, _data, additionalData, removePosition);
             if (positionIndex != type(uint256).max) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

153:     function updateTokenInRegistry(address token) public onlyManager {
             _updateTokenInRegistry(token);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

51:     function updatePositionToRegistryUsingType(bytes32 _positionId, bytes memory data, bool remove) external {
            registry.updateHoldingPosition(vaultId, _positionId, data, "", remove);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

40:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {
            require(lzHelperAddress != address(0));
            chainInfo[lzChainId] = ChainInfo(chainId, lzHelperAddress);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

36:     function updateMessageSetting(bytes memory _messageSetting) public onlyOwner {
            messageSetting = _messageSetting;

51:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {
            require(lzHelperAddress != address(0));
            chainInfo[chainId] = ChainInfo(lzChainId, lzHelperAddress);

75:     function updateTVL(uint256 vaultId, uint256 tvl, uint256 updateTime) public {
            if (msg.sender != vaultIdToVaultInfo[vaultId].omniChainManager) revert InvalidSender();
    
            uint32 lzChainId = chainInfo[vaultIdToVaultInfo[vaultId].baseChainId].lzChainId;
            bytes memory data = abi.encode(vaultId, tvl, updateTime);
            _lzSend(lzChainId, data, messageSetting, MessagingFee(address(this).balance, 0), payable(address(this))); // TODO: send event here

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol

32:     function updateTVL(uint256 chainId, uint256 tvl, uint256 updateTime) external nonReentrant {
            if (msg.sender != lzHelper) revert IConnector_InvalidSender();
    
            registry.updateHoldingPostionWithTime(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol

28:     function updateTVLInfo() external onlyManager {
            uint256 tvl = getTVL();
            LZHelperSender(lzHelper).updateTVL(vaultId, tvl, block.timestamp);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol)

### <a name="NC-17"></a>[NC-17] NatSpec is completely non-existent on functions that should have them

Public and external functions that aren't view or pure should have NatSpec comments

*Instances (60)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

200:     function deposit(address receiver, uint256 amount, address referrer) public nonReentrant whenNotPaused {

226:     function calculateDepositShares(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

543:     function burnShares(uint256 amount) public {

659:     function emergencyStop() public whenNotPaused onlyEmergency {

663:     function unpause() public whenPaused onlyEmergency {

667:     function setDepositLimits(uint256 _depositLimitPerTransaction, uint256 _depositTotalAmount) public onlyMaintainer {

673:     function changeDepositWaitingTime(uint256 _depositWaitingTime) public onlyMaintainer {

678:     function changeWithdrawWaitingTime(uint256 _withdrawWaitingTime) public onlyMaintainer {

683:     function rescue(address token, uint256 amount) public onlyEmergency nonReentrant {

693:     function mint(uint256 shares, address receiver) public override returns (uint256) {

697:     function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {

701:     function redeem(uint256 shares, address receiver, address shareOwner) public override returns (uint256) {

705:     function deposit(uint256 assets, address receiver) public override returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

23:     function withdrawShares(uint256 amount) external onlyOwner {

27:     function burnShares(uint256 amount) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/accountingManager/Registry.sol

79:     function setMaxNumHoldingPositions(uint256 _maxNumHoldingPositions) external onlyRole(MAINTAINER_ROLE) {

84:     function setFlashLoanAddress(address _flashLoan) external onlyRole(MAINTAINER_ROLE) {

106:     function addVault(

158:     function changeVaultAddresses(

188:     function addConnector(uint256 vaultId, address[] calldata _connectorAddresses, bool[] calldata _enableds)

207:     function updateConnectorTrustedTokens(

238:     function addTrustedPosition(

266:     function removeTrustedPosition(uint256 vaultId, bytes32 _positionId)

335:     function updateHoldingPosition(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

88:     function repayWithCollateral(uint256 _amount, uint256 i, address _borrowAsset) external onlyManager {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

100:     function stake(address pool, uint256 liquidity) public onlyManager nonReentrant {

106:     function unstake(address pool, uint256 liquidity) public onlyManager nonReentrant {

111:     function claim(address pool) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

53:     function harvestAuraRewards(address[] calldata rewardsPools) public onlyManager nonReentrant {

109:     function depositIntoAuraBooster(bytes32 poolId, uint256 _amount) public onlyManager nonReentrant {

115:     function decreasePosition(DecreasePositionParams memory p) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

43:     function addLiquidityInCamelotPool(CamelotAddLiquidityParams calldata p) external onlyManager nonReentrant {

65:     function removeLiquidityFromCamelotPool(CamelotRemoveLiquidityParams calldata p)

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

30:     function deposit(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {

43:     function withdraw(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {

58:     function openBorrowPosition(uint256 marketId, uint256 _amountWei, uint256 accountId)

77:     function transferBetweenAccounts(uint256 accountId, uint256 marketId, uint256 _amountWei, bool borrowOrRepay)

98:     function closeBorrowPosition(uint256[] memory marketIds, uint256 accountId) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

37:     function deposit(uint256 amountIn) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

64:     function stake(uint256 amount, uint256 duration, bool doDelegation) external onlyManager nonReentrant {

78:     function unstake(uint256 lockupId) external onlyManager nonReentrant {

91:     function addLiquidityInMaverickPool(MavericAddLiquidityParams calldata p) external onlyManager nonReentrant {

115:     function removeLiquidityFromMaverickPool(MavericRemoveLiquidityParams calldata p)

137:     function claimBoostedPositionRewards(IMaverickReward rewardContract) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

25:     function createAccount() public onlyManager {

30:     function deposit(address _token, uint256 _amount, uint128 _accountId) public onlyManager {

46:     function withdraw(address _token, uint256 _amount, uint128 _accountId) public onlyManager {

68:     function delegateIntoPreferredPool(

81:     function delegateIntoApprovedPool(

94:     function claimRewards(uint128 accountId, uint128 poolId, address collateralType, address distributor)

102:     function mintOrBurnSUSD(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

27:     function sendTokensToTrustedAddress(address token, uint256 amount, address caller, bytes memory data)

40:     function addLiquidity(address[] memory tokens, uint256[] memory amounts, bytes memory data) external {

51:     function updatePositionToRegistryUsingType(bytes32 _positionId, bytes memory data, bool remove) external {

59:     function addPositionToRegistryUsingType(uint256 _positionType, bytes memory data) external {

65:     function addPositionToRegistry(bytes memory data) external {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

193:     function rescueFunds(address token, address userAddress, uint256 amount) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

61:     function updatePriceRoute(address asset, address base, address[] calldata s) external onlyMaintainer {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

56:     function updateChainlinkPriceAgeThreshold(uint256 _chainlinkPriceAgeThreshold) external onlyMaintainer {

70:     function setAssetSources(address[] calldata assets, address[] calldata baseTokens, address[] calldata sources)

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="NC-18"></a>[NC-18] Incomplete NatSpec: `@param` is missing on actually documented functions

The following functions are missing `@param` NatSpec comments.

*Instances (10)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

123:     /// @notice updateValueOracle is a function that is used to update the value oracle of the vault
         function updateValueOracle(INoyaValueOracle _valueOracle) public onlyMaintainer {

149:     /// @notice sendTokensToTrustedAddress is used to transfer tokens from accounting manager to other contracts
         function sendTokensToTrustedAddress(address token, uint256 amount, address _caller, bytes calldata _data)

547:     /// @notice retrieveTokensForWithdraw the manager can call this function to get tokens from the connectors to fulfill the withdraw requests
         function retrieveTokensForWithdraw(RetrieveData[] calldata retrieveData) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

368:     /// @dev Same as updateHoldingPosition but with a positionTimestamp parameter
         /// @dev in scenarios where the positionTimestamp is not the current time (e.g. when we have positions on other chains)
         function updateHoldingPostionWithTime(
             uint256 vaultId,
             bytes32 _positionId,
             bytes calldata _data,
             bytes calldata additionalData,
             bool removePosition,
             uint256 positionTimestamp

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

43:     /**
         * @notice Supply tokens to Aave
         */
        function supply(address supplyToken, uint256 amount) external onlyManager nonReentrant {

78:     /**
         * @notice Repays onBehalfOf's debt amount of asset which has a rateMode.
         */
        function repay(address asset, uint256 amount, uint256 i) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

61:     /**
         * Internal Functions *********************************
         */
        function openPosition(
            bytes32 poolId,
            uint256[] memory amounts,
            uint256[] memory amountsWithoutBPT,
            uint256 minBPT,
            uint256 auraAmount

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

62:     /// @notice Claim additional rewards
        function claimRewards(address rewardContract, address market) external onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/governance/Keepers.sol

68:     /**
         * @notice Executes a transaction if it has been approved by the required number of owners
         * @dev Validates the signatures against the transaction details and the current nonce to prevent replay attacks.
         * @param destination The address to which the transaction will be sent
         * @param data The data payload of the transaction (same as msg.data (https://github.com/safe-global/safe-smart-account/blob/2278f7ccd502878feb5cec21dd6255b82df374b5/contracts/base/Executor.sol#L24))
         * @param gasLimit The maximum amount of gas that the transaction is allowed to use
         * @param executor The address executing the transaction, must be an owner
         * @param sigR Array of 'r' components of the signatures
         * @param sigS Array of 's' components of the signatures
         * @param sigV Array of 'v' components of the signatures
         * @dev The execute function incorporates several security measures, including:
         *     - Verification that the msg.sender is an owner.
         *     - Ensuring that the number of signatures (sigR, sigS, sigV) matches the threshold.
         *     - Sequentially verifying each signature to confirm it's valid, from an owner, and not reused within the same transaction (guarding against replay attacks).
         */
    
        function execute(
            address destination,
            bytes calldata data,
            uint256 gasLimit,
            address executor,
            bytes32[] memory sigR,
            bytes32[] memory sigS,
            uint8[] memory sigV,
            uint256 deadline

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

157:     ///@notice disables the route  if required.
         function setEnableRoute(uint256 _routeId, bool enable) external onlyMaintainerOrEmergency {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

### <a name="NC-19"></a>[NC-19] Incomplete NatSpec: `@return` is missing on actually documented functions

The following functions are missing `@return` NatSpec comments.

*Instances (2)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

149:     /// @notice sendTokensToTrustedAddress is used to transfer tokens from accounting manager to other contracts
         function sendTokensToTrustedAddress(address token, uint256 amount, address _caller, bytes calldata _data)
             external
             returns (uint256)

502:     /// @notice collectManagementFees is a function that is used to collect the management fees
         /// @dev management fee is x% of the total assets per year
         /// @dev we can mint x% of the total shares to the management fee receiver
         function collectManagementFees() public onlyManager nonReentrant returns (uint256, uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

### <a name="NC-20"></a>[NC-20] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor

If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (28)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

155:         if (registry.isAnActiveConnector(vaultId, msg.sender)) {

305:         if (balanceOf(msg.sender) < share + withdrawRequestsByAddress[msg.sender]) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

33:         if (msg.sender != vaults[_vaultId].maintainer || hasRole(EMERGENCY_ROLE, msg.sender) == false) {

40:         if (msg.sender != vaults[_vaultId].maintainerWithoutTimeLock && hasRole(EMERGENCY_ROLE, msg.sender) == false) {

47:         if (msg.sender != vaults[_vaultId].governer && hasRole(EMERGENCY_ROLE, msg.sender) == false) {

305:             if (!isPositionTrustedForConnector(vaultId, _positionId, msg.sender)) {

343:         if (!vault.connectors[msg.sender].enabled) revert UnauthorizedAccess();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

61:         require(msg.sender == address(vault));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/governance/Keepers.sol

94:         require(isOwner[msg.sender], "Not an owner");

97:         require(executor == msg.sender, "Invalid executor");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/governance/NoyaGovernanceBase.sol

33:         if (!(msg.sender == keeperContract || msg.sender == emergencyManager || msg.sender == registry.flashLoan())) {

45:         if (msg.sender != emergencyManager) revert NoyaGovernance_Unauthorized(msg.sender);

55:         if (msg.sender != emergencyManager && msg.sender != watcherContract) {

67:         if (msg.sender != maintainer && msg.sender != emergencyManager) revert NoyaGovernance_Unauthorized(msg.sender);

77:         if (msg.sender != maintainer) revert NoyaGovernance_Unauthorized(msg.sender);

87:         if (msg.sender != governer) revert NoyaGovernance_Unauthorized(msg.sender);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/NoyaGovernanceBase.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

90:         if (msg.sender == accountingManager) {

98:         } else if (registry.isAnActiveConnector(vaultId, msg.sender) || msg.sender == registry.flashLoan()) {

102:             swapHandler.verifyRoute(routeId, msg.sender);

174:         if (!registry.isAddressTrusted(vaultId, msg.sender)) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

76:         if (msg.sender != vaultIdToVaultInfo[vaultId].omniChainManager) revert InvalidSender();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol

33:         if (msg.sender != lzHelper) revert IConnector_InvalidSender();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

25:         require(isEligibleToUse[msg.sender], "NoyaSwapHandler: Not eligible to use");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

27:     constructor(address swapHandler, address _lifi) Ownable2Step() Ownable(msg.sender) {

35:         require(isHandler[msg.sender] == true, "LifiImplementation: INVALID_SENDER");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

25:         if (!registry.hasRole(registry.MAINTAINER_ROLE(), msg.sender)) revert INoyaValueOracle_Unauthorized(msg.sender);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

42:         if (!registry.hasRole(registry.MAINTAINER_ROLE(), msg.sender)) revert INoyaValueOracle_Unauthorized(msg.sender);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

25:         if (!registry.hasRole(registry.MAINTAINER_ROLE(), msg.sender)) revert INoyaValueOracle_Unauthorized(msg.sender);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-21"></a>[NC-21] Consider using named mappings

Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (19)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

27:     mapping(address => uint256) public withdrawRequestsByAddress;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

26:     mapping(uint256 => Vault) public vaults;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/governance/Keepers.sol

10:     mapping(address => bool) public isOwner;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

19:     mapping(uint32 => ChainInfo) public chainInfo; // chainId => ChainInfo

20:     mapping(uint256 => VaultInfo) public vaultIdToVaultInfo; // vaultId => VaultInfo

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

20:     mapping(uint256 => ChainInfo) public chainInfo; // chainId => ChainInfo

21:     mapping(uint256 => VaultInfo) public vaultIdToVaultInfo; // vaultId => VaultInfo

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

21:     mapping(uint256 => address) public destChainAddress;

22:     mapping(bytes32 => uint256) public approvedBridgeTXN;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

13:     mapping(address => bool) public isEligibleToUse;

15:     mapping(address => mapping(address => uint256)) public slippageTolerance;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

13:     mapping(address => bool) public isHandler;

14:     mapping(string => bool) public isBridgeWhiteListed;

15:     mapping(uint256 => bool) public isChainSupported;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

13:     mapping(address => INoyaValueOracle) public defaultPriceSource;

14:     mapping(address => mapping(address => address[])) public priceRoutes;

16:     mapping(address => mapping(address => INoyaValueOracle)) public priceSource;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

20:     mapping(address => mapping(address => address)) private assetsSources;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

14:     mapping(address => mapping(address => address)) public assetToBaseToPool;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-22"></a>[NC-22] Adding a `return` statement when the function defines a named return variable, is redundant

*Instances (24)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

594:     /// @notice This is a view function that helps us to get the queue items easily
     
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

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

114:     function _getPositionTVL(HoldingPI memory, address base) public view override returns (uint256 tvl) {
             (uint256 totalCollateralBase, uint256 totalDebtBase,,,,) = IPool(pool).getUserAccountData(address(this));
             uint256 poolBaseAmount = totalCollateralBase - totalDebtBase;
             return valueOracle.getValue(poolBaseToken, base, poolBaseAmount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

88:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
            (address tokenA, address tokenB) =
                abi.decode(registry.getPositionBP(vaultId, p.positionId).data, (address, address));
            address pool = factory.getPair(tokenA, tokenB);
            uint256 totalSupply = IERC20(pool).totalSupply();
            (uint256 reserves0, uint256 reserves1,,) = ICamelotPair(pool).getReserves();
    
            uint256 balanceThis = IERC20(pool).balanceOf(address(this));
            return balanceThis * (_getValue(tokenA, base, reserves0) + _getValue(tokenB, base, reserves1)) / totalSupply;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

80:     /**
         * @notice Returns the borrow balance in base token for the given comet.
         */
    
        function getBorrowBalanceInBase(IComet comet) public view returns (uint256 borrowBalanceInVirtualBase) {
            uint256 borrowBalanceInBase = comet.borrowBalanceOf(address(this));
            if (borrowBalanceInBase == 0) return 0;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

265:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
             PositionBP memory PTI = registry.getPositionBP(vaultId, p.positionId);
             PoolInfo memory poolInfo = abi.decode(PTI.additionalData, (PoolInfo));
             uint256 lpBalance = totalLpBalanceOf(poolInfo);
             (uint256 amount, address token) = LPToUnder(poolInfo, lpBalance);
             return _getValue(token, base, amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

106:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
             uint256 accountId = abi.decode(p.data, (uint256));
     
             (uint256[] memory markets, address[] memory tokens,, Types.Wei[] memory amounts) =
                 dolomiteMargin.getAccountBalances(Info(address(this), accountId));
             uint256 totalDebt = 0;
             uint256 totalCollateral = 0;
             for (uint256 i = 0; i < markets.length; i++) {
                 uint256 value = valueOracle.getValue(tokens[i], base, amounts[i].value);
                 if (amounts[i].sign) {
                     totalCollateral += value;
                 } else {
                     totalDebt += value;
                 }
             }
             return totalCollateral - totalDebt;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

150:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
             PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
             IFraxPair pool = IFraxPair(abi.decode(positionInfo.data, (address)));
             uint256 collateralAmount = pool.userCollateralBalance(address(this));
             uint256 borrowerShares = pool.userBorrowShares(address(this));
             uint256 _borrowerAmount = pool.toBorrowAmount(borrowerShares, true);
     
             uint256 borrowValue = _getValue(pool.asset(), base, _borrowerAmount);
             uint256 collateralValue = _getValue(pool.collateralContract(), base, collateralAmount);
             if (collateralValue > borrowValue) {
                 return collateralValue - borrowValue;
             }
             return tvl;

150:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
             PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
             IFraxPair pool = IFraxPair(abi.decode(positionInfo.data, (address)));
             uint256 collateralAmount = pool.userCollateralBalance(address(this));
             uint256 borrowerShares = pool.userBorrowShares(address(this));
             uint256 _borrowerAmount = pool.toBorrowAmount(borrowerShares, true);
     
             uint256 borrowValue = _getValue(pool.asset(), base, _borrowerAmount);
             uint256 collateralValue = _getValue(pool.collateralContract(), base, collateralAmount);
             if (collateralValue > borrowValue) {
                 return collateralValue - borrowValue;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

87:     /**
         * @notice Get the TVL of a credit account
         * @param p - HoldingPI struct
         * @param base - base token address
         */
    
        function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
            address creditAccount = abi.decode(p.data, (address));
            PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
            ICreditFacadeV3 facade = ICreditFacadeV3(abi.decode(positionInfo.data, (address)));
            CollateralDebtData memory d = ICreditManagerV3(facade.creditManager()).calcDebtAndCollateral(
                creditAccount, CollateralCalcTask.DEBT_COLLATERAL_SAFE_PRICES
            );
            if (d.totalDebtUSD > d.totalValueUSD) {
                return 0;
            }
            return _getValue(address(840), base, (d.totalValueUSD - d.totalDebtUSD));

87:     /**
         * @notice Get the TVL of a credit account
         * @param p - HoldingPI struct
         * @param base - base token address
         */
    
        function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
            address creditAccount = abi.decode(p.data, (address));
            PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
            ICreditFacadeV3 facade = ICreditFacadeV3(abi.decode(positionInfo.data, (address)));
            CollateralDebtData memory d = ICreditManagerV3(facade.creditManager()).calcDebtAndCollateral(
                creditAccount, CollateralCalcTask.DEBT_COLLATERAL_SAFE_PRICES
            );
            if (d.totalDebtUSD > d.totalValueUSD) {
                return 0;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

91:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
            (uint256 amount) = abi.decode(p.additionalData, (uint256));
            return _getValue(steth, base, amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

153:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
             PositionBP memory position = registry.getPositionBP(vaultId, p.positionId);
             IMaverickPool pool = abi.decode(position.data, (IMaverickPool));
     
             (uint256 a, uint256 b) = positionInspector.addressBinReservesAllKindsAllTokenIds(address(this), pool);
             return _getValue(pool.tokenA(), base, a) + _getValue(pool.tokenB(), base, b);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

249:     /**
          * @notice Retrieves the Total Value Locked (TVL) for a specific holding position in the given base token
          * @param p Struct containing holding position information
          * @param base Address of the base token for TVL calculation
          * @return tvl The total value locked of the position
          * @dev The TVL is calculated by calculating the value of YT, LP and PT in terms of SY and then converting to the base token
          */
     
         function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
             PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
             if (positionInfo.positionTypeId == PENDLE_POSITION_ID) {
                 uint256 underlyingBalance = 0;
                 address market = abi.decode(positionInfo.data, (address));
                 (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(market).readTokens();
                 (, address _underlyingToken,) = _SY.assetInfo();
     
                 uint256 SYAmount = _SY.balanceOf(address(this));
     
                 //
                 uint256 lpBalance =
                     IERC20(market).balanceOf(address(this)) + pendleMarketDepositHelper.balance(market, address(this));
                 if (lpBalance > 0) {
                     SYAmount += lpBalance * IPMarket(market).getLpToAssetRate(10) / 1e18;
                 }
     
                 uint256 PTAmount = _PT.balanceOf(address(this));
                 if (PTAmount > 0) SYAmount += PTAmount * IPMarket(market).getPtToAssetRate(10) / 1e18;
     
                 uint256 YTBalance = _YT.balanceOf(address(this));
                 if (YTBalance > 0) SYAmount += getYTValue(market, YTBalance);
     
                 if (SYAmount > 0) underlyingBalance += SYAmount * _SY.exchangeRate() / 1e18;
     
                 tvl = valueOracle.getValue(_underlyingToken, base, underlyingBalance);
             }
             return tvl;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

137:     /**
          * @notice Calculates the Total Value Locked (TVL) of a given position in the specified base token
          * @param p The holding position information
          * @param base The address of the base currency to calculate the TVL in
          * @return tvl The TVL of the position in the base currency
          * @dev The TVL is calculated as the value of the collateral minus the value of the debt
          */
     
         function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
             PositionBP memory positionInfo = registry.getPositionBP(vaultId, p.positionId);
             if (positionInfo.positionTypeId == PRISMA_POSITION_ID) {
                 (address zap, address troveManager) = abi.decode(positionInfo.data, (address, address));
                 IBorrowerOperations borrowerOperations = IStakeNTroveZap(zap).borrowerOps();
                 address collateral = borrowerOperations.troveManagersData(troveManager).collateralToken;
                 address debTtoken = ITroveManager(troveManager).debtToken();
                 (uint256 collateralBalance, uint256 debtBalance) =
                     ITroveManager(troveManager).getTroveCollAndDebt(address(this));
                 return _getValue(collateral, base, collateralBalance) - _getValue(debTtoken, base, debtBalance);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

71:     function getData(address siloToken)
            public
            view
            returns (uint256 userLTV, uint256 LiquidationThreshold, bool isSolvent)
        {
            return SolvencyV2.getData(ISilo(siloRepository.getSilo(siloToken)), address(this), minimumHealthFactor);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

110:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
             PositionBP memory pBP = registry.getPositionBP(vaultId, p.positionId);
             uint256 poolId = abi.decode(pBP.data, (uint256));
             address lpAddress = LPStaking.poolInfo(poolId).lpToken;
             uint256 lpAmount = LPStaking.userInfo(poolId, address(this)).amount + IERC20(lpAddress).balanceOf(address(this));
             if (lpAmount == 0) {
                 return 0;
             }
             address underlyingToken = IStargatePool(lpAddress).token();
             uint256 underlyingAmount = IStargatePool(lpAddress).amountLPtoLD(lpAmount);
             return _getValue(underlyingToken, base, underlyingAmount);

110:     function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
             PositionBP memory pBP = registry.getPositionBP(vaultId, p.positionId);
             uint256 poolId = abi.decode(pBP.data, (uint256));
             address lpAddress = LPStaking.poolInfo(poolId).lpToken;
             uint256 lpAmount = LPStaking.userInfo(poolId, address(this)).amount + IERC20(lpAddress).balanceOf(address(this));
             if (lpAmount == 0) {
                 return 0;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

271:     function _getPositionTVL(HoldingPI memory, address) public view virtual returns (uint256 tvl) {
             return 0;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

189:     function _isNative(IERC20 token) internal pure returns (bool isNative) {
             return address(token) == address(0);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

81:     function _getValue(address asset, address baseToken, uint256 amount, address[] memory sources)
            internal
            view
            returns (uint256 value)
        {
            uint256 initialValue = amount;
            address quotingToken = asset;
            for (uint256 i = 0; i < sources.length; i++) {
                initialValue = _getValue(asset, sources[i], initialValue);
                quotingToken = sources[i];
            }
            return _getValue(quotingToken, baseToken, initialValue);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

143:     function getSourceOfAsset(address asset, address baseToken) public view returns (address source, bool isInverse) {
             if (assetsSources[asset][baseToken] != address(0)) {
                 return (assetsSources[asset][baseToken], false);
             } else if (assetsSources[baseToken][asset] != address(0)) {
                 return (assetsSources[baseToken][asset], true);
             }
             return (address(0), false);

143:     function getSourceOfAsset(address asset, address baseToken) public view returns (address source, bool isInverse) {
             if (assetsSources[asset][baseToken] != address(0)) {
                 return (assetsSources[asset][baseToken], false);

143:     function getSourceOfAsset(address asset, address baseToken) public view returns (address source, bool isInverse) {
             if (assetsSources[asset][baseToken] != address(0)) {
                 return (assetsSources[asset][baseToken], false);
             } else if (assetsSources[baseToken][asset] != address(0)) {
                 return (assetsSources[baseToken][asset], true);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/WETH_Oracle.sol

5:     function latestRoundData()
           external
           view
           returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
       {
           return (0, 1e18, 0, block.timestamp, 0);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/WETH_Oracle.sol)

### <a name="NC-23"></a>[NC-23] `require()` / `revert()` statements should have descriptive reason strings

*Instances (74)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

106:         require(p._baseTokenAddress != address(0));

107:         require(p._valueOracle != address(0));

108:         require(p._withdrawFeeReceiver != address(0));

109:         require(p._performanceFeeReceiver != address(0));

110:         require(p._managementFeeReceiver != address(0));

125:         require(address(_valueOracle) != address(0));

140:         require(_withdrawFeeReceiver != address(0));

141:         require(_performanceFeeReceiver != address(0));

142:         require(_managementFeeReceiver != address(0));

361:         require(currentWithdrawGroup.isStarted == false && currentWithdrawGroup.isFullfilled == false);

371:         require(currentWithdrawGroup.isStarted == true && currentWithdrawGroup.isFullfilled == false);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

15:         require(_accountingManager != address(0));

16:         require(_baseToken != address(0));

17:         require(_receiver != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/accountingManager/Registry.sol

67:         require(_governer != address(0));

68:         require(_maintainer != address(0));

69:         require(_emergency != address(0));

80:         require(_maxNumHoldingPositions <= MAX_NUM_HOLDING_POSITIONS);

120:         require(_governer != address(0));

121:         require(_accountingManager != address(0));

122:         require(_baseToken != address(0));

123:         require(_maintainer != address(0));

124:         require(_keeperContract != address(0));

125:         require(_watcher != address(0));

167:         require(_governer != address(0));

168:         require(_maintainer != address(0));

169:         require(_keeperContract != address(0));

170:         require(_watcher != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

36:         require(_pool != address(0));

37:         require(_poolBaseToken != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

43:         require(_router != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

45:         require(_balancerVault != address(0));

46:         require(bal != address(0));

47:         require(aura != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

25:         require(_balancerVault != address(0));

26:         require(address(_registry) != address(0));

61:         require(msg.sender == address(vault));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

37:         require(_router != address(0));

38:         require(_factory != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

52:         require(_convexBooster != address(0));

53:         require(cvx != address(0));

54:         require(crv != address(0));

55:         require(prisma != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

24:         require(_depositWithdrawalProxy != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

23:         require(_lido != address(0));

24:         require(_lidoW != address(0));

25:         require(_steth != address(0));

26:         require(w != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

46:         require(_mav != address(0));

47:         require(_veMav != address(0));

48:         require(mr != address(0));

49:         require(pi != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

24:         require(MB != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

22:         require(MC != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

60:         require(_pendleMarketDepositHelper != address(0));

61:         require(_pendleRouter != address(0));

62:         require(SR != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

21:         require(_SNXCoreProxy != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

18:         require(SR != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

36:         require(lpStacking != address(0));

37:         require(_stargateRouter != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/governance/Keepers.sol

28:         require(_owners.length <= 10 && _threshold <= _owners.length && _threshold > 1);

53:         require(numOwnersTemp <= 10 && threshold <= numOwnersTemp && threshold > 1);

64:         require(_threshold <= numOwners && _threshold > 1);

106:                 require(recovered > lastAdd && isOwner[recovered]);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/governance/NoyaGovernanceBase.sol

22:         require(address(_registry) != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/NoyaGovernanceBase.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

41:         require(lzHelperAddress != address(0));

53:         require(omniChainManager != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

52:         require(lzHelperAddress != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

37:         require(_lzHelper != address(0));

47:         require(destinationAddress != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

41:         require(_valueOracle != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

30:         require(address(_registry) != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

47:         require(_reg != address(0));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="NC-24"></a>[NC-24] Take advantage of Custom Error's return value property

An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (51)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

116:             revert NoyaAccounting_INVALID_FEE();

175:             revert NoyaAccounting_INVALID_FEE();

202:             revert NoyaAccounting_INVALID_AMOUNT();

208:             revert NoyaAccounting_DepositLimitPerTransactionExceeded();

212:             revert NoyaAccounting_TotalDepositLimitExceeded();

295:             revert NoyaAccounting_INVALID_CONNECTOR();

336:             revert NoyaAccounting_ThereIsAnActiveWithdrawGroup();

375:             revert NoyaAccounting_NOT_READY_TO_FULFILL();

398:             revert NoyaAccounting_ThereIsAnActiveWithdrawGroup();

458:                 revert NoyaAccounting_INVALID_AMOUNT();

465:                 revert NoyaAccounting_INVALID_AMOUNT();

560:             if (balanceBefore + amount > balanceAfter) revert NoyaAccounting_banalceAfterIsNotEnough();

571:             revert NoyaAccounting_INVALID_AMOUNT();

694:         revert NoyaAccounting_NOT_ALLOWED();

698:         revert NoyaAccounting_NOT_ALLOWED();

702:         revert NoyaAccounting_NOT_ALLOWED();

706:         revert NoyaAccounting_NOT_ALLOWED();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

34:             revert UnauthorizedAccess();

41:             revert UnauthorizedAccess();

48:             revert UnauthorizedAccess();

54:         if (vaults[_vaultId].accountManager == address(0)) revert NotExist();

118:         if (vaults[vaultId].accountManager != address(0)) revert AlreadyExists();

250:             if (vault.trustedPositionsBP[positionId].isEnabled) revert AlreadyExists();

251:             if (vault.connectors[calculatorConnector].enabled == false) revert NotExist();

272:         if (!vault.trustedPositionsBP[_positionId].isEnabled) revert NotExist();

309:                 revert TooManyPositions();

343:         if (!vault.connectors[msg.sender].enabled) revert UnauthorizedAccess();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

92:             revert IConnector_InvalidInput();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

66:             revert IConnector_InvalidAmount();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

76:         if (msg.sender != vaultIdToVaultInfo[vaultId].omniChainManager) revert InvalidSender();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

74:         if (bridgeRequest.from != address(this)) revert IConnector_InvalidInput();

79:             revert IConnector_InvalidDestinationChain();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol

33:         if (msg.sender != lzHelper) revert IConnector_InvalidSender();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

30:         if (routes[_routeId].route == address(0) && !routes[_routeId].isEnabled) revert RouteNotFound();

98:         if (_swapRequest.amount == 0) revert InvalidAmount();

100:         if (swapImplInfo.isBridge) revert RouteNotAllowedForThisAction();

135:         if (!bridgeImplInfo.isBridge) revert RouteNotAllowedForThisAction();

166:             revert RouteNotFound();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

113:             revert InvalidSelector();

119:         if (receivingAmount < _request.minAmount) revert InvalidMinAmount();

120:         if (sendingAssetId != _request.inputToken) revert InvalidInputToken();

121:         if (receivingAssetId != _request.outputToken) revert InvalidOutputToken();

122:         if (amount != _request.amount) revert InvalidAmount();

153:         if (isBridgeWhiteListed[bridgeData.bridge] == false) revert BridgeBlacklisted();

154:         if (isChainSupported[bridgeData.destinationChainId] == false) revert InvalidChainId();

155:         if (bridgeData.sendingAssetId != _request.inputToken) revert InvalidFromToken();

159:         if (bridgeData.minAmount > _request.amount) revert InvalidMinAmount();

160:         if (bridgeData.destinationChainId != _request.destChainId) revert InvalidToChainId();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

58:             revert NoyaChainlinkOracle_INVALID_INPUT();

126:             revert NoyaChainlinkOracle_DATA_OUT_OF_DATE();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

39:         if (_period == 0) revert INoyaValueOracle_InvalidInput();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-25"></a>[NC-25] Avoid the use of sensitive terms

Use [alternative variants](https://www.zdnet.com/article/mysql-drops-master-slave-and-blacklist-whitelist-terminology/), e.g. allowlist/denylist instead of whitelist/blacklist

*Instances (6)*:

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

14:     mapping(string => bool) public isBridgeWhiteListed;

22:     event AddedBridgeBlacklist(string bridgeName, bool state);

65:     function addBridgeBlacklist(string memory bridgeName, bool state) external onlyOwner {

66:         isBridgeWhiteListed[bridgeName] = state;

67:         emit AddedBridgeBlacklist(bridgeName, state);

153:         if (isBridgeWhiteListed[bridgeData.bridge] == false) revert BridgeBlacklisted();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="NC-26"></a>[NC-26] Contract does not follow the Solidity style guide's suggested layout ordering

The [style guide](https://docs.soliditylang.org/en/v0.8.16/style-guide.html#order-of-layout) says that, within a contract, the ordering should be:

1) Type declarations
2) State variables
3) Events
4) Modifiers
5) Functions

However, the contract(s) below do not follow this ordering

*Instances (4)*:

```solidity
File: contracts/governance/NoyaGovernanceBase.sol

1: 
   Current order:
   VariableDeclaration.registry
   VariableDeclaration.vaultId
   ErrorDefinition.NoyaGovernance_Unauthorized
   FunctionDefinition.constructor
   ModifierDefinition.onlyManager
   ModifierDefinition.onlyEmergency
   ModifierDefinition.onlyEmergencyOrWatcher
   ModifierDefinition.onlyMaintainerOrEmergency
   ModifierDefinition.onlyMaintainer
   ModifierDefinition.onlyGovernance
   
   Suggested order:
   VariableDeclaration.registry
   VariableDeclaration.vaultId
   ErrorDefinition.NoyaGovernance_Unauthorized
   ModifierDefinition.onlyManager
   ModifierDefinition.onlyEmergency
   ModifierDefinition.onlyEmergencyOrWatcher
   ModifierDefinition.onlyMaintainerOrEmergency
   ModifierDefinition.onlyMaintainer
   ModifierDefinition.onlyGovernance
   FunctionDefinition.constructor

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/NoyaGovernanceBase.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

1: 
   Current order:
   VariableDeclaration.chainInfo
   VariableDeclaration.vaultIdToVaultInfo
   ErrorDefinition.InvalidPayload
   VariableDeclaration.TVL_UPDATE
   FunctionDefinition.constructor
   FunctionDefinition.setChainInfo
   FunctionDefinition.addVaultInfo
   FunctionDefinition._lzReceive
   
   Suggested order:
   VariableDeclaration.chainInfo
   VariableDeclaration.vaultIdToVaultInfo
   VariableDeclaration.TVL_UPDATE
   ErrorDefinition.InvalidPayload
   FunctionDefinition.constructor
   FunctionDefinition.setChainInfo
   FunctionDefinition.addVaultInfo
   FunctionDefinition._lzReceive

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

1: 
   Current order:
   UsingForDirective.IERC20
   VariableDeclaration.isHandler
   VariableDeclaration.isBridgeWhiteListed
   VariableDeclaration.isChainSupported
   VariableDeclaration.lifi
   VariableDeclaration.LI_FI_GENERIC_SWAP_SELECTOR
   EventDefinition.AddedHandler
   EventDefinition.AddedChain
   EventDefinition.AddedBridgeBlacklist
   EventDefinition.Bridged
   EventDefinition.Rescued
   FunctionDefinition.constructor
   ModifierDefinition.onlyHandler
   FunctionDefinition.addHandler
   FunctionDefinition.addChain
   FunctionDefinition.addBridgeBlacklist
   FunctionDefinition.performSwapAction
   FunctionDefinition.verifySwapData
   FunctionDefinition.performBridgeAction
   FunctionDefinition.verifyBridgeData
   FunctionDefinition._forward
   FunctionDefinition._setAllowance
   FunctionDefinition._isNative
   FunctionDefinition.rescueFunds
   
   Suggested order:
   UsingForDirective.IERC20
   VariableDeclaration.isHandler
   VariableDeclaration.isBridgeWhiteListed
   VariableDeclaration.isChainSupported
   VariableDeclaration.lifi
   VariableDeclaration.LI_FI_GENERIC_SWAP_SELECTOR
   EventDefinition.AddedHandler
   EventDefinition.AddedChain
   EventDefinition.AddedBridgeBlacklist
   EventDefinition.Bridged
   EventDefinition.Rescued
   ModifierDefinition.onlyHandler
   FunctionDefinition.constructor
   FunctionDefinition.addHandler
   FunctionDefinition.addChain
   FunctionDefinition.addBridgeBlacklist
   FunctionDefinition.performSwapAction
   FunctionDefinition.verifySwapData
   FunctionDefinition.performBridgeAction
   FunctionDefinition.verifyBridgeData
   FunctionDefinition._forward
   FunctionDefinition._setAllowance
   FunctionDefinition._isNative
   FunctionDefinition.rescueFunds

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

1: 
   Current order:
   VariableDeclaration.registry
   VariableDeclaration.chainlinkPriceAgeThreshold
   VariableDeclaration.assetsSources
   VariableDeclaration.ETH
   VariableDeclaration.USD
   EventDefinition.AssetSourceUpdated
   EventDefinition.ChainlinkPriceAgeThresholdUpdated
   ErrorDefinition.NoyaChainlinkOracle_DATA_OUT_OF_DATE
   ErrorDefinition.NoyaChainlinkOracle_PRICE_ORACLE_UNAVAILABLE
   ErrorDefinition.NoyaChainlinkOracle_INVALID_INPUT
   ModifierDefinition.onlyMaintainer
   FunctionDefinition.constructor
   FunctionDefinition.updateChainlinkPriceAgeThreshold
   FunctionDefinition.setAssetSources
   FunctionDefinition.getValue
   FunctionDefinition.getValueFromChainlinkFeed
   FunctionDefinition.getTokenDecimals
   FunctionDefinition.getSourceOfAsset
   
   Suggested order:
   VariableDeclaration.registry
   VariableDeclaration.chainlinkPriceAgeThreshold
   VariableDeclaration.assetsSources
   VariableDeclaration.ETH
   VariableDeclaration.USD
   ErrorDefinition.NoyaChainlinkOracle_DATA_OUT_OF_DATE
   ErrorDefinition.NoyaChainlinkOracle_PRICE_ORACLE_UNAVAILABLE
   ErrorDefinition.NoyaChainlinkOracle_INVALID_INPUT
   EventDefinition.AssetSourceUpdated
   EventDefinition.ChainlinkPriceAgeThresholdUpdated
   ModifierDefinition.onlyMaintainer
   FunctionDefinition.constructor
   FunctionDefinition.updateChainlinkPriceAgeThreshold
   FunctionDefinition.setAssetSources
   FunctionDefinition.getValue
   FunctionDefinition.getValueFromChainlinkFeed
   FunctionDefinition.getTokenDecimals
   FunctionDefinition.getSourceOfAsset

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="NC-27"></a>[NC-27] TODO Left in the code

TODOs may signal that a feature is missing or not ready for audit, consider resolving the issue and removing the TODO comment

*Instances (2)*:

```solidity
File: contracts/connectors/MaverickConnector.sol

93:         _approveOperations(p.pool.tokenA(), maverickRouter, p.tokenARequiredAllowance); // TODO: check token A is eth

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

80:         _lzSend(lzChainId, data, messageSetting, MessagingFee(address(this).balance, 0), payable(address(this))); // TODO: send event here

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

### <a name="NC-28"></a>[NC-28] Use Underscores for Number Literals (add an underscore every 3 digits)

*Instances (2)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

89:     uint256 public depositLimitPerTransaction = 1e6 * 2000;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

19:     uint32 public period = 1800;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-29"></a>[NC-29] Internal and private variables and functions names should begin with an underscore

According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (15)*:

```solidity
File: contracts/accountingManager/Registry.sol

293:     function updateHoldingPosition(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

33:     IRouter aerodromeRouter;

34:     IVoter voter;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

27:     address internal balancerVault;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

15:     IBalancerVault internal vault;

17:     address caller;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

30:     address mav;

31:     address veMav;

32:     address maverickRouter;

33:     IPositionInspector positionInspector;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

22:     IStargateLPStaking LPStaking;

23:     IStargateRouter stargateRouter;

24:     address rewardToken;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

23:     bytes messageSetting;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

20:     mapping(address => mapping(address => address)) private assetsSources;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="NC-30"></a>[NC-30] Event is missing `indexed` fields

Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (91)*:

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

12:     event ManagementFeeReceived(address indexed token, uint256 amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

26:     event Supply(address supplyToken, uint256 amount);

27:     event Borrow(address borrowToken, uint256 amount);

28:     event Repay(address repayToken, uint256 amount, uint256 i);

29:     event RepayWithCollateral(address repayToken, uint256 amount, uint256 i);

30:     event WithdrawCollateral(address collateral, uint256 amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

36:     event Supply(address pool, uint256 amount0, uint256 amount1);

37:     event Withdraw(address pool, uint256 amountLiquidity);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

34:     event OpenPosition(

37:     event DecreasePosition(DecreasePositionParams p);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

21:     event MakeFlashLoan(IERC20[] tokens, uint256[] amounts);

22:     event ReceiveFlashLoan(IERC20[] tokens, uint256[] amounts, uint256[] feeAmounts, bytes userData);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

10:     event Supply(address market, address asset, uint256 amount);

11:     event WithdrawOrBorrow(address market, address asset, uint256 amount);

12:     event ClaimRewards(address rewardContract, address market);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

33:     event OpenCurvePosition(address pool, uint256 depositIndex, uint256 amount, uint256 minAmount);

34:     event DecreaseCurvePosition(address pool, uint256 withdrawIndex, uint256 amount, uint256 minAmount);

35:     event WithdrawFromConvexBooster(uint256 pid, uint256 amount);

36:     event WithdrawFromConvexRewardPool(address pool, uint256 amount);

37:     event WithdrawFromGauge(address pool, uint256 amount);

38:     event WithdrawFromPrisma(address depostiToken, uint256 amount);

39:     event HarvestRewards(address[] gauges);

40:     event HarvestPrismaRewards(address[] pools);

41:     event HarvestConvexRewards(address[] rewardsPools);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

24:     event BorrowAndSupply(address pool, uint256 borrowAmount, uint256 collateralAmount);

25:     event Withdraw(address pool, uint256 withdrawAmount);

26:     event Repay(address pool, uint256 sharesToRepay);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

11:     event OpenAccount(address facade, uint256 ref);

12:     event CloseAccount(address facade, address creditAccount);

13:     event ExecuteCommands(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

15:     event Deposit(uint256 amountIn);

16:     event RequestWithdrawals(uint256 amount);

17:     event ClaimWithdrawal(uint256 requestId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

37:     event Stake(uint256 amount, uint256 duration, bool doDelegation);

38:     event Unstake(uint256 lockupId);

39:     event AddLiquidityInMaverickPool(MavericAddLiquidityParams p);

40:     event RemoveLiquidityFromMaverickPool(MavericRemoveLiquidityParams p);

41:     event ClaimBoostedPositionRewards(IMaverickReward rewardContract);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

17:     event Supply(uint256 amount, Id id, bool sOrC);

18:     event Withdraw(uint256 amount, Id id, bool sOrC);

19:     event Borrow(uint256 amount, Id id);

20:     event Repay(uint256 amount, Id id);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

14:     event SendPositionToMasterChef(uint256 tokenId);

15:     event UpdatePosition(uint256 tokenId);

16:     event Withdraw(uint256 tokenId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

35:     event Supply(address market, uint256 amount);

36:     event MintPTAndYT(address market, uint256 syAmount);

37:     event DepositIntoMarket(address market, uint256 SYamount, uint256 PTamount);

38:     event DepositIntoPenpie(address market, uint256 amount);

39:     event WithdrawFromPenpie(address market, uint256 amount);

40:     event SwapYTForPT(address market, uint256 exactYTIn, uint256 min, ApproxParams guess);

41:     event SwapYTForSY(address market, uint256 exactYTIn, uint256 min, LimitOrderData orderData);

42:     event SwapExactPTForSY(address market, uint256 exactPTIn, bytes swapData, uint256 minSY);

43:     event BurnLP(address market, uint256 amount);

44:     event DecreasePosition(address market, uint256 amount, bool closePosition);

45:     event ClaimRewards(address market);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

16:     event OpenTrove(address zap, address tm, uint256 maxFee, uint256 dAmount, uint256 bAmount);

17:     event AddColl(address zap, address tm, uint256 amountIn);

18:     event AdjustTrove(address zap, address tm, uint256 mFee, uint256 wAmount, uint256 bAmount, bool isBorrowing);

19:     event CloseTrove(address zap, address troveManager);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

12:     event Deposit(address siloToken, address dToken, uint256 amount, bool oC);

13:     event Withdraw(address siloToken, address wToken, uint256 amount, bool oC, bool closePosition);

14:     event Borrow(address siloToken, address bToken, uint256 amount);

15:     event Repay(address siloToken, address rToken, uint256 amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

28:     event DepositIntoStargatePool(StargateRequest depositRequest);

29:     event WithdrawFromStargatePool(StargateRequest withdrawRequest);

30:     event ClaimStargateRewards(uint256 poolId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

21:     event OpenPosition(MintParams p, uint256 tokenId);

22:     event DecreasePosition(DecreaseLiquidityParams p);

23:     event IncreasePosition(IncreaseLiquidityParams p);

24:     event CollectFees(uint256 tokenId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

18:     event Execute(address indexed destination, bytes data, uint256 gasLimit, address executor, uint256 deadline);

19:     event UpdateOwners(address[] owners, bool[] addOrRemove);

20:     event UpdateThreshold(uint8 threshold);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

24:     event UpdateChainInfo(uint256 chainId, address destinationAddress);

25:     event UpdateBridgeTransactionApproval(bytes32 transactionHash, uint256 timestamp);

26:     event StartBridgeTransaction(BridgeRequest bridgeRequest, bytes32 transactionHash);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

19:     event SetValueOracle(address _valueOracle);

20:     event SetSlippageTolerance(address _inputToken, address _outputToken, uint256 _slippageTolerance);

21:     event AddEligibleUser(address _user);

22:     event BridgeExecutionCompleted(BridgeRequest _bridgeRequest);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

20:     event AddedHandler(address _handler, bool state);

21:     event AddedChain(uint256 _chainId, bool state);

22:     event AddedBridgeBlacklist(string bridgeName, bool state);

23:     event Bridged(address bridge, address token, uint256 amount, bytes data);

24:     event Rescued(address token, address userAddress, uint256 amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

20:     event UpdatedDefaultPriceSource(address[] baseCurrencies, INoyaValueOracle[] oracles);

21:     event UpdatedAssetPriceSource(address[] asset, address[] baseToken, address[] oracle);

22:     event UpdatedPriceRoute(address asset, address baseToken, address[] s);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

32:     event ChainlinkPriceAgeThresholdUpdated(uint256 newThreshold);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

21:     event NewPeriod(uint32 period);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-31"></a>[NC-31] Constants should be defined rather than using magic numbers

*Instances (2)*:

```solidity
File: contracts/connectors/GearBoxV3.sol

103:         return _getValue(address(840), base, (d.totalValueUSD - d.totalDebtUSD));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

26:     address public constant USD = address(840);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="NC-32"></a>[NC-32] `override` function arguments that are unused should have the variable name removed or commented out to avoid compiler warnings

*Instances (9)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

693:     function mint(uint256 shares, address receiver) public override returns (uint256) {

697:     function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {

701:     function redeem(uint256 shares, address receiver, address shareOwner) public override returns (uint256) {

705:     function deposit(uint256 assets, address receiver) public override returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

117:     function _getUnderlyingTokens(uint256 p, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

99:     function _getUnderlyingTokens(uint256 id, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

134:     function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

142:     function _getUnderlyingTokens(uint256 p, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

161:     function _getUnderlyingTokens(uint256 id, bytes memory data) public view override returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

### <a name="NC-33"></a>[NC-33] `public` functions not called by the contract should be declared `external` instead

*Instances (113)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

124:     function updateValueOracle(INoyaValueOracle _valueOracle) public onlyMaintainer {

135:     function setFeeReceivers(

170:     function setFees(uint256 _withdrawFee, uint256 _performanceFee, uint256 _managementFee) public onlyMaintainer {

200:     function deposit(address receiver, uint256 amount, address referrer) public nonReentrant whenNotPaused {

226:     function calculateDepositShares(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

257:     function executeDeposit(uint256 maxI, address connector, bytes memory addLPdata)

304:     function withdraw(uint256 share, address receiver) public nonReentrant whenNotPaused {

328:     function calculateWithdrawShares(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

360:     function startCurrentWithdrawGroup() public onlyManager nonReentrant whenNotPaused {

370:     function fulfillCurrentWithdrawGroup() public onlyManager nonReentrant whenNotPaused {

396:     function executeWithdraw(uint256 maxIterations) public onlyManager nonReentrant whenNotPaused {

453:     function resetMiddle(uint256 newMiddle, bool depositOrWithdraw) public onlyManager {

475:     function recordProfitForFee() public onlyManager nonReentrant {

493:     function checkIfTVLHasDroped() public nonReentrant {

505:     function collectManagementFees() public onlyManager nonReentrant returns (uint256, uint256) {

526:     function collectPerformanceFees() public onlyManager nonReentrant {

543:     function burnShares(uint256 amount) public {

548:     function retrieveTokensForWithdraw(RetrieveData[] calldata retrieveData) public onlyManager nonReentrant {

596:     function getQueueItems(bool depositOrWithdraw, uint256[] memory items)

632:     function getPositionTVL(HoldingPI memory position, address base) public view returns (uint256) {

649:     function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {

659:     function emergencyStop() public whenNotPaused onlyEmergency {

663:     function unpause() public whenPaused onlyEmergency {

667:     function setDepositLimits(uint256 _depositLimitPerTransaction, uint256 _depositTotalAmount) public onlyMaintainer {

673:     function changeDepositWaitingTime(uint256 _depositWaitingTime) public onlyMaintainer {

678:     function changeWithdrawWaitingTime(uint256 _withdrawWaitingTime) public onlyMaintainer {

683:     function rescue(address token, uint256 amount) public onlyEmergency nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

224:     function getPositionBP(uint256 vaultId, bytes32 _positionId) public view returns (PositionBP memory) {

394:     function getHoldingPositionIndex(uint256 vaultId, bytes32 _positionId, address _connector, bytes memory data)

408:     function getHoldingPosition(uint256 vaultId, uint256 i) public view returns (HoldingPI memory) {

416:     function getHoldingPositions(uint256 vaultId) public view returns (HoldingPI[] memory) {

426:     function isPositionTrusted(uint256 vaultId, bytes32 _positionId) public view returns (bool) {

449:     function getGovernanceAddresses(uint256 vaultId)

508:     function isPositionDebt(uint256 vaultId, bytes32 _positionId) public view returns (bool) {

516:     function getVaultAddresses(uint256 vaultId) public view returns (address, address) {

525:     function isAddressTrusted(uint256 vaultId, address addr) public view returns (bool) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

53:     function supply(DepositData memory data) public onlyManager nonReentrant {

79:     function withdraw(WithdrawData memory data) public onlyManager nonReentrant {

100:     function stake(address pool, uint256 liquidity) public onlyManager nonReentrant {

106:     function unstake(address pool, uint256 liquidity) public onlyManager nonReentrant {

111:     function claim(address pool) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

53:     function harvestAuraRewards(address[] calldata rewardsPools) public onlyManager nonReentrant {

64:     function openPosition(

109:     function depositIntoAuraBooster(bytes32 poolId, uint256 _amount) public onlyManager nonReentrant {

115:     function decreasePosition(DecreasePositionParams memory p) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

68:     function depositIntoGauge(address pool, uint256 amount) public onlyManager nonReentrant {

81:     function depositIntoPrisma(address pool, uint256 amount, bool curveOrConvex) public onlyManager nonReentrant {

103:     function depositIntoConvexBooster(address pool, uint256 pid, uint256 amount, bool stake) public onlyManager {

117:     function openCurvePosition(address pool, uint256 depositIndex, uint256 amount, uint256 minAmount)

160:     function decreaseCurvePosition(address pool, uint256 withdrawIndex, uint256 amount, uint256 minAmount)

182:     function withdrawFromConvexBooster(uint256 pid, uint256 amount) public onlyManager {

192:     function withdrawFromConvexRewardPool(address pool, uint256 amount) public onlyManager {

202:     function withdrawFromGauge(address pool, uint256 amount) public onlyManager {

212:     function withdrawFromPrisma(address depostiToken, uint256 amount) public onlyManager {

221:     function harvestRewards(address[] calldata gauges) public onlyManager nonReentrant {

233:     function harvestPrismaRewards(address[] calldata pools) public onlyManager nonReentrant {

247:     function harvestConvexRewards(address[] calldata rewardsPools) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

30:     function deposit(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {

43:     function withdraw(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {

58:     function openBorrowPosition(uint256 marketId, uint256 _amountWei, uint256 accountId)

77:     function transferBetweenAccounts(uint256 accountId, uint256 marketId, uint256 _amountWei, bool borrowOrRepay)

98:     function closeBorrowPosition(uint256[] memory marketIds, uint256 accountId) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

68:     function withdraw(IFraxPair pool, uint256 withdrawAmount) public onlyManager nonReentrant {

87:     function repay(IFraxPair pool, uint256 sharesToRepay) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

24:     function openAccount(address facade, uint256 ref) public onlyManager {

41:     function closeAccount(address facade, address creditAccount) public onlyManager nonReentrant {

62:     function executeCommands(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

51:     function requestWithdrawals(uint256 amount) public onlyManager nonReentrant {

69:     function claimWithdrawal(uint256 requestId) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

95:     function repay(uint256 amount, Id id) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

40:     function updatePosition(uint256 tokenId) public onlyManager nonReentrant {

50:     function withdraw(uint256 tokenId) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

126:     function depositIntoPenpie(address _market, uint256 _amount) public onlyManager nonReentrant {

137:     function withdrawFromPenpie(address _market, uint256 _amount) public onlyManager nonReentrant {

166:     function swapYTForSY(address market, uint256 exactYTIn, uint256 min, LimitOrderData memory orderData)

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

33:     function approveZap(IStakeNTroveZap zap, address tm, bool approve) public onlyManager nonReentrant {

52:     function openTrove(IStakeNTroveZap zap, address tm, uint256 maxFee, uint256 dAmount, uint256 bAmount)

75:     function addColl(IStakeNTroveZap zapContract, address tm, uint256 amountIn) public onlyManager nonReentrant {

97:     function adjustTrove(

129:     function closeTrove(IStakeNTroveZap zapContract, address troveManager) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

25:     function createAccount() public onlyManager {

30:     function deposit(address _token, uint256 _amount, uint128 _accountId) public onlyManager {

46:     function withdraw(address _token, uint256 _amount, uint128 _accountId) public onlyManager {

68:     function delegateIntoPreferredPool(

81:     function delegateIntoApprovedPool(

94:     function claimRewards(uint128 accountId, uint128 poolId, address collateralType, address distributor)

102:     function mintOrBurnSUSD(

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

71:     function getData(address siloToken)

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

101:     function collectAllFees(uint256[] memory tokenIds) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

42:     function updateOwners(address[] memory _owners, bool[] memory addOrRemove) public onlyOwner {

63:     function setThreshold(uint8 _threshold) public onlyOwner {

84:     function execute(

124:     function domainSeparatorV4() public view returns (bytes32) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

153:     function updateTokenInRegistry(address token) public onlyManager {

232:     function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {

249:     function getPositionTVL(HoldingPI memory p, address baseToken) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

71:     function getPositionTVL(HoldingPI memory p, address baseToken) public view returns (uint256) {

75:     function getUnderlyingTokens(uint256 positionTypeId, bytes memory data) public view returns (address[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

40:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {

52:     function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

36:     function updateMessageSetting(bytes memory _messageSetting) public onlyOwner {

51:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {

63:     function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {

75:     function updateTVL(uint256 vaultId, uint256 tvl, uint256 updateTime) public {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

57:     function updateBridgeTransactionApproval(bytes32 transactionHash) public onlyManager {

68:     function startBridgeTransaction(BridgeRequest memory bridgeRequest) public onlyManager nonReentrant {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

147:     function addRoutes(RouteData[] memory _routes) public onlyMaintainer {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

14:     function getTVL(uint256 vaultId, PositionRegistry registry, address baseToken) public view returns (uint256) {

41:     function getLatestUpdateTime(uint256 vaultId, PositionRegistry registry) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

37:     function updateDefaultPriceSource(address[] calldata baseCurrencies, INoyaValueOracle[] calldata oracles)

71:     function getValue(address asset, address baseToken, uint256 amount) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

89:     function getValue(address asset, address baseToken, uint256 amount) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

60:     function getValue(address tokenIn, address baseToken, uint256 amount) public view returns (uint256 _amountOut) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="NC-34"></a>[NC-34] Variables need not be initialized to zero

The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (59)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

228:         uint64 i = 0;

264:         uint64 i = 0;

265:         uint256 processedBaseTokenAmount = 0;

330:         uint64 i = 0;

331:         uint256 processedShares = 0;

332:         uint256 assetsNeededForWithdraw = 0;

400:         uint64 i = 0;

403:         uint256 withdrawFeeAmount = 0;

404:         uint256 processedBaseTokenAmount = 0;

549:         uint256 amountAskedForWithdraw_temp = 0;

551:         for (uint256 i = 0; i < retrieveData.length; i++) {

603:             for (uint256 i = 0; i < items.length; i++) {

608:             for (uint256 i = 0; i < items.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/Registry.sol

138:         for (uint256 i = 0; i < _trustedTokens.length; i++) {

194:         for (uint256 i = 0; i < _connectorAddresses.length; i++) {

214:         for (uint256 i = 0; i < _tokens.length; i++) {

253:             for (uint256 i = 0; i < usingTokens.length; i++) {

274:         for (uint256 i = 0; i < length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

54:         for (uint256 i = 0; i < rewardsPools.length; i++) {

77:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

74:             for (uint256 i = 0; i < tokens.length; i++) {

79:             for (uint256 i = 0; i < destinationConnector.length; i++) {

84:             for (uint256 i = 0; i < tokens.length; i++) {

89:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

222:         for (uint256 i = 0; i < gauges.length; i++) {

234:         for (uint256 i = 0; i < pools.length; i++) {

248:         for (uint256 i = 0; i < rewardsPools.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

111:         uint256 totalDebt = 0;

112:         uint256 totalCollateral = 0;

113:         for (uint256 i = 0; i < markets.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

69:         for (uint256 i = 0; i < calls.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

140:         for (uint256 i = 0; i < earnedInfo.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

244:         for (uint256 i = 0; i < rewardTokens.length; i++) {

260:             uint256 underlyingBalance = 0;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

114:         uint256 totalDepositAmount = 0;

115:         uint256 totalBAmount = 0;

116:         for (uint256 i = 0; i < assets.length; i++) {

132:         for (uint256 i = 0; i < assetsS.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

102:         for (uint256 i = 0; i < tokenIds.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

29:         for (uint256 i = 0; i < _owners.length; i++) {

44:         for (uint256 i = 0; i < _owners.length; i++) {

103:             address lastAdd = address(0);

104:             for (uint256 i = 0; i < threshold;) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

178:         for (uint256 i = 0; i < tokens.length; i++) {

189:         for (uint256 i = 0; i < tokens.length; i++) {

211:         for (uint256 i = 0; i < tokensIn.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

17:     uint256 public vaultId = 0;

41:         for (uint256 i = 0; i < tokens.length; i++) {

46:         for (uint256 i = 0; i < tokens.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

37:         for (uint256 i = 0; i < usersAddresses.length; i++) {

148:         for (uint256 i = 0; i < _routes.length;) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

85:         uint256 balanceOut0 = 0;

92:         uint256 balanceOut1 = 0;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

18:         for (uint256 i = 0; i < positions.length; i++) {

44:         for (uint256 i = 0; i < positions.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

41:         for (uint256 i = 0; i < baseCurrencies.length; i++) {

55:         for (uint256 i = 0; i < oracle.length; i++) {

88:         for (uint256 i = 0; i < sources.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

74:         for (uint256 i = 0; i < assets.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

## Low Issues

| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | `approve()`/`safeApprove()` may revert if the current approval is not zero | 2 |
| [L-2](#L-2) | Use a 2-step ownership transfer pattern | 1 |
| [L-3](#L-3) | Some tokens may revert when zero value transfers are made | 19 |
| [L-4](#L-4) | Missing checks for `address(0)` when assigning values to address state variables | 4 |
| [L-5](#L-5) | `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()` | 1 |
| [L-6](#L-6) | `decimals()` is not a part of the ERC-20 standard | 1 |
| [L-7](#L-7) | Deprecated approve() function | 2 |
| [L-8](#L-8) | Division by zero not prevented | 15 |
| [L-9](#L-9) | `domainSeparator()` isn't protected against replay attacks in case of a future chain split  | 3 |
| [L-10](#L-10) | Empty Function Body - Consider commenting why | 1 |
| [L-11](#L-11) | Empty `receive()/payable fallback()` function does not authenticate requests | 3 |
| [L-12](#L-12) | External calls in an un-bounded `for-`loop may result in a DOS | 3 |
| [L-13](#L-13) | External call recipient may consume all transaction gas | 5 |
| [L-14](#L-14) | Signature use at deadlines should be allowed | 3 |
| [L-15](#L-15) | Prevent accidentally burning tokens | 5 |
| [L-16](#L-16) | Possible rounding issue | 6 |
| [L-17](#L-17) | Loss of precision | 11 |
| [L-18](#L-18) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 40 |
| [L-19](#L-19) | Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership` | 6 |
| [L-20](#L-20) | Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting | 7 |
| [L-21](#L-21) | Unsafe ERC20 operation(s) | 2 |

### <a name="L-1"></a>[L-1] `approve()`/`safeApprove()` may revert if the current approval is not zero

- Some tokens (like the *very popular* USDT) do not work when changing the allowance from an existing non-zero allowance value (it will revert if the current approval is not zero to protect against front-running changes of approvals). These tokens must first be approved for zero and then the actual allowance can be approved.
- Furthermore, OZ's implementation of safeApprove would throw an error if an approve is attempted from a non-zero value (`"SafeERC20: approve from non-zero to non-zero allowance"`)

Set the allowance to zero immediately before each of the existing allowance calls

*Instances (2)*:

```solidity
File: contracts/connectors/LidoConnector.sol

71:         ILidoWithdrawal(lidoWithdrawal).approve(lidoWithdrawal, requestId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

121:         position.approve(maverickRouter, p.tokenId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

### <a name="L-2"></a>[L-2] Use a 2-step ownership transfer pattern

Recommend considering implementing a two step process where the owner or admin nominates an account and the nominated account needs to call an `acceptOwnership()` function for the transfer of ownership to fully succeed. This ensures the nominated EOA account is a valid and active account. Lack of two-step procedure for critical operations leaves them error-prone. Consider adding two step procedure on the critical functions.

*Instances (1)*:

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

7: contract NoyaFeeReceiver is Ownable {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

### <a name="L-3"></a>[L-3] Some tokens may revert when zero value transfers are made

Example: <https://github.com/d-xo/weird-erc20#revert-on-zero-value-transfers>.

In spite of the fact that EIP-20 [states](https://github.com/ethereum/EIPs/blob/46b9b698815abbfa628cd1097311deee77dd45c5/EIPS/eip-20.md?plain=1#L116) that zero-valued transfers must be accepted, some tokens, such as LEND will revert if this is attempted, which may cause transactions that involve other tokens (such as batch operations) to fully revert. Consider skipping the transfer if the amount is zero, which will also save gas.

*Instances (19)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

156:             IERC20(token).safeTransfer(address(msg.sender), amount);

205:         baseToken.safeTransferFrom(msg.sender, address(this), amount);

428:             baseToken.safeTransfer(data.receiver, baseTokenAmount);

439:             baseToken.safeTransfer(withdrawFeeReceiver, withdrawFeeAmount);

688:             IERC20(token).safeTransfer(msg.sender, amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

76:                 tokens[i].safeTransfer(receiver, amounts[i]);

91:             tokens[i].safeTransfer(msg.sender, amounts[i]);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

99:         IERC20(address(_SY)).safeTransfer(address(_YT), syAmount);

114:         IERC20(address(_SY)).safeTransfer(address(market), SYamount);

115:         IERC20(address(_PT)).safeTransfer(address(market), PTamount);

189:         IERC20(address(_PT)).safeTransfer(address(market), exactPTIn);

204:         IERC20(address(market)).safeTransfer(address(market), amount);

221:         IERC20(address(SY)).safeTransfer(address(SY), _amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

96:             IERC20(token).safeTransfer(address(accountingManager), newAmount);

99:             IERC20(token).safeTransfer(address(msg.sender), amount);

104:             IERC20(token).safeTransfer(msg.sender, amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

32:             IERC20(token).safeTransfer(msg.sender, amount);

36:         IERC20(token).safeTransfer(msg.sender, amountToSend);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

198:             IERC20(token).safeTransfer(userAddress, amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="L-4"></a>[L-4] Missing checks for `address(0)` when assigning values to address state variables

*Instances (4)*:

```solidity
File: contracts/accountingManager/Registry.sol

76:         flashLoan = _flashLoan;

86:         flashLoan = _flashLoan;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

29:         lifi = _lifi;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

32:         factory = _factory;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="L-5"></a>[L-5] `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`

Use `abi.encode()` instead which will pad items to 32 bytes, which will [prevent hash collisions](https://docs.soliditylang.org/en/v0.8.13/abi-spec.html#non-standard-packed-mode) (e.g. `abi.encodePacked(0x123,0x456)` => `0x123456` => `abi.encodePacked(0x1,0x23456)`, but `abi.encode(0x123,0x456)` => `0x0...1230...456`). "Unless there is a compelling reason, `abi.encode` should be preferred". If there is only one argument to `abi.encodePacked()` it can often be cast to `bytes()` or `bytes32()` [instead](https://ethereum.stackexchange.com/questions/30912/how-to-compare-strings-in-solidity#answer-82739).
If all arguments are strings and or bytes, `bytes.concat()` should be used instead

*Instances (1)*:

```solidity
File: contracts/governance/Keepers.sol

102:             bytes32 totalHash = keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), txInputHash));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

### <a name="L-6"></a>[L-6] `decimals()` is not a part of the ERC-20 standard

The `decimals()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (1)*:

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

139:         uint256 decimals = IERC20Metadata(token).decimals();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

### <a name="L-7"></a>[L-7] Deprecated approve() function

Due to the inheritance of ERC20's approve function, there's a vulnerability to the ERC20 approve and double spend front running attack. Briefly, an authorized spender could spend both allowances by front running an allowance-changing transaction. Consider implementing OpenZeppelin's `.safeApprove()` function to help mitigate this.

*Instances (2)*:

```solidity
File: contracts/connectors/LidoConnector.sol

71:         ILidoWithdrawal(lidoWithdrawal).approve(lidoWithdrawal, requestId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

121:         position.approve(maverickRouter, p.tokenId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

### <a name="L-8"></a>[L-8] Division by zero not prevented

The divisions below take an input parameter which does not have any zero-value checks, which may lead to the functions reverting when zero is passed.

*Instances (15)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

243:                 middleTemp, data.receiver, block.timestamp, shares, data.amount, shares * 1e18 / data.amount

275:                 firstTemp, data.receiver, block.timestamp, data.shares, data.amount, data.shares * 1e18 / data.amount

416:                 data.amount * currentWithdrawGroup.totalABAmount / currentWithdrawGroup.totalCBAmountFullfilled;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

131:         uint256 amount0 = balance * reserve0 / totalSupply;

132:         uint256 amount1 = balance * reserve1 / totalSupply;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

172:         return (((1e18 * token1bal * lpBalance) / _weight) / _totalSupply);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

96:         return balanceThis * (_getValue(tokenA, base, reserves0) + _getValue(tokenB, base, reserves1)) / totalSupply;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

78:         return getCollBlanace(comet, true) * 1e18 / borrowBalanceInBase;

89:         borrowBalanceInVirtualBase = (borrowBalanceInBase * basePriceInVirtualBase) / comet.baseScale();

118:                     collateralBalance * collateralPriceInVirtualBase * baseScale / info.scale / basePrice;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

129:             (((_borrowerAmount * _exchangeRate) * LTV_PRECISION) / EXCHANGE_PRECISION) / _collateralAmount;

136:         uint256 currentHF = (fraxlendPairMaxLTV * 1e18) / currentPositionLTV;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

115:         return market.lltv * convertCToL(p.collateral, market.oracle, market.collateralToken) / borrowAmount;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

132:             return (amountIn * sourceTokenUnit) / uintprice;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

81:         int24 timeWeightedAverageTick = int24(tickCumulativesDelta / int56(int32(period)));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="L-9"></a>[L-9] `domainSeparator()` isn't protected against replay attacks in case of a future chain split

Severity: Low.
Description: See <https://eips.ethereum.org/EIPS/eip-2612#security-considerations>.
Remediation: Consider using the [implementation](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/EIP712.sol#L77-L90) from OpenZeppelin, which recalculates the domain separator if the current `block.chainid` is not the cached chain ID.
Past occurrences of this issue:

- [Reality Cards Contest](https://github.com/code-423n4/2021-06-realitycards-findings/issues/166)
- [Swivel Contest](https://github.com/code-423n4/2021-09-swivel-findings/issues/98)
- [Malt Finance Contest](https://github.com/code-423n4/2021-11-malt-findings/issues/349)

*Instances (3)*:

```solidity
File: contracts/governance/Keepers.sol

102:             bytes32 totalHash = keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), txInputHash));

124:     function domainSeparatorV4() public view returns (bytes32) {

125:         return _domainSeparatorV4();

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

### <a name="L-10"></a>[L-10] Empty Function Body - Consider commenting why

*Instances (1)*:

```solidity
File: contracts/governance/Watchers.sol

8:     function verifyRemoveLiquidity(uint256 withdrawAmount, uint256 sentAmount, bytes memory data) external view { }

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Watchers.sol)

### <a name="L-11"></a>[L-11] Empty `receive()/payable fallback()` function does not authenticate requests

If the intention is for the Ether to be used, the function should call another function, otherwise it should revert (e.g. require(msg.sender == address(weth))). Having no access control on the function means that someone may send Ether to the contract, and have no way to get anything back out, which is a loss of funds. If the concern is having to spend a small amount of gas to check the sender against an immutable address, the code should at least have a function to rescue unused Ether.

*Instances (3)*:

```solidity
File: contracts/connectors/LidoConnector.sol

89:     receive() external payable { }

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

56:     receive() external payable { }

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

27:     receive() external payable { }

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

### <a name="L-12"></a>[L-12] External calls in an un-bounded `for-`loop may result in a DOS

Consider limiting the number of iterations in for-loops that make external calls

*Instances (3)*:

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

76:                 tokens[i].safeTransfer(receiver, amounts[i]);

91:             tokens[i].safeTransfer(msg.sender, amounts[i]);

92:             require(tokens[i].balanceOf(address(this)) == 0, "BalancerFlashLoan: Flash loan extra tokens");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

### <a name="L-13"></a>[L-13] External call recipient may consume all transaction gas

There is no limit specified on the amount of gas used, so the recipient can use up all of the transaction's gas, causing it to revert. Use `addr.call{gas: <amount>}("")` or [this](https://github.com/nomad-xyz/ExcessivelySafeCall) library instead.

*Instances (5)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

685:             (bool success,) = payable(msg.sender).call{ value: amount }("");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

71:             bytes4 method = bytes4(calls[i].callData[:4]);

74:                 (address token) = abi.decode(calls[i].callData[4:], (address));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

176:         (bool success, bytes memory err) = lifi.call{ value: msg.value }(data);

195:             (bool success,) = payable(userAddress).call{ value: amount }("");

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="L-14"></a>[L-14] Signature use at deadlines should be allowed

According to [EIP-2612](https://github.com/ethereum/EIPs/blob/71dc97318013bf2ac572ab63fab530ac9ef419ca/EIPS/eip-2612.md?plain=1#L58), signatures used on exactly the deadline timestamp are supposed to be allowed. While the signature may or may not be used for the exact EIP-2612 use case (transfer approvals), for consistency's sake, all deadlines should follow this semantic. If the timestamp is an expiration rather than a deadline, consider whether it makes more sense to include the expiration timestamp as a valid timestamp, as is done for deadlines.

*Instances (3)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

269:                 && depositQueue.queue[firstTemp].calculationTime + depositWaitingTime <= block.timestamp && i < maxI

408:                 && withdrawQueue.queue[firstTemp].calculationTime + withdrawWaitingTime <= block.timestamp

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

71:         if (approvedBridgeTXN[txn] == 0 || approvedBridgeTXN[txn] + BRIDGE_TXN_WAITING_TIME > block.timestamp) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

### <a name="L-15"></a>[L-15] Prevent accidentally burning tokens

Minting and burning tokens to address(0) prevention

*Instances (5)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

278:             _mint(data.receiver, data.shares);

419:             _burn(data.owner, shares);

519:         _mint(managementFeeReceiver, managementFeeAmount);

534:         _mint(performanceFeeReceiver, preformanceFeeSharesWaitingForDistribution);

544:         _burn(msg.sender, amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

### <a name="L-16"></a>[L-16] Possible rounding issue

Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator. Also, there is indication of multiplication and division without the use of parenthesis which could result in issues.

*Instances (6)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

416:                 data.amount * currentWithdrawGroup.totalABAmount / currentWithdrawGroup.totalCBAmountFullfilled;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

131:         uint256 amount0 = balance * reserve0 / totalSupply;

132:         uint256 amount1 = balance * reserve1 / totalSupply;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

172:         return (((1e18 * token1bal * lpBalance) / _weight) / _totalSupply);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

96:         return balanceThis * (_getValue(tokenA, base, reserves0) + _getValue(tokenB, base, reserves1)) / totalSupply;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

78:         return getCollBlanace(comet, true) * 1e18 / borrowBalanceInBase;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

### <a name="L-17"></a>[L-17] Loss of precision

Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator

*Instances (11)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

416:                 data.amount * currentWithdrawGroup.totalABAmount / currentWithdrawGroup.totalCBAmountFullfilled;

423:                 uint256 feeAmount = baseTokenAmount * withdrawFee / FEE_PRECISION;

484:             previewDeposit(((storedProfitForFee - totalProfitCalculated) * performanceFee) / FEE_PRECISION);

518:             (timePassed * managementFee * (totalShares - currentFeeShares)) / FEE_PRECISION / 365 days;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

131:         uint256 amount0 = balance * reserve0 / totalSupply;

132:         uint256 amount1 = balance * reserve1 / totalSupply;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

172:         return (((1e18 * token1bal * lpBalance) / _weight) / _totalSupply);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

96:         return balanceThis * (_getValue(tokenA, base, reserves0) + _getValue(tokenB, base, reserves1)) / totalSupply;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

129:             (((_borrowerAmount * _exchangeRate) * LTV_PRECISION) / EXCHANGE_PRECISION) / _collateralAmount;

136:         uint256 currentHF = (fraxlendPairMaxLTV * 1e18) / currentPositionLTV;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

138:         return amount * IOracle(marketOracle).price() / ORACLE_PRICE_SCALE;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

### <a name="L-18"></a>[L-18] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`

The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (40)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/accountingManager/Registry.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/connectors/AaveConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AaveConnector.sol)

```solidity
File: contracts/connectors/AerodromeConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/AerodromeConnector.sol)

```solidity
File: contracts/connectors/BalancerConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerConnector.sol)

```solidity
File: contracts/connectors/BalancerFlashLoan.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/BalancerFlashLoan.sol)

```solidity
File: contracts/connectors/CamelotConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CamelotConnector.sol)

```solidity
File: contracts/connectors/CompoundConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CompoundConnector.sol)

```solidity
File: contracts/connectors/CurveConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/Dolomite.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/Dolomite.sol)

```solidity
File: contracts/connectors/FraxConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/FraxConnector.sol)

```solidity
File: contracts/connectors/GearBoxV3.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/GearBoxV3.sol)

```solidity
File: contracts/connectors/LidoConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

```solidity
File: contracts/connectors/MorphoBlueConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MorphoBlueConnector.sol)

```solidity
File: contracts/connectors/PancakeswapConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PancakeswapConnector.sol)

```solidity
File: contracts/connectors/PendleConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PendleConnector.sol)

```solidity
File: contracts/connectors/PrismaConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/PrismaConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/SiloConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SiloConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/connectors/UNIv3Connector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

```solidity
File: contracts/governance/Keepers.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/governance/NoyaGovernanceBase.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/NoyaGovernanceBase.sol)

```solidity
File: contracts/governance/TimeLock.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/TimeLock.sol)

```solidity
File: contracts/governance/Watchers.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Watchers.sol)

```solidity
File: contracts/helpers/BaseConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/BaseConnector.sol)

```solidity
File: contracts/helpers/ConnectorMock2.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/ConnectorMock2.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol)

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol)

```solidity
File: contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

```solidity
File: contracts/helpers/TVLHelper.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/WETH_Oracle.sol

2: pragma solidity 0.8.20;

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/WETH_Oracle.sol)

### <a name="L-19"></a>[L-19] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`

Use [Ownable2Step.transferOwnership](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol) which is safer. Use it as it is more secure due to 2-stage ownership transfer.

**Recommended Mitigation Steps**

Use <a href="https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol">Ownable2Step.sol</a>
  
  ```solidity
      function acceptOwnership() external {
          address sender = _msgSender();
          require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
          _transferOwnership(sender);
      }
```

*Instances (6)*:

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

5: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

4: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

4: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/valueOracle/NoyaValueOracle.sol

4: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/NoyaValueOracle.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol

7: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

6: import "@openzeppelin/contracts-5.0/access/Ownable.sol";

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="L-20"></a>[L-20] Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting

Downcasting from `uint256`/`int256` in Solidity does not revert on overflow. This can result in undesired exploitation or bugs, since developers usually assume that overflows raise errors. [OpenZeppelin's SafeCast library](https://docs.openzeppelin.com/contracts/3.x/api/utils#SafeCast) restores this intuition by reverting the transaction when such an operation overflows. Using this library eliminates an entire class of bugs, so it's recommended to use it always. Some exceptions are acceptable like with the classic `uint256(uint160(address(variable)))`

*Instances (7)*:

```solidity
File: contracts/connectors/CurveConnector.sol

169:         ICurveSwap(poolInfo.pool).remove_liquidity_one_coin(amount, int128(uint128(withdrawIndex)), minAmount);

169:         ICurveSwap(poolInfo.pool).remove_liquidity_one_coin(amount, int128(uint128(withdrawIndex)), minAmount);

302:         int128 tokenIndex = int128(uint128(index));

302:         int128 tokenIndex = int128(uint128(index));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/CurveConnector.sol)

```solidity
File: contracts/connectors/SNXConnector.sol

90:             _accountId, uint128(poolIds[poolIndex]), collateralType, newCollateralAmountD18, leverage

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/SNXConnector.sol)

```solidity
File: contracts/connectors/StargateConnector.sol

84:                 uint16(withdrawRequest.poolId), withdrawRequest.routerAmount, address(this)

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/StargateConnector.sol)

```solidity
File: contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol

61:         uint128 amountIn128 = uint128(amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol)

### <a name="L-21"></a>[L-21] Unsafe ERC20 operation(s)

*Instances (2)*:

```solidity
File: contracts/connectors/LidoConnector.sol

71:         ILidoWithdrawal(lidoWithdrawal).approve(lidoWithdrawal, requestId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/LidoConnector.sol)

```solidity
File: contracts/connectors/MaverickConnector.sol

121:         position.approve(maverickRouter, p.tokenId);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/MaverickConnector.sol)

## Medium Issues

| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Contracts are vulnerable to fee-on-transfer accounting-related issues | 1 |
| [M-2](#M-2) | Centralization Risk for trusted owners | 23 |
| [M-3](#M-3) | Fees can be set to be greater than 100%. | 2 |
| [M-4](#M-4) | Lack of EIP-712 compliance: using `keccak256()` directly on an array or struct variable | 1 |
| [M-5](#M-5) | Library function isn't `internal` or `private` | 2 |

### <a name="M-1"></a>[M-1] Contracts are vulnerable to fee-on-transfer accounting-related issues

Consistently check account balance before and after transfers for Fee-On-Transfer discrepancies. As arbitrary ERC20 tokens can be used, the amount here should be calculated every time to take into consideration a possible fee-on-transfer or deflation.
Also, it's a good practice for the future of the solution.

Use the balance before and after the transfer to calculate the received amount instead of assuming that it would be equal to the amount passed as a parameter. Or explicitly document that such tokens shouldn't be used and won't be supported

*Instances (1)*:

```solidity
File: contracts/accountingManager/AccountingManager.sol

205:         baseToken.safeTransferFrom(msg.sender, address(this), amount);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/AccountingManager.sol)

### <a name="M-2"></a>[M-2] Centralization Risk for trusted owners

#### Impact

Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (23)*:

```solidity
File: contracts/accountingManager/NoyaFeeReceiver.sol

7: contract NoyaFeeReceiver is Ownable {

14:     constructor(address _accountingManager, address _baseToken, address _receiver) Ownable(msg.sender) {

23:     function withdrawShares(uint256 amount) external onlyOwner {

27:     function burnShares(uint256 amount) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/NoyaFeeReceiver.sol)

```solidity
File: contracts/accountingManager/Registry.sol

12: contract PositionRegistry is AccessControl, IPositionRegistry, ReentrancyGuard {

79:     function setMaxNumHoldingPositions(uint256 _maxNumHoldingPositions) external onlyRole(MAINTAINER_ROLE) {

84:     function setFlashLoanAddress(address _flashLoan) external onlyRole(MAINTAINER_ROLE) {

117:     ) external onlyRole(MAINTAINER_ROLE) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/accountingManager/Registry.sol)

```solidity
File: contracts/governance/Keepers.sol

9: contract Keepers is EIP712, Ownable2Step {

27:     constructor(address[] memory _owners, uint8 _threshold) EIP712("Keepers", "1") Ownable2Step() Ownable(msg.sender) {

42:     function updateOwners(address[] memory _owners, bool[] memory addOrRemove) public onlyOwner {

63:     function setThreshold(uint8 _threshold) public onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/governance/Keepers.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperReceiver.sol

40:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {

52:     function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperReceiver.sol)

```solidity
File: contracts/helpers/LZHelpers/LZHelperSender.sol

36:     function updateMessageSetting(bytes memory _messageSetting) public onlyOwner {

51:     function setChainInfo(uint256 chainId, uint32 lzChainId, address lzHelperAddress) public onlyOwner {

63:     function addVaultInfo(uint256 vaultId, uint256 baseChainId, address omniChainManager) public onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/LZHelpers/LZHelperSender.sol)

```solidity
File: contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol

10: contract LifiImplementation is ISwapAndBridgeImplementation, Ownable2Step, ReentrancyGuard {

27:     constructor(address swapHandler, address _lifi) Ownable2Step() Ownable(msg.sender) {

45:     function addHandler(address _handler, bool state) external onlyOwner {

55:     function addChain(uint256 _chainId, bool state) external onlyOwner {

65:     function addBridgeBlacklist(string memory bridgeName, bool state) external onlyOwner {

193:     function rescueFunds(address token, address userAddress, uint256 amount) external onlyOwner {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol)

### <a name="M-3"></a>[M-3] Fees can be set to be greater than 100%

There should be an upper limit to reasonable fees.
A malicious owner can keep the fee rate at zero, but if a large value transfer enters the mempool, the owner can jack the rate up to the maximum and sandwich attack a user.

*Instances (2)*:

```solidity
File: contracts/connectors/UNIv3Connector.sol

101:     function collectAllFees(uint256[] memory tokenIds) public onlyManager nonReentrant {
             for (uint256 i = 0; i < tokenIds.length; i++) {

122:     function _collectFees(uint256 tokenId) internal returns (uint256 amount0, uint256 amount1) {
             CollectParams memory params = CollectParams(tokenId, address(this), type(uint128).max, type(uint128).max);
             (amount0, amount1) = positionManager.collect(params);

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/connectors/UNIv3Connector.sol)

### <a name="M-4"></a>[M-4] Lack of EIP-712 compliance: using `keccak256()` directly on an array or struct variable

Directly using the actual variable instead of encoding the array values goes against the EIP-712 specification <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md#definition-of-encodedata>.
**Note**: OpenSea's [Seaport's example with offerHashes and considerationHashes](https://github.com/ProjectOpenSea/seaport/blob/a62c2f8f484784735025d7b03ccb37865bc39e5a/reference/lib/ReferenceGettersAndDerivers.sol#L130-L131) can be used as a reference to understand how array of structs should be encoded.

*Instances (1)*:

```solidity
File: contracts/helpers/OmniChainHandler/OmnichainLogic.sol

69:         bytes32 txn = keccak256(abi.encode(bridgeRequest));

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/OmniChainHandler/OmnichainLogic.sol)

### <a name="M-5"></a>[M-5] Library function isn't `internal` or `private`

In a library, using an external or public visibility means that we won't be going through the library with a DELEGATECALL but with a CALL. This changes the context and should be done carefully.

*Instances (2)*:

```solidity
File: contracts/helpers/TVLHelper.sol

14:     function getTVL(uint256 vaultId, PositionRegistry registry, address baseToken) public view returns (uint256) {

41:     function getLatestUpdateTime(uint256 vaultId, PositionRegistry registry) public view returns (uint256) {

```

[Link to code](https://github.com/code-423n4/2024-04-noya/blob/main/contracts/helpers/TVLHelper.sol)
