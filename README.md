# ✨ So you want to run an audit

This `README.md` contains a set of checklists for our audit collaboration.

Your audit will use two repos: 
- **an _audit_ repo** (this one), which is used for scoping your audit and for providing information to wardens
- **a _findings_ repo**, where issues are submitted (shared with you after the audit) 

Ultimately, when we launch the audit, this repo will be made public and will contain the smart contracts to be reviewed and all the information needed for audit participants. The findings repo will be made public after the audit report is published and your team has mitigated the identified issues.

Some of the checklists in this doc are for **C4 (🐺)** and some of them are for **you as the audit sponsor (⭐️)**.

---

# Audit setup

## 🐺 C4: Set up repos
- [ ] Create a new private repo named `YYYY-MM-sponsorname` using this repo as a template.
- [ ] Rename this repo to reflect audit date (if applicable)
- [ ] Rename audit H1 below
- [ ] Update pot sizes
  - [ ] Remove the "Bot race findings opt out" section if there's no bot race.
- [ ] Fill in start and end times in audit bullets below
- [ ] Add link to submission form in audit details below
- [ ] Add the information from the scoping form to the "Scoping Details" section at the bottom of this readme.
- [ ] Add matching info to the Code4rena site
- [ ] Add sponsor to this private repo with 'maintain' level access.
- [ ] Send the sponsor contact the url for this repo to follow the instructions below and add contracts here. 
- [ ] Delete this checklist.

# Repo setup

## ⭐️ Sponsor: Add code to this repo

- [ ] Create a PR to this repo with the below changes:
- [ ] Confirm that this repo is a self-contained repository with working commands that will build (at least) all in-scope contracts, and commands that will run tests producing gas reports for the relevant contracts.
- [ ] Please have final versions of contracts and documentation added/updated in this repo **no less than 48 business hours prior to audit start time.**
- [ ] Be prepared for a 🚨code freeze🚨 for the duration of the audit — important because it establishes a level playing field. We want to ensure everyone's looking at the same code, no matter when they look during the audit. (Note: this includes your own repo, since a PR can leak alpha to our wardens!)

## ⭐️ Sponsor: Repo checklist

- [ ] Modify the [Overview](#overview) section of this `README.md` file. Describe how your code is supposed to work with links to any relevent documentation and any other criteria/details that the auditors should keep in mind when reviewing. (Here are two well-constructed examples: [Ajna Protocol](https://github.com/code-423n4/2023-05-ajna) and [Maia DAO Ecosystem](https://github.com/code-423n4/2023-05-maia))
- [ ] Review the Gas award pool amount, if applicable. This can be adjusted up or down, based on your preference - just flag it for Code4rena staff so we can update the pool totals across all comms channels.
- [ ] Optional: pre-record a high-level overview of your protocol (not just specific smart contract functions). This saves wardens a lot of time wading through documentation.
- [ ] [This checklist in Notion](https://code4rena.notion.site/Key-info-for-Code4rena-sponsors-f60764c4c4574bbf8e7a6dbd72cc49b4#0cafa01e6201462e9f78677a39e09746) provides some best practices for Code4rena audit repos.

## ⭐️ Sponsor: Final touches
- [ ] Review and confirm the pull request created by the Scout (technical reviewer) who was assigned to your contest. *Note: any files not listed as "in scope" will be considered out of scope for the purposes of judging, even if the file will be part of the deployed contracts.*
- [ ] Check that images and other files used in this README have been uploaded to the repo as a file and then linked in the README using absolute path (e.g. `https://github.com/code-423n4/yourrepo-url/filepath.png`)
- [ ] Ensure that *all* links and image/file paths in this README use absolute paths, not relative paths
- [ ] Check that all README information is in markdown format (HTML does not render on Code4rena.com)
- [ ] Delete this checklist and all text above the line below when you're ready.

---

# NOYA audit details
- Total Prize Pool: $65000 in USDC
  - HM awards: $49920 in USDC
  - (remove this line if there is no Analysis pool) Analysis awards: XXX XXX USDC (Notion: Analysis pool)
  - QA awards: $2080 in USDC
  - (remove this line if there is no Bot race) Bot Race awards: XXX XXX USDC (Notion: Bot Race pool)
 
  - Judge awards: $7500 in USDC
  - Lookout awards: XXX XXX USDC (Notion: Sum of Pre-sort fee + Pre-sort early bonus)
  - Scout awards: $500 in USDC
  - (this line can be removed if there is no mitigation) Mitigation Review: XXX XXX USDC (*Opportunity goes to top 3 backstage wardens based on placement in this audit who RSVP.*)
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2024-04-noya/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts April 26, 2024 20:00 UTC
- Ends May 17, 2024 20:00 UTC

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-04-noya/blob/main/4naly3er-report.md).



_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._
## 🐺 C4: Begin Gist paste here (and delete this line)





# Scope

*See [scope.txt](https://github.com/code-423n4/2024-04-noya/blob/main/scope.txt)*

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

*See [out_of_scope.txt](https://github.com/code-423n4/2024-04-noya/blob/main/out_of_scope.txt)*

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

