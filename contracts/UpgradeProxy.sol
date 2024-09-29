// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract InscriptionToken is ERC20 {
    address public factory;

    constructor(address _factory, string memory name, string memory symbol) ERC20(name, symbol) {
        factory = _factory;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == factory, "Only factory can mint");
        _mint(to, amount);
    }
}

contract FactoryV2 {
    event TokenCreated(address token, string symbol, uint totalSupply, uint perMint, uint price);

    function deployInscription(string memory symbol, uint totalSupply, uint perMint, uint price) public {
        address token = address(new InscriptionTokenProxy(address(this), totalSupply));
        InscriptionToken(token).mint(msg.sender, totalSupply);
        emit TokenCreated(token, symbol, totalSupply, perMint, price);
    }

    function mintInscription(address tokenAddr, uint price) public payable {
        InscriptionToken token = InscriptionToken(tokenAddr);
        require(msg.value >= price, "Not enough ether sent");
        token.mint(msg.sender, 1);
    }
}

contract InscriptionTokenProxy is InscriptionToken {
    constructor(address _factory, uint totalSupply) InscriptionToken(_factory, "Inscription Token", "INS") {
        _mint(msg.sender, totalSupply);
    }
}