# V4 Lending Hook
## Setup
```
bun i
forge install
forge test
```

## Resources
- Refer to https://github.com/uniswapfoundation/v4-template for the original template docs

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