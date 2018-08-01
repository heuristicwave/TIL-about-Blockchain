### Web3.js 불러오기

NodeJS에서 web3.js를 사용하기 위해서는 단순히 프로젝트 디렉토리 내에서 `npm install web3`를 실행하고, 소스코드에서 `require("web3");`를 사용해 불러오면 된다. 클라이언트 측 자바스크립트에서 web3.js를 사용하기 위해서는 프로젝트 소스 코드의 dist 디렉터리 내부에서 찾을 수 있는 web3.js파일을 대기열에 추가하면 된다.



### 노드에 연결

web3.js는 Http 또는 IPC를 사용해 노드와 통신할 수 있다. 애플리케이션이 미스트 내부에서 동작 중이라면 미스트 노드와 연결된 web3 인스턴스를 자동으로 생성한다. 인스턴스의 변수명은 web3다.

노드에 연결하기 위한 기본 코드

````javascript
if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
````

먼저, web3가 undefined인지 아닌지를 확인해 코드가 미스트 내에서 실행 중인지 확인한다.

web3가 정의되어 있으면 이미 사용 가능한 인스턴스를 사용한다. 

그렇지 않으면, 커스텀 노드에 연결해 인스턴스를 생성한다.  



 Web3.providers 객체는 연결을 맺고 다양한 프로토콜을 사용해 메시지를 전송하기 위해 생성자를 제공한다.

- Http - Web3.providers.HttpProvider
- IPC - Web3.providers.IpcProvider



web3.currentProvider 속성은 현재 제공자 인스턴스에 자동으로 할당된다. web3 인스턴스를 만든 후에는 web3.setProvider() 메소드를 사용해 제공자를 변경할 수 있다. web3는 노드에 연결되어 있는지를 확인 할 수 있는 isConnected() 메소드를 제공한다. 연결 상태에 따라 true 또는 false를 리턴한다.



### API 구조

web3는 이더리움 블록체인 상호작용을 위한 eth객체(web3.eth)와 위스퍼 상호작용을 위한 shh 객체 (web3.ssh)를 특별히 포함하고 있다. web3.js의 대부분 API는 이 두 객체 내부에 있다.

모든 API는 기본적으로 synchronous이다. 비동기식 요청을 만들고 싶은 경우 대부분의 함수에 마지막 매개변수로 선택적인 콜백을 전달하면 된다. 모든 콜백은 error-first 콜백 스타일을 사용한다.

일부 API는 비동기식 이다. `web3.eth.coinbase()`는 동기식이지만, `web3.eth.getCoinbase()`는 비동기식이다.

````javascript
// 동기식 요청
try {
	console.log(web3.eth.getBlock(48));
} catch(e) {
    console.log(e);
}

// 비동기식 요청
web3.eth.getBlock(48, function(error, result){
	if(!error)
		console.log(result);
	else
		console.error(error);
})
````



### BigNumbers.js

자바스크립트에서 큰 숫자를 다루거나 완벽한 계산이 필요할 때, `BigNumber.js`라이브러리를 사용한다.

web3.js 또한 BigNumber.js에 의존한다. BigNumber.js는 자동으로 추가된다. web3.js는 항상 숫자 값에 대해서는 BigNumber 객체를 리턴한다. 자바스크립트 숫자, 숫자 문자열, BigNumber 인스턴스를 입력 값으로 사용할 수 있다.

````javascript
web3.eth.getBalance("0x27E829fB34d14f3384646F938165dfcD30cFfB7c").toString();
````

위의 코드에서  `web3.eth.getBalance()`는 BigNumber 객체를 반환한다. 이런 객체를 숫자형 문자열로 변환하기 위해서는 toString()을 호출해야 한다.

`BigNumber.js`는 소수점 20자리 이상의 숫자를 올바르게 처리하지 못한다. 따라서 잔액을 wei 단위로 저장하고 보여 줄 때, 다른 단위로 변환하는 것을 권장한다. web3.js는 자체적으로 잔액을 리턴하거나 받아 들일 때 항상 wei단위를 사용한다. 때문에 위 함수도 주소의 잔액을 wei 단위로 리턴한다.



### 단위 변환

