# TIL-about-Blockchain

### 다른 컨트랙트와 상호작용하기
다른 Contract와 상호작용을 하려면 인터페이스를 정의해야 한다.</br>
~~~
contract NumberInterface {
  function getNum(address _myAddress) public view returns (uint);
}
~~~
다른 컨트랙트에서 인터페이스 이용하기
~~~
contract MyContract {
  address NumberInterfaceAddress = 0xab38... 
  // ^ 이더리움상의 FavoriteNumber 컨트랙트 주소이다 
  NumberInterface numberContract = NumberInterface(NumberInterfaceAddress)
  // 이제 `numberContract`는 다른 컨트랙트를 가리키고 있다. Now `numberContract` is pointing to the other contract

  function someFunction() public {
    // 이제 `numberContract`가 가리키고 있는 컨트랙트에서 `getNum` 함수를 호출할 수 있다: 
    uint num = numberContract.getNum(msg.sender);
    // ...그리고 여기서 `num`으로 무언가를 할 수 있다 
  }
}
~~~
ckAddress라는 변수에 크립토키티 컨트랙트 주소가 입력되어 있다. 다음 줄에 kittyContract라는 KittyInterface를 생성하고, 위의 numberContract 선언 시와 동일하게 ckAddress를 이용하여 초기화
~~~
KittyInterface kittyContract = KittyInterface(ckAddress);
~~~

### 다수의 반환값 처리하기
~~~
function multipleReturns() internal returns(uint a, uint b, uint c) {
  return (1, 2, 3);
}

function processMultipleReturns() external {
  uint a;
  uint b;
  uint c;
  // 다음과 같이 다수 값을 할당한다:
  (a, b, c) = multipleReturns();
}

// 혹은 단 하나의 값에만 관심이 있을 경우: 
function getLastReturnValue() external {
  uint c;
  // 다른 필드는 빈칸으로 놓기만 하면 된다: 
  (,,c) = multipleReturns();
}
~~~
ex)그 다음, 이 함수는 _kittyID를 전달하여 kittyContract.getKitty 함수를 호출하고 gene을 kittyDna에 저장해야 한다.getKitty가 다수의 변수를 반환한다는 사실을 기억할 것 (정확히 말하자면 10개의 변수를 반환한다).

마지막으로 이 함수는 feedAndMultiply를 호출하고 이 때 _zombieId와 kittyDna를 전달해야 한다.
~~~
function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyID);
    feedAndMultiply(_zombie, kittyDna);
  }
~~~
