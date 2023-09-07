//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title RomanCoin
 *
 */

contract RomanCoin is ERC20, ERC20Burnable, Ownable, AccessControl {
    using SafeERC20 for ERC20;
    using SafeMath for uint256;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    uint256 private s_totalSupply;
    mapping(address user => uint256 amount) private s_balances;

    constructor() ERC20("RomanCoin", "ROMAN") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
    }

    function mint(address to, uint256 amount) external {
        require(hasRole(MINTER_ROLE, _msgSender()), "Not Allowed");
        s_totalSupply = s_totalSupply.add(amount);
        s_balances[to] = s_balances[to].add(amount);
        _mint(to, amount);
    }
}
