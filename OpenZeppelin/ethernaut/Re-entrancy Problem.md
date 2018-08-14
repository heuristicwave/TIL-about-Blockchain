문제 해설에 들어가기 전,  이번 포스팅은 이더넛 내에서 콘솔창과 상호작용을 할 줄 알고 기본적인 리믹스 및 메타마스크 사용법이 숙지되어 있다는 가정 하에 해설을 진행합니다.



## Re-entrancy Problem

이번 문제의 목표는 컨트랙트에 모인 King이 되는 것이다. 사실 코드만 보면 prize보다 큰 금액만 걸면 왕위에 오를 수 있기 때문에 무척이나 간단한 문제처럼 보인다. 실제로 단 한번의 sendTransaction을 통하여 이번 단계를 해결 할 수 있다. 그러나, Ethernaut이 말하고 싶은 문제는, **Your goal is to break it. **즉, 영원한 왕위에 오를 수 있는 방법을 구하라고 하는 것이다. 자! 이제 왕좌를 차지하러 코드속으로 들어가 보자!



> 이번 문제를 다른 단계에서 해결했던 방법대로 주어진 코드를 바로 리믹스에 복사해도 컴파일이 불가능 할 것이다. import하고 있는 Ownable.sol파일을 찾지 못해서 발생하는 문제이니,  https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.0.5/contracts/ownership/Ownable.sol (이더넛에서 0.4.18컴파일을 사용하므로, 최신 코드가 아닌 코드수정이 필요없는 Ownable을 링크)이곳에서 코드를 복사하여 함께 컴파일 하거나, 리믹스에서 Ownable.sol 파일을 미리 만들어 놓아야 한다. 



왕위를 탈취하고 영원한 왕좌를 차지하기 위해 컨트랙트 이름을 정복자라고 지었다. 정복자 컨트랙트를 나의 계정으로 배포하자.

![](C:\Users\hwave\Documents\GitHub\TIL-about-Blockchain\img\King01.png)

현재 owner와 king은 위에 명시된 주소이고, prize는 1ETH 이다. 즉, 1이더 이상을 King의 CA에 전송하면 왕이 될 수 있다.

### Conqueror.sol

```javascript
pragma solidity ^0.4.18;

contract Conqueror {
	function Conqueror() public {}

	function victory(address _king) public payable {
		_king.call.value(msg.value)();
    }

	function() public payable {
        revert();
    }
}
```

### 코드 리뷰

**victory** 함수는 인자로 받은 target 주소의 fallback 함수를 **msg.value**만큼의 금액을 전송하는 형태로 호출한다.

위 에서는 traget이 될 함수가 fallback이기 때문에 `()`상태로 두었다. 만약 target 컨트랙트에 공격대상 함수로 a()라는 함수가 있다면`(bytes4(sha3("a()")))`을 사용해서 **Methods Id**를 알아낸다. Methods Id를 리믹스에서 알아내는 방법은 필자의 [Delegation Problem](https://steemit.com/ethereum/@heuristicwave/delegation-problem) 에서 설명해 두었다.



>**bytes4(sha3("a()"))**
>
>이더리움에서는 컴파일 된 함수를, 솔리디티로 작성한 함수의 sha3 해시값 첫 4바이트를 이용하여 식별한다. 게스에서 함수를 호출할 때는 ABI가 알려져 있기 때문에 컴파일 이전의 함수명을 사용할 수 있지만, 호출할 경우에는 컴파일된 함수의 식별자를 사용해야 한다.



**call** 함수는 앞에 위치한 주소에 대해 value 인자로 지정한 금액(wei 단위)를 송금한다. 이때, value 뒤에 오는 괄호 안에 함수를 넣으면 대상 계약의 함수를 호출한다.

즉, '_king함수에 위치한 fallback함수를 msg.value만큼 전송할 금액으로 지정하며 호출한다'는 의미다.



**Fallback** 함수는 다른 누군가가 왕위를 탈취하려 할 때,  revert시켜서 그 누구도 왕좌에 오르지 못하게 한다.

---

리믹스에서 배포한 Conqueror 컨트랙트를 활용하여 target이 될 King의 주소를 넣고, Value 값에 1이더 이상의 금액을 넣고 트랜잭션을 발생시킨다.

![](C:\Users\hwave\Documents\GitHub\TIL-about-Blockchain\img\King02.png)

그러나 가스리밋과 수수료를 넉넉하게 지정해 주었음에도 불구하고, Out of gas 문제가 발생한다.

![](C:\Users\hwave\Documents\GitHub\TIL-about-Blockchain\img\King03.png)

롭슨 네트워크 상의 문제로 인식하고 그냥 King 컨트랙트에 1이더 이상의 금액을 넣어서 다음단계로 넘어가자.

---

### JavaScript VM에서 실행하기

나의 풀이법이 맞는지 점검해 보기위해서 환경만 바꿔 테스트를 진행했다.

![](C:\Users\hwave\Documents\GitHub\TIL-about-Blockchain\img\King04.png)

위와 같이 Conqueror 컨트랙트를 활용하여2이더를 전송하여 King(위 사진을 보면 킹과 오너가 다르다)이 되고 다른 주소(0x4b0....)로 King컨트랙트에 3이더 이상의 트랜잭션 발생시키면 revert처리가 된 것을 콘솔창에서 확인 할 수 있다.



이번 문제를 통하여 악의적인 의도를 가진 컨트랙트에 의해서 내가 배포한 코드가 공격을 받을 수 있다는 것을 체험했다. 또한, Fallback함수와 revert() 함수로 예외를 발생시켜 영원한 왕좌에 오르게 되면서 다른 사람들이 게임에 참여할 수 없도록 만들었다. 이것은 실제 스마트 컨트랙트로 경매에 관련된 서비스를 제공할때 위와 같은 공격에 대한 대비책이 없다면, 아무도 입찰 할 수 없는 문제를 발생시킨다. 때문에 우리는 `Condition - Effects - Interation` 패턴을 지닌 `pull형 payable`을 사용해야한다. 



### Condition - Effects - Interation

> - Condition
>
>   함수를 실행하는 조건을 확인하고 조건이 유효하지 않을 때는 처리를 중단
>
> - Effects
>
>   상태를 업데이트 (ex : 경매일 경우, 반환 금액)
>
> - Interaction
>
>   다른 컨트랙트에 메시지를 보낸다 (ex : 입찰금)



다음번에는 10단계 Re-entrancy에서 만나요!