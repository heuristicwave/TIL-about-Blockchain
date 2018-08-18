문제 해설에 들어가기 전,  이번 포스팅은 이더넛 내에서 콘솔창과 상호작용을 할 줄 알고 기본적인 리믹스 및 메타마스크 사용법이 숙지되어 있다는 가정 하에 해설을 진행합니다.



## Re-entrancy Problem

이번 문제의 목표는 컨트랙트에 모인 funds를 탈취하는 것이다. 우선 힌트를 확인해보자

- 신뢰할 수 없는 컨트랙트에서는 예상치 못한 곳에서 코드가 실행된다
- Fallback 함수
- Throw/revert Bubbling
- 다른 컨트랙트로 공격하기
- 콘솔 창 활용하기



### 취약점 분석

```javascript
pragma solidity ^0.4.18;

contract Reentrance {

  mapping(address => uint) public balances; // 주소별로 잔액을 관리
  // 기부를 받을 때, 호출되는 함수
  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }
  // 잔액을 체크하는 함수
  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }
  // 인출 함수
  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  function() public payable {}
}
```

아내는 방법은 필자의 [Delegation Problem](https://steemit.com/ethereum/@heuristicwave/delegation-problem) 에서 설명해 두었다.

> - 



다음번에는 11단계 Elevator에서 만나요!