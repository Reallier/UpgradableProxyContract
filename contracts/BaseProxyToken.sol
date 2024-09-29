// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract InscriptionToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract Factory {
    event TokenCreated(address token, string symbol, uint totalSupply, uint perMint);

    function deployInscription(string memory symbol, uint totalSupply, uint perMint) public {
        InscriptionToken token = new InscriptionToken("Inscription Token", symbol);
        token.mint(msg.sender, totalSupply);
        emit TokenCreated(address(token), symbol, totalSupply, perMint);
    }

    function mintInscription(address tokenAddr) public {
        InscriptionToken token = InscriptionToken(tokenAddr);
        token.mint(msg.sender, 1);
    }
}