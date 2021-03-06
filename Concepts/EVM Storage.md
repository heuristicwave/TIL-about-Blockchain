### EVM Storage

스마트 컨트랙트에서 선언한 변수들은 EVM내에 Storage에 어떻게 저장될까?

구글링을 하다보니 EVM Storage에는 약 2의 256에 해당하는 메모리 슬롯이 존재한다고 하는데 사실인지는 잘 모르겠다. 이는 약 10의 77제곱에 해당한다고 한다. (우주를 구성하는 원자의 개수는 10의 80제곱에 해당한다.) 

**슬롯 하나의 크기는 256 비트 = 32 바이트 이다.** 



>EVM Stack - 256비트 크기의 1024개의 스택으로 이루어져 있다
>
>EVM Memory - 함수를 호출하거나 메모리 연산을 수행할 때 임시로 사용된다. 이더리움에서 메시지 호출이 발생할 때마다, 깨끗하게 초기화된 메모리 영역이 컨트랙트에 제공된다.
>
>EVM Call Data - 트랜잭션을 요청했을때, 전송되는 데이터 들이 기록된다.



다시 본론으로 돌아와서, 우리가 스마트 컨트랙트에서 변수를 할당 할 때 마다 어떻게 기록되는지 알아보자.

설명보다는 바로 실험을 통해 알아보겠다. 

> 실험환경 : testrpc (Web3 Provider)
>
> remix로 배포후 truffle 콘솔창으로 값 확인



StorageTest라는 컨트랙트 안에 크기가  서로 다른 변수, 배열, 구조체를 선언했다.

첫번째 사진의 선언한 항목들에 각각 해당되는 슬롯을 주석으로 명시해 두었다.

https://github.com/heuristicwave/TIL-about-Blockchain/blob/master/img/storage1.png?raw=true

배포된 StorageTest의 CA주소를 복사하여 `getStorageAt` 함수를 이용하여 데이터를 조회했다.

```
web3.eth.getStorageAt('Paste your CA Address', 0, (err, res) => console.log(res))
```

위 명령어에서 0은 슬롯의 index Number을 뜻한다. 
https://github.com/heuristicwave/TIL-about-Blockchain/blob/master/img/storage2.png?raw=true

#### slot 0

슬롯 하나의 크기가 32byte 이기 때문에, 솔리디티는 최적화를 통해 a, b, c를 한 슬롯안에 저장한다.

때문에 c(2) = 02, b(true) = 01, a(1) = 1이 뒤에서부터 위치 push된다.

#### slot 1

**구조체는 Storage 영역에 저장되지 않기 때문에 기록 되지않고**, 그다음 배열 e가 저장됐다.

#### slot 2

256바이트에 해당하는 주소는 하나의 슬롯을 차지한다.

#### slot 3

256바이트로 선언한 변수 g는 슬론 3을 통째로 차지한다. 10진수 123은 16진수 7b에 해당한다.

#### slot 4

변수g가 한칸을 차지했기 때문에 그 다음에 선언된 변수 h (16진수 04)는 슬롯 4에 저장된다.

#### slot 5

0x00이 나왔다는 뜻은 슬롯에 아무것도 저장이 돼지 않았다는 뜻이다.



>저장공간을 최적화되도록 하려면 스토리지 변수와 구조를 잘 알아야한다. 예를 들어 스토리지 변수를 uint128, uint128, uint256 는 슬롯 2개를 차지하고 uint128, uint256, uint128은 스토리지 슬롯 3개를 차지한다. 이는 더 많은 가스비를 요구 하기 때문에, 개발자는 항상 Storage 사용을 염두하면서 코딩을 해야 한다.



이렇게 솔리디티에서 데이터가 어떻게 저장되는지 저수준의 방법으로 알아보았다. 상태 변수가 어떻게 저장되는지 공부함으로써 솔리디티 개발자가 지향해야 할 자세와 가스비를 절약할 수 있는 방법을 알 수 있었다.



#### 참고

https://programtheblockchain.com/posts/2018/03/09/understanding-ethereum-smart-contract-storage/

