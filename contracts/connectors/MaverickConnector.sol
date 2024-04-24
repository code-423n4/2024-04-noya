// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.20;

import "@openzeppelin/contracts-5.0/token/ERC20/IERC20.sol";
import "../external/interfaces/Maverick/IMaverickRouter.sol";

import "../helpers/BaseConnector.sol";

struct MavericAddLiquidityParams {
    bool ethPoolIncluded;
    IMaverickPool pool;
    AddLiquidityParams[] params;
    uint256 minTokenAAmount;
    uint256 minTokenBAmount;
    uint256 tokenARequiredAllowance;
    uint256 tokenBRequiredAllowance;
    uint256 deadline;
}

struct MavericRemoveLiquidityParams {
    IMaverickPool pool;
    uint256 tokenId;
    RemoveLiquidityParams[] params;
    uint256 minTokenAAmount;
    uint256 minTokenBAmount;
    uint256 deadline;
}

contract MaverickConnector is BaseConnector, IERC721Receiver {
    address mav;
    address veMav;
    address maverickRouter;
    IPositionInspector positionInspector;

    uint256 public MAVERICK_LP = 10;

    event Stake(uint256 amount, uint256 duration, bool doDelegation);
    event Unstake(uint256 lockupId);
    event AddLiquidityInMaverickPool(MavericAddLiquidityParams p);
    event RemoveLiquidityFromMaverickPool(MavericRemoveLiquidityParams p);
    event ClaimBoostedPositionRewards(IMaverickReward rewardContract);

    constructor(address _mav, address _veMav, address mr, address pi, BaseConnectorCP memory baseCP)
        BaseConnector(baseCP)
    {
        require(_mav != address(0));
        require(_veMav != address(0));
        require(mr != address(0));
        require(pi != address(0));
        mav = _mav;
        veMav = _veMav;
        maverickRouter = mr;
        positionInspector = IPositionInspector(pi);
    }

    receive() external payable { }
    /*
    * @notice: Supply mav to veMav
    * @param: amount - amount of mav to stake
    * @param: duration - duration of the stake
    * @param: doDelegation - whether to delegate the stake
    */

    function stake(uint256 amount, uint256 duration, bool doDelegation) external onlyManager nonReentrant {
        // approve veMav to spend mav
        _approveOperations(mav, veMav, amount);
        // stake mav
        IveMAV(veMav).stake(amount, duration, doDelegation);
        _updateTokenInRegistry(mav);
        _updateTokenInRegistry(veMav);
        emit Stake(amount, duration, doDelegation);
    }
    /*
    * @notice: Unstake veMav
    * @param: lockupId - lockup id of the stake
    */

    function unstake(uint256 lockupId) external onlyManager nonReentrant {
        // unstake veMav
        IveMAV(veMav).unstake(lockupId);
        _updateTokenInRegistry(mav);
        _updateTokenInRegistry(veMav);
        emit Unstake(lockupId);
    }

    /*
    * @notice: Add liquidity to Maverick pool
    * @param: p - parameters for adding liquidity
    * @dev: If the pool belongs to eth-erc20 consider tokenA == eth
    */
    function addLiquidityInMaverickPool(MavericAddLiquidityParams calldata p) external onlyManager nonReentrant {
        uint256 sendEthAmount = p.ethPoolIncluded ? p.tokenARequiredAllowance : 0;
        _approveOperations(p.pool.tokenA(), maverickRouter, p.tokenARequiredAllowance); // TODO: check token A is eth
        _approveOperations(p.pool.tokenB(), maverickRouter, p.tokenBRequiredAllowance);
        // add liquidity
        uint256 tokenId;
        {
            (tokenId,,,) = IMaverickRouter(maverickRouter).addLiquidityToPool{ value: sendEthAmount }(
                p.pool, 0, p.params, p.minTokenAAmount, p.minTokenBAmount, p.deadline
            );
        }
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), MAVERICK_LP, abi.encode(p.pool)), "", "", false
        );
        _updateTokenInRegistry(p.pool.tokenA());
        _updateTokenInRegistry(p.pool.tokenB());
        emit AddLiquidityInMaverickPool(p);
    }
    /*
    * @notice: Remove liquidity from Maverick pool
    * @param: p - parameters for removing liquidity
    * @dev: eth pool index : 0(tokenA), 1(tokenB), other(there is no eth in the pool)
    */

    function removeLiquidityFromMaverickPool(MavericRemoveLiquidityParams calldata p)
        external
        onlyManager
        nonReentrant
    {
        IMaverickPosition position = IMaverickRouter(maverickRouter).position();
        position.approve(maverickRouter, p.tokenId);
        IMaverickRouter(maverickRouter).removeLiquidity(
            p.pool, address(this), p.tokenId, p.params, p.minTokenAAmount, p.minTokenBAmount, p.deadline
        );
        registry.updateHoldingPosition(
            vaultId, registry.calculatePositionId(address(this), MAVERICK_LP, abi.encode(p.pool)), "", "", true
        );
        _updateTokenInRegistry(p.pool.tokenA());
        _updateTokenInRegistry(p.pool.tokenB());
        emit RemoveLiquidityFromMaverickPool(p);
    }
    /*
    * @notice: Claim boosted position rewards
    * @param: rewardContract - reward contract address
    */

    function claimBoostedPositionRewards(IMaverickReward rewardContract) external onlyManager nonReentrant {
        IMaverickReward.EarnedInfo[] memory earnedInfo = rewardContract.earned(address(this));
        uint8 tokenIndex;
        for (uint256 i = 0; i < earnedInfo.length; i++) {
            if (earnedInfo[i].earned != 0) {
                tokenIndex = rewardContract.tokenIndex(address(earnedInfo[i].rewardToken));
                rewardContract.getReward(address(this), tokenIndex);
            }
        }
        emit ClaimBoostedPositionRewards(rewardContract);
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function _getPositionTVL(HoldingPI memory p, address base) public view override returns (uint256 tvl) {
        PositionBP memory position = registry.getPositionBP(vaultId, p.positionId);
        IMaverickPool pool = abi.decode(position.data, (IMaverickPool));

        (uint256 a, uint256 b) = positionInspector.addressBinReservesAllKindsAllTokenIds(address(this), pool);
        return _getValue(pool.tokenA(), base, a) + _getValue(pool.tokenB(), base, b);
    }

    function _getUnderlyingTokens(uint256 id, bytes memory data) public view override returns (address[] memory) {
        (address pool) = abi.decode(data, (address));
        address[] memory tokens = new address[](2);
        tokens[0] = IMaverickPool(pool).tokenA();
        tokens[1] = IMaverickPool(pool).tokenB();
        return tokens;
    }
}
