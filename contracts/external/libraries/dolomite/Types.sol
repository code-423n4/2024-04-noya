/*

    Copyright 2019 dYdX Trading Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

*/

pragma solidity 0.8.20;
pragma experimental ABIEncoderV2;

import "./Decimal.sol";

struct Index {
    uint96 borrow;
    uint96 supply;
    uint32 lastUpdate;
}

/*
     * The price of a base-unit of an asset. Has `36 - token.decimals` decimals
     */

struct Price {
    uint256 value;
}

/*
     * Total value of an some amount of an asset. Equal to (price * amount). Has 36 decimals.
     */
struct Value {
    uint256 value;
}
// All information necessary for tracking a market

struct Market {
    // Contract address of the associated ERC20 token
    address token;
    // Whether additional borrows are allowed for this market
    bool isClosing;
    // Whether this market can be removed and its ID can be recycled and reused
    bool isRecyclable;
    // Total aggregated supply and borrow amount of the entire market
    Types.TotalPar totalPar;
    // Interest index of the market
    Index index;
    // Contract address of the price oracle for this market
    IPriceOracle priceOracle;
    // Contract address of the interest setter for this market
    address interestSetter;
    // Multiplier on the marginRatio for this market, IE 5% (0.05 * 1e18). This number increases the market's
    // required collateralization by: reducing the user's supplied value (in terms of dollars) for this market and
    // increasing its borrowed value. This is done through the following operation:
    // `suppliedWei = suppliedWei + (assetValueForThisMarket / (1 + marginPremium))`
    // This number increases the user's borrowed wei by multiplying it by:
    // `borrowedWei = borrowedWei + (assetValueForThisMarket * (1 + marginPremium))`
    Decimal.D256 marginPremium;
    // Multiplier on the liquidationSpread for this market, IE 20% (0.2 * 1e18). This number increases the
    // `liquidationSpread` using the following formula:
    // `liquidationSpread = liquidationSpread * (1 + spreadPremium)`
    // NOTE: This formula is applied up to two times - one for each market whose spreadPremium is greater than 0
    // (when performing a liquidation between two markets)
    Decimal.D256 spreadPremium;
    // The maximum amount that can be held by the protocol. This allows the protocol to cap any additional risk
    // that is inferred by allowing borrowing against low-cap or assets with increased volatility. Setting this
    // value to 0 is analogous to having no limit. This value can never be below 0.
    Types.Wei maxWei;
}

// The global risk parameters that govern the health and security of the system
struct RiskParams {
    // Required ratio of over-collateralization
    Decimal.D256 marginRatio;
    // Percentage penalty incurred by liquidated accounts
    Decimal.D256 liquidationSpread;
    // Percentage of the borrower's interest fee that gets passed to the suppliers
    Decimal.D256 earningsRate;
    // The minimum absolute borrow value of an account
    // There must be sufficient incentivize to liquidate undercollateralized accounts
    Value minBorrowedValue;
    // The maximum number of markets a user can have a non-zero balance for a given account.
    uint256 accountMaxNumberOfMarketsWithBalances;
}

// The maximum RiskParam values that can be set
struct RiskLimits {
    // The highest that the ratio can be for liquidating under-water accounts
    uint64 marginRatioMax;
    // The highest that the liquidation rewards can be when a liquidator liquidates an account
    uint64 liquidationSpreadMax;
    // The highest that the supply APR can be for a market, as a proportion of the borrow rate. Meaning, a rate of
    // 100% (1e18) would give suppliers all of the interest that borrowers are paying. A rate of 90% would give
    // suppliers 90% of the interest that borrowers pay.
    uint64 earningsRateMax;
    // The highest min margin ratio premium that can be applied to a particular market. Meaning, a value of 100%
    // (1e18) would require borrowers to maintain an extra 100% collateral to maintain a healthy margin ratio. This
    // value works by increasing the debt owed and decreasing the supply held for the particular market by this
    // amount, plus 1e18 (since a value of 10% needs to be applied as `decimal.plusOne`)
    uint64 marginPremiumMax;
    // The highest liquidation reward that can be applied to a particular market. This percentage is applied
    // in addition to the liquidation spread in `RiskParams`. Meaning a value of 1e18 is 100%. It is calculated as:
    // `liquidationSpread * Decimal.onePlus(spreadPremium)`
    uint64 spreadPremiumMax;
    uint128 minBorrowedValueMax;
}

interface IPriceOracle {
    // ============ Public Functions ============

    /**
     * Get the price of a token
     *
     * @param  token  The ERC20 token address of the market
     * @return        The USD price of a base unit of the token, then multiplied by 10^36.
     *                So a USD-stable coin with 18 decimal places would return 10^18.
     *                This is the price of the base unit rather than the price of a "human-readable"
     *                token amount. Every ERC20 may have a different number of decimals.
     */
    function getPrice(address token) external view returns (Price memory);
}

/**
 * @title Types
 * @author dYdX
 *
 * Library for interacting with the basic structs used in DolomiteMargin
 */
library Types {
    // ============ Permission ============

    struct OperatorArg {
        address operator;
        bool trusted;
    }

    // ============ AssetAmount ============

    enum AssetDenomination {
        Wei, // the amount is denominated in wei
        Par // the amount is denominated in par

    }

    enum AssetReference {
        Delta, // the amount is given as a delta from the current value
        Target // the amount is given as an exact number to end up at

    }

    struct AssetAmount {
        bool sign; // true if positive
        AssetDenomination denomination;
        AssetReference ref;
        uint256 value;
    }

    // ============ Par (Principal Amount) ============

    // Total borrow and supply values for a market
    struct TotalPar {
        uint128 borrow;
        uint128 supply;
    }

    // Individual principal amount for an account
    struct Par {
        bool sign; // true if positive
        uint128 value;
    }

    // Individual token amount for an account
    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }
}
