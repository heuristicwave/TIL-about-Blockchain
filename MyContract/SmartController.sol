pragma solidity ^0.4.11; //컴파일러 버전 지정

contract SmartController {
		// 스위치가 사용할 구조체
		struct Controller {
      address add; // client의 주소
      uint endTime; // 이용 종료 시간
      bool staus; // true알 때만 사용가능
    }

    address public owner; // 오너의 주소
    address public iot; // IoT Device의 주소

    mapping (uint => Controller) public controllers; // Controller 구조체를 담을 매핑
    uint public numPaid; //결제 횟수

    /// 오너의 권한 체크
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }

    /// IoT 장치 권한 체크
    modifier onlyIoT() {
      require(msg.sender == iot;
      _;
    }

    ///생성자, IoT장치의 주소를 매개변수로 받음
    function SmartController(address _iot) {
      // owner의 값에 이 계약을 생성한 계정 주소 대입
      owner = msg.sender;
      iot = _iot;
      numPaid = 0;
    }
    //이더 지불 시, 호출되는 함수
    function payToSwitch() public payable {
      require(msg.value == 1000000000000000000); //1ETH가 아니면 종료

      Controller c = controllers[numPaid++]; //Controller 생성
      s.add = msg.sender;
      s.endTime = now + 60; // 이용시간 1분, 원하는 시간 만큼 수정 가능
      s.status = true;
    }

    /// 상태(staus)를 변경하는 함수, 이용 종료 시각에 호출
    // controllers의 키 값이 매개변수가 됨
    function updateStatus(uint _index) public onlyIoT {
      //인덱스 값에 해당하는 Controller 구조체가 없으면 종료
      require(controllers[_index].add != 0);

      //이용 종료 시간이 되지 않았으면 종료
      require(now > controllers[_index].endTime);

      controllers[_index].status = false; //상태변경
    }

    // 지불된 이더를 인출하는 함수
    function withdrawFunds() public onlyOwner {
    	if (!owner.send(this.balance))
    		throw;
    }

    // 계약을 소멸시키는 함수
    function kill() public onlyOwner {
      selfdestruct(owner);
    }
}
