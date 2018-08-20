

### 트러플 프레임워크 파헤치기 3



**MetaCoin**

메타코인은 10k의 메타코인을 컨트랙트를 배포한 계좌 주소에 할당한다. sendCoin()함수를 사용해 누구에게나 이 코인을 전송할 수 있고, 언제든지 계좌의 잔액을 확인 할 수 있다. `ConvertLib`라이브러리는 메타코인들의 가치를 이더 단위로 계산하기 위해 사용된다. 이를 위해 convert()메소드를 제공한다.



**마이그레이션 작성**

마이그레이션 파일의 시작 부분에서는 artifacts.require() 메소드를 통해 상호작용하길 원하는 컨트랙트를 트러플에게 알려준다. 이 메소드는 Node의 require와 유사하지만, 여기서는 나머지 배포 스크립트 내에서 사용할 수 있는 컨트랙트 추상화를 리턴한다.

모든 마이그레이션은 `module.exports` 문법을 통해 함수를 내보내기해야 한다. 각 마이그레이션으로 부터 내보내기된 함수는 첫 번째 인자로 **deployer 객체**(배포 작업 준비를 위한 주요 인터페이스)를 받아들여야 한다. 이 객체는 스마트 컨트랙트를 배포하기 위한 명확한 API를 제공하고 배포된 아티팩트를 차후 사용을 위해 아티팩트 파일에 저장하거나 라이브러리를 링킹하는 등의 배포에 필요한 작업을 진행함으로써 배포 작업을 지원한다. 

- `deployer.deploy(contractAbstraction, args..., options)` : 컨트랙트 추상화 객체에 의해 지정된 특정 컨트랙트를 옵션 생성자 인자와 함께 배포한다. 싱글톤 컨트랙트의 경우 유용하므로 이 컨트랙트의 오직 하나의 인스턴스만 DApp을 위해 존재한다. 배포 이후 CA를 설정하고(artifact 내 address 속성은 새로 배포된 주소와 같다) 기존에 저장된 주소를 재정의 한다. 다수의 컨트랙트 배포 속도를 높이기 위해 선택적으로 컨트랙트의 배열, 배열의 배열을 전달할 수 있다. 마지막 인자는 overwrite라는 하나의 키를 포함할 수 있는 옵션 값이다. overwrite가 false로 설정되면, deployer는 이미 하나가 배포돼 있을 경우 배포하지 않을 것이다. 이 메소드는 프로미스를 리턴한다.
- `deployer.link(library, destinations)` : 이미 배포된 라이브러리를 컨트랙트 또는 다수의 컨트랙트에 링크한다. destinations 인자는 하나의 컨트랙트 추상화 또는 다수의 컨트랙트 추상화의 배열일 수 있다. destination 내 어떤 컨트랙트도 링크된 라이브러리에 의존하지 않는 경우 deployer는 해당 컨트랙트르 무시한다. 이 메소드는 프로미스를 리턴한다.
- `deployer.then(function(){})` : 임의의 배포 절차를 실행하기 위해 사용된다. 이를 사용해 마이그레이션 중 컨트랙트 데이터를 추가, 편집, 재구성하기 위해 특별한 컨트랙트를 호출 할 수 있다. 콜백 함수 내에서 컨트랙트를 배포하고 링크하기 위해서는 컨트랙트 추상화 API를 사용할 수 있다.

배포되는 네트워크에 따라 배포 절차를 조건부로 실행할 수도 있다. 배포 절차를 조건별로 준비하기 위해 network라고 불리는 두번째 매개변수를 받아들이는 마이그레이션을 작성한다. 

```
module.exports = {
	if (network != "live") {
		// 그렇지 않은 경우 다른 절차를 수행한다.
	} else {
        // "live" 네트워크의 경우에는 특정 작업을 수행한다.
	}
}
```



**2_deploy_contracts.js**

```javascript
var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
};
```

ConvertLib 및 MetaCoin 컨트랙트를 위한 추상화를  생성했다. 어떤 네트워크가 사용되는지와 상관 없이 CovertLib라이브러리를 배포하고, 라이브러리를 MetaCoin 네트워크와 링크하고, 최종적으로 MetaCoin 네트워크를 배포한다.

마이그레이션을 실행하기 위해서 배포하는 명령어

```shell
truffle migrate --network development
```

위 명령은 자동으로 ConvertLib 라이브러리 및 아티팩트 파일 내의 MetaCoin 컨트랙트 주소를 업데이트하고, 링크를  업데이트하는 것을 알 수 있다.

- --reset : 마지막으로 완료된 마이그레이션부터 실행하는 대신 처음부터 모든 마이그레이션을 실행한다.
- --f number : 특정 마이그레이션으로부터 컨트랙트를 실행한다.





---

위 정보는 `이더리움을 활용한 블록체인 프로젝트 구축 - 나라얀 프루스티 `이라는 책을보고 정리 하였습니다. 