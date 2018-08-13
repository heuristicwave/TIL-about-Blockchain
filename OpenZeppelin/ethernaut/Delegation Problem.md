문제에 해설에 들어가기 전,  이번 포스팅은 이더넛 내에서 콘솔창과 상호작용을 할 줄 알고 기본적인 리믹스 및 메타마스크 사용법이 숙지되어 있다는 가정하에 해설을 진행합니다. 사실 이번 문제에서 완벽하게 풀이가 맞은 것은 아니지만 다음단계로 넘어 갈 수 잇는 방법을 소개하겠습니다.



## Delegation Problem

주어진 객체의 오너가 되어보는 문제다.

low level의 함수 delegatecall은 다른 컨트랙트를 호출하는 메소드이다.

어떤 역할을 하는지 궁금하다면 아래링크가 도움이 될 것이다.

<a href=http://ihpark92.tistory.com/54?category=747041 >



문제에 들어가기전 우리는 `Fallback methods`와 `Method ids`라는 힌트 키워드를 숙지하고 주어진 소스코드를 분석해보자!

```javascript
pragma solidity ^0.4.18;

contract Delegate {

  address public owner;

  function Delegate(address _owner) public {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  function Delegation(address _delegateAddress) public {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  function() public {
    if(delegate.delegatecall(msg.data)) {
      this;
    }
  }
}
```



 **Delegate **컨트랙트의 오너 권한을 탈취해야 하는데 오너 권한을 바꾸는 `pwn()`함수가 눈에 들어온다. 또 **Delegation** 컨트랙트에서 `msg.data`를 주목하자. 여기까지만 읽고 감이 온다면, 그 감이 거의 맞을 것이다.

**msg.data**에는 함수의 시그니처를 넣을 수 있는데, 그 시그니처는 sha3해시 값의 첫 8byte를 의미한다. 즉, 우리는 코드를 만나기전에 힌트로 주어진 Delegation컨트랙트의 fallback함수를 호출하여 msg.data에 `Method ids`라는 힌트였던 pwn() 함수의 시그니처를 넣어 부른다면 owner를 바꿀 수 있을 것이다.

이제 본격적으로 문제를 풀어보자!

리믹스에 주어진 소스코드를 복사한 후, 버전에 맞는 컴파일러를 지정하고 컴파일을 하자.

이 후, 리믹스의 Compile 탭에서 Details 버튼을 눌러 아래와 같은 화면을 찾으면 pwn()함수의 FunctionHashes를 찾을 수 있다. 우리는 `dd365b8b`를 메타마스크 전송 시에 사용할 것이니 기억해 두자. 

![](C:\Users\Admin\Documents\GitHub\TIL-about-Blockchain\img\delegate01.png)

fallback 함수를 실행하기 위해서 **Get new instance**를 누른 후 지급되는 instance 주소를 리믹스에서 불러와 Delegation컨트랙트를 컴파일 하기 전에 타겟이 될 delegate컨트랙트의 주소를 넣어서 배포한다.



![](C:\Users\Admin\Documents\GitHub\TIL-about-Blockchain\img\delegate02.png)

대상에는 fallback 함수를 호출할 delegation컨트랙트의 CA주소가 들어가고 아까 알아둔 pwn()의functionhashes를 메타마스크의 `Hex Data`부분에 0x를 붙여서 충분한 가스 수수료를 주고 배포한다.

정상적으로 작동한다면, 위 작업 이후 Delegate 컨트랙트의 owner를 확인 하면 Delegation 컨트랙트를 배포한 나의 주소가 owner로 나와야 한다. 하지만, 여러번의 실험을 통해 충분한 가스를주었음에도 이더스캔내에서 Out of Gas 문제가 발생하여 owner를 바꾸는데 실패 했다.

위 풀이법에 대한 로직과 설명은 < a href = https://medium.com/@ihcho131313/%EC%8A%A4%EB%A7%88%ED%8A%B8-%EC%BB%A8%ED%8A%B8%EB%A0%89%ED%8A%B8-%EB%B3%B4%EC%95%88-6%EA%B0%9C%EC%9D%98-%EC%86%94%EB%A6%AC%EB%94%94%ED%8B%B0-%EC%B7%A8%EC%95%BD%EC%A0%90-%EB%B0%8F-%EA%B7%B8%EC%97%90-%EB%8C%80%ED%95%9C-%EB%8C%80%EB%B9%84%EC%B1%85-%ED%8C%8C%ED%8A%B8-1-f4f32d19a558 > 에서도 확인 할 수 있다.

그러나 메타마스크에서 보낼 주소에 Delegation의 CA가아닌 Delegate의 CA를 기입하고 같은 방법으로 Hex Data를 채워 배포 한 후에 오너를 확인하면 나의 주소로 바뀌는 것을 확인 할 수 있다. 얼떨결에 다음 단계로 진입하게 되었지만, Ouf of Gas 문제가 발생하는 정확한 이유를 아시는 분은 설명해주시면 고맙겠습니다.

