// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "../external/interfaces/Lido/ILidoWithdrawal.sol";
import "../helpers/BaseConnector.sol";

contract LidoConnector is BaseConnector, ERC721Holder {
    address public lido;
    address public lidoWithdrawal;
    address public steth;
    address public weth;

    uint256 public LIDO_WITHDRAWAL_REQUEST_ID = 10;

    event Deposit(uint256 amountIn);
    event RequestWithdrawals(uint256 amount);
    event ClaimWithdrawal(uint256 requestId);
    // ------------ constructor -------------- //

    constructor(address _lido, address _lidoW, address _steth, address w, BaseConnectorCP memory baseConnectorParams)
        BaseConnector(baseConnectorParams)
    {
        require(_lido != address(0));
        require(_lidoW != address(0));
        require(_steth != address(0));
        require(w != address(0));
        lido = _lido;
        lidoWithdrawal = _lidoW;
        steth = _steth;
        weth = w;
    }
    /*
        * @notice Deposit ETH to Lido
        * @param amountIn - amount of ETH to deposit
        */

    function deposit(uint256 amountIn) external onlyManager nonReentrant {
        IWETH(weth).withdraw(amountIn);
        // deposit recieved eth into Lido
        // refferal address can be different
        ILido(lido).submit{ value: amountIn }(address(0));
        _updateTokenInRegistry(steth);
        _updateTokenInRegistry(weth);
        emit Deposit(amountIn);
    }
    /**
     * @notice Request withdrawal from Lido
     * @param amount - amount of steth to withdraw
     */

    function requestWithdrawals(uint256 amount) public onlyManager nonReentrant {
        _approveOperations(steth, lidoWithdrawal, amount);
        // prepare inputs for requestWithdrawals
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;
        // request for withdrawal
        uint256[] memory requestIds = ILidoWithdrawal(lidoWithdrawal).requestWithdrawals(amounts, address(this));
        bytes32 positionId = registry.calculatePositionId(address(this), LIDO_WITHDRAWAL_REQUEST_ID, "");
        registry.updateHoldingPosition(vaultId, positionId, abi.encode(requestIds[0]), abi.encode(amount), false);

        _updateTokenInRegistry(steth);
        emit RequestWithdrawals(amount);
    }
    /**
     * @notice Claim withdrawal from Lido
     * @param requestId - request id to claim
     */

    function claimWithdrawal(uint256 requestId) public onlyManager nonReentrant {
        // approve to lidoWithdrawal to spend withdrawal NFT
        ILidoWithdrawal(lidoWithdrawal).approve(lidoWithdrawal, requestId);
        // eth balance before claim
        uint256 beforeClaimBalance = address(this).balance;
        // claim request withdrawal
        ILidoWithdrawal(lidoWithdrawal).claimWithdrawal(requestId);
        // emit ClaimWithdrawal event
        IWETH(weth).deposit{ value: address(this).balance - beforeClaimBalance }();
        registry.updateHoldingPosition(
            vaultId,
            registry.calculatePositionId(address(this), LIDO_WITHDRAWAL_REQUEST_ID, ""),
            abi.encode(requestId),
            "",
            true
        );
        _updateTokenInRegistry(weth);
        emit ClaimWithdrawal(requestId);
    }

    receive() external payable { }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        (uint256 amount) = abi.decode(p.additionalData, (uint256));
        return _getValue(steth, base, amount);
    }
}
