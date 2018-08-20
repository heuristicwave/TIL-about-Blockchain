

### 트러플 프레임워크 파헤치기 1



**트러플 설치**

``` sh
npm install -g truffle
```

 애플리케이션을 위한 디렉토리를 생성한다. **생성한 디렉토리 내에서 초기화를 진행**한다.



**트러플 초기화**

```shell
tuffle init
```

- contracts : 트러플이 솔리디티 컨트랙트를 찾는 디렉토리
- migrations : 컨트랙트 배포 코드를 포함한 파일을 배치할 디렉토리
- test : 스마트 컨트랙트를 테스트하기 위한 테스트 파일의 위치
- truffle.js : 트러플 메인 설정 파일
- truffle-config.js : 트러플 설정 파일 양식



`truffle init` 명령어는 이더리움 위에 구축된 altcoin처럼 동작하는 몇 개의 예시 컨트랙트(Metacoin, ConvertLib)를 제공한다.



**컨트랙트 컴파일**

트러플에서 컨트랙트를 컴파일 하면 abi 및 unliked_binary세트의 아티팩트 객체가 생성된다

```
truffle compile
```

트러플은 불필요한 컴파일을 피하고자 마지막 컴파일 시점으로 부터 변경된 컨트랙트만 컴파일한다.

이 동작을 재정의 하기 위해서는 앞 명령어를 -all 옵션과 함께 실행한다.

컴파일 결과로 생성한 파일은 `build/contracts` 디렉토리에 있다. 이 곳은 배포마다 덮어쓰므로 직접 수정하면 안된다.

`build/contracts`디렉토리에서 아티팩트를 찾을 수 있다. 이 파일들은 compile 및 migrate 명령어를 실행한 시점에 수정된다.



- 트러플은 컨트랙트 파일이 자신의 파일 이름과 정확하게 일치하는 컨트랙트를 정의할 것이라고 기대한다. 예를들어 **MyContract.sol**이라는 파일이 있는 경우 `contract MyContract {}` 또는 `library myContract {}` 중 하나가 컨트랙트 파일 내에 반드시 있어야 한다.
- 파일 이름 매칭은 대소문자를 구별한다. 즉 파일 이름이 대문자로 돼 있지 않으면 컨트랙트 이름 또한 대문자가 아니여야 한다.



**계약 불러오기**

솔리디티의 import 명령어를 사용해 컨트랙트 의존성을 정의 할 수 있다. 트러플은 정확한 순서대로 컨트랙트를 컴파일 할 것이며, 필요한 경우 라이브러리를 자동으로 링크 할 것이다. 의존성 ./ 또는 ../.로 시작하며 현재 솔리디티 파일에서 상대적 경로로 지정해야 한다.

- 다른 파일에서 계약 불러오기

  ```
  import "./AnotherContract.sol";
  ```

- 외부 패키지에서 계약 불러오기

  ```
  import "<외부 패키지 이름>/<파일 이름>.sol";
  ```

  - 외부 패키지 이름은 npm 또는 EthPM으로 설치한 패키지 이름이다.
  - 트러플 프레임워크는 npm의 패키지보다 EthPM의 패키지를 먼저 검색한다. 같은 패키지 이름이 있다면 EthPM의 패키지를 사용한다.



**스마트 컨트랙트 컴파일**

```
truffle compile	// 변경된 부분만 부분 컴파일
truffle compile --all	// 전체 파일을 다시 컴파일
```

컴파일 결과로 생성한 파일은 `build/contracts` 디렉토리에 있다.



**Test**

컴파일 후, 테스트를 진행하여 문제없이 테스트를 마치면 네트워크에 배포합니다.

만약 실패한다면, 몇개가 실패했는지 (숫자) failing 와 이유가 함께 나온다.

```
truffle(develop)> test
```



**네트워크에 배포하기 전 수행 작업**

`truffle.js` 파일은 프로젝트를 설정하기 위해 사용되는 자바스크립트 파일이다. 이 파일은 프로젝트를 위한 설정을 생성하는 데 필요하다면 어떠한 코드라도 수행할 수 있다. 이 파일은 프로젝트 설정을 나타내는 객체를 내보내기(export)해야 한다.

```
module.exports = {
 networks: {
  development: {
   host: 'localhost',
   port: 8545,
   network_id: '*'
  }
 }
}
```

 - cmd를 사용할 때 기본 설정 파일 이름은 트러플 실행 파일과의 충돌을 발생 시킬 수 있다. 만약 충돌한다면, 파워셸 또는 Git Bash를 사용하자. 또한 충돌을 피하고자 설정 파일의 이름을 `truffle-config.js`로 변경 할 수 있다.



