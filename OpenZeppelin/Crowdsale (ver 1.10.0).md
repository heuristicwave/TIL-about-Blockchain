

## Crowdsale (ver 1.10.0)

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/Crowdsale.sol >

### contract Crowdsale

````
import "../token/ERC20/ERC20.sol";
import "../math/SafeMath.sol";
````



#### Variable

ERC20 public token;

wallet : fund가 모이는 주소

rate : wei당 구매자가 얻는  토큰단위의 수, 가장작고 나눌수없는 단위의 토큰과 `wei`와의 전환 비율을 뜻한다.

ex) HolyToken(HYT)의 decimal이 3이면 , 1 wei는 1개의 단위 이거나 0.001HYT를 받는다.

weiRaised : Amount of wei raised 



#### Decimal Places: .0000000000000000001

0 ~ 18 사이의 숫자 선택 가능

- 0을 택하고 516개를 발행하면 총량은 516개
- 10을 택하고 516개를 발행하면 516,0000000000 개가 총량이 된다.



```event **TokenPurchase**(address purchaser, address beneficiary, uint256 value, uint256 amount) 
event TokenPurchase(address purchaser, address beneficiary, uint256 value, uint256 amount)
```

**Parameters**: 토큰 구입자,  토큰을 받을 사람 (who got the tokens), 구입하는데 사용한 wei, 구입한 토큰 양



```
constructor(uint256 _rate, address _wallet, ERC20 _token) public
```

**Parameters**: 토큰 단위당 wei로 환산, 수금된 자금이 모이는 지갑의 주소, 판매 중인 토큰의 주소

require : rate는 0보다 커야하고, 지갑과 토큰 주소는 0이면 안됨



### Crowdsale external interface 

@dev low level token purchase ***DO NOT OVERRIDE*** 

````
function () external payable { buyTokens(msg.sender); }
````

````
function buyTokens(address _beneficiary) public payable
````

**Parameters** : 토큰 구입을 수행하는 주소

````
uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);	// Condition

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);	// Effects

    _processPurchase(_beneficiary, tokens);
    
    emit TokenPurchase( msg.sender, _beneficiary, weiAmount, tokens );

    _updatePurchasingState(_beneficiary, weiAmount);	// Effects

    _forwardFunds();	// Interaction
    _postValidatePurchase(_beneficiary, weiAmount);
````





### Crowdsale internal interface



##### _preValidatePurchase

````
function _preValidatePurchase( address _beneficiary, uint256 _weiAmount ) internal
````

들어오는 구매의 유효성을 확인한다. 조건이 맞지 않을때는 revert를 한다. Use super to concatenate validations.



##### _postValidatePurchase

````
function _postValidatePurchase( address _beneficiary, uint256 _weiAmount ) internal
````

실행된 구매의 유효성을 확인한다. 상태를 관찰하고 유효한 조건이 아닐때 롤벡하기 위해 `revert`문을 사용한다. (근데 revert가 없네...)

**Parameters** : 토큰구매를 수행하는 주소, 구매에 사용된 `wei`의 값



------



### Functions



##### _deliverTokens

````
function _deliverTokens( address _beneficiary, uint256 _tokenAmount ) internal {
	token.transfer(_beneficiary, _tokenAmount); 
  }
````

토큰의 소스. 이 함수를 오버라이드하여 크라우드세일이 궁극적으로 토큰을 보내고 받는 방법을 수정할 수 있다.

**Parameters** : 토큰구매를 수행하는 주소, emit할 토큰의 수



##### _processPurchase 

````
function _processPurchase( address _beneficiary, uint256 _tokenAmount ) internal {
    _deliverTokens(_beneficiary, _tokenAmount);
  }
````

구매의 유효성을 확인하고 실행할 준비가 되었을 때 실행한다. 필수적으로 토큰을 emit하거나 보낼필요가 없다.



##### _updatePurchasingState

````
 function _updatePurchasingState( address _beneficiary, uint256 _weiAmount ) internal {
    // optional override
  }
````

유효성을 검사하기 위해 내부 상태를 요구하는(that require an internal state) 확장에 대한 오버라이드. (현재 사용자 기부금)



##### _getTokenAmount 

````
function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
    return _weiAmount.mul(rate);
  }
````

이더가 토큰으로 전환되는 방법을 확장하려면 오버라이드하세요.

**Parameters** : 토큰으로 변환할 `wei`의 값

**return** : 지정한 `wei`로 구입할 수 있는 토큰의 양



##### _forwardFunds 

````
function _forwardFunds() internal { wallet.transfer(msg.value); }
````

구입 시, ETH가 저장되거나 forward될 방법를 결정한다. (지갑으로 전송)