// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../helpers/BaseConnector.sol";
import "../external/interfaces/Gearbox/ICreditManagerV3.sol";
import "../external/interfaces/Gearbox/ICreditFacadeV3.sol";

contract Gearboxv3 is BaseConnector {
    uint256 public constant GEARBOX_POSITION_ID = 3;

    event OpenAccount(address facade, uint256 ref);
    event CloseAccount(address facade, address creditAccount);
    event ExecuteCommands(
        address facade, address creditAccount, MultiCall[] calls, address approvalToken, uint256 amount
    );

    constructor(BaseConnectorCP memory baseConnectorParams) BaseConnector(baseConnectorParams) { }
    /**
     * @notice Open a credit account
     * @param facade - CreditFacade address
     * @param ref - referral code
     */

    function openAccount(address facade, uint256 ref) public onlyManager {
        address c = ICreditFacadeV3(facade).openCreditAccount(address(this), new MultiCall[](0), ref);
        registry.updateHoldingPosition(
            vaultId,
            registry.calculatePositionId(address(this), GEARBOX_POSITION_ID, abi.encode(facade)),
            abi.encode(c),
            "",
            false
        );
        emit OpenAccount(facade, ref);
    }
    /**
     * @notice Close a credit account
     * @param facade - CreditFacade address
     * @param creditAccount - credit account address
     */

    function closeAccount(address facade, address creditAccount) public onlyManager nonReentrant {
        ICreditFacadeV3(facade).closeCreditAccount(creditAccount, new MultiCall[](0));

        registry.updateHoldingPosition(
            vaultId,
            registry.calculatePositionId(address(this), GEARBOX_POSITION_ID, abi.encode(facade)),
            abi.encode(creditAccount),
            "",
            true
        );
        emit CloseAccount(facade, creditAccount);
    }
    /**
     * @notice Execute multiple commands on a credit account
     * @param facade - CreditFacade address
     * @param creditAccount - credit account address
     * @param calls - array of multicalls
     * @param approvalToken - token to approve
     * @param amount - amount to approve
     */

    function executeCommands(
        address facade,
        address creditAccount,
        MultiCall[] calldata calls,
        address approvalToken,
        uint256 amount
    ) public onlyManager nonReentrant {
        for (uint256 i = 0; i < calls.length; i++) {
            if (calls[i].target != facade) revert IConnector_InvalidTarget(calls[i].target);
            bytes4 method = bytes4(calls[i].callData[:4]);

            if (method == ICreditFacadeV3Multicall.enableToken.selector) {
                (address token) = abi.decode(calls[i].callData[4:], (address));
                _updateTokenInRegistry(token);
            }
        }
        if (approvalToken != address(0)) {
            _approveOperations(approvalToken, ICreditFacadeV3(facade).creditManager(), amount);
        }
        ICreditFacadeV3(facade).multicall(creditAccount, calls);
        if (approvalToken != address(0)) {
            _revokeApproval(approvalToken, ICreditFacadeV3(facade).creditManager());
        }
        emit ExecuteCommands(facade, creditAccount, calls, approvalToken, amount);
    }
    /**
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
    }
}
