// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// forge
import "forge-std/Test.sol";

// Interfaces
import { IHooks } from "@uniswap/v4-core/contracts/interfaces/IHooks.sol";
import { IPoolManager } from "@uniswap/v4-core/contracts/interfaces/IPoolManager.sol";
// Libraries
import { Hooks } from "@uniswap/v4-core/contracts/libraries/Hooks.sol";
import { TickMath } from "@uniswap/v4-core/contracts/libraries/TickMath.sol";
import { PoolKey } from "@uniswap/v4-core/contracts/types/PoolKey.sol";
import { PoolId, PoolIdLibrary } from "@uniswap/v4-core/contracts/types/PoolId.sol";
import { BalanceDelta } from "@uniswap/v4-core/contracts/types/BalanceDelta.sol";
import { CurrencyLibrary, Currency } from "v4-core/types/Currency.sol";

// Constants
import { Constants } from "@uniswap/v4-core/contracts/../test/utils/Constants.sol";
//Utils
import { HookTest } from "./utils/HookTest.sol";
import { HookMiner } from "./utils/HookMiner.sol";
// Our contracts
import { LendingHook } from "../src/LendingHook.sol";

contract LendingHookTest is HookTest {
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    LendingHook lendingHook;
    PoolKey poolKey;
    PoolId poolId;

    uint256 subsidyAmount = 0.005 ether;

    function setUp() public {
        // creates the pool manager, test tokens, and other utility routers
        HookTest.initHookTestEnv();

        // Deploy the hook to an address with the correct flags
        uint160 flags =
            uint160(Hooks.AFTER_SWAP_FLAG | Hooks.BEFORE_MODIFY_POSITION_FLAG | Hooks.AFTER_MODIFY_POSITION_FLAG);
        (address hookAddress, bytes32 salt) =
            HookMiner.find(address(this), flags, type(LendingHook).creationCode, abi.encode(address(manager)));
        lendingHook = new LendingHook{ salt: salt }(IPoolManager(address(manager)));
        require(address(lendingHook) == hookAddress, "CounterTest: hook address mismatch");

        // Create the pool
        poolKey = PoolKey(Currency.wrap(address(token0)), Currency.wrap(address(token1)), 3000, 60, IHooks(lendingHook));
        poolId = poolKey.toId();
        initializeRouter.initialize(poolKey, Constants.SQRT_RATIO_1_1, ZERO_BYTES);

        modifyPositionRouter.modifyPosition(poolKey, IPoolManager.ModifyPositionParams(-60, 60, 10 ether), ZERO_BYTES);
        modifyPositionRouter.modifyPosition(poolKey, IPoolManager.ModifyPositionParams(-120, 120, 10 ether), ZERO_BYTES);
        modifyPositionRouter.modifyPosition(
            poolKey,
            IPoolManager.ModifyPositionParams(TickMath.minUsableTick(60), TickMath.maxUsableTick(60), 10 ether),
            ZERO_BYTES
        );
    }

    // Note - Contract context goes: --> Swap Router --> Manager --> Swap Router --> Manager --> Gas Subsidy Hook.
    function testLendTokenBMP() public { }
    function testLendEthBMP() public { }
    function testLendTokenAMP() public { }
    function testLendEthAMP() public { }
    function testLendTokenAS() public { }
    function testLendEthAS() public { }

    // TODO - test all negative cases too
}
