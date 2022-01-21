const USDCToken = artifacts.require('USDCToken')
const RomanCoin = artifacts.require('RomanCoin')
const RomanFund = artifacts.require('RomanFund')

require('chai')
  .use(require('chai-as-promised'))
  .should()

function tokens(n) {
  return web3.utils.toWei(n, 'ether');
}

contract('RomanFund', (accounts) => {
  
//Before tests, we deploy the USDCToken, RomanCoin, and RomanFund contracts
//We then transfer all the Roman Coins to the RomanFund smart contract
//We then transfer 1000000 each of the rUSDC Tokens to 6 addresses
  let USDCTokenInstance, RomanCoinInstance, RomanFundInstance;

  before(async () => {

   //Get all the deployed contracts
    USDCTokenInstance = await USDCToken.new();
    RomanCoinInstance = await RomanCoin.new();
    RomanFundInstance = await RomanFund.new(USDCTokenInstance.address, RomanCoinInstance.address);

    //Transfer 350 million Roman Coins to the RomanFund smart contract
    await RomanCoinInstance.transfer(RomanFundInstance.address, tokens('350000000'))

    //Transfer 1000000 rUSDC Tokens to 1 addresses
    await USDCTokenInstance.transfer(accounts[1], tokens('350000000'), {from: accounts[0]})
    



    

    
  })


//Test Case 1: Test the name of the contract
  describe('Test the name of the RomanFund contract', async () => {
   
    it('Check the name of the contract', async () => {
      const name = await RomanFundInstance.name();
      assert.equal(name, 'RomanFund');
    });
  }); //End of Test Case 1

 

//Test Case 2: Test the name of USDCToken contract
describe('Test the name of the USDCToken contract', async () => {
   
  it('Check the name of the contract', async () => {
    const name = await USDCTokenInstance.name();
    assert.equal(name, 'ROMAN USDC');
  });

})




//Test Case 3: Test the name of RomanCoin contract
describe('Test the name of the RomanCoin contract', async () => {
  it('Check the name of the contract', async () => {  
    const name = await RomanCoinInstance.name();
    assert.equal(name, 'ROMAN Coin');
  });
})




//Test Case 4: Test whether the RomanFund contract has all the Roman Coins
describe('Test whether the RomanFund contract has all the Roman Coins', async () => {
  it('Check whether the RomanFund contract has all the Roman Coins', async () => {
    const balance = await RomanCoinInstance.balanceOf(RomanFundInstance.address);
    assert.equal(balance, tokens('350000000'));
  });
})



//Test Case 5: Test whether the RomanFund contract rewards the users
describe('Test whether the RomanFund contract rewards the users', async () => {
  
  
  it('Check whether the RomanFund contract rewards the users', async () => {
    //Test Case 5.1: Test whether the balance is correct before staking
    const balance = await USDCTokenInstance.balanceOf(accounts[1]);
    assert.equal(balance.toString(), tokens('350000000'), 'The rUSDC token balance should be correct before staking');

    //Test Case 5.2: Approve the RomanFund contract to spend the rUSDC tokens and then stake
    await USDCTokenInstance.approve(RomanFundInstance.address, tokens('1000000'), {from: accounts[1]});
    await RomanFundInstance.stake(tokens('1000000'), {from: accounts[1]});

    //Test Case 5.3: Test whether the balance is correct after staking
    const balanceAfterStaking = await USDCTokenInstance.balanceOf(accounts[1]);
    assert.equal(balanceAfterStaking.toString(), tokens('349000000'), 'The rUSDC token balance should be correct after staking');

    //Test Case 5.4: Test whether the balance of the RomanFund contract is correct
    const balanceOfRomanFund = await USDCTokenInstance.balanceOf(RomanFundInstance.address);
    assert.equal(balanceOfRomanFund.toString(), tokens('1000000'), 'The rUSDC token balance of the RomanFund contract should be correct');

    //Test Case 5.5: Test the staking balance of the staking address
    const stakingBalance = await RomanFundInstance.stakedAmount(accounts[1]);
    assert.equal(stakingBalance.toString(), tokens('1000000'), 'The staking balance of the staking address should be correct');

    //Test Case 5.6: Test the staking status of the staking address
    const stakingStatus = await RomanFundInstance.isStaker(accounts[1]);
    assert.equal(stakingStatus, true, 'The staking status of the staking address should be correct');


    //THE FOLLOWING TEST CASES ARE FOR THE REWARDING PART OF THE CONTRACT

    //The owner calls the reward function
    await RomanFundInstance.reward({from: accounts[0]});
    
    /*Test Case 5.7: Test the balance of Roman coins in the RomanFund contract after rewarding
    const balanceOfRomanFundAfterRewarding = await RomanCoinInstance.balanceOf(RomanFundInstance.address);
    assert.equal(balanceOfRomanFundAfterRewarding.toString(), tokens('349f000000'), 'The Roman coin balance of the RomanFund contract should be correct after rewarding');
    */


    //Test Case 5.8: Test the balance of the staking address after rewarding
    const balanceOfStakingAddressAfterRewarding = await RomanCoinInstance.balanceOf(accounts[1]);
    assert.equal(balanceOfStakingAddressAfterRewarding.toString(), tokens('1000000'), 'The Roman coin balance of the staking address should be correct after rewarding');

    //Test Case 5.9: Test the staking status of the staking address after rewarding
    const stakingStatusAfterRewarding = await RomanFundInstance.isStaker(accounts[1]);
    assert.equal(stakingStatusAfterRewarding, true, 'The staking status of the staking address should be correct after rewarding');

    //Test Case 5.10: Test that only the owner can call the reward function
    await RomanFundInstance.reward({from: accounts[1]}).should.be.rejected;

    //THE FOLLOWING TEST CASES ARE FOR THE REDEEMING PART OF THE CONTRACT

    //Test Case 5.11: Test the balance of the staking address AFTER redeeming USDCToken
    const balanceOfStakingAddressAfterRedeeming = await USDCTokenInstance.balanceOf(accounts[1]);
    assert.equal(balanceOfStakingAddressAfterRedeeming.toString(), tokens('349000000'), 'The rUSDC token balance of the staking address should be correct after redeeming');

    //Test Case 5.12: Test the staking balance of the staking address AFTER redeeming USDCToken
    const stakingBalanceAfterRedeeming = await RomanFundInstance.stakedAmount(accounts[1]);
    assert.equal(stakingBalanceAfterRedeeming.toString(), tokens('1000000'), 'The staking balance of the staking address should be correct after redeeming');

    //Test Case 5.13: Test the staking status of the staking address AFTER redeeming USDCToken
    const stakingStatusAfterRedeeming = await RomanFundInstance.isStaker(accounts[1]);
    assert.equal(stakingStatusAfterRedeeming, true, 'The staking status of the staking address should be correct after redeeming');



  });



})
})