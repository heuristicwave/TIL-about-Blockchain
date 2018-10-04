

## LockedTokens

일정기간 동안 토큰을 Lock 할 수 있다

https://github.com/theabyssportal/DAICO-Smart-Contract/blob/master/token/LockedTokens.sol

````
import '../math/SafeMath.sol';
import './IERC20Token.sol';
````

------



#### struct

```javascript
struct Tokens {
    uint256 amount;
    uint256 lockEndTime;	// lock이 끝나는 시간
    bool released;
}
```



#### event

event TokensUnlocked(address _to, uint256 _value);



#### Variables

생성자에서 인자값으로 정해줌

```javascript
IERC20Token public token;
address public crowdsaleAddress;
```



#### Mapping

주소를 Tokens 구조체 배열로 보관함

````
mapping(address => Tokens[]) public walletTokens;
````



------



### Functions



##### addTokens 

토큰을 잠그는 함수

````javascript
function addTokens(address _to, uint256 _amount, uint256 _lockEndTime) external {
    require(msg.sender == crowdsaleAddress);
    walletTokens[_to].push(Tokens({amount: _amount, lockEndTime: _lockEndTime, released: false}));
}
````

##### Parameters

_to : _lockEndTime 이후로 토큰을 전송할 지갑 주소

_amount : lock된 토큰의 양

_lockEndTime : lock 기간이 끝나는 시간



##### releaseTokens

lock된 토큰의 owner에 의해서 release

````javascript
 function releaseTokens() public {
    require(walletTokens[msg.sender].length > 0);

    for(uint256 i = 0; i < walletTokens[msg.sender].length; i++) {
        if(!walletTokens[msg.sender][i].released && now >= walletTokens[msg.sender][i].lockEndTime) {
            walletTokens[msg.sender][i].released = true;
            token.transfer(msg.sender, walletTokens[msg.sender][i].amount);// 이때 전송
            TokensUnlocked(msg.sender, walletTokens[msg.sender][i].amount);
        }
    }
}
````
