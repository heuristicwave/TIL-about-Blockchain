문제 해설에 들어가기 전,  이더넛 내에서 콘솔창과 상호작용을 할 줄 알고 기본적인 리믹스 및 메타마스크 사용법이 숙지되어 있다는 가정 하에 해설을 진행합니다. 필자의 풀이 방법이 절대적은 풀이 방법은 아니므로 이 점 참고하시기 바랍니다.

![대표이미지](https://github.com/heuristicwave/TIL-about-Blockchain/blob/master/OpenZeppelin/ethernaut/Heuristic%20Wave%20Ethernaut.png?raw=true)



## Denial Problem



이것은 시간이 지날수록 자금이 떨어지는 간단한 지갑이다.  인출 파트너가되면 천천히 자금을 인출할 수 있다. 만약 owner가 withdraw()를 호출할 때, 돈을 인출하는 것을 막을수 있다면, 이번 단계를 해결 할 수 있다.



### 코드 분석



#### Denial.sol

```javascript
contract Denial {

    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = 0xA9E;
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance/100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call.value(amountToSend)();
        owner.transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = now;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    function() payable {}

    // convenience function
    function contractBalance() view returns (uint) {
        return address(this).balance;
    }
}
```

0xed58be6f23c0005907f5f65840b0bebfb58138f0





### 문제 풀이 과정



```
contract.revise('35707666377435648211887908874984608119992236509074197713628505308453184860938', '0x000000000000000000000000344FbEe17c2d215D364EC5943Bc4a0c7030cfaA1', {from:player, gas: 900000});
```

index의 위치를 정확하게 알앗기 때문에 위 코드를 콘솔창에 넣어 트랜잭션을 발생시키면, 아래와 같이 첫번째 슬롯을 조회 했을때 내 주소로 변경한 것을 확인 할 수 있다.

![alienCodex03](https://github.com/heuristicwave/TIL-about-Blockchain/blob/master/img/alienCodex03.png?raw=true)

이제 문제를 제출하면 끝!



3달전 마지막으로 19번 문제를 풀고 기말고사 준비로 손을 놓고 있다보니, 다시 머리를 쓰기가 무척이나 힘들었다. (이게 다 게으름 때문이지만...) 하루에 2시간씩 고민하며, 20번 문제해설을 작성하다보니 거의 2주가 걸렸다. 최근 들어 구글링을 해보니 나 말고도 문제풀이를 올리시는 분들이 보이기 시작했다. 어서 빨리 나도 연재를 끝내야지....  3달 동안 내 실력도 많이 늘어 이전문제에 대한 풀이 방법이 부끄럽게 느껴진다. 



21번 문제 Denial에서 만나요!