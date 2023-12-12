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

That is all it has to do!