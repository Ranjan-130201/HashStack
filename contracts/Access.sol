// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Access{
    address public admin;
    address[] signatories;
    mapping (address=>bool) public isSignatories;
    address public MultiSigContract;

    constructor(address _contract){
        admin=msg.sender;
        signatories.push(admin);
        isSignatories[admin]=true;
        MultiSigContract =_contract;
    }
    modifier onlyContractOrIsSignatories(){
        require(msg.sender==MultiSigContract || isSignatories[msg.sender],"Only MultiSigContract and Signatories have Access");
        _;
    }
    modifier onlyAdmin(){
        require(msg.sender==admin,"Only Admin Has Access");
        _;
    }
    modifier onlySignatories(address _add){
        require(isSignatories[_add],"You are not among Signatories");
        _;
    }
    function getSignatories()external onlyContractOrIsSignatories  view returns(address[] memory) {
        return signatories;
    }
    function getIsSignatories(address _add)external onlyContractOrIsSignatories view returns(bool) {
        return isSignatories[_add];
    }
    function addSignatories(address _add)external onlyAdmin{
        require(!isSignatories[_add],"Alredy among Signatories ");
        signatories.push(_add);
        isSignatories[_add]=true;
    }

    function revokeAccess(address _add)external onlyAdmin{
        require(isSignatories[_add],"Already revoked or Not among Signatories");
        isSignatories[_add]=false;
    }

    function renounceAccess()external onlySignatories(msg.sender){
        uint index;
        for(uint i;i<signatories.length;i++){
            if(signatories[i]==msg.sender){
                index=i;
            }
        }
        for(uint j=index;j<signatories.length-1;j++){
            signatories[j]=signatories[j+1];
        }
        signatories.pop();
        isSignatories[msg.sender]=false;
    }

    function transferAccess(address _transferTo) external  onlySignatories(msg.sender){
        require(isSignatories[_transferTo],"Already among signatories");
        for(uint i;i<signatories.length;i++){
            if(signatories[i]==msg.sender){
                signatories[i]=_transferTo;
            }
        }
        isSignatories[msg.sender]=false;
        isSignatories[_transferTo]=true;
    }
}