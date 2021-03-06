

### 트러플 프레임워크 파헤치기 2



**Unit test**

unit 이라는 가장 작은 테스트가 가능한 부분을 올바른 동작을 위해 개별적 및 독립적으로 검사하는 절차다.

트러플은 2가지 서로 다른 방법으로 간단하면서 관리 할 수 있는 테스트를 작성할 수 있게한다.

1. 자바스크립트에서는 앱 클라이언트로부터의 컨트랙트를 테스트한다
2. 솔리디티에서는  다른 컨트랙트로부터 컨트랙트를 테스트한다.

모든 테스트 파일은 ./test 내에 있어야 한다. 트러플은 **.js .es .es6 .jsx .sol**의 확장자를 가진 테스트 파일만 실행한다.



**자바스크립트 내에서 테스트 작성**

트러플의 자바스크립트 테스트 프레임워크는 mocha 위에 구축돼 있다. mocha는 테스트 작성을 위한 자바스크립트 프레임워크이며, chai는 assertion 라이브러리다.

테스트 프레임워크는 테스트를 구성하고 실행하는데 사용되며, assertion은 결과가 올바른지 검증 할 수 있는 유틸리티를 제공한다.

<a href= https://mochajs.org > < a href=http://chaijs.com >

컨트랙트 추상화는 자바스크립트로부터 컨트랙트 상호작용을 가능하게 하는 기초다.

트러플은 테스트 내에서 어떤 컨트랙트와 상호작용하는지 탐지할 방법이 없으므로, 이러한 컨트랙트를 명시적으로 요청해야 한다. `artifacts.require()`메소드를 사용해 수행한다. 즉, 테스트 파일 내에서 첫 번째로 수행돼야 하는 작업은 테스트하길 원하는 컨트랙트의 추상화를 생성하는 것이다.

이후, 실제 테스트 부분이 작성돼야 한다. 구조적으로 테스트 파일은 mocha의 테스트 파일로부터 크게 다르지 않다. 테스트 파일은 mocha가 자동화된 테스트로 인식할 수 있도록 코드가 포함돼 있어야 한다. mocha와 트러플 테스트의 차이점은 contract() 함수다. 이 함수는 트러플에게 모든 마이그레이션을 실행하도록 시그널을 보내는 것을 제외하고는 describe()와 같은 방식으로 동작한다.

- 각 contract() 함수가 실행되기 전에, 컨트랙트는 실행 중인 이더리움 노드에 재배포되므로 깨끗한 컨트랙트 상태에서 테스트가 실행된다.
- contract() 함수는 테스트 작성 시에 사용할 수 있도록 이더리움 노드로부터 사용 가능한 계좌의 목록을 제공한다.



`metacoin.js`에 MetaCoin 컨트랙트를 테스트하기 위해 트러플로부터 생성된 기본 테스트 코드가 있다.

트러플은 mocha의 설정에 접근할 수 있으므로 mocha가 동작하는 방식을 변경할 수 있다. mocha의 설정은 truffle.js파일의 내보낸 객체 내의 mocha 속성 하위에 있다.

``` javascript
mocha: {
    useColors : true
}
```



**솔리디티로 테스트 작성**

솔리디티 테스트 코드는 .sol에 저장된다.

- 솔리디티 테스트는 어떠한 컨트랙트로부터 extend 돼서는 안 된다. 가능한 최소화 해서 만들고, 작성 컨트랙트에 대한 완전한 제어를 제공해준다.
- 트러플은 기본 assert 라이브러리를 제공하지만, 필요 시 언제든지 라이브러리 변경이 가능하다.
- 어떤 이더리움 클라이언트에 대해서도 솔리디티 테스트를 실행 할 수 있어야 한다.



트러플에 의해 생성된 기본 솔리디티 테스트 코드는 `TestMetacoin.sol`에서 찾을 수 있다.

-  Assert.equal()과 같은 단언문 함수는 truffle/Assert.sol에서 제공된다. 이는 기본 단언문 라이브러리나 올바른 단언문 이벤트를 트리거함으로써 트러플의 테스트 러너와 느슨하게 통합되는 한 자신의 단언문 라이브러리를 포함 할 수 있다. 트러플 내에서 솔리디티 단언문 라이브러리의 구조  < a href = https://github.com/trufflesuite/truffle/blob/beta/lib/testing/Assert.sol >
-  배포된 컨트랙트의 주소(즉, 마이그레이션의 일부로 배포된 컨트랙트)는 truffle/DeplotedAddresses.sol 라이브러리를 통해 사용할 수 있다. 이는 트러플에 의해 제공되며 각 테스트 스위트가 실행되기 전에 재컴파일되고 재링크 된다. 이 라이브러리는 DeployedAddresses.< contract name > ()의 형태로 모든 배포된 컨트랙트에 대한 함수를 제공한다. 이는 컨트랙트에 접속하기 위해 사용할 수 있는 주소를 리턴한다.
-  모든 테스트 컨트랙트는 대문자 T를 사용한 Test로 시작해야 한다. 이는 컨트랙트를 테스트 헬퍼와 프로젝트 컨트랙트와 구별해주며, 테스트 헬퍼가 테스트 스위트를 나타내는 컨트랙트를 알 수 있도록 한다.
-  테스트 함수는 소문자 test로 시작해야 한다. 각 테스트 함수는 테스트 파일 내에 나타나는 순서에 따라 하나의 트랜잭션으로 실행된다.



---

위 web3관련 정보는 `이더리움을 활용한 블록체인 프로젝트 구축 - 나라얀 프루스티 `이라는 책을보고 정리 하였습니다. 