

## **Whitelisted**Crowdsale (ver 1.10.0)

화이트리스트에 있는 사용자만 크라우드 세일에 참여할 수 있는 Crowdsale

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/validation/WhitelistedCrowdsale.sol>

````
import "../Crowdsale.sol";
import "../../ownership/Ownable.sol";
````

------



#### Mapping

mapping(address => bool) public whitelist; 

------



### Modifiers

````
modifier isWhitelisted(address _beneficiary) {
    require(whitelist[_beneficiary]);
    _;
  }
````

`beneficiary`가 화이트 리스트에 있지 않으면 반환한다. 이 계약을 확장할 때 사용할 수 있다.



------



### Functions



##### addToWhitelist 

````
function addToWhitelist(address _beneficiary) external onlyOwner {
    whitelist[_beneficiary] = true;
  }
````

화이트리스트에 단일 주소를 추가한다.

**Parameters** : 화이트리스트에 추가할 주소



##### addManyToWhitelist

````
 function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
    for (uint256 i = 0; i < _beneficiaries.length; i++) {
      whitelist[_beneficiaries[i]] = true;
    }
  }
````

화이트리스트에 주소 목록을 추가한다. 트러플 테스팅 제한으로 인하여 오버로드 하지는 않았다.

**Parameters** : 화이트리스트에 추가된 주소들



##### removeFromWhitelist 

````
function removeFromWhitelist(address _beneficiary) external onlyOwner {
    whitelist[_beneficiary] = false;
  }
````

화이트리스트에 등록된 단일 주소를 제거합니다.

**Parameters** : 화이트리스트에 제거할 주소들



##### _preValidatePurchase

````
function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal   		
	isWhitelisted(_beneficiary) {
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }
````

beneficiary가 화이트리스트에 들어가기위한 선수작업