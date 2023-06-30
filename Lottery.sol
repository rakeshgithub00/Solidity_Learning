// SPDX-License-Identifier: GPL-3.0
//This is Lottery contract in which participant can participate with one ether as a fee. 
//Here is one is manager who can see contract balance and can hit to find out lottery winner and collected ethers amount will be transfer to winner's account 


pragma solidity >=0.8.2 <0.9.0;

contract Lottery 
{
    address public manager;
    address payable[] public participants;   //state variable
    uint randNonce =0;

    constructor()
    {
        manager = msg.sender;   //msg global variable
    }

    receive () external payable    // two function receive and fallback function to recieve ether for contract
    {
        require(msg.value==1 ether);  // like if condition
        participants.push(payable(msg.sender));
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;   
    }

    function getRandomNumber (uint _modulus) internal returns(uint)
    {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % _modulus;
    }

    //event LogString(string message);
    event LogInteger(uint256 number);

    function selectWinner() public payable 
    {
        require(msg.sender == manager);
        emit LogInteger(participants.length);
        require(participants.length >=3 );
        uint r = getRandomNumber(participants.length);
        r = r%(participants.length);
        emit LogInteger(r);
        address payable winner = participants[r];
        winner.transfer(getContractBalance());
    }
}
