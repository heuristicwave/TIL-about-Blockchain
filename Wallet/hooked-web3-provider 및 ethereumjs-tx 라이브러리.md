### hooked-web3-provider 및 ethereumjs-tx 라이브러리

지갑의 개인 키가 다른 곳에 저장돼 있다면 geth는 개인 키를 찾을 수가 없다. 따라서 트랜잭션을 브로드캐스팅하기 위해 `web3.eth.sendRawTransaction()`메소드를 사용해야 한다.

`web3.eth.sendRawTransaction()`은 윈시 트랜잭션을 브로드캐스트하는 데 사용된다. 즉, 원시 트랜잭션을 생성하고 서명하기 위한 코드를 작성해야 한다. 이더리움 노드는 트랜잭션에 아무것도 수행하지 않고 직접 브로드캐스팅한다. 하지만 `web3.eth.sendRawTransaction()`을 사용해 트랜잭션을 브로드캐스팅 하는 것은 데이터 부분 생성, 원시 트랜잭션 생성, 트랜잭션 서명이 필요하므로 어렵다.

> Raw Transaction 원시 트랜잭션

`hooked-web3-provider`라이브러리는 HTTP를 사용해 geth와 통신하는 커스텀 공급자를 제공한다. 그리고 이 공급자는 우리의 키를 사용해 컨트랙트 인스턴스의 `sendTransaction` 호출을 서명할 수 있게 해준다. 따라서 더 이상 트랜잭션의 데이터 부분을 만들 필요가 없다. 커스텀 공급자는 실제로 `web3.eth.sendRawTransaction()` 메소드 구현 부분을 override한다. 따라서 컨트랙트 인스턴스의 **sendTransaction() **호출과**web3.eth.sendRawTransaction()** 호출을 모두 서명할 수 있다. 컨트랙트 인스턴스의  **sendTransaction() ** 메소드는 내부적으로 트랜잭션의 데이터를 생성하고 트랜잭션을 브로드캐스트 하기 위해 **web3.eth.sendRawTransaction()** 를 호출한다.

`ethereumjs-tx`는 트랜잭션과 연관된 다양한 API를 제공하는 라이브러리 중 하나다. 원시 트랜잭션을 생성하고, 서명하고, 올바른 키로 서명됐는지 여부 등을 검사 할 수 있다.

<img src = "..\img\HookedWeb3Provider.png">

1. 먼저 HookedWeb3Provider 인스턴스를 생성했다. (hooked-web3-provider 라이브러리에서 제공) **host** 는 노드의 HTTP URL이며 **transaction_signer **은 커스텀 공급자가 트랜잭션을 서명하기 위해 통신하는 객체다.

2. transaction_signer 의 hasAddress는 트랜잭션이 서명될 수 있는지, 즉 트랜잭션 서명자가 from 주소 계좌의 개인 키를 가졌는지 검사하기 위해  호출된다. 이 메소드는 주소와 콜백을 받는다. 콜백은 첫 번째 인자를 오류 메시지로, 두번째 인자를 주소의 개인 키가 발견되지 않을 경우 false로 설정해 호출돼야 한다. 개인키가 발견되면 첫 번째 인자는 null이고 두번째 인자는 true여야 한다.

3. 만약 주소의 개인 키가 있는 경우 커스텀 공급자는 트랜잭션을 서명하기 위해 signTransaction 메소드를 호출한다. 이 메소드는 트랜잭션 매개변수와 콜백이라는 2개의 인자를 가지고 있다. 메소드 내에서 먼저 트랜잭션 매개변수를 원시 트랜잭션 매개변수로 변환한다. 즉 원시 트랜잭션 매개변수 값은 16진수 문자열로 코딩돼 있다. 그런 다음 개인 키를 저장하기 위한 버퍼를 생성한다. 버퍼는 ethereumjs-util 라이브러리에 포함된 EthJS.Util.toBuffer() 메소드를 이용해 생성된다. ethereumjs-util 라이브러리는 ethereumjs-tx 라이브러리에 의해 임포트 된다. 그런 다음 rawTransaction을 생서하고 서명한 후 16진수 문자열로 변환한다. 마지막으로 서명된 Raw Transaction의 16 진수 문자열을 커스텀 공급자에게 콜백을 사용해 전달해야 한다. 이 경우 메소드 내부에서 오류가 발생하면 콜백의 첫 번째 인자는 오류 메시지여야 한다.

   <img src = "..\img\HookedWeb3Provider2.png"> 

4. 커스텀 공급자는 원시 트랜잭션을 받아들이고 `web3.eth.sendRawTransaction()`을 사용해 브로드캐스팅한다.

5. 다른 계좌로 일부 이더를 송금하기 위해 web3.eth.sendRawTransaction()함수를 호출한다. 커스텀 공급자가 논스를 계산할 수 있으므로 여기서는 논스를 제외한 모든 트랜잭션 매개변수를 제공해야 한다.

---

위 정보는 `Building Blockchain Projects : Narayan Prusty`이라는 책을보고 정리 하였습니다. 