>**프라이빗 네트워크 배포**
>
>1. 프라이빗에 접속하여 채굴 상태로 만든다.
>
>2. 위에 나온 truffle.js에서 network_id를 본인의 네트워크 아이디로 명시한다.
>
>3. Geth를 실행한 상태에서 새 터미널 창을 열고 해당 디렉토리로 이동하여
>
>   ```
>   truffle migrate --network development // development 네트워크의 이름이다.
>   ```
>
>4. 배포에 성공하면  `컨트랙트명: CA`의 형태로 결과물이 나온다
>
>   
>
>**배포한 컨트랙트 다루기**
>
>1. 새 터미널 창을 열고 해당 디렉토리로 이동하여 아래 명령어 입력
>
>   ```
>   truffle console --network development
>   ```
>
>2. ```
>   truffle(development)> d = DappsToken.at("아까 발생한 CA주소")
>   
>   // 테스트 예시 명령어
>   truffle(development)> d.balanceOf(web3.eth.accounts[0])
>   truffle(development)> d.transfer(web3.eth.accounts[1], 100)
>   ```



**컨트랙트 배포**

작은 프로젝트라도 적어도 두 개의 블록체인과 상호작용한다. 하나는 EthereumJS TestRPC와 같은 개발자의 컴퓨터이며, 다른 하나는 개발자가 결국 애플리케이션을 최종적으로 배포할 네트워크(이더리움의 메인 네트워크, 프라이빗 컨소시엄 네트워크)를 나타낸다.

네트워크는 런타임에 컨트랙트 추상화에 의해 자동으로 탐지 되므로, 애플리케이션 또는 프론트엔드를 한 번만 배포하면 된다는 것을 의미한다. 애플리케이션이 동작 중이면, 실행 중인 이더리움 클라이언트는 어떤 아티팩트를 사용할지 결정하므로 응용프로그램이 유연해진다.

컨트랙트를 이더리움 네트워크에 배포하기 위한 코드를 포함하고 있는 자바스크립트 파일을 **Migration**이라고 부른다. 이 파일들은 배포 작업 준비를 담당하고, 시간이 지남에 따라 배포에 대한 요구 조건이 변경되리라는 것을 가정해 작성한다. 프로젝트가 진화할수록 새로운 마이그레이션 스크립트를 생성해 블록체인 위에서 이러한 진화를 진전시킨다. 기존에 실행되 마이그레이션의 기록은 Migrations 컨트랙트를 통해 블록체인에 기록된다.



**마이그레이션 파일**

Migratoins 컨트랙트는 Migratoins 폴더 내에서 마지막으로 적용된 마이그레이션 스크립트의 번호를 저장한다. (last_completed_migration 내에) Migrations 컨트랙트는 항상 가장 먼저 배포된다. 번호 부여 방식은 `x_script_name.js`이며 x는 1부터 시작한다.

Migrations 컨트랙트는 적용된 마지막 배포 스크립트의 번호를 저장하므로 트러플이 이 스크립트들을 다시 돌리지 않는다. 반면에 차후 애플리케이션에 수정이 필요하거나, 새로운 컨트랙트가 배포돼야 할 수 있다. 이를 위해서는 증가한 번호와 함께 새로운 스크립트를 생성하고 필요한 모든 절차를 기술해야 한다. 

--reset 옵션을 설정하면 모든 마이그레이션 작업을 처음부터 실행한다.



**마이그레이션 실행 후 제대로 배포했는지 체크하기**

```
truffle(develop)> dappsToken = DappsToken.at(DappsToekn.address)
truffle(develop)> dappsToken.name()
truffle(develop)> dappsToken.symbol()
truffle(develop)> dappsToken.totalSupply()
truffle(develop)> dappsToken.balanceOf(web3.eth.accounts[0])
truffle(develop)> dappsToken.balanceOf(web3.eth.accounts[1])
```



```
truffle migrate --compile-all --reset --network ganache // 이렇게 한번에도 가능하다.
```



---

위 정보는 `이더리움을 활용한 블록체인 프로젝트 구축 - 나라얀 프루스티` 와 `처음 배우는 블록체인 - 가사키 나가토, 시노하라 와타루`라는 책을보고 정리 하였습니다. 