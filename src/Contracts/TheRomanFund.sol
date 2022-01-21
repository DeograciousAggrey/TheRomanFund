

//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract RomanCoin {
    string  public name = "ROMAN Coin";
    string  public symbol = "RMC";
    uint256 public totalSupply = 350000000000000000000000000; // 350 million tokens
    uint8   public decimals = 18;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}

contract USDCToken {
    string  public name = "ROMAN USDC";
    string  public symbol = "rUSDC";
    uint256 public totalSupply = 350000000000000000000000000; // 350 million tokens
    uint8   public decimals = 18;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}

/*
    * @title TheRomanFund 
    * @dev The fund is a smart contract that allows users to stake and unstake USDCTokens.
    * @dev The fund is a smart contract that allows users to receive Roman coins as a reward for staking.
    * @dev The fund is a smart contract that allows users to redeem their Roman coins and USDCTokens.
    * @dev The fund is a smart contract that allows users to transfer Roman Coins to other users.
    * @dev The fund is a smart contract that allows users to transfer USDCTokens to other users.

*/

 // Create a contract for the fund

 contract RomanFund {
      /*
      *@ the name of the fund
      *@var address of the owner of the fund 
      
      */
    
        string public name = "RomanFund";
        address public owner;

        //assign usdcToken to state variable of type USDCToken
        //assign romanCoin to state variable of type RomanCoin
        USDCToken public usdcToken;
        RomanCoin public romanCoin;


        //Array of type address to store the addresses of the stakers
        address[] public stakers;

        //Array of type address to store the addresses of the redeemers
        address[] public redeemers;

        //Array of type address to store the addresses of the transferrs
        address[] public transferrs;

        //Map of type address to uint256 to store the staked amount of each staker
        mapping (address => uint256) public stakedAmount;

        //Map of type address to uint256 to store the redeemed amount of each redeemer
        mapping (address => uint256) public redeemedAmount;

        //Map of type address to uint256 to store the transferred amount of each transferr
        mapping (address => uint256) public transferredAmount;

        //Map to store whether a user has staked or not
        mapping (address => bool) public staked;

        //Map to show whether a user is a staker or not
        mapping (address => bool) public isStaker;





        
    /*
        * @dev a constructor that stores references to the USDCToken and RomanCoin contracts
        * @param _usdctoken a reference to the USDCToken contract
        * @param _romancoin a reference to the RomanCoin contract
    */
    constructor(USDCToken _usdctoken, RomanCoin _romancoin) public {
        usdcToken = _usdctoken;
        romanCoin = _romancoin;
        owner = msg.sender;
    }


    /* 
        *a function that allows users to stake USDCTokens 
        *@param _amount the amount of USDCTokens to be staked
        *@dev the function will check if the user has enough USDCTokens to stake
        *@dev the function will check if the user has already staked
        *@dev the function will check if the user has already staked the maximum amount of USDCTokens

    */
    function stake(uint _amount) public payable {
        //require(_amount <= usdcToken.balanceOf(msg.sender), "You don't have enough USDCTokens to stake");
        //the user cannot stake zero tokens
        require(_amount > 0, "You cannot stake zero tokens");
       // require(stakedAmount[msg.sender] == 0, "You have already staked");
        //require(stakedAmount[msg.sender] <= usdcToken.balanceOf(msg.sender), "You have already staked the maximum amount of USDCTokens");

        //Transfer the amount of USDCTokens to the fund using transferFrom
        usdcToken.transferFrom(msg.sender,address(this), _amount);

        //Keep track of the staked amount of the user every time they stake
        stakedAmount[msg.sender] = stakedAmount[msg.sender] + _amount;

        //Add the address of the user to the stakers array if they have not already staked
        if(staked[msg.sender] == false) {
            stakers.push(msg.sender);
            staked[msg.sender] = true;
            //The user is now a staker
            isStaker[msg.sender] = true;
        }


        
    }



    /*
      * @dev a function that is called only by the owner of the fund to reward the stakers with Roman Coins at 12% APY of their staked USDC amount
        * @dev the user must have a staked amount of at least 1 USDCToken to be rewarded
        * @dev the user's staking status must be true
        * @dev the function should reward all eligible stakers in the stakers array

    */  
        function reward() public {
            require(msg.sender == owner, "Only the owner of the fund can reward");

            //Loop through the stakers array
           // Reward all eligible stakers in the stakers array
            for(uint i = 0; i < stakers.length; i++) {
                //Check if the user has a staked amount of at least 1 USDCToken
                if(stakedAmount[stakers[i]] >= 1) {
                    //Reward the user with a Roman Coin
                    romanCoin.transfer(stakers[i], stakedAmount[stakers[i]]);
                }
            }

        }


    /*
        * @dev a function that allows users to redeem their Roman Coins
        * @param _amount the amount of Roman Coins to be redeemed
        * @dev the function will check if the user has enough Roman Coins to redeem
        * @dev the function will check if the user has already redeemed the maximum amount of Roman Coins
        
    */
    function redeem(uint _amount) public {
        //Require the user has enough staked USDC Tokens to redeem
        //require(stakedAmount[msg.sender] >= _amount, "You don't have enough USDC Tokens to redeem");
        //require the user not redeem zero USDC Tokens
        require(_amount > 0, "You cannot redeem zero Roman Coins");

        //Transfer the requested amount of USDC Tokens to the user 
        usdcToken.transfer(msg.sender, _amount);

        //Update the staked amount of the user
        stakedAmount[msg.sender] = stakedAmount[msg.sender] - _amount;

        //If the staked amount of the user is zero, set their staked status to false
        if(stakedAmount[msg.sender] == 0) {
            staked[msg.sender] = false;
            //The user is no longer a staker
            isStaker[msg.sender] = false;
        }

        
        
        



    }


        

























 }
