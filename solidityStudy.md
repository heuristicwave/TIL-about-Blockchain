# TIL-about-Blockchain

https://medium.com/@heuristicwave/iot-smartcontract-in-solidity-51d7b5f83428 미디엄 IoT and SmartContract</br>
https://medium.com/@heuristicwave/iot-smartcontract-in-solidity-2-%EC%9E%91%EC%84%B1%EC%A4%91-c3f2aa04fb8e 2편

## 상태변경성

함수의 상태변경성은 컨트랙트에 정의된 상태 변수를 읽거나 쓰는 연산을 함수 내에서 수행할 수 있는지 제한하기 위한 용도로 사용한다.</br>
pure / view / payable / default(non-payable)</br>

<img src = "https://github.com/heuristicwave/TIL-about-Blockchain/blob/master/img/%EC%83%81%ED%83%9C%EB%B3%80%EA%B2%BD%EC%84%B1.png">




## Address 타입의 속성과 함수

balance / uint256 / 주소의 잔액(wei 단위)</br>
transfer(uint256 amount) / 없음 / 주어진 주소로 amount만큼의 wei를 보낸다. 실패하면 예외를 던진다 (2300gas)</br>
send(uint256 amount) / bool / 주어진 주소로 amount만큼의 wei를 보낸다. 실패하면 false 반환. 실패 시 처리 로직을 구현해야 한다. (2300gas)</br>
~~~
if (!owner.send(address(this).balance)) {
    	    revert();
    	}
~~~
~~~
owner.transfer(address(this).balance);
~~~ 
위 2개는 동일한 기능을 한다.

## 트랜잭션과 오류 처리

throw : 예외를 발생시키는 키워드로 예외가 발생하면 진행하던 처리를 롤백, false를 리턴하게 되면 변경 내용이 그대로 유효하게 남끼 때문에 원자성 atomicity가 필요한 경우에는 false를 리턴하는 대신 throw를 사용한다. 예외가 발생해도 가스는 소비한다 </br>
if(msg.sender != owner) { throw; }</br>

throw()를 사용했을 경우 가스를 다 사용하지 않앗더라도 트랜잭션을 시작할 때 지정한 가스가 모두 마이너에게 보상으로 지급됨.</br>
revert()는 revert()를 실행한 시점까지 소모한 가스만 마이너에게 지급하고 나머지는 트랜잭션을 요청한 송신자에게 반환되도록 개선됨.</br>

currently behaves exactly the same as all of the following:</br>

if(msg.sender != owner) { revert(); }</br>
assert(msg.sender == owner);</br>
require(msg.sender == owner);</br>

## 리믹스 디버거

- Instructions : 함수 실행을 위한 바이트 코드를 보여줌
- Solidity Locals : 현재 컨텍스트와 관련된 지역 변수의 값과 자료형을 보여준다.
- Solidity State : 상태 변수의 값과 자료형을 보여준다.
- Step detail : 가스 사용량, 남은 가스를 디버그 하는데 필요
- Call Stack : 함수 코드에 필요한 임시 변수를 보여준다.
- Memory : 함수 내에서 사용되는 지역 변수를 보여줌
- Call Data : 클라이언트가 계약에 보내는 실제 데이터를 보여준다. 첫 4바이트는 함수 식별자를 가리키며, 나머지 32바이트는 들어오는 파라미터를 포함한다.
