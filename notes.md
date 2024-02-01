# Spark Hook Notes
- Naive implementation is just taking DAI and converting it to sDAI, which earns interest automatically
- But of course, sDAI is small, and doesn’t really trade - people just wrap and unwrap it. There is no need for sDAI pools on uniswap
- Naive ETH
    - Deposit ETH into wstETH, unwrap when needed
- Non-naive
    - Deposit ETH into spark, earn 2.38% (no sense, should be rETH, wstETH or cbETH)
- Thoughts
    - It could optimize for the best yield out of a few lending protocols (not gonna do now, too much work)
    - You could supply DAI, get 5% withdraw wstETH, sell that for DAI, which you could deposit again. RISK IN SLIPPAGE MAYBE NOT WORTH IT?
    - you gotta think the hook is SUPPOSED TO OPTIMIZE FOR DEPOSITORS SO MAYBE CYCLING THROUGH MULTIPLE LENDING PROTOCOLS IS THE WAY TO GO!
    - the obvious thing to build IS wstETH, rETH, and sDAI. you don’t even need to use any of these protocols of lending, cuz you end up that just holding sDAI and wstETH are the lowest risk, and still provide yield. to deposit them in AAVE , you basically get nothing back
        - however you could chase yield…. that is what I am saying here 



Alright
- rotate through Spark, AAVE, and Compound to get best stable yield
  - should work for USDC, DAI, USDT (AS IT IS A HOOK THAT MANY POOLS MIGHT USE)
  - Obviosly DAI is special case, where sDAI is awesome
- For ETH, rotate through
  - wstETH, rETH, cbETH, and others? 
- Other things
  - Parameters
    - Max amount of idle capital that can go to a lending protocol
    - tbg others

That is all it has to do! But the DEVIL IS IN THE DETAILS
- Like any strategy in investing, it has to be flexible and move around efficiently, otherwise it can just grind away and do too much, and cost fees
- Or be super simple
  - I want it to be super simple
  - However to get to that point will take a lot of iterations, and hard work, but lets get there.

Big Questions
- How will we be able to send the users rewards? It means tracking each users share. Or else, we just sell the returns, and donate(), and that increases everyones LP shares automatically?

Extremely good explanation on what this hook does
- Each tick can be viewed as it's own pool
- so all those pools are completely idle capital when you are outside of them
- thus, they are useless. might as well earn yield

# Summary 1
So it's
- WETH or ETH and DAI
- it is WETH/DAI
- Question - Do you still need a WETH/sDAI pool, or a wstETH/DAI pool, or a wstETH/sDAI pool
  - Ideally you aggregate it all.
  - note - ETH is not wsETH and DAI is not sDAI, they do bring risks (wstETH more so)
  - depositing them
  - duh - if you use wstETH and sDAI from the start, you don't even need this module at all, so you must do with raw WETH
- NOTE - DAI has quite low volume on DEXes, 25m daily to usdts 240MM and usdcs 265MM
- HEY - ridiculously obvious thing I realized
  - You can't use uniswap v3 pools here.... cuz this is uniswap v4, lol
  - so you need to natively import the raw v3 code for basic pool config, somewhere
  - ahh okay but the HOOKS are depositing weth, usdc and tether into AAVE and compound and spark and sDAI
  - okay but no SDAI, just do AAVE right now

# Summary of summary 
- Its native ETH because uniswap v4 does not use WETH
- It's built for USDC and USDT as they have heavy aave depth
- We deposit idle assets into aave (i.e. assets outside of the active curve)
- We are using uniswap v3 curve and ticks