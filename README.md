# V4 Lending Hook
# Setup
```
bun i
forge install
forge test
```

# TODOS
- [ ] Write the basic hooks, with 1 test
- [ ] Clean up repo to remove any excess files from the template (i.e. make it look like no template ever existed)
- [ ] Connect with the very basics to Aave, i.e. just deposit in aave on afterDeposit hook
- [ ] Once aave is MPV connected, make everything in Uniswap v4 work properly
  - [ ] Bring in V3 curve with ticks
  - [ ] Update to latest uniswap v4 code base
  - [ ] Implement the 2-3 hooks I need
  - [ ] Testing
  - .... probably more
- [ ] Once Uniswap is working as intended, integrate with aave 100%
  - .... depositing, withdrawing, paying rewards, tests, many tasks here
- Misc
  - [ ] solhint bun script breaks, exits early
  - [ ] github actions
  - [x] cleanup solhint warnings
    - [ ] turn back on state-visibility, global imports, empty-blocks, 
  - [ ] probably - Switch entire repo to node modules and not foundry submodules. The remappings always give me errors, and block out real errors in vsCode. Also, if submodules are being annoying, [see this](https://twitter.com/PaulRBerg/status/1736695487057531328)
- Future
  - How to add in more assets, not just, USDC, USDT, and WETH ()

# Design
Basically, deposit idle assets into Aave V3. More details:
- Its native ETH because uniswap v4 does not use WETH
- Just take ETH and put it into wstETH or rETH
- It's built for USDC and USDT as they have heavy aave depth and uniswap depth
- We deposit idle assets into aave (i.e. assets outside of the active curve)
- We are using uniswap v3 curve and ticks

Ideas we decided to avoid
- sDAI, because it just for DAI, and we want to use Aave. So no use of Spark for now.
- Working with aUSDC or wstETH or anything, because then you wouldn't need the hook at all if the pool is based in those assets
- We do not nest borrowing in aave, too complex, too much risk, and it's just leverage anyways, and it costs money to take leverage
- no cbETH because it is blacklistable

# Open Questions
- How to hand out the rewards to users? (maybe sell rewards then donate token/eth to pool, increase everyones LP shares value)
- How to add in more yield protocols (i.e. compound, spark) and rebalance for the best yield?
- What if Aave gets too full (so the pool couldn't withdraw) - you are kinda stuck not being able to withdraw assets. Very, very bad for the uniswap pool. You need some sort of management here

# Resources
- Refer to https://github.com/uniswapfoundation/v4-template for the original template docs
- Repo is also inspired by https://github.com/PaulRBerg/foundry-template

## Updating to v4-template:latest

This template is actively maintained -- you can update the v4 dependencies, scripts, and helpers:

```bash
git remote add template https://github.com/uniswapfoundation/v4-template
git fetch template
git merge template/main <BRANCH> --allow-unrelated-histories
```

## Local Development (Anvil)

Because v4 depends on TSTORE and its _business licensed_, you can only deploy & test hooks on
[anvil](https://book.getfoundry.sh/anvil/)

```bash
# start anvil with TSTORE support
# (`foundryup`` to update if cancun is not an option)
anvil --hardfork cancun

# in a new terminal
forge script script/Anvil.s.sol \
    --rpc-url http://localhost:8545 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    --broadcast
```

## Goerli Deployment
- See https://github.com/uniswapfoundation/v4-template 

## Deploying your own Tokens For Testing

Because V4 is still in testing mode, most networks don't have liquidity pools live on V4 testnets. We recommend
launching your own test tokens and expirementing with them that. We've included in the templace a Mock UNI and Mock USDC
contract for easier testing. You can deploy the contracts and when you do you'll have 1 million mock tokens to test with
for each contract. See deployment commands below

```
forge create script/mocks/mUNI.sol:MockUNI \
--rpc-url [your_rpc_url_here] \
--private-key [your_private_key_on_goerli_here]
```

```
forge create script/mocks/mUSDC.sol:MockUSDC \
--rpc-url [your_rpc_url_here] \
--private-key [your_private_key_on_goerli_here]
```