// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0 <0.9.0;

// Uniswap
// TODO: update to v4-periphery/BaseHook.sol when its compatible
import { BaseHook } from "./forks/BaseHook.sol";
import { Hooks } from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import { PoolId, PoolIdLibrary } from "@uniswap/v4-core/contracts/types/PoolId.sol";
import { PoolKey } from "@uniswap/v4-core/contracts/types/PoolKey.sol";
import { CurrencyLibrary, Currency } from "@uniswap/v4-core/contracts/types/Currency.sol";
import { BalanceDelta } from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";
import { TickMath } from "@uniswap/v4-core/contracts/libraries/TickMath.sol";
import { Pool } from "@uniswap/v4-core/contracts/libraries/Pool.sol";
import { Position } from "@uniswap/v4-core/contracts/libraries/Position.sol";
import { IPoolManager } from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";

// Oz
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LendingHook is BaseHook {
    using Pool for *;
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    // NOTE - Starting with hardcoding USDC and DAI, in order to keep it simple for now
    // TODO - not really true, sDAI has different interface for mint and burn events
    IERC20 public immutable sDAI = IERC20(0x83F20F44975D03b1b09e64809B757c47f942BEeA);
    IERC20 public immutable DAI = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IERC20 public immutable USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    // TODO - add rETH, cbETH (but TODO - look at legal aspects of cbETH). Leave out frxETH - too risky
    IERC20 public immutable wstETH = IERC20(0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0);

    // NOTE - You can't directly read stETH yield. It's unknown the future of it.
    // Best you can do is 7 day average or something
    // Will be important when incorporating other liquid eth tokens (I guess we don't know the real yield of any of
    // them)

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) { }

    function getHookPermissions() public pure override returns (Hooks.Permissions memory) {
        return Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: false,
            beforeModifyPosition: true,
            afterModifyPosition: true,
            beforeSwap: false, // TODO - is it needed?
            afterSwap: true,
            beforeDonate: false,
            afterDonate: false, // TODO - Should be able to incorporate donating
            noOp: false,
            accessLock: false
        });
    }
    // ---------------------------------- Hooks ----------------------------------

    function afterSwap(
        address,
        PoolKey calldata key,
        IPoolManager.SwapParams calldata,
        BalanceDelta,
        bytes calldata
    )
        external
        override
        returns (bytes4)
    {
        // TODO
        return BaseHook.afterSwap.selector;
    }

    function beforeModifyPosition(
        address sender,
        PoolKey calldata key,
        IPoolManager.ModifyPositionParams calldata params,
        bytes calldata
    )
        external
        override
        returns (bytes4)
    {
        // TODO
        return BaseHook.beforeModifyPosition.selector;
    }

    function afterModifyPosition(
        address,
        PoolKey calldata key,
        IPoolManager.ModifyPositionParams calldata,
        BalanceDelta,
        bytes calldata
    )
        external
        override
        returns (bytes4)
    {
        // TODO
        return BaseHook.afterModifyPosition.selector;
    }

    receive() external payable { }
}
