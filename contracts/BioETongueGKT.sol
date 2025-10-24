// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BioETongueGKT {
    string public name = "Bio e-Tongue GKT Rewards";
    string public symbol = "BET-GKT";
    uint256 public totalSupply = 1_000_000_000 * 10**18; // 1B
    address public xAIAdmin;
    uint256 public constant TAX_RATE = 2;

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public stakedBalance;

    event Mint(address indexed to, uint256 value, string reason); // e.g., "Test cycle"
    event Burn(address indexed from, uint256 value, string cause); // e.g., "Nutrition fund"

    constructor() {
        xAIAdmin = msg.sender;
        balanceOf[xAIAdmin] = totalSupply;
    }

    // Mint for testers (Anu-led)
    function mintForTest(address user, uint256 amount, string memory reason) public {
        require(msg.sender == xAIAdmin, "Only xAI");
        balanceOf[user] += amount;
        emit Mint(user, amount, reason);
    }

    // Burn for philanthropy
    function burnForCause(uint256 amount, string memory cause) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Burn(msg.sender, amount, cause);
    }

    // Transfer with tax
    function transfer(address to, uint256 amount) public returns (bool) {
        uint256 tax = (amount * TAX_RATE) / 100;
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += (amount - tax);
        balanceOf[xAIAdmin] += tax / 2; // Rewards
        totalSupply -= tax / 2; // Burn
        return true;
    }

    // Score test contribution (Grok hook)
    function scoreTest(string memory data) external view returns (uint256) {
        return bytes(data).length > 50 ? 100 * 10**18 : 10 * 10**18; // 100 GKT for detailed
    }
}
