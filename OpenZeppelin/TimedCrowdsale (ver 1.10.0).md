

## TimedCrowdsale (ver 1.10.0)

일정 기간내에 기부금을 받는 Crowdsale

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/validation/TimedCrowdsale.sol >

````
import "../../math/SafeMath.sol";
import "../Crowdsale.sol";
````

------



#### Variable

uint256 public openingTime;

uint256 public closingTime;

------



### Modifiers

````
  modifier onlyWhileOpen {
    // solium-disable-next-line security/no-block-members
    require(block.timestamp >= openingTime && block.timestamp <= closingTime);
    _;
  }
````

크라우드 세일 기간이 아니면 반환한다.



### Constructor

(uint256 _openingTime, uint256 _closingTime) 

오픈시간은 블록타임스탬프보다 이우의 시간이고 클로징타임은 오픈시간 이후여야 통과한다

------



### Functions



##### hasClosed 

````
function hasClosed() public view returns (bool) {
    // solium-disable-next-line security/no-block-members
    return block.timestamp > closingTime;
  }
````

크라우드 세일의 열린기간이 이미 경과 되었는지 체크하는 함수

**Returns** : 세일 기간이 경과되었는지 여부



##### _preValidatePurchase

````
function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }
````

이게 여기서 왜 잇어야 하는지 모르겠음

(Extend parent behavior requiring to be within contributing period ) // 

**Parameters** : 토큰으로 구입자, 기부할 `wei`의 양