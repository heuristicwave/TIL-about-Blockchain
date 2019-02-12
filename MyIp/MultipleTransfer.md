## Multiple Token Transfer

https://etherscan.io/tx/0xf76b87a61ff35309aae84afa2f11714e783fbabf0192727a861bce2b8cc4c196

POC토큰의 경우, 1개의 tx당 38058 ~ 38122 (통상적인 ERC20 transfer 비용)

2개의 경우 - 148783, 3개의 경우 - 211129, 5개의 경우 - 335820

=> 즉, 21000만큼의 비용절감 효과 미미

=> 고객 1인당 영수증 1개부여 실현 X (타인의 트랜잭션이 포함됨)



**ETHMULTIPLE**

https://etherscan.io/tx/0xcbb37650b91906ffd518b9297671bf9bfa917b4302adfefc7175150eaa858e77

```
function multiSendEth(address[] addresses) public payable {
   for(uint i = 0; i < addresses.length; i++) {
     addresses[i].transfer(msg.value / addresses.length);
   }
   msg.sender.transfer(this.balance);
}
```



### When do we use multiple transactions?

=> AirDrop

[NTX Airdrop - for](https://etherscan.io/tx/0x71781f6300a7ab0869fc32710e5a1af43d0721e7a4d416208648e31a98d1801e), [XSC_AirDrop - while](https://github.com/crowdstartcapital/XSC/blob/master/XSC_AirDrop_public_functions.sol)

[NTX Code](https://etherscan.io/address/0xce3708924a9a44aee5e7caad22881fdda816fd16#code)

```javascript
    function adminClaimAirdropMultiple(address[] _addresses, uint _amount) public onlyOwner {        
        for (uint i = 0; i < _addresses.length; i++)
            doAirdrop(_addresses[i], _amount);
    }
```

=> for문을 사용하여 doAirdrop을 여러번 호출,

```javascript
/// transfer
balances[msg.sender] = balances[msg.sender].sub(_amount);
balances[_to] = balances[_to].add(_amount);

emit Transfer(msg.sender, _to, _amount);

/// airdrop
balances[_participant] = balances[_participant].add(_amount);
totalDistributed = totalDistributed.add(_amount);

emit Airdrop(_participant, _amount, balances[_participant]);
emit Transfer(address(0), _participant, _amount);
```



> "Talking" to multiple untrusted contracts in a single transaction is an **anti-pattern**.
>
> From a quick glance at the contract, it appears to be wide open to DoS attack. I wouldn't recommend that pattern unless you are quite sure you understand the attack vector and there is something else mitigating the risk.
>
> by [Rob Hitchens B9lab](https://ethereum.stackexchange.com/users/5549/rob-hitchens-b9lab)



[multipleEthTransfer](https://fling.openrelay.xyz/)