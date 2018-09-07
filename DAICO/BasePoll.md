

## BasePoll

투표 컨트랙트의 기본 class

https://github.com/theabyssportal/DAICO-Smart-Contract/blob/master/poll/BasePoll.sol

````
import '../math/SafeMath.sol';
import '../token/IERC20Token.sol';
````

------



#### struct

```
struct Vote {
    uint256 time;
    uint256 weight;	// 가중치
    bool agree;
}
```



#### Variables

uint256 public constant MAX_TOKENS_WEIGHT_DENOM = 1000;	//  최대 가중치 액면가 즉, 최대 영향력행사

```javascript
IERC20Token public token;
address public fundAddress;

uint256 public startTime;
uint256 public endTime;
bool checkTransfersAfterEnd;

uint256 public yesCounter = 0;
uint256 public noCounter = 0;
uint256 public totalVoted = 0;

bool public finalized;
```



#### Mapping

투표한 사람의 주소를 Vote 구조체로 보관함

````
mapping(address => Vote) public votesByAddress;
````



#### Modifier

```javascript
/// now를 기준으로 시작과 끝 시간범위에 있는지 확인
modifier checkTime() {
    require(now >= startTime && now <= endTime);
    _;
}
/// finalized의 상태를 확인
modifier notFinalized() {
    require(!finalized);
    _;
}
```



------



### Functions



##### vote 

사용자 투표처리, 사용자가 제안을 지지하면 True 그렇지 않으면 False를 인자로 넣는다

````javascript
function vote(bool agree) public checkTime {
    require(votesByAddress[msg.sender].time == 0);

    uint256 voiceWeight = token.balanceOf(msg.sender);
    uint256 maxVoiceWeight = safeDiv(token.totalSupply(), MAX_TOKENS_WEIGHT_DENOM);
    voiceWeight =  voiceWeight <= maxVoiceWeight ? voiceWeight : maxVoiceWeight;

    if(agree) {
        yesCounter = safeAdd(yesCounter, voiceWeight);
    } else {
        noCounter = safeAdd(noCounter, voiceWeight);
    }

    votesByAddress[msg.sender].time = now;
    votesByAddress[msg.sender].weight = voiceWeight;
    votesByAddress[msg.sender].agree = agree;

    totalVoted = safeAdd(totalVoted, 1);
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