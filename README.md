This is a fork of  the tutorial from [DApp Univeristy](https://www.dappuniversity.com/) which is configured to work on harmony blockchain. 

Steps
* `npm install`
* `truffle compile`
* add your private keys to .env file (the deployment requires two private keys)
* `truffle migrate --reset --network testnet`
* `npm start` which should popup http://localhost:3000/ page
* make sure to connect metamask to harmony testnet, as the dbank contracts are deployed on harmony testnet 

After running the scripts the 
 * Roman Coin HRC20 token is deployed here(https://explorer.testnet.harmony.one/address/0x98c7bb22a3975116b800bf04066b1e8c113a6bcc?activeTab=0)
 * Roman USDC HRC20 token is deployed here (https://explorer.testnet.harmony.one/address/0x8c8d2dde817c933225f6e9ec0cbe74ff054acba4?activeTab=5)
 * RomanFund contract is deployed here (https://explorer.testnet.harmony.one/address/0x0a4bfc451fada87cf28c5e10c90414b37d1bf567?activeTab=0)

