pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol";

contract ERC1155Splitter is ERC1155 {
    mapping(bytes32 => address) public erc20Token;
    mapping(bytes32 => uint256) public erc20Supply;

    function split(bytes32 _tokenId, uint256 _amount) public {
        require(balanceOf(msg.sender, _tokenId) >= _amount, "Insufficient balance.");
        require(_amount > 0, "Invalid amount.");

        address _erc20 = erc20Token[_tokenId];
        require(_erc20 != address(0), "Token is not splittable.");

        erc20Supply[_tokenId] += _amount;
        ERC20(_erc20).transfer(msg.sender, _amount);
        safeSubtract(msg.sender, _tokenId, _amount);
    }

    function setSplittable(bytes32 _tokenId, address _erc20) public {
        require(erc20Token[_tokenId] == address(0), "Token is already splittable.");
        require(ERC20(_erc20).balanceOf(address(this)) == 0, "ERC20 contract should be empty.");
        erc20Token[_tokenId] = _erc20;
    }
}
