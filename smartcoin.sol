pragma solidity ^0.4.19;

import "./Ownable.sol";

import "./Entropy.sol";


contract rockpaperscissors is Ownable {
    address public j1; 
    address public j2; 
    enum Move {Null, Rock, Paper, Scissors} 
    bytes32 public c1Hash; 
    Move public c2; 
    uint256 public stake; 
    uint256 public TIMEOUT = 5 minutes; 
    uint256 public lastAction; 

    function rockpaperscissors(bytes32 _c1Hash, address _j2) public payable {
        stake = msg.value; 
        j1=msg.sender;
        j2=_j2;
        c1Hash=_c1Hash;
        lastAction=now;
    }

    function play(Move _c2) payable {
        require(c2==Move.Null); 
        require(msg.value==stake); 
        require(msg.sender==j2); 

        c2=_c2;
        lastAction=now;
    }


    function solve(Move _c1, uint256 _salt) {
        require(c2!=Move.Null); 
        require(msg.sender==j1);
        require(keccak256(_c1,_salt)==c1Hash); 

        if (win(_c1,c2))
            j1.send(2*stake);
        else if (win(c2,_c1))
            j2.send(2*stake);
        else {
            j1.send(stake);
            j2.send(stake);
        }
        stake=0;
    }

    function j1Timeout() {
        require(c2!=Move.Null); 
        require(now > lastAction + TIMEOUT); 
        j2.send(2*stake);
        stake=0;
    }

    function j2Timeout() {
        require(c2==Move.Null); 
        require(now > lastAction + TIMEOUT);
        j1.send(stake);
        stake=0;
    }


    function win(Move _c1, Move _c2) constant returns (bool w) {
        if (_c1 == _c2)
            return false;
        else if (_c1==Move.Null)
            return false;
        else if (uint(_c1)%2==uint(_c2)%2)
            return (_c1<_c2);
        else
            return (_c1>_c2);
    }

}

