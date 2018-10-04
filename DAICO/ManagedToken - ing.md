

## **ManagedToken**

issue와 destory기능이 있는 erc20 호환 토큰, 모든 transfer를 모니터링 할 수 있다.

https://github.com/theabyssportal/DAICO-Smart-Contract/blob/master/token/ManagedToken.sol

````
import '../ownership/MultiOwnable.sol';
import './ERC20Token.sol';
import './ITokenEventListener.sol';
````

------

#### Variables

```javascript
bool public allowTransfers = false;
bool public issuanceFinished = false;

ITokenEventListener public eventListener;
```



#### event

```
event AllowTransfersChanged(bool _newState);
event Issue(address indexed _to, uint256 _value);
event Destroy(address indexed _from, uint256 _value);
event IssuanceFinished();
```



#### Modifier

```javascript
modifier transfersAllowed() {
    require(allowTransfers);
    _;
}

modifier canIssue() {
    require(!issuanceFinished);
    _;
}
```



------



### Functions



##### setAllowTransfers

오너에 의해서 사용 가능하거나 가능하지 않은 토큰을 transfer 할 수 있음

````javascript
function setAllowTransfers(bool _allowTransfers) external onlyOwner {
    allowTransfers = _allowTransfers;
    AllowTransfersChanged(_allowTransfers);	//이벤트 발생
}
````


