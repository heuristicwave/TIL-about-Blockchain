

## PostDeliveryCrowdsale (ver 1.10.0)

크라우드세일이 종료될때 까지, 인출할수 없도록 lock하는 Crowdsale

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol>

````
import "../validation/TimedCrowdsale.sol";
import "../../token/ERC20/ERC20.sol";
import "../../math/SafeMath.sol";
````

------



#### Mapping

````
mapping(address => uint256) public balances;
````



------



### Functions



##### withdrawTokens 

````
function withdrawTokens() public {
    require(hasClosed());	// Conditions
    uint256 amount = balances[msg.sender];
    require(amount > 0);
    balances[msg.sender] = 0;	// Effects
    _deliverTokens(msg.sender, amount); // Interactions
  }
````

크라우드 세일 종료 후에 토큰을 인출 한다.



##### _processPurchase

````
function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
    balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
  }
````

즉시 토큰을 발행하는 대신에 balances를 저장하여 부모를 오버라이딩한다.

**Parameters** : 토큰 구매자 / 구입한 토큰의 양