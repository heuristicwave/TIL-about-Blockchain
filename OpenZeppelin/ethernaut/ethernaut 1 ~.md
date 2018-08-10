### Fallback

시큐리티 코딩을 위한 fallback 함수의 고려 사항



### Fallout

생성자는 한번만 실행되고 이후에 되면 안됨

=> 생성자가 매우 중요하기 때문에 함수 이름에 대한 오류를 예방하기 위해서 construct생김



### Random

블록체인 상에서의 난수 생성의 어려움

- 블록체인 상에서 얻을 수 있는 blockhash, timestamp 등을 난수 생성 시드로 사용하게 된다면, 예측이 가능.
- 난수 생성을 위해서는 외부의 오라클을 이용해서 생성



'+ public으로 선언했기 때문에 외부 공격을 받는다 가시성!



msg.sender : 호출한 스마트 컨트랙트의 주소 

tx.orgin : 내가 다른컨트래에서 내자신의 eoa



### Delegation

delegatecall은 현재 data를 변경함

Delegation 컨트랙트에서 ownership을 빼앗음

delegatecall은 lowlevel 함수

delegate의 pwn을 통해서 owner를 바꾼다

`FUNCTIONHASHES`에서 4bytes로 잘린것들을 msg.data로 넣으면

delegatacall을 통해서 해당 함수들을 실행할 수 있다.

fallback을 실행하면, 실행할 때 msg.sender가 owner로 바뀌게 되어있다.



call은 delegate 컨트랙트의 owner가 바뀌지만, delegatecall은 현재 내 자신의 값이 바뀐다

```

```

