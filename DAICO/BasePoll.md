

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
    require(votesByAddress[msg.sender].time == 0);	// ?

    uint256 voiceWeight = token.balanceOf(msg.sender);	// sender의 토큰양이 voiceWeight
    uint256 maxVoiceWeight = safeDiv(token.totalSupply(), MAX_TOKENS_WEIGHT_DENOM);
    // 토큰을 1000개 이상 가지고 있어도 영향력은 max 1000
    voiceWeight =  voiceWeight <= maxVoiceWeight ? voiceWeight : maxVoiceWeight;
	// user가 행사한 의견만큼 카운트가 증감됨
    if(agree) {
        yesCounter = safeAdd(yesCounter, voiceWeight);
    } else {
        noCounter = safeAdd(noCounter, voiceWeight);
    }
	// 투자의 투표시간과 투표량 동의 여부가 기록됨
    votesByAddress[msg.sender].time = now;
    votesByAddress[msg.sender].weight = voiceWeight;
    votesByAddress[msg.sender].agree = agree;
	// 총 투표자수 1씩 더함
    totalVoted = safeAdd(totalVoted, 1);
}
````

>Ternary Operator
>
>`<conditional> ? <if-true> : <if-false>



##### revokeVote

사용자  투표 철회

````javascript
function revokeVote() public checkTime {
    require(votesByAddress[msg.sender].time > 0);

    uint256 voiceWeight = votesByAddress[msg.sender].weight;	// weight가 voiceWeight
    bool agree = votesByAddress[msg.sender].agree;
	// 투표를 철회하기 위한 변수 변경
    votesByAddress[msg.sender].time = 0;
    votesByAddress[msg.sender].weight = 0;
    votesByAddress[msg.sender].agree = false;
	// 총 투표자 수에서도 빠지고 의사권을 행사한것도 빠짐
    totalVoted = safeSub(totalVoted, 1);
    if(agree) {
        yesCounter = safeSub(yesCounter, voiceWeight);
    } else {
        noCounter = safeSub(noCounter, voiceWeight);
    }
}
````



##### onTokenTransfer (모르겠다)

사용자의 투표 내용을 확인하고 수정할 수 있도록 사용자의 지갑에서 토큰을 전송한 후 함수 호출

```javascript
function onTokenTransfer(address tokenHolder, uint256 amount) public {
        require(msg.sender == fundAddress);
        if(votesByAddress[tokenHolder].time == 0) {
            return;
        }
        if(!checkTransfersAfterEnd) {
             if(finalized || (now < startTime || now > endTime)) {
                 return;
             }
        }

        if(token.balanceOf(tokenHolder) >= votesByAddress[tokenHolder].weight) {
            return;
        }
        uint256 voiceWeight = amount;
        if(amount > votesByAddress[tokenHolder].weight) {
            voiceWeight = votesByAddress[tokenHolder].weight;
        }

        if(votesByAddress[tokenHolder].agree) {
            yesCounter = safeSub(yesCounter, voiceWeight);
        } else {
            noCounter = safeSub(noCounter, voiceWeight);
        }
        votesByAddress[tokenHolder].weight = safeSub(votesByAddress[tokenHolder].weight, voiceWeight);
    }

```



##### tryToFinalize

poll을 마무리짓고  결과와 함꼐 onPollFinish를 콜백

```javascript
function tryToFinalize() public notFinalized returns(bool) {
    if(now < endTime) {	// endTime이 되기 전까지는 끝낼 수 없음
        return false;
    }
    finalized = true;	// endTime을 넘으면 종려시키고
    onPollFinish(isSubjectApproved());	// 이부분 중에서 > 뭘까?
    return true;
}
```



#### 기타 함수

```javascript
function isNowApproved() public view returns(bool) {	// 여기서는 사용 안함
    return isSubjectApproved();
}

function isSubjectApproved() internal view returns(bool) {
    return yesCounter > noCounter;
}

function onPollFinish(bool agree) internal;
```

