

## IndividuallyCappedCrowdsale (ver 1.10.0)

사용자마다 Cap가 있는 컨트랙트

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/validation/IndividuallyCappedCrowdsale.sol >

````
import "../../math/SafeMath.sol";
import "../Crowdsale.sol";
import "../../ownership/Ownable.sol";
````

------



#### Mapping

````
mapping(address => uint256) public contributions;
mapping(address => uint256) public caps;
````



------



### Functions



##### setUserCap 

````
function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {
   caps[_beneficiary] = _cap;
 }
````

특정 유저의 최대 기부금을 설정하는 함수

**Parameters** : 최대금액을 설정할 주소, 개인 기부금의 최대 제한 `wei`



##### setGroupCap

````
function setGroupCap(address[] _beneficiaries, uint256 _cap) external onlyOwner {
    for (uint256 i = 0; i < _beneficiaries.length; i++) {
      caps[_beneficiaries[i]] = _cap;
    }
  }
````

그룹 유저의 최대 기부금을 설정하는 함수

그룹내 주소 각각의 cap들의 총합

**Parameters** : 최대금액이 설정된 주소들, 개인 기부금의 최대 제한 `wei`



##### getUserCap

```
function getUserCap(address _beneficiary) public view returns (uint256) {
    return caps[_beneficiary];
  }
```

그룹 유저의 cap를 반환하는 함수

**Parameters** : 확인할 cap의 주소

**Returns** : 사용자의 현재 cap를 반환한다.



##### getUserContribution

```
function getUserContribution(address _beneficiary) public view returns (uint256) {
    return contributions[_beneficiary];
  }
```

지금까지의 특정 유저가 기부한 금액을 반환하는 함수

**Parameters** : 기부자의 주소

**Returns** : 유저가 지금까지 기부한 금액



##### _preValidatePurchase 

````
function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
    super._preValidatePurchase(_beneficiary, _weiAmount);
    require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
  }
````

기부하려는 금액이 유저의 cap보다 크면 안됨



##### _updatePurchasingState 

````
 function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
    super._updatePurchasingState(_beneficiary, _weiAmount);
    contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
  }
````

유저가 기부한 금액을 update한다