NOTES:

- Must have a file named .secret with the seed phrase for the testnet wallet
- Must have a file named .bscscanApiKey that can be filled with garbage since it's unused for Nervos



ERROR SEEN WHEN DEPLOYING TO CKB VIA TRUFFLE

[wingnut] /d/0-CODE/rugzombie/contracts-nervos:$ truffle migrate --f 96 --to 96 --network ckb_testnet

Starting migrations...
======================
> Network name:    'ckb_testnet'
> Network id:      868455272153094
> Block gas limit: 12500000 (0xbebc20)


96_wingnut_nft.js
=================

   Deploying 'OblivionBasicNft'
   ----------------------------

Error:  *** Deployment Failed ***

"OblivionBasicNft" -- Cannot convert 0x-4 to a BigInt.

    at C:\Users\barry\AppData\Roaming\npm\node_modules\truffle\build\webpack:\packages\deployer\src\deployment.js:365:1
    at processTicksAndRejections (node:internal/process/task_queues:96:5)
    at Migration._deploy (C:\Users\barry\AppData\Roaming\npm\node_modules\truffle\build\webpack:\packages\migrate\Migration.js:75:1)
    at Migration._load (C:\Users\barry\AppData\Roaming\npm\node_modules\truffle\build\webpack:\packages\migrate\Migration.js:61:1)
    at Migration.run (C:\Users\barry\AppData\Roaming\npm\node_modules\truffle\build\webpack:\packages\migrate\Migration.js:218:1)
    at Object.runMigrations (C:\Users\barry\AppData\Roaming\npm\node_modules\truffle\build\webpack:\packages\migrate\index.js:150:1)
    at Object.runFrom (C:\Users\barry\AppData\Roaming\npm\node_modules\truffle\build\webpack:\packages\migrate\index.js:110:1)
    at runMigrations (C:\Users\barry\AppData\Roaming\npm\node_modules\truffle\build\webpack:\packages\core\lib\commands\migrate.js:253:1)
    at Object.run (C:\Users\barry\AppData\Roaming\npm\node_modules\truffle\build\webpack:\packages\core\lib\commands\migrate.js:223:1)
    at Command.run (C:\Users\barry\AppData\Roaming\npm\node_modules\truffle\build\webpack:\packages\core\lib\command.js:167:1)
Truffle v5.3.10 (core: 5.3.10)
Node v16.14.2




SUCCESS WHEN DEPLOYING TO BSC TESTNET


[wingnut] /d/0-CODE/rugzombie/contracts-nervos:$ truffle migrate --f 96 --to 96 --network testnet

Starting migrations...
======================
> Network name:    'testnet'
> Network id:      97
> Block gas limit: 30000000 (0x1c9c380)


96_wingnut_nft.js
=================

   Deploying 'OblivionBasicNft'
   ----------------------------
   > transaction hash:    0xc4272c6aa4ae9af9563094d57561295c9b68cf1d5b0777c84e7fc4080f239127
   > Blocks: 5            Seconds: 13
   > contract address:    0xb906bAC1290F051aaA6f163364612565c9edBf13
   > block number:        17958917
   > block timestamp:     1648481920
   > account:             0x964805Bb614285b451dca872e6245F86F833AB24
   > balance:             33.032871080509667282
   > gas used:            1984519 (0x1e4807)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.01984519 ETH

   Pausing for 10 confirmations...
   -------------------------------
   > confirmation number: 1 (block: 17958920)
   > confirmation number: 3 (block: 17958922)
   > confirmation number: 4 (block: 17958923)
   > confirmation number: 6 (block: 17958925)
   > confirmation number: 7 (block: 17958926)
   > confirmation number: 8 (block: 17958927)
   > confirmation number: 9 (block: 17958928)
   > confirmation number: 11 (block: 17958930)
NFT1: 0xb906bAC1290F051aaA6f163364612565c9edBf13
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.01984519 ETH


Summary
=======
> Total deployments:   1
> Final cost:          0.01984519 ETH





SAME CONTRACT SUCCESSFUL USING THE HARDHAT/WEB3 DEPLOYMENT SCRIPT

[wingnut] (master) /d/0-CODE/nervos/layer2-evm-documentation/code-examples/2-deploy-contract:$ node index.js OblivionBasicNft
Found file: ./artifacts/contracts/OblivionBasicNft.sol/OblivionBasicNft.json
Deploying contract...
Transaction hash: 0x402bb321dbb7c4721779d3775f9cb7e0c5dad9f3bcf377fe80b0d5bf5edaf677
Deployed contract address: 0x003989d409253403C924758556CD6aAAb57697cF