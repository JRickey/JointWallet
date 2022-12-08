# JointWallet
An ether wallet that can have multiple co owners

Upon instantiation the wallet only has two, msg.sender and the specified coowner

any owner can send any amount of ether to the contract and withdraw any amount of ether the contract owns.

the initial deployer is the only owner that can set a new co-owner besides themself.

the inital deployer can transfer ownership of the contract to a new owner
