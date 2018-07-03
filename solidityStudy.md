# TIL-about-Blockchain
~~~
pragma solidity ^0.4.11; //컴파일러 버전 지정

contract HelloWorld {
		//contract 안에서 선언한 변수를 상태라고 한다
		//객체지향 언어에서 인스턴스 변수에 해당한다고 보면 됨
		string public msg1;
		string private msg2;

		address public owner;				// EOA나 CA를 어드레스 값으로 갖는다 
		uint8 public counter;
		///생성자
		//생성자는 스마트 계약을 새로 만들 때 실행된다. 생성자 이름은 반드시 계약 이름과 같아야 한다.
    function HelloWorld(string _msg1) {
    		msg1 = _msg1;

    		owner = msg.sender;     // owner의 값에 이 계약을 생성한 계정 주소 대입
    		counter = 0;
    }

    function setMsg2(string _msg2) public {
    	if (owner != msg.sender) {
    		throw;			//예외를 방생시키는 키워드로 예외가 발생하면 진행하던 처리를 롤백
    		//false를 리턴하게 되면 변경 내용이 그대로 유효하게 남끼 때문에 원자성 atomicity가 필요한 경우에는 false를 리턴하는 대신 throw를 사용한다. 예외가 발생해도 가스는 소비한다
    	}	else {
    		msg2 = _msg2;
    	}
    }

    //storage의 내용을 수정하지 않는다는 의도를 constant 키워드로 나타낸다
    function getMsg2() constant public returns(string) {
    	return msg2;
    }
}
~~~
https://medium.com/@heuristicwave/iot-smartcontract-in-solidity-51d7b5f83428 미디엄 IoT and SmartContract</br>
https://medium.com/@heuristicwave/iot-smartcontract-in-solidity-2-%EC%9E%91%EC%84%B1%EC%A4%91-c3f2aa04fb8e 2편

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

## Withdraw 패턴

http://solidity.readthedocs.io/en/v0.4.24/common-patterns.html
송금을 받는 주체가 계약인 경우에는 fallback 함수가 호출되는데, 이 fallback 함수에 악의적인 처리가 포함되면 부정인출이 일어 날 수 있다.
이전 CA의 처리를 실패하게 만들어서 본래의 기능을 못하게 함.

그러나 전용 함수를 사용하여 사용자가 직접 인출해가게 하면
솔리디티 예시에서는
bid와 입찰금 반환처리 부분이 분리되었기 때문에 withdraw가 실패해도 이후의 bid처리에 영향을 미치지 않는다.
