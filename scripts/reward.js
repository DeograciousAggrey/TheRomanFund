const RomanFund = artifacts.require('RomanFund')

module.exports = async function(callback) {
  //call the reward function and log the result
  const romanFund = await RomanFund.deployed()
   await romanFund.reward()
    console.log('rewarded')
    callback()


  
}
