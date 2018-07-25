

## IncreasingPriceCrowdsale  (ver 1.10.0)

토큰 가격을 시간에 따라 지속해서 올리는 Crowdsale. 생성자에게 최초, 최종 비율과  `wei`당 기부된 토큰의 양을 제공해야한다. 그러므로, 초기비율은 최종비율보다 커야 한다.

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/price/IncreasingPriceCrowdsale.sol>

````
import "../validation/TimedCrowdsale.sol";
import "../../math/SafeMath.sol";
````

------



#### Variable

uint256 public initialRate;

uint256 public finalRate; 



------



### Constructor

생성자는 `wei`기부금 당 최초, 최종 비율을 받는다.

````
constructor(uint256 _initialRate, uint256 _finalRate) public {
  require(_initialRate >= _finalRate);
  require(_finalRate > 0);
  initialRate = _initialRate;
  finalRate = _finalRate;
}
````

**Parameters** : 초기 `wei`당 구매자가 받는 토큰의 수, 끝날 무렵 `wei` 당 구매자가 받는 토큰의 수

------



### Functions



##### getCurrentRate 

````
function getCurrentRate() public view returns (uint256) {
  // solium-disable-next-line security/no-block-members
  uint256 elapsedTime = block.timestamp.sub(openingTime);	//흐른시간 = 타임스탬프 - 오픈시간
  uint256 timeRange = closingTime.sub(openingTime);	// 시간간격 = 클로징 - 오프닝
  uint256 rateRange = initialRate.sub(finalRate);	// 비율간격 = 초기 비율 - 마지막 비율
  return initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
}

````

현재 시간에 `wei`당 받는 토큰의 비율을 리턴하는 함수

**Returns** : 주어진 시간에 구매자가 `wei`당 받는 토큰의 수



##### _getTokenAmount

````
function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
  uint256 currentRate = getCurrentRate();
  return currentRate.mul(_weiAmount);
}
````

**Parameters** : 토큰으로 변환할  `wei`의 값

**Returns** : 현재 시간의 비율에 맞추어 받는 토큰의 양