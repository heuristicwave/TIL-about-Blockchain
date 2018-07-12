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

### 난수

~~~
uint randNonce = 0;
uint random = uint(keccak256(now, msg.sender, randNonce)) % 100;
randNonce++;
uint random2 = uint(keccak256(now, msg.sender, randNonce)) % 100;
~~~
pow 방식에서는 난수 함수를 취약하게 만듬. 
https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract

### 기타
_isReady()를 확인하는 require 문장을 추가하고 거기에 myZombie를 전달

#### 3-9 (띄어쓰기 중요)
Create a function called changeName. It will take 2 arguments: _zombieId (a uint), and _newName (a string), and make it external. It should have the aboveLevel modifier, and should pass in 2 for the _level parameter. (Don't forget to also pass the _zombieId).

In this function, first we need to verify that msg.sender is equal to zombieToOwner[_zombieId]. Use a require statement.

Then the function should set zombies[_zombieId].name equal to _newName.

Create another function named changeDna below changeName. Its definition and contents will be almost identical to changeName, except its second argument will be _newDna (a uint), and it should pass in 20 for the _level parameter on aboveLevel. And of course, it should set the zombie's dna to _newDna instead of setting the zombie's name.

~~~
   function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }
~~~

