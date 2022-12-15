// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAccess {
    function getSignatories() external view returns(address[] memory);
    function getIsSignatories(address _add) external view returns(bool);
}

contract MultiSig{
    address[] signatories;
    bool public isSignatories;
    address AccessContract;
    struct transaction{
        address from;
        address payable to;
        uint value;
        bool executed;
    }
    transaction[] public transactions;
    mapping(uint=>mapping(address=>bool))public approve;
    receive() external payable {}
    function getContract(address _add) public returns (address[] memory){
        AccessContract=_add;
       signatories= IAccess(_add).getSignatories();
       isSignatories=IAccess(_add).getIsSignatories(msg.sender);
       return signatories;
    }
    function getSignatories()public view returns (address[] memory){
        return signatories;
    }
    modifier onlySignatories(){
        require(isSignatories,"You are not among Signatories");
        _;
    }


    modifier txExists(uint _txId){
        require(_txId<transactions.length,"Transaction does not exist");
        _;
    }

    modifier txNotApproved(uint _txId){
        require(!approve[_txId][msg.sender],"Transaction already approved");
        _;
    }

    modifier txNotExecuted(uint _txId){
        require(!transactions[_txId].executed,"Transaction already executed");
        _;
    }
    function getContractBalance()external view returns (uint){
        return address(this).balance;
    }
    function submitTransaction(address payable _to,uint _value) public {    
        transactions.push(transaction({
            from: msg.sender,
            to: _to,
            value:_value,
            executed: false
        }));
        }
    function removeTransaction(uint _txId) onlySignatories txNotExecuted(_txId) external {
        delete transactions[_txId];
        for(uint i; i<signatories.length;i++){
            approve[_txId][signatories[i]]=false;
        }
    }
    function approveTransaction(uint _txId) external onlySignatories 
    txExists(_txId)
    txNotApproved(_txId)
    txNotExecuted(_txId) 
    {
        approve[_txId][msg.sender]=true;
        ExecuteTransaction(_txId);
    }

    function ExecuteTransaction(uint _txId) public txNotExecuted(_txId){
        uint count;
        for(uint i;i<signatories.length;i++){
            if(IAccess(AccessContract).getIsSignatories(signatories[i]) && approve[_txId][signatories[i]]){
                count++;
                }
            }
        uint percentage= 100*count/signatories.length;
        
        if(percentage>=60){
            transaction storage transact = transactions[_txId];
            transact.to.transfer(transact.value*(10**18));
            transact.executed=true;
        }

    }
}