````javascript
web3.fromWei("1000000000000000000", "ether");	//wei를 ether롤 변환
web3.toWei("0.000000000000000001", "ether");	//ether를 wei로 변환
````



### Web3 API

https://github.com/ethereum/wiki/wiki/JavaScript-API

````javascript
web3.eth.gasPrice();	// 최신블록 x개의 가스가격 
web3.eth.getTransactionReceipt();	// 해시를 이용해 트랜잭션 상세정보를 얻을때 사용된다.
````

특정 주소로 이더를 전송하는 예시

````javascript
var txnHash = web3.eth.sendTransaction({
    form: web3.eth.accounts[0],
    fo: web3.eth.accounts[1],
    value: web3.toWei("1", "ether")
});
````



### 컨트랙트 작업

새로운 컨트랙트를 배포하거나 이미 배포된 컨트랙트의 참조 값을 얻기 위해서는 `web3.eth.contract()` 메소드를 이용해 컨트랙트 객체를 생성해야 한다. 인자로는 ABI를 받으며 컨트랙트 객체를 리턴한다.

컨트랙트 객체 생성 코드

````
var proofContract = web3.eth.contract(ABI);
````

컨트랙트 객체를 생성했다면, 컨트랙트 객체의 new메소드를 이용해 배포하거나, at 메소드를 사용해 ABI와 매칭하는 이미 배포된 컨트랙트의 참조 값을 얻을 수 있다.

새로운 컨트랙트를 배포하기

````javascript
var proof = proofContract.new({
    from: web3.eth.accounts[0],
    data: "0x606060405261...",
    gas: "470000"
},
fuction (e, contract){
	if(e) {
        console.log("Error " + e);
	}
	else if(contract.address != undefined) {
        console.log("Contract Address: " + contract.address);
	}
	else {
        console.log("Txn Hash: " + contract.transactionHash)
	}
})
````

new 메소드는 비동기식으로 호출 됐으므로 트랜잭션이 성공적으로 생성되고 브로드캐스팅 됐다면 콜백이 두 번 발생한다. 첫 번쨰는 트랜잭션이 브로드캐스팅 된 이후 호출되며, 두 번째로는 트랜잭션이 채굴된 이후 호출된다. 콜백을 제공하지 않은 경우 proof변수는 undefined로 설정된 address 속성을 가질 것이다. 컨트랙트가 채굴된 이후 address속성이 설정될 것이다.

proof 컨트랙트 내에는 생성자가 없지만, 만약 생성자가 있었다면 생성자의 인자가 new메소드 시작 부분에 반드시 있어야 한다. 우리가 전달한 객체는 **from주소**, **컨트랙트의 바이트코드**, **사용할 최대 가스양**을 포함하고 있다. 이 세가지 속성은 반드시 있어야 하며, 그렇지 않은 경우 트랜잭션이 생성되지 않는다.

at메소드를 사용해 배포된 컨트랙트의 참조 값 얻기

````javascript
var proof = proofContract.at("주소");
````

컨트랙트의 메소드를 호출하기 위해 트랜잭션을 전송하는 법

````javascript
proof.set.sendTransaction("Owner Name", "주소", {
	from: web3.eth.accounts[0],
	}, function(error, transactionHash){
        if (!err)
        	console.log(transactionHash);
})
````

위에서는 동일한 이름을 가진 객체의 sendTransaction 메소드를 호출한다. sendTransaction 메소드에게 전달된 객체는 web3.eth.sendTransaction()과 같은 속성을 가진다. (data 및 to 속성은 무시된다.)

트랜잭션을 생성하고 브로드캐스팅하는 대신 노드 자체에 있는 메소드를 호출하고 싶은 경우 call를 사용한다

````javascript
var returnValue = proof.get.call("주소");
````

호출 여부를 결정하기 위해 메소드를 호출하는 데 필요한 가스의 양을 알기 위해서는

````javascript
var estimatedGas = proof.get.estimateGas("주소");
````

---

위 web3관련 정보는 `이더리움을 활용한 블록체인 프로젝트 구축 - 나라얀 프루스티 `이라는 책을보고 정리 하였습니다. 

 