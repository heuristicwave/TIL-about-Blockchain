

## MultiOwnable.sol

오너의 주소와 기본적인 권한 관리를 제어한다

https://github.com/theabyssportal/DAICO-Smart-Contract/blob/master/ownership/MultiOwnable.sol



#### Variable

address public manager;	// 처음에 설정한 오너의 주소

addrsss[] public owners;	



#### event

SetOwners : 오너가 배열에 들어갈때마다 이벤트 발생



#### modifier

mapping에서 onlyOwner()를 호출한주소의 상태값이 true여야지만 실행가능

------



### Functions



##### setOwners 

````javascript
function setOwners(address[] _owners) public {
	require(msg.sender == manager);
    _setOwners(_owners);
}
````

require문 해당하면 _setOwners 호출



##### _setOwners

````javascript
function _setOwners(address[] _owners) internal {
    for(uint256 i = 0; i < owners.length; i++) {
        ownerByAddress[owners[i]] = false;
    }

    for(uint256 j = 0; j < _owners.length; j++) {
        ownerByAddress[_owners[j]] = true;
    }
    owners = _owners;
    SetOwners(_owners);
}
````

이친구는 내부함수에서 밖에 못부름 즉, setOwner함수를 통해서만 부를 수 있고, manager만 호출할 수 있다.

근데 이상하네,,,,



#### getOwners

owners를 보여줌

```javascript
function getOwners() public constant returns (address[]) {
    return owners;
}
```

