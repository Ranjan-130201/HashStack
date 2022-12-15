Contracts deployed in Goerli testnet (id = 5)
address: MultiSig: 0x5BAEcceFb1B1d915536C87fBf9E9b63Dc8Cf27f0
         Access: 0x8b8982646D127b4D64Bc79F8BcbD08F15069B419

Contract MultiSig info:
-> interface IAccess used to interact with Access Contract
-> struct array transactions stores information from user
-> function getcontract used to define signatories values
-> function getSignatories returns Signatories array
-> function submitTransaction used for adding a transaction for approval,anyone can add a transaction.
-> function removeTransaction used to delete the transaction from transactions array
-> function approveTransaction used to approve the transaction,
     the mapping approve stores the address which have approved, After every approval the  ExecuteTransaction function is called 
     if approval >  60% the transaction is executed automaticaly
-> function ExecuteTransaction used to send amt to the 'to' address.
    for loop counts the number or approvals from the access granted signatories.

Contract Access info: 
-> its the access registry
-> admin is the person who deployed the contract
-> only admin can add signatories
-> function getSignatories returns signatories array to MultiSigcontract
-> function getIsSignatories returns boolean true or false depending on the signatories access is true or revoked(false).
-> function addSignatories adds signatories, only admin has access
-> function revokeAccess sets isSignatories to false to revoke access.
-> function renounceAccess deletes the signatories from the signatories array
-> function transferAccess rewrites the signatories address to the address which the current signatories wants to transfer to. 
