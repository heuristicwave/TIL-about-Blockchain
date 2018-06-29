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
https://medium.com/@heuristicwave/iot-smartcontract-in-solidity-51d7b5f83428 미디엄 IoT and SmartContract
