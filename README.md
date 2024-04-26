# NOYA audit details

- Total Prize Pool: $65,000 in USDC
  - HM awards: $49,920 in USDC
  - QA awards: $2080 in USDC
  - Judge awards: $7,500 in USDC
  - Lookout awards: $5,000 in USDC
  - Scout awards: $500 in USDC
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2024-04-noya/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts April 26, 2024 20:00 UTC
- Ends May 17, 2024 20:00 UTC

⭐️ Note: NOYA platform will allocate 5% of all stars from the campaign to wardens who find valid vulnerabilities. This allocation will be proportional to their USDC rewards earned in the Code4rena competition, incentivizing thorough and diligent reviews of NOYA’s codebase.

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-04-noya/blob/main/4naly3er-report.md).

_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

# Overview

## Noya smart contracts [![tests](https://github.com/Noya-ai/noya-vault-contracts/actions/workflows/tests.yml/badge.svg)](https://github.com/Noya-ai/noya-vault-contracts/actions/workflows/tests.yml)
**This repo contains noya smart contract**

Contracts

- **Accounting manager** : This contract is responsible for managing the deposits and withdrawals of the users, holding users shares as an ERC20 token and calculating its value based on a base token.
- **Connectors** : these set of contracts are responsible for the connection between the vault manager and the external protocols, it handles the deposits and withdrawals from the external protocols. They hold the assets and report the value of the assets to the vault manager.
- **Omnichain Handler** : these smart contracts are responsible for the connection between the vault manager and the external protocols on other chains. It handles the bridging to other chains and communication with those chains through Layer Zero infrastructure.
- **Noya Value Oracle** : this contract is responsible for calculating the value of the other tokens/positions that the connectors hold. The result is used by accounting manager to calculate the value of the shares.
- **Noya Bridge and Swap handler** : this contract is responsible for handling the bridging and swaps. We are using LiFi for this purpose but this contract is designed to be able to support other bridges and swaps in the future. Other contracts will be explained in the docs in detail.

## Links

- **Previous audits:**  https://docs.noya.ai/audits-and-risk/audits
- **Documentation:** <https://docs.noya.ai>
- **Website:** <https://noya.ai/>
- **X/Twitter:** <https://twitter.com/NetworkNoya>
- **Discord:** <https://discord.com/invite/BGS5qX6fPj>

---

# Scope

