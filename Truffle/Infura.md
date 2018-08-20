### 인퓨라

인퓨라는 Geth같은 이더리움 클라이언트를 이용하지 않고도 테스트넷이나 메인넷에 계약을 배포할 수 있는 서비스이다. 게스로도 계약을 배포할 수 있지만, 각 네트워크의 블록체인과 동기화 하려면 많은 시간과 디스크 용량이 소모되기 때문이다.



**truffle.js**에 아래와 같은 정보를 업데이트 한다.

```
var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "여기 안에 메타마스크로 부터 가져온 씨드 복사";
var accessToken = "여기 안에 API키 복사";

/// 네트워크 {} 안에 넣는다.
ropsten: {
      provider:function() {
        return new HDWalletProvider(
          mnemonic,
          "https://ropsten.infura.io/"  + accessToken
        );
      },
      network_id: 3,
      gas: 500000
    }
```

HDWalletProvider라는 라이브러리르 사용할 것이다.  인자로 mnemonic과 인프라 노드를 사용하기 위한 사이트주소와 API키를 명시해야 한다.

HDWalletProvider이 mnemonic을 통해 메타마스크 계정을 불러온다.(첫 번째 계정으로 배포)



**mnemonic 가져오기**

1. 메타마스크 접속 setting - > reveal Seed Words -> 비밀번호 입력 하고 씨드 복사하기

   [인퓨라 공식 사이트](https://infura.io/)에 접속하여 GET STARTED FOR FREE

2. 프로잭트 만들기 하면 자동으로 API 키가 생성된다. 그것을 복사하여 주소뒤에 붙여 넣는다.



**HDWallet 라이브러리 이용하기** (관리자 권한)

해당 프로젝트 위치에가서 아래 명령어를 친다.

```
npm install truffle-hdwallet-provider
```

> hdwallet을 다운 받기 전에, windows SDK 8.1을 먼저 다운받아야 함
>
> npm을 통해서 받을 수 있음(관리지 권한으로)
>
> 아래 명령어는 파워셸에서 전역으로 실행가능
>
> ```
> npm install --global --production windows-build-tools
> ```
>
> 위에 명령어를 안쳣다면 hdwallet을 설치하기 전에 실행하자! 설치하는데 오류가 나면 재부팅후 실행하자!



이후 아래 명령어로 컴파일과 배포하기

 ```
truffle migrate --compile-all --reset --network ropsten
 ```

트랜잭션이 정상적으로 완료된후, 아티팩트도 network부분에 주소와 트랜잭션 해시가 업데이트되어있다.