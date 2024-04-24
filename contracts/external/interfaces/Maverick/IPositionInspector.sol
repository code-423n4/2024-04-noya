// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.20;

import { IMaverickPool } from "./IMaverickPool.sol";

interface IPositionInspector {
    ////////////////////
    /// Reserves by address
    ////////////////////

    /// @notice Returns reserve amounts that an address owns in a pool; searches
    //all binIds.
    /// @dev May revert with out of gas if there are too many bins.
    /// @param  owner Position NFT owner address
    /// @param  tokenIdIndex of the tokenIs that the owner has
    /// @param  pool Mav pool
    /// @param  kind of bin to search for (0=static, 1=right, 2=left, 3=both)
    function addressBinReservesByKind(address owner, uint256 tokenIdIndex, IMaverickPool pool, uint8 kind)
        external
        view
        returns (uint256 amountA, uint256 amountB);

    /// @notice Returns reserve amounts that an address owns in a pool; searches
    //all binIds.
    /// @dev May revert with out of gas if there are too many bins.
    /// @param  owner Position NFT owner address
    /// @param  pool Mav pool
    /// @param  kind of bin to search for (0=static, 1=right, 2=left, 3=both)
    function addressBinReservesByKindAllTokenIds(address owner, IMaverickPool pool, uint8 kind)
        external
        view
        returns (uint256 amountA, uint256 amountB);

    /// @notice Returns reserve amounts that an address owns in a pool; searches
    //all binIds and all kinds.
    /// @dev May revert with out of gas if there are too many bins.
    /// @param  owner Position NFT owner address
    /// @param  pool Mav pool
    function addressBinReservesAllKindsAllTokenIds(address owner, IMaverickPool pool)
        external
        view
        returns (uint256 amountA, uint256 amountB);

    /// @notice Returns reserve amounts that an address owns in a pool; searches
    //all binIds and all kinds.
    /// @dev May revert with out of gas if there are too many bins.
    /// @param  owner Position NFT owner address
    /// @param  tokenIdIndex of the tokenIs that the owner has
    /// @param  pool Mav pool
    function addressBinReservesAllKinds(address owner, uint256 tokenIdIndex, IMaverickPool pool)
        external
        view
        returns (uint256 amountA, uint256 amountB);

    ////////////////////
    /// Reserves by tokenId
    ////////////////////

    /// @notice Returns reserve amounts a tokenId owns in a pool; searches
    //all binIds and all kinds.
    /// @dev May revert with out of gas if there are too many bins.
    /// @param  tokenId Position NFT ID of the LP
    /// @param  pool Mav pool
    function tokenBinReservesAllKinds(uint256 tokenId, IMaverickPool pool)
        external
        view
        returns (uint256 amountA, uint256 amountB);

    /// @notice Returns reserve amounts a tokenId owns in a pool; searches
    //all binIds.
    /// @dev May revert with out of gas if there are too many bins.
    /// @param  tokenId Position NFT ID of the LP
    /// @param  pool Mav pool
    /// @param  kind of bin to search for (0=static, 1=right, 2=left, 3=both)
    function tokenBinReservesByKind(uint256 tokenId, IMaverickPool pool, uint8 kind)
        external
        view
        returns (uint256 amountA, uint256 amountB);

    /// @notice Returns reserve amounts a tokenId owns in a pool
    /// @param  tokenId Position NFT ID of the LP
    /// @param  pool Mav pool
    /// @param  kind of bin to search for (0=static, 1=right, 2=left, 3=both)
    /// @param  startBin start search bin ussed for pagination if needed.
    //startBin = 0 should be used if not paginating.
    /// @param  endBin end search bin ussed for pagination if needed.  endBin =
    //type(uint128).max should be used if not paginating.
    function tokenBinReservesByKind(uint256 tokenId, IMaverickPool pool, uint8 kind, uint128 startBin, uint128 endBin)
        external
        view
        returns (uint256 amountA, uint256 amountB);

    /// @notice Returns reserve amounts a tokenId owns in a pool
    /// @param  tokenId Position NFT ID of the LP
    /// @param  pool Mav pool
    /// @param  startBin start search bin ussed for pagination if needed.
    //startBin = 0 should be used if not paginating.
    /// @param  endBin end search bin ussed for pagination if needed.  endBin =
    //type(uint128).max should be used if not paginating.
    function tokenBinReservesAllKinds(uint256 tokenId, IMaverickPool pool, uint128 startBin, uint128 endBin)
        external
        view
        returns (uint256 amountA, uint256 amountB);

    /// @notice Returns reserve amounts a tokenId owns in a pool
    /// @param  tokenId Position NFT ID of the LP
    /// @param  pool Mav pool
    /// @param  userBins  array of binIds that will be checked for reserves
    function tokenBinReservesByBinList(uint256 tokenId, IMaverickPool pool, uint128[] memory userBins)
        external
        view
        returns (uint256 amountA, uint256 amountB);

    ////////////////////
    /// Utility
    ////////////////////

    /// @notice Returns binIds that a token owns in a pool
    /// @param  tokenId Position NFT ID of the LP
    /// @param  pool Mav pool
    /// @param  startBin start search bin ussed for pagination if needed.
    //startBin = 0 should be used if not paginating.
    /// @param  endBin end search bin ussed for pagination if needed.  endBin =
    //type(uint128).max should be used if not paginating.
    function getTokenBinIds(uint256 tokenId, IMaverickPool pool, uint128 startBin, uint128 endBin)
        external
        view
        returns (uint128[] memory bins);
}
