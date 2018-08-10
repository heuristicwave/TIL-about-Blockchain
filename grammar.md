# TIL-about-Blockchain

## 문법

### 연산
솔리디티는 지수 연산  (즉, "x의 y승", x^y이지): </br>

uint x = 5 ** 2; // 즉, 5^2 = 25

### 배열

// 2개의 원소를 담을 수 있는 고정 길이의 배열: </br>
uint[2] fixedArray; </br>
// 스트링 고정 배열으로 5개: </br>
string[5] stringArray; </br>
// 동적 배열은 고정된 크기가 없으며 계속 크기가 커질 수 있다: </br>
uint[] dynamicArray; </br>
구조체의 배열을 생성할 수도 있다. 이전 챕터의 Person 구조체를 이용하면: </br>
Person[] people; // 이는 동적 배열로, 원소를 계속 추가할 수 있다.</br>
상태 변수가 블록체인에 영구적으로 저장, 이처럼 구조체의 동적 배열을 생성하면 마치 데이터베이스처럼 컨트랙트에 구조화된 데이터를 저장하는 데 유용

Public 배열 </br>
public으로 배열을 선언할 수 있지. 솔리디티는 이런 배열을 위해 getter 메소드를 자동적으로 생성하지. 구문은 다음과 같네:

Person[] public people; </br>
그러면 다른 컨트랙트들이 이 배열을 읽을 수 있게 되지 (쓸 수는 없네). 이는 컨트랙트에 공개 데이터를 저장할 때 유용한 패턴이지.

### 구조체 생성하기

새로운 Person를 생성하고 people 배열에 추가하는 방법을 살펴보도록 하지.

// 새로운 사람을 생성한다: Person satoshi = Person(172, "Satoshi");

// 이 사람을 배열에 추가한다: people.push(satoshi); </br>
이 두 코드를 조합하여 깔끔하게 한 줄로 표현할 수 있네: people.push(Person(16, "Vitalik"));
참고로 array.push()는 무언가를 배열의 끝에 추가해서 모든 원소가 순서를 유지하도록 하네. 다음 예시를 살펴보도록 하지:
~~~
uint[] numbers;
numbers.push(5);
numbers.push(10);
numbers.push(15);
// numbers 배열은 [5, 10, 15]과 같다.
~~~

Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)
~~~
struct Zombie {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
      uint16 winCount;
      uint16 lossCount;
    }
~~~

### 함수
private 함수는 관례적으로 _ 로 시작한다, 호출시에도 언더바를 붙여서 호출한다 ex) _play </br> 
~~~
string greeting = "What's up dog";

function sayHello() public returns (string) {
  return greeting;
}
~~~
솔리디티에서 함수 선언은 반환값의 종류를 포함한다.

### 형 변환
~~~
uint8 a = 5;
uint b = 6;
// a * b가 uint8이 아닌 uint를 반환하기 때문에 에러 메시지가 난다:
uint8 c = a * b; 
// b를 uint8으로 형 변환해서 코드가 제대로 작동하도록 해야 한다:
uint8 c = a * uint8(b);
~~~

### 이벤트
~~~
// 이벤트를 선언한다
event IntegersAdded(uint x, uint y, uint result);

function add(uint _x, uint _y) public {
  uint result = _x + _y;
  // 이벤트를 실행하여 앱에게 add 함수가 실행되었음을 알린다:
  IntegersAdded(_x, _y, result);
  return result;
}
~~~
자바스크립트로 구현:
~~~
YourContract.IntegersAdded(function(error, result) { 
  // 결과와 관련된 행동을 취한다
}
~~~

### 맵핑
구조화된 데이터를 저장하는 방법</br>
~~~
// 금융 앱용으로, 유저의 계좌 잔액을 보유하는 uint를 저장한다: 
mapping (address => uint) public accountBalance;
// key는 address이고, 값은 uint 이다.
// 혹은 userID로 유저 이름을 저장/검색하는 데 매핑을 쓸 수도 있다 
mapping (uint => string) userIdToName;
// key는 uint이고, 값은 string 이다.
~~~

###  Msg.sender
모든 함수에서 이용 가능한 전역 변수, 현재 함수를 호출한 주체의 주소를 가리킨다. </br>
참고: 솔리디티에서 함수 실행은 항상 외부 호출자가 시작. 컨트랙트는 누군가가 컨트랙트의 함수를 호출할 때까지 블록체인 상에서 아무 것도 안 하고 있을 것이네. 그러니 항상 msg.sender가 있어야 하네.  </br>
msg.sender를 이용하고 mapping을 업데이트하는 예시 </br>
~~~
mapping (address => uint) favoriteNumber;

function setMyNumber(uint _myNumber) public {
  // `msg.sender`에 대해 `_myNumber`가 저장되도록 `favoriteNumber` 매핑을 업데이트한다 `
  favoriteNumber[msg.sender] = _myNumber;
  // ^ 데이터를 저장하는 구문은 배열로 데이터를 저장할 떄와 동일하다 
}

function whatIsMyNumber() public view returns (uint) {
  // sender의 주소에 저장된 값을 불러온다 
  // sender가 `setMyNumber`을 아직 호출하지 않았다면 반환값은 `0`이 될 것이다
  return favoriteNumber[msg.sender];
}
~~~
이 간단한 예시에서 누구나 setMyNumber을 호출하여 본인의 주소와 연결된 우리 컨트랙트 내에 uint를 저장할 수 있지.

msg.sender를 활용하면 자네는 이더리움 블록체인의 보안성을 이용할 수 있게 되지. 즉, 누군가 다른 사람의 데이터를 변경하려면 해당 이더리움 주소와 관련된 개인키를 훔치는 것 밖에는 다른 방법이 없다는 것이네.</br>

먼저, 새로운 좀비의 id가 반환된 후에 zombieToOwner 매핑을 업데이트하여 id에 대하여 msg.sender가 저장되도록 해보자.</br>
그 다음, 저장된 msg.sender을 고려하여 ownerZombieCount를 증가시키자.</br>
~~~
zombieToOwner[id] = msg.sender;
ownerZombieCount[msg.sender]++;
~~~

### Require
require를 활용하면 특정 조건이 참이 아닐 때 함수가 에러 메시지를 발생하고 실행을 멈추게 됨</br>
~~~
function sayHiToVitalik(string _name) public returns (string) {
  // _name이 "Vitalik"인지 비교한다. 참이 아닐 경우 에러 메시지를 발생하고 함수를 벗어난다
  // (참고: 솔리디티는 고유의 스트링 비교 기능을 가지고 있지 않기 때문에 
  // 스트링의 keccak256 해시값을 비교하여 스트링 값이 같은지 판단한다)
  require(keccak256(_name) == keccak256("Vitalik"));
  // 참이면 함수 실행을 진행한다:
  return "Hi!";
}
~~~

### Storage vs Memory
Storage는 블록체인 상에 영구적으로 저장되는 변수를 의미. Memory는 임시적으로 저장되는 변수로, 컨트랙트 함수에 대한 외부 호출들이 일어나는 사이에 지워짐. 상태 변수(함수 외부에 선언된 변수)는 **초기 설정상 storage로 선언되어 블록체인에 영구적으로 저장**되는 반면, 함수 내에 선언된 변수는 memory로 자동 선언되어서 함수 호출이 종료되면 사라짐.
~~~
contract SandwichFactory {
  struct Sandwich {
    string name;
    string status;
  }

  Sandwich[] sandwiches;

  function eatSandwich(uint _index) public {
    Sandwich storage mySandwich = sandwiches[_index];
    // ...이 경우, `mySandwich`는 저장된 `sandwiches[_index]`를 가리키는 포인터이다.
    // 그리고 
    mySandwich.status = "Eaten!";
    // ...이 코드는 블록체인 상에서 `sandwiches[_index]`을 영구적으로 변경한다. 

    // 단순히 복사를 하고자 한다면 `memory`를 이용하면 된다: 
    Sandwich memory anotherSandwich = sandwiches[_index + 1];
    // ...이 경우, `anotherSandwich`는 단순히 메모리에 데이터를 복사하는 것이 된다. 
    // 그리고 
    anotherSandwich.status = "Eaten!";
    // ...이 코드는 임시 변수인 `anotherSandwich`를 변경하는 것으로 
    // `sandwiches[_index + 1]`에는 아무런 영향을 끼치지 않는다. 그러나 다음과 같이 코드를 작성할 수 있다: 
    sandwiches[_index + 1] = anotherSandwich;
    // ...이는 임시 변경한 내용을 블록체인 저장소에 저장하고자 하는 경우이다.
  }
}
~~~
값 타입은 (int, uint, bool)로컬 변수로 쓰일 때 memory, 배열은 로컬 변수로 쓰일 때 stroage에 저장 된다.

Quiz. feedAndMultiply라는 함수를 생성한다. 이 함수는 uint형인 _zombieId 및 _targetDna을 전달받는다. 이 함수는 public으로 선언되어야 한다.

주인만이 좀비에게 먹이를 줄 수 있도록 한다. require 구문을 추가하여 msg.sender가 좀비 주인과 동일하도록 한다. 

참고: 다시 말하지만, 우리가 작성한 확인 기능은 기초적이기 때문에 컴파일러는 msg.sender가 먼저 나올 것을 기대하고, 항의 순서를 바꾸면 잘못된 값이 입력되었다고 할 걸세. 하지만 보통 코드를 작성할 때 항의 순서는 자네가 원하는 대로 정하면 되네. 어떤 경우든 참이 되거든.

먹이를 먹는 좀비 DNA를 얻을 필요가 있으므로, 그 다음으로 myZombie라는 Zombie형 변수를 선언한다 (이는 storage 포인터가 될 것이다). 이 변수에 zombies 배열의 _zombieId 인덱스가 가진 값에 부여한다.

~~~
function feedAndMultiply (uint _zombieId, uint _targetDna) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
    }
~~~
