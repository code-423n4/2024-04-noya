// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import "../external/libraries/Pendle/PendleLpOracleLib.sol";
import { MarketApproxPtInLib, MarketApproxPtOutLib } from "../external/libraries/Pendle/MarketApproxPtInLib.sol";
import { IPendleMarketDepositHelper } from "../external/interfaces/Pendle/IPendleMarketDepositHelper.sol";
import "../external/interfaces/Pendle/IPendleRouter.sol";
import { IPendleStaticRouter } from "../external/interfaces/Pendle/IPendleStaticRouter.sol";
import { SafeERC20 } from "@openzeppelin/contracts-5.0/token/ERC20/utils/SafeERC20.sol";

contract PendleConnector is BaseConnector {
    using SafeERC20 for IERC20;
    using PendleLpOracleLib for IPMarket;
    using PendlePtOracleLib for IPMarket;
    using MarketMathCore for MarketState;
    using MarketApproxPtInLib for MarketState;
    using MarketApproxPtOutLib for MarketState;
    using PYIndexLib for IPYieldToken;
    using PYIndexLib for PYIndex;

    IPendleMarketDepositHelper public pendleMarketDepositHelper;
    IPAllActionV3 public pendleRouter;
    IPendleStaticRouter public staticRouter;

    uint256 public constant PENDLE_POSITION_ID = 11;

    /**
     * @notice throws when the output of a swap operation is insufficient
     * @param netSyOut The actual amount of SY tokens received from the swap
     * @param minSY The minimum acceptable amount of SY tokens specified for the swap
     */
    error InsufficientSyOut(uint256 netSyOut, uint256 minSY);

    event Supply(address market, uint256 amount);
    event MintPTAndYT(address market, uint256 syAmount);
    event DepositIntoMarket(address market, uint256 SYamount, uint256 PTamount);
    event DepositIntoPenpie(address market, uint256 amount);
    event WithdrawFromPenpie(address market, uint256 amount);
    event SwapYTForPT(address market, uint256 exactYTIn, uint256 min, ApproxParams guess);
    event SwapYTForSY(address market, uint256 exactYTIn, uint256 min, LimitOrderData orderData);
    event SwapExactPTForSY(address market, uint256 exactPTIn, bytes swapData, uint256 minSY);
    event BurnLP(address market, uint256 amount);
    event DecreasePosition(address market, uint256 amount, bool closePosition);
    event ClaimRewards(address market);

    /**
     * Constructor *********************************
     */
    /**
     * @notice Initializes a new PendleConnector contract with references to other contracts for interaction
     * @param _pendleMarketDepositHelper Address of the Pendle Market Deposit Helper contract
     * @param _pendleRouter Address of the Pendle Router contract for swap operations
     * @param SR Address of the Pendle Static Router contract for static calls
     * @param baseCP Parameters required for the base connector initialization
     */
    constructor(address _pendleMarketDepositHelper, address _pendleRouter, address SR, BaseConnectorCP memory baseCP)
        BaseConnector(baseCP)
    {
        require(_pendleMarketDepositHelper != address(0));
        require(_pendleRouter != address(0));
        require(SR != address(0));
        pendleMarketDepositHelper = IPendleMarketDepositHelper(_pendleMarketDepositHelper);
        pendleRouter = IPAllActionV3(_pendleRouter);
        staticRouter = IPendleStaticRouter(SR);
    }

    /**
     * Connector Functions *********************************
     */
    /**
     * @notice Supplies an amount of asset into the specified market
     * @param market Address of the market where the asset is to be supplied
     * @param amount Amount of the asset to supply
     * @dev Only the manager can call this function
     * @dev is deposits the asset into SY and mint SY token
     */
    function supply(address market, uint256 amount) external onlyManager nonReentrant {
        (IPStandardizedYield _SY, IPPrincipalToken _PT,) = IPMarket(market).readTokens();

        (, address _underlyingToken,) = _SY.assetInfo();

        _approveOperations(_underlyingToken, address(_SY), amount);
        // Mint SY from underlying token
        uint256 syMinted = _SY.deposit(address(this), _underlyingToken, amount, 1);

        bytes32 positionId = registry.calculatePositionId(address(this), PENDLE_POSITION_ID, abi.encode(market));
        registry.updateHoldingPosition(vaultId, positionId, "", "", false);
        emit Supply(market, syMinted);
    }
    /**
     * @notice Mints Principal Tokens (PT) and Yield Tokens (YT) in the specified market using Standardized Yield (SY) tokens
     * @param market Address of the market for PT and YT minting
     * @param syAmount Amount of SY tokens to use for minting
     */

    function mintPTAndYT(address market, uint256 syAmount) external onlyManager nonReentrant {
        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(market).readTokens();
        IERC20(address(_SY)).safeTransfer(address(_YT), syAmount);
        _YT.mintPY(address(this), address(this));
        emit MintPTAndYT(market, syAmount);
    }
    /**
     * @notice Deposits Standardized Yield (SY) and Principal Tokens (PT) into the specified market
     * @param market Market where SY and PT are to be deposited
     * @param SYamount Amount of SY tokens to deposit
     * @param PTamount Amount of PT tokens to deposit
     * @dev minting LP token
     * @dev skim allows us to get the surplus tokens
     */

    function depositIntoMarket(IPMarket market, uint256 SYamount, uint256 PTamount) external onlyManager nonReentrant {
        (IPStandardizedYield _SY, IPPrincipalToken _PT,) = IPMarket(market).readTokens();
        IERC20(address(_SY)).safeTransfer(address(market), SYamount);
        IERC20(address(_PT)).safeTransfer(address(market), PTamount);
        market.mint(address(this), SYamount, PTamount);
        market.skim();
        emit DepositIntoMarket(address(market), SYamount, PTamount);
    }

    /**
     * @notice Deposits the LP into the Penpie pool
     * @param _market Address of the market
     * @param _amount Amount to deposit
     */
    function depositIntoPenpie(address _market, uint256 _amount) public onlyManager nonReentrant {
        _approveOperations(_market, pendleMarketDepositHelper.pendleStaking(), _amount);
        pendleMarketDepositHelper.depositMarket(_market, _amount);
        emit DepositIntoPenpie(_market, _amount);
    }

    /**
     * @notice Withdraws from the Penpie pool
     * @param _market Address of the market
     * @param _amount Amount to withdraw
     */
    function withdrawFromPenpie(address _market, uint256 _amount) public onlyManager nonReentrant {
        pendleMarketDepositHelper.withdrawMarketWithClaim(_market, _amount, true);
        emit WithdrawFromPenpie(_market, _amount);
    }
    /**
     * @notice Swaps Yield Tokens (YT) for Principal Tokens (PT) in a specified market
     * @param market Address of the market
     * @param exactYTIn Amount of YT to swap
     * @param min Minimum amount of PT to receive
     * @param guess Approximation parameters for the swap
     */

    function swapYTForPT(address market, uint256 exactYTIn, uint256 min, ApproxParams memory guess)
        external
        onlyManager
    {
        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(market).readTokens();
        _approveOperations(address(_YT), address(pendleRouter), exactYTIn);
        pendleRouter.swapExactYtForPt(address(this), market, exactYTIn, min, guess);
        emit SwapYTForPT(market, exactYTIn, min, guess);
    }

    /**
     * @notice Swaps Yield Tokens (YT) for Standardized Yield (SY) tokens in a specified market
     * @param market Address of the market
     * @param exactYTIn Amount of YT to swap
     * @param min Minimum amount of SY to receive
     * @param orderData Specifies the type of swap to perform
     */
    function swapYTForSY(address market, uint256 exactYTIn, uint256 min, LimitOrderData memory orderData)
        public
        onlyManager
    {
        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(market).readTokens();
        _approveOperations(address(_YT), address(pendleRouter), exactYTIn);
        pendleRouter.swapExactYtForSy(address(this), market, exactYTIn, min, orderData);
        emit SwapYTForSY(market, exactYTIn, min, orderData);
    }
    /**
     * @notice Swaps Principal Tokens (PT) for Standardized Yield (SY) tokens in a specified market
     * @param market Market where the swap is to occur
     * @param exactPTIn Amount of PT to swap
     * @param swapData Additional data for the swap
     * @param minSY Minimum amount of SY to receive
     */

    function swapExactPTForSY(IPMarket market, uint256 exactPTIn, bytes calldata swapData, uint256 minSY)
        external
        onlyManager
        nonReentrant
    {
        (IPStandardizedYield _SY, IPPrincipalToken _PT,) = IPMarket(market).readTokens();
        IERC20(address(_PT)).safeTransfer(address(market), exactPTIn);
        (uint256 netSyOut, uint256 netSyFee) = market.swapExactPtForSy(address(this), exactPTIn, swapData);
        if (netSyOut < minSY) {
            revert InsufficientSyOut(netSyOut, minSY);
        }
        market.skim();
        emit SwapExactPTForSY(address(market), exactPTIn, swapData, minSY);
    }
    /**
     * @notice Burns LP tokens in the specified market and withdraws the underlying assets
     * @param market Market from which LP tokens are to be burned
     * @param amount Amount of LP tokens to burn
     */

    function burnLP(IPMarket market, uint256 amount) external onlyManager nonReentrant {
        IERC20(address(market)).safeTransfer(address(market), amount);
        market.burn(address(this), address(market), amount);
        market.skim();
        emit BurnLP(address(market), amount);
    }
    /**
     * @notice withdraws some amount from the position in the specified market
     * @param market Market from which the position is to be decreased
     * @param _amount Amount by which the position is to be decreased
     * @param closePosition Flag indicating whether to close the position entirely
     */

    function decreasePosition(IPMarket market, uint256 _amount, bool closePosition) external onlyManager nonReentrant {
        (IPStandardizedYield SY,,) = market.readTokens();
        (, address _underlyingToken,) = SY.assetInfo();

        // redeems an amount of base tokens by burning SY
        IERC20(address(SY)).safeTransfer(address(SY), _amount);
        IPStandardizedYield(address(SY)).redeem(address(this), _amount, _underlyingToken, 1, true);
        if (closePosition && isMarketEmpty(market)) {
            registry.updateHoldingPosition(
                vaultId,
                registry.calculatePositionId(address(this), PENDLE_POSITION_ID, abi.encode(market)),
                "",
                "",
                true
            );
        }
        emit DecreasePosition(address(market), _amount, closePosition);
    }
    /**
     * @notice Claims rewards from the specified market
     * @param market Market from which rewards are to be claimed
     * @dev reward tokens must be updated in the registry after claiming
     * @dev the reward tokens may vary from market to market
     */

    function claimRewards(IPMarket market) external onlyManager nonReentrant {
        market.redeemRewards(address(this));
        address[] memory rewardTokens = market.getRewardTokens();
        for (uint256 i = 0; i < rewardTokens.length; i++) {
            _updateTokenInRegistry(rewardTokens[i]);
        }
        emit ClaimRewards(address(market));
    }
    /**
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
    }
    /**
     * @notice Calculates the value of Yield Tokens (YT) in terms of Standardized Yield (SY) tokens
     * @param market Address of the market where YT are traded
     * @param balance Amount of YT tokens to evaluate
     * @return The equivalent SY token value of the specified YT balance
     */

    function getYTValue(address market, uint256 balance) public view returns (uint256) {
        (uint256 netSyOut,,,,,,) = staticRouter.swapExactYtForSyStatic(market, balance);
        return netSyOut;
    }
    /**
     * @notice Checks whether all positions (SY, PT, YT, and LP (in the pool and in penpie)) in a given market are empty for this contract
     * @param market Market to check for any remaining positions
     * @return True if all positions are empty, false otherwise
     */

    function isMarketEmpty(IPMarket market) public view returns (bool) {
        (IPStandardizedYield _SY, IPPrincipalToken _PT, IPYieldToken _YT) = IPMarket(market).readTokens();
        return (
            _SY.balanceOf(address(this)) == 0 && _PT.balanceOf(address(this)) == 0 && _YT.balanceOf(address(this)) == 0
                && market.balanceOf(address(this)) == 0
        );
    }

    function _getUnderlyingTokens(uint256, bytes memory data) public view override returns (address[] memory) {
        address market = abi.decode(data, (address));
        (IPStandardizedYield SY,,) = IPMarket(market).readTokens();
        address[] memory tokens = new address[](1);
        (, tokens[0],) = SY.assetInfo();
        return tokens;
    }
}
