// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import { PoolInitializeTest } from "@uniswap/v4-core/contracts/test/PoolInitializeTest.sol";
import { IHooks } from "@uniswap/v4-core/contracts/interfaces/IHooks.sol";
import { PoolKey } from "@uniswap/v4-core/contracts/types/PoolKey.sol";
import { CurrencyLibrary, Currency } from "@uniswap/v4-core/contracts/types/Currency.sol";
import { PoolId, PoolIdLibrary } from "@uniswap/v4-core/contracts/types/PoolId.sol";

contract CreatePoolScript is Script {
    using CurrencyLibrary for Currency;

    //addresses with contracts deployed
    address constant POOL_INITIALIZE_ROUTER = address(0x0); // TODO: Update once deployed
    address constant MUNI_ADDRESS = address(0xbD97BF168FA913607b996fab823F88610DCF7737); //mUNI deployed to GOERLI --
        // insert your own contract address here
    address constant MUSDC_ADDRESS = address(0xa468864e673a807572598AB6208E49323484c6bF); //mUSDC deployed to GOERLI --
        // insert your own contract address here
    address constant HOOK_ADDRESS = address(0x3CA2cD9f71104a6e1b67822454c725FcaeE35fF6); //address of the hook contract
        // deployed to goerli -- you can use this hook address or deploy your own!

    PoolInitializeTest initializeRouter = PoolInitializeTest(POOL_INITIALIZE_ROUTER);

    function run() external {
        // sort the tokens!
        address token0 = uint160(MUSDC_ADDRESS) < uint160(MUNI_ADDRESS) ? MUSDC_ADDRESS : MUNI_ADDRESS;
        address token1 = uint160(MUSDC_ADDRESS) < uint160(MUNI_ADDRESS) ? MUNI_ADDRESS : MUSDC_ADDRESS;
        uint24 swapFee = 4000;
        int24 tickSpacing = 10;

        // floor(sqrt(1) * 2^96)
        uint160 startingPrice = 79_228_162_514_264_337_593_543_950_336;

        bytes memory hookData = abi.encode(block.timestamp);

        PoolKey memory pool = PoolKey({
            currency0: Currency.wrap(token0),
            currency1: Currency.wrap(token1),
            fee: swapFee,
            tickSpacing: tickSpacing,
            hooks: IHooks(HOOK_ADDRESS)
        });

        // Turn the Pool into an ID so you can use it for modifying positions, swapping, etc.
        PoolId id = PoolIdLibrary.toId(pool);
        bytes32 idBytes = PoolId.unwrap(id);

        console.log("Pool ID Below");
        console.logBytes32(bytes32(idBytes));

        vm.broadcast();
        initializeRouter.initialize(pool, startingPrice, hookData);
    }
}