_See [scope.txt](https://github.com/code-423n4/2024-04-noya/blob/main/scope.txt)_

### Files in scope

| File   | Logic Contracts | Interfaces | SLOC  | Purpose | Libraries used |
| ------ | --------------- | ---------- | ----- | -----   | ------------ |
| /contracts/accountingManager/AccountingManager.sol | 1| **** | 486 | |@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol<br>@openzeppelin/contracts-5.0/token/ERC20/extensions/ERC4626.sol|
| /contracts/accountingManager/NoyaFeeReceiver.sol | 1| **** | 23 | |@openzeppelin/contracts-5.0/access/Ownable.sol|
| /contracts/accountingManager/Registry.sol | 1| **** | 327 | |@openzeppelin/contracts-5.0/access/AccessControl.sol<br>@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol|
| /contracts/connectors/AaveConnector.sol | 1| **** | 75 | ||
| /contracts/connectors/AerodromeConnector.sol | 1| **** | 107 | ||
| /contracts/connectors/BalancerConnector.sol | 1| **** | 161 | ||
| /contracts/connectors/BalancerFlashLoan.sol | 1| **** | 68 | |@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol<br>@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol|
| /contracts/connectors/CamelotConnector.sol | 1| **** | 88 | |@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol|
| /contracts/connectors/CompoundConnector.sol | 1| **** | 86 | ||
| /contracts/connectors/CurveConnector.sol | 1| **** | 215 | ||
| /contracts/connectors/Dolomite.sol | 1| **** | 102 | ||
| /contracts/connectors/FraxConnector.sol | 1| **** | 109 | ||
| /contracts/connectors/GearBoxV3.sol | 1| **** | 71 | ||
| /contracts/connectors/LidoConnector.sol | 1| **** | 62 | ||
| /contracts/connectors/MaverickConnector.sol | 1| **** | 121 | |@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol|
| /contracts/connectors/MorphoBlueConnector.sol | 1| **** | 103 | ||
| /contracts/connectors/PancakeswapConnector.sol | 1| **** | 31 | |@openzeppelin/contracts-5.0/token/ERC721/IERC721.sol|
| /contracts/connectors/PendleConnector.sol | 1| **** | 178 | |@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol|
| /contracts/connectors/PrismaConnector.sol | 1| **** | 107 | |@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol|
| /contracts/connectors/SNXConnector.sol | 1| **** | 100 | ||
| /contracts/connectors/SiloConnector.sol | 1| **** | 107 | ||
| /contracts/connectors/StargateConnector.sol | 1| **** | 94 | ||
| /contracts/connectors/UNIv3Connector.sol | 1| **** | 105 | ||
| /contracts/governance/Keepers.sol | 1| **** | 81 | |@openzeppelin/contracts-5.0/utils/cryptography/EIP712.sol<br>@openzeppelin/contracts-5.0/access/Ownable2Step.sol<br>@openzeppelin/contracts-5.0/utils/cryptography/ECDSA.sol|
| /contracts/governance/NoyaGovernanceBase.sol | 1| **** | 46 | ||
| /contracts/governance/TimeLock.sol | 1| **** | 7 | |@openzeppelin/contracts-5.0/governance/TimelockController.sol|
| /contracts/governance/Watchers.sol | 1| **** | 6 | ||
| /contracts/helpers/BaseConnector.sol | 1| **** | 175 | |@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol<br>@openzeppelin/contracts-5.0/token/ERC721/utils/ERC721Holder.sol<br>@openzeppelin/contracts-5.0/token/ERC721/IERC721Receiver.sol<br>@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol|
| /contracts/helpers/ConnectorMock2.sol | 1| **** | 71 | |@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol<br>contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol<br>contracts/interface/ITokenTransferCallBack.sol<br>contracts/interface/IConnector.sol<br>contracts/accountingManager/Registry.sol|
| /contracts/helpers/LZHelpers/LZHelperReceiver.sol | 1| **** | 35 | |@openzeppelin/contracts-5.0/access/Ownable.sol<br>@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol|
| /contracts/helpers/LZHelpers/LZHelperSender.sol | 1| **** | 40 | |@openzeppelin/contracts-5.0/access/Ownable.sol<br>@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/OApp.sol|
| /contracts/helpers/OmniChainHandler/OmnichainLogic.sol | 1| **** | 46 | ||
| /contracts/helpers/OmniChainHandler/OmnichainManagerBaseChain.sol | 1| **** | 31 | |@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol|
| /contracts/helpers/OmniChainHandler/OmnichainManagerNormalChain.sol | 1| **** | 27 | |@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol|
| /contracts/helpers/SwapHandler/GenericSwapAndBridgeHandler.sol | 1| **** | 110 | |@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol<br>@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol|
| /contracts/helpers/SwapHandler/Implementaions/LifiImplementation.sol | 1| **** | 129 | |@openzeppelin/contracts-5.0/access/Ownable2Step.sol<br>@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol<br>@openzeppelin/contracts-5.0/utils/ReentrancyGuard.sol|
| /contracts/helpers/TVLHelper.sol | 1| **** | 39 | ||
| /contracts/helpers/valueOracle/NoyaValueOracle.sol | 1| **** | 80 | |@openzeppelin/contracts-5.0/access/Ownable.sol|
| /contracts/helpers/valueOracle/oracles/ChainlinkOracleConnector.sol | 1| **** | 89 | |@openzeppelin/contracts-5.0/access/Ownable.sol<br>@openzeppelin/contracts-5.0/token/ERC20/extensions/IERC20Metadata.sol|
| /contracts/helpers/valueOracle/oracles/UniswapValueOracle.sol | 1| **** | 51 | |@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol<br>@openzeppelin/contracts-5.0/access/Ownable.sol|
| /contracts/helpers/valueOracle/oracles/WETH_Oracle.sol | 1| **** | 10 | ||
| **Totals** | **41** | **** | **3999** | | |

### Files out of scope

_See [out_of_scope.txt](https://github.com/code-423n4/2024-04-noya/blob/main/out_of_scope.txt)_

| File         |
| ------------ |
| ./contracts/external/interfaces/Aave/IPool.sol |
| ./contracts/external/interfaces/Aerodrome/IGauge.sol |
| ./contracts/external/interfaces/Aerodrome/IPool.sol |
| ./contracts/external/interfaces/Aerodrome/IRouter.sol |
| ./contracts/external/interfaces/Aerodrome/IVoter.sol |
| ./contracts/external/interfaces/Balancer/IBalancerPool.sol |
| ./contracts/external/interfaces/Balancer/IBalancerVault.sol |
| ./contracts/external/interfaces/Balancer/IFlashLoanRecipient.sol |
| ./contracts/external/interfaces/Camelot/ICamelotFactory.sol |
| ./contracts/external/interfaces/Camelot/ICamelotPair.sol |
| ./contracts/external/interfaces/Camelot/ICamelotRouter.sol |
| ./contracts/external/interfaces/Compound/ICompound.sol |
| ./contracts/external/interfaces/Convex/IBooster.sol |
| ./contracts/external/interfaces/Convex/IConvexBasicRewards.sol |
| ./contracts/external/interfaces/Curve/ICurveSwap.sol |
| ./contracts/external/interfaces/Curve/IRewardsGauge.sol |
| ./contracts/external/interfaces/Dolomite/AccountBalanceHelper.sol |
| ./contracts/external/interfaces/Dolomite/IBorrowPositionProxyV1.sol |
| ./contracts/external/interfaces/Dolomite/IDepositWithdrawalProxy.sol |
| ./contracts/external/interfaces/Dolomite/IDolomiteAMMPair.sol |
| ./contracts/external/interfaces/Dolomite/IDolomiteAmmFactory.sol |
| ./contracts/external/interfaces/Dolomite/IDolomiteMargin.sol |
| ./contracts/external/interfaces/Frax/IFraxPair.sol |
| ./contracts/external/interfaces/Gearbox/ICreditConfiguratorV3.sol |
| ./contracts/external/interfaces/Gearbox/ICreditFacadeV3.sol |
| ./contracts/external/interfaces/Gearbox/ICreditFacadeV3Multicall.sol |
| ./contracts/external/interfaces/Gearbox/ICreditManagerV3.sol |
| ./contracts/external/interfaces/Lido/ILido.sol |
| ./contracts/external/interfaces/Lido/ILidoWithdrawal.sol |
| ./contracts/external/interfaces/Lido/IWETH.sol |
| ./contracts/external/interfaces/Maverick/IMaverickPool.sol |
| ./contracts/external/interfaces/Maverick/IMaverickPosition.sol |
| ./contracts/external/interfaces/Maverick/IMaverickReward.sol |
| ./contracts/external/interfaces/Maverick/IMaverickRouter.sol |
| ./contracts/external/interfaces/Maverick/IPositionInspector.sol |
| ./contracts/external/interfaces/Maverick/IveMAV.sol |
| ./contracts/external/interfaces/Morpho/IIrm.sol |
| ./contracts/external/interfaces/Morpho/IMorpho.sol |
| ./contracts/external/interfaces/Morpho/IOracle.sol |
| ./contracts/external/interfaces/MorphoBlue/IIrm.sol |
| ./contracts/external/interfaces/MorphoBlue/IMorpho.sol |
| ./contracts/external/interfaces/MorphoBlue/IOracle.sol |
| ./contracts/external/interfaces/Pancakeswap/IMasterChefV3.sol |
| ./contracts/external/interfaces/Pendle/IPActionSwapPTV3.sol |
| ./contracts/external/interfaces/Pendle/IPActionSwapYTV3.sol |
| ./contracts/external/interfaces/Pendle/IPAllActionTypeV3.sol |
| ./contracts/external/interfaces/Pendle/IPLimitRouter.sol |
| ./contracts/external/interfaces/Pendle/IPMarket.sol |
| ./contracts/external/interfaces/Pendle/IPPrincipalToken.sol |
| ./contracts/external/interfaces/Pendle/IPPtOracle.sol |
| ./contracts/external/interfaces/Pendle/IPStandardizedYield.sol |
| ./contracts/external/interfaces/Pendle/IPYieldToken.sol |
| ./contracts/external/interfaces/Pendle/IPendleMarketDepositHelper.sol |
| ./contracts/external/interfaces/Pendle/IPendleRouter.sol |
| ./contracts/external/interfaces/Pendle/IPendleStaticRouter.sol |
| ./contracts/external/interfaces/Prisma/IBorrowerOperations.sol |
| ./contracts/external/interfaces/Prisma/IDepositToken.sol |
| ./contracts/external/interfaces/Prisma/IStakeNTroveZap.sol |
| ./contracts/external/interfaces/Prisma/TroveManager/ITroveManager.sol |
| ./contracts/external/interfaces/SNXV3/IV3CoreProxy.sol |
| ./contracts/external/interfaces/Silo/IBaseSilo.sol |
| ./contracts/external/interfaces/Silo/IInterestRateModel.sol |
| ./contracts/external/interfaces/Silo/INotificationReceiver.sol |
| ./contracts/external/interfaces/Silo/IPriceProvider.sol |
| ./contracts/external/interfaces/Silo/IPriceProvidersRepository.sol |
| ./contracts/external/interfaces/Silo/IShareToken.sol |
| ./contracts/external/interfaces/Silo/ISilo.sol |
| ./contracts/external/interfaces/Silo/ISiloRepository.sol |
| ./contracts/external/interfaces/Stargate/IStargateLPStaking.sol |
| ./contracts/external/interfaces/Stargate/IStargateRouter.sol |
| ./contracts/external/interfaces/UNIv3/INonfungiblePositionManager.sol |
| ./contracts/external/interfaces/UNIv3/IUniswapV3Factory.sol |
| ./contracts/external/interfaces/UNIv3/IUniswapV3Pool.sol |
| ./contracts/external/libraries/GearBox/BalancesLogic.sol |
| ./contracts/external/libraries/GearBox/BitMask.sol |
| ./contracts/external/libraries/Morpho/ErrorsLib.sol |
| ./contracts/external/libraries/Morpho/MarketParamsLib.sol |
| ./contracts/external/libraries/Morpho/MathLib.sol |
| ./contracts/external/libraries/Morpho/SharesMathLib.sol |
| ./contracts/external/libraries/Morpho/UtilsLib.sol |
| ./contracts/external/libraries/Morpho/periphery/MorphoLib.sol |
| ./contracts/external/libraries/Morpho/periphery/MorphoStorageLib.sol |
| ./contracts/external/libraries/Pendle/Errors.sol |
| ./contracts/external/libraries/Pendle/IPMarket.sol |
| ./contracts/external/libraries/Pendle/IPPrincipalToken.sol |
| ./contracts/external/libraries/Pendle/IPPtOracle.sol |
| ./contracts/external/libraries/Pendle/IPStandardizedYield.sol |
| ./contracts/external/libraries/Pendle/IPYieldToken.sol |
| ./contracts/external/libraries/Pendle/IPendleMarketDepositHelper.sol |
| ./contracts/external/libraries/Pendle/LogExpMath.sol |
| ./contracts/external/libraries/Pendle/MarketApproxPtInLib.sol |
| ./contracts/external/libraries/Pendle/MarketMathCore.sol |
| ./contracts/external/libraries/Pendle/Math.sol |
| ./contracts/external/libraries/Pendle/MiniHelpers.sol |
| ./contracts/external/libraries/Pendle/PYIndex.sol |
| ./contracts/external/libraries/Pendle/PendleLpOracleLib.sol |
| ./contracts/external/libraries/Pendle/PendlePtOracleLib.sol |
| ./contracts/external/libraries/Pendle/SYUtils.sol |
| ./contracts/external/libraries/Silo/EasyMathV2.sol |
| ./contracts/external/libraries/Silo/SolvencyV2.sol |
| ./contracts/external/libraries/dolomite/Decimal.sol |
| ./contracts/external/libraries/dolomite/Types.sol |
| ./contracts/external/libraries/uniswap/FixedPoint96.sol |
| ./contracts/external/libraries/uniswap/FullMath.sol |
| ./contracts/external/libraries/uniswap/LiquidityAmounts.sol |
| ./contracts/external/libraries/uniswap/OracleLibrary.sol |
| ./contracts/external/libraries/uniswap/PoolAddress.sol |
| ./contracts/external/libraries/uniswap/TickMath.sol |
| ./contracts/interface/Accounting/IAccountingManager.sol |
| ./contracts/interface/IConnector.sol |
| ./contracts/interface/IPositionRegistry.sol |
| ./contracts/interface/ITokenTransferCallBack.sol |
| ./contracts/interface/SwapHandler/ILiFi.sol |
| ./contracts/interface/SwapHandler/ISwapAndBridgeHandler.sol |
| ./contracts/interface/SwapHandler/ISwapAndBridgeImplementation.sol |
| ./contracts/interface/valueOracle/AggregatorV3Interface.sol |
| ./contracts/interface/valueOracle/INoyaValueOracle.sol |
| ./testFoundry/AaveConnector.t.sol |
| ./testFoundry/Aerodrome.t.sol |
| ./testFoundry/BalancerConnector.t.sol |
| ./testFoundry/BaseConnector.t.sol |
| ./testFoundry/CompoundConnector.t.sol |
| ./testFoundry/CurveConnector.t.sol |
| ./testFoundry/Dolomite.t.sol |
| ./testFoundry/FraxConnector.t.sol |
| ./testFoundry/GearBoxV3.t.sol |
| ./testFoundry/LidoConnector.t.sol |
| ./testFoundry/MaverickConnector.t.sol |
| ./testFoundry/MorphoBlue.t.sol |
| ./testFoundry/PancakeswapConnector.t.sol |
| ./testFoundry/PendleConnector.t.sol |
| ./testFoundry/PrismaConnector.t.sol |
| ./testFoundry/SNXConnector.t.sol |
| ./testFoundry/SiloConnector.t.sol |
| ./testFoundry/SiloFlashLoan.t.sol |
| ./testFoundry/StargateConnector.t.sol |
| ./testFoundry/TestAccounting.sol |
| ./testFoundry/TestFlashLoan.sol |
| ./testFoundry/UNIv3Connector.t.sol |
| ./testFoundry/testAccountingBranches.sol |
| ./testFoundry/testLifi.sol |
| ./testFoundry/testOmnichain.t.sol |
| ./testFoundry/testOracle.sol |
| ./testFoundry/testRegistry.sol |
| ./testFoundry/testSwapETH.sol |
| ./testFoundry/testSwapHandler.sol |
| ./testFoundry/utils/mocks/ConnectorMock.sol |
| ./testFoundry/utils/mocks/ConnectorMock2.sol |
| ./testFoundry/utils/mocks/EmergancyMock.sol |
| ./testFoundry/utils/mocks/IDiamondCut.sol |
| ./testFoundry/utils/mocks/IrmMock.sol |
| ./testFoundry/utils/mocks/LZEndpointMock.sol |
| ./testFoundry/utils/mocks/MockDataFeed.sol |
| ./testFoundry/utils/mocks/MockDataFeedForMorphoBlue.sol |
| ./testFoundry/utils/mocks/bridgeImplementationMock.sol |
| ./testFoundry/utils/mocks/lifiDiamondMock.sol |
| ./testFoundry/utils/resources/ArbitrumAddresses.sol |
| ./testFoundry/utils/resources/BaseAddresses.sol |
| ./testFoundry/utils/resources/BinanceSmartChainAddresses.sol |
| ./testFoundry/utils/resources/MainnetAddresses.sol |
| ./testFoundry/utils/resources/OptimismAddresses.sol |
| ./testFoundry/utils/resources/PolygonAddresses.sol |
| ./testFoundry/utils/testStarter.sol |
| Totals: 163 |

## Scoping Q &amp; A

### General questions

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       Any             |
| Test coverage                           | 90.2%                          |
| ERC721 used  by the protocol            |            Yes, uniswap non fungible positions              |
| ERC777 used by the protocol             |           No                |
| ERC1155 used by the protocol            |              No            |
| Chains the protocol will be deployed on | Ethereum,Arbitrum,Base,BSC,Optimism,Polygon,zkSync,Other,Avaxpolygon zkevm  |

### ERC20 token behaviors in scope

| Question                                                                                                                                                   | Answer |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| [Missing return values](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#missing-return-values)                                                      |   No  |
| [Fee on transfer](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#fee-on-transfer)                                                                  |  No  |
| [Balance changes outside of transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#balance-modifications-outside-of-transfers-rebasingairdrops) | Yes    |
| [Upgradeability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#upgradable-tokens)                                                                 |   No  |
| [Flash minting](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#flash-mintable-tokens)                                                              | No    |
| [Pausability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#pausable-tokens)                                                                      | Yes    |
| [Approval race protections](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#approval-race-protections)                                              | No    |
| [Revert on approval to zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-approval-to-zero-address)                            | No    |
| [Revert on zero value approvals](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-approvals)                                    | No    |
| [Revert on zero value transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                    | Yes    |
| [Revert on transfer to the zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-transfer-to-the-zero-address)                    | No    |
| [Revert on large approvals and/or transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-large-approvals--transfers)                  | No    |
| [Doesn't revert on failure](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#no-revert-on-failure)                                                   |  Yes   |
| [Multiple token addresses](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                          | Yes    |
| [Low decimals ( < 6)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#low-decimals)                                                                 |   No  |
| [High decimals ( > 18)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#high-decimals)                                                              | No    |
| [Blocklists](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#tokens-with-blocklists)                                                                | Yes    |

### External integrations (e.g., Uniswap) behavior in scope

| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | No   |
| Pausability (e.g. Uniswap pool gets paused)               |  No   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   No  |

### EIP compliance checklist

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| src/governance/Keepers.sol                           | EIP712          |
| src/accountingManager/AccountingManager.sol          | ERC4626         |

# Additional context

## Main invariants

<https://docs.google.com/document/d/1TRYK3Vpr6VsI9B3QLEiGQR-E-NAmTd3tHfwj8eWHf64/edit>

## Attack ideas (where to focus for bugs)

Integrity of the connectors interactions with the protocols (can we deposit and withdraw correctly)
Fee mechanisms of noya

## All trusted roles in the protocol

| Role                                | Description                       |
| --------------------------------------- | ---------------------------- |
|Governor|This is a timelock smart contract that is responsible for changing the addresses of others.|
|Maintainer|This smart contract is in charge of adding a new vault, adding trusted tokens for that vault, and adding trusted positions to the registry.|
|Keepers|This is the smart contract that manages execution of the strategies. It’s a multisig contract. Strategy managers can submit their transactions into IPFS in an encrypted way and the keepers will decrypt and execute it.|
|watchers|This smart contract is responsible to make sure the execution of noya is going on correctly. If there is any misbehaving (like price manipulation or any suspicious actions from the keepers) the watchers and undo the action.|
|emergency|This address is also a cold wallet that is going to be used in situations that a position is stuck or another role of noya is compromised.|

## Running tests

```bash
git clone --recurse https://github.com/code-423n4/2024-04-noya.git
cd 2024-04-noya
yarn install
forge build
forge test
# To compare gas usage
forge snapshot --diff .gas-snapshot-init
# To generate lcov file
sh coverage.sh
# See slither.txt
slither . --foundry-out-directory artifactsFoundry
```

- Coverage report:

![](https://github.com/code-423n4/2024-04-noya/assets/47150934/5d9938e0-aea6-4319-9159-5d9904717785)


## Miscellaneous

Employees of NOYA and employees' family members are ineligible to participate in this audit.
