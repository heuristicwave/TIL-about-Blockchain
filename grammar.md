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
