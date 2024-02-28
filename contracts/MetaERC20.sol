// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/IMetaERC20.sol";


contract MetaERC20 is IMetaERC20 {

    string public s_tokenName;
    string public s_tokenSymbol;
    uint256 public constant MAX_SUPPLY = 1000000;

    uint256 public s_totalSupply;
    address public s_owner;
    uint8 public s_tokenDecimal;

    mapping(address account => uint256 balance) private balances;

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 decimal
    ) {
        s_tokenName = _tokenName;
        s_tokenSymbol = _tokenSymbol;
        s_tokenDecimal = decimal;
        s_owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner, "ONLY_OWNER");
        _;
    }

    function mint(address _account, uint256 _amount) public onlyOwner {
        if (_amount <= 0) revert("CANNOT_MINT_ZERO_VALUE");
        uint256 tempSupply = s_totalSupply + _amount;
        if (tempSupply > MAX_SUPPLY) revert("MAXIMUM_TOKEN_SUPPLY_REACHED");

        s_totalSupply = s_totalSupply + _amount;
        balances[_account] = balances[_account] + _amount;
    }


    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) external returns (bool){
        if (_to == address(0) || msg.sender == address(0)) revert("ZERO_ADDRESS_NOT_ALLOWED");
        if (s_totalSupply < balances[msg.sender]) revert("BALANCE_MORE_THAN_TOTAL_SUPPLY");

        uint256 initBal = balances[msg.sender];
        if (initBal < _value) revert("INSUFFICIENT BALANCE");

        balances[msg.sender] = initBal - _value;
        balances[_to] = balances[_to] + _value;

        assert(balances[msg.sender] == (initBal - _value));

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function burn(uint96 _amount) external {
        if (msg.sender == address(0)) revert("ZERO_ADDRESS_NOT_ALLOWED");
        if (balances[msg.sender] <= 0) revert("CANNOT_BURN_ZERO_TOKEN");
        if (balances[msg.sender] < _amount) revert("YOU CANNOT BURN WHAT YOU DO NOT HAVE");

        balances[msg.sender] = balances[msg.sender] - _amount;
        s_totalSupply = s_totalSupply - _amount;

        balances[address(0)] = balances[address(0)] + _amount;
    }
}
