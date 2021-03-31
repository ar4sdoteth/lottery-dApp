// SPDX-License-Identifier: CPL-1.0

pragma solidity ^0.8.3;

contract Lottery {
  address public admin;
  address[] public players;
  
  constructor () {
    admin = msg.sender;
  }

  modifier onlyadmin {
    require(msg.sender == admin, "You need to be the admin to pick a winner");
    _;
  }
  
  function enter() public payable {
    // Second argument is the error that's thrown
    require(msg.value > 0.01 ether, "Minimum of 0.01 ETH required");
    
    players.push(msg.sender);
  }

  function pseudoRandom() private view returns (uint) {
    // Uses three values to create a hash that is stored
    // as a pseudo-random uint256
    return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
  }

  function pickWinner() public onlyadmin {
    // Chooses an element/address from players array
    uint index = pseudoRandom() % players.length;

    // Assigns address as payable and transfers
    // the contracts entire balance
    payable(players[index]).transfer(address(this).balance);

    // Clears the players array to reset the game
    players = new address[](0);
  }
}

// add chainlink random number generation