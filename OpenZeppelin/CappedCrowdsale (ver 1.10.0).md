

## CappedCrowdsale (ver 1.10.0)

총 기부금에 대한 제한이 있는 Crowdsale

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/validation/CappedCrowdsale.sol>

````
import "../../math/SafeMath.sol";
import "../Crowdsale.sol";
````

------



#### Variable

uint256 public cap;

기부할 최대 `wei`의 양

------



### Constructor

(uint256 _cap) 

cap이 0보다 커야 통과

------



### Functions



##### capReached 

````
function capReached() public view returns (bool) {
    return weiRaised >= cap;
  }
````

**Returns** : 총 모금된 weiRaised가 cap보다 크면  반환한다.



##### _preValidatePurchase

````
function _preValidatePurchase( address _beneficiary, uint256 _weiAmount ) internal {
    super._preValidatePurchase(_beneficiary, _weiAmount);
    require(weiRaised.add(_weiAmount) <= cap);
  }

````

구입시 미리 유효성을 검증하는 함수, 내가 기부하려는 금액을 현재까지 모인 `wei`에 더하였을때 cap보다 크다면 반환된다.

**Parameters** : 토큰으로 구입자, 기부할 `wei`의 양
