pragma solidity ^0.4.9;

contract entropy{

    function entropy_calculate(uint8 _c, uint256 _salt) public pure returns(bytes32) {
        return keccak256(_c,_salt);
    }
}
