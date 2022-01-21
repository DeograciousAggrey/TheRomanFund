const USDCToken = artifacts.require("USDCToken");
const RomanCoin = artifacts.require("RomanCoin");
const TheRomanFund = artifacts.require("RomanFund");

module.exports = async function(deployer) {
  /* 
    1. Deploy USDCToken
    2. Deploy RomanCoin
    3. Deploy RomanFund 
  */
  await deployer.deploy(USDCToken);
  const USDCTokenInstance = await USDCToken.deployed();


/* ******************************************************** */
  await deployer.deploy(RomanCoin);
  const RomanCoinInstance = await RomanCoin.deployed();


/* ********************************************************** */
  await deployer.deploy(TheRomanFund, USDCTokenInstance.address, RomanCoinInstance.address);
  const RomanFundInstance = await TheRomanFund.deployed();


//Transfer all the Roman Coins to the RomanFund smart contract 
  
  await RomanCoinInstance.transfer(RomanFundInstance.address,"350000000000000000000000000");

//Transfer 1000000 each of the USDC Tokens to 6 addresses
  const Stakers = [
    //"0xe218279A68C0184F61187aC883cCeb3189CE4633",
    "0x5A95dB4465332549e00B591CF06f8DEa40b04350",
    
  ];
  const USDCAmounts = [
    //"350000000000000000000000000",
    "100000000000000000000000000",
    
  ];
  for (let i = 0; i < Stakers.length; i++) {
    await USDCTokenInstance.transfer(Stakers[i], USDCAmounts[i]);
  }





  
}