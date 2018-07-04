pragma solidity ^0.4.11;

contract VictimBalance {
    // 어드레스 별로 잔액 관리
    mapping (address => uint) public userBalances;

    // 메시지를 출력하는 이벤트
    event MessageLog(string);

    // 잔액을 출력하는 이벤트
    event BalanceLog(uint);

    /// 생성자
    constructor () public {

    }

    /// 송금받을 때 호출되는 함수
    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    ///이더를 인출할 때 호출되는 함수
    function withdrawBalance() public payable returns(bool) {
        MessageLog("withdrawBalance started.");
        BalanceLog(this.balance);

        // 1. 잔액 확인
        if (userBalances[msg.sender] == 0) {
            MessageLog("No Balance.");
            return false;
        }

        // 2. 자신을 호출한 어드레스로 이더 반환
        if (!(msg.sender.call.value(userBalances[msg.sender])())) {
            revert();
        }

        // 3. 잔액 업데이트
        userBalance[msg.sender] = 0;

        MessageLog("withdrawBalance finished.");

        return true;
    }
}