/*

  << Exchange >>

*/

pragma solidity 0.5.1;

import "./ExchangeCore.sol";

/**
 * @title Exchange
 * @author Wyvern Protocol Developers
 */
contract Exchange is ExchangeCore {

    /* Public ABI-encodable method wrappers. */

    function hashOrder_(address maker, address staticTarget, bytes memory staticExtradata, uint maximumFill, uint listingTime, uint expirationTime, uint salt)
        public
        pure
        returns (bytes32 hash)
    {
        return hashOrder(Order(maker, staticTarget, staticExtradata, maximumFill, listingTime, expirationTime, salt));
    }

    function hashToSign_(bytes32 orderHash)
        external
        view
        returns (bytes32 hash)
    {
        return hashToSign(orderHash);
    }

    function validateOrderParameters_(address maker, address staticTarget, bytes memory staticExtradata, uint maximumFill, uint listingTime, uint expirationTime, uint salt)
        public
        view
        returns (bool)
    {
        Order memory order = Order(maker, staticTarget, staticExtradata, maximumFill, listingTime, expirationTime, salt);
        return validateOrderParameters(order, hashOrder(order));
    }

    function validateOrderAuthorization_(bytes32 hash, address maker, uint8 v, bytes32 r, bytes32 s)
        external
        view
        returns (bool)
    {
        return validateOrderAuthorization(hash, maker, Sig(v, r, s));
    }

    function approveOrderHash_(bytes32 hash)
        external
    {
        return approveOrderHash(hash);
    }

    function approveOrder_(address maker, address staticTarget, bytes memory staticExtradata, uint maximumFill, uint listingTime, uint expirationTime, uint salt, bool orderbookInclusionDesired)
        public
    {
        return approveOrder(Order(maker, staticTarget, staticExtradata, maximumFill, listingTime, expirationTime, salt), orderbookInclusionDesired);
    }

    function setOrderFill_(bytes32 hash, uint fill)
        external
    {
        return setOrderFill(hash, fill);
    }

    function atomicMatch_(address[6] memory addrs, uint[8] memory uints, bytes memory firstExtradata, bytes memory firstCalldata, bytes memory secondExtradata,
        bytes memory secondCalldata, uint8[4] memory howToCallsVs, bytes32[5] memory rssMetadata)
        public
        payable
    {
        return atomicMatch(
            Order(addrs[0], addrs[1], firstExtradata, uints[0], uints[1], uints[2], uints[3]),
            Sig(howToCallsVs[0], rssMetadata[0], rssMetadata[1]),
            Call(addrs[2], AuthenticatedProxy.HowToCall(howToCallsVs[1]), firstCalldata),
            Order(addrs[3], addrs[4], secondExtradata, uints[4], uints[5], uints[6], uints[7]),
            Sig(howToCallsVs[2], rssMetadata[2], rssMetadata[3]),
            Call(addrs[5], AuthenticatedProxy.HowToCall(howToCallsVs[3]), secondCalldata),
            rssMetadata[4]
        );
    }

}
