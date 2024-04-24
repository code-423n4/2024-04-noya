// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import "../external/interfaces/Dolomite/IDepositWithdrawalProxy.sol";
import "../external/interfaces/Dolomite/IBorrowPositionProxyV1.sol";
import "../external/interfaces/Dolomite/IDolomiteMargin.sol";

contract DolomiteConnector is BaseConnector {
    using SafeERC20 for IERC20;

    IDepositWithdrawalProxy public depositWithdrawalProxy;
    IDolomiteMargin public dolomiteMargin;
    IBorrowPositionProxyV1 public borrowPositionProxy;

    uint256 public constant DOL_POSITION_ID = 1;

    constructor(
        address _depositWithdrawalProxy,
        address _dolomiteMargin,
        address _borrowPositionProxy,
        BaseConnectorCP memory baseConnectorParams
    ) BaseConnector(baseConnectorParams) {
        require(_depositWithdrawalProxy != address(0));
        depositWithdrawalProxy = IDepositWithdrawalProxy(_depositWithdrawalProxy);
        dolomiteMargin = IDolomiteMargin(_dolomiteMargin);
        borrowPositionProxy = IBorrowPositionProxyV1(_borrowPositionProxy);
    }

    function deposit(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {
        // get market token
        address token = dolomiteMargin.getMarketTokenAddress(marketId);
        // approve
        _approveOperations(token, address(dolomiteMargin), _amount);
        depositWithdrawalProxy.depositWeiIntoDefaultAccount(marketId, _amount);
        // Update token
        _updateTokenInRegistry(token);
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), DOL_POSITION_ID, ""), abi.encode(0), "", false
        );
    }

    function withdraw(uint256 marketId, uint256 _amount) public onlyManager nonReentrant {
        address token = dolomiteMargin.getMarketTokenAddress(marketId);
        depositWithdrawalProxy.withdrawWeiFromDefaultAccount(
            marketId, _amount, AccountBalanceHelper.BalanceCheckFlag.None
        );
        // Update token
        _updateTokenInRegistry(token);
        (uint256[] memory markets,,,) = dolomiteMargin.getAccountBalances(Info(address(this), 0));
        if (markets.length == 0) {
            registry.updateHoldingPosition(
                vaultId, registry.calculatePositionId(address(this), DOL_POSITION_ID, ""), abi.encode(0), "", true
            );
        }
    }

    function openBorrowPosition(uint256 marketId, uint256 _amountWei, uint256 accountId)
        public
        onlyManager
        nonReentrant
    {
        address token = dolomiteMargin.getMarketTokenAddress(marketId);

        if (!registry.isTokenTrusted(vaultId, token, address(this))) {
            revert IConnector_UntrustedToken(token);
        }
        // borrow
        borrowPositionProxy.openBorrowPosition(
            0, accountId, marketId, _amountWei, AccountBalanceHelper.BalanceCheckFlag.None
        );
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), DOL_POSITION_ID, ""), abi.encode(accountId), "", true
        );
    }

    function transferBetweenAccounts(uint256 accountId, uint256 marketId, uint256 _amountWei, bool borrowOrRepay)
        public
        onlyManager
        nonReentrant
    {
        address token = dolomiteMargin.getMarketTokenAddress(marketId);

        if (!registry.isTokenTrusted(vaultId, token, address(this))) {
            revert IConnector_UntrustedToken(token);
        }
        if (borrowOrRepay) {
            borrowPositionProxy.transferBetweenAccounts(
                accountId, 0, marketId, _amountWei, AccountBalanceHelper.BalanceCheckFlag.None
            );
        } else {
            borrowPositionProxy.transferBetweenAccounts(
                0, accountId, marketId, _amountWei, AccountBalanceHelper.BalanceCheckFlag.None
            );
        }
    }

    function closeBorrowPosition(uint256[] memory marketIds, uint256 accountId) public onlyManager nonReentrant {
        // repay
        borrowPositionProxy.closeBorrowPosition(accountId, 0, marketIds);
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), DOL_POSITION_ID, ""), abi.encode(accountId), "", true
        );
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
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
    }
}
