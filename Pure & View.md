### View

블록체인의 상태를 변경시키지 않음을 의미하고 구체적으로는 아래에 나열된 사항 중 어떤 것도 하지 않는다는 것을 의미합니다.

- 상태 변수 값 변경
- [이벤트 발생](http://solidity.readthedocs.io/en/v0.4.21/contracts.html#events)
- [다른 계약 생성](http://solidity.readthedocs.io/en/v0.4.21/control-structures.html#creating-contracts)
- `selfdestruct` 사용(해당 계약 계정을 삭제하고 모든 잔액을 지정된 주소로 이동)
- 이더 전송
- `view` 혹은 `pure`로 선언되지 않은 어떠한 함수라도 호출
- 로우레벨 호출
- 특정 OPCODE를 포함한 인라인 어셈블리 사용



### Pure

아래에 나열된 사항 중 어떤 것도 하지 않는다는 것을 의미합니다.

- 상태 변수 읽기
- `this.balance` 혹은 `<주소>.balance` 접근
- `block`, `tx`, `msg` 중 하나의 멤버 변수에 접근(예외: `msg.sig`와 `msg.data`는 제외)
- `pure`로 정의되어 있지 않은 어떠한 함수라도 호출
- 특정 OPCODE를 포함한 인라인 어셈블리 사용