### 트러플

migrate로 배포

build 생기는데  그 안에 있는 json파일들을 artifacts라고 함

abi + 컨트랙트에 대한 모든 정보가 다밈



web3.eth.accounts

web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]), "ether").toNumber()



트러플에 배포한 함수 사용하기

MyContract.deployed().then(function(instance) { app = instance; })

// 인스턴스를 콜백으로 받아 전역변수 app에 대가 대입한다는 말

이후 app을 실행해서 볼 수 있음

app.setStudentInfo(1111, "jihun", "male", 7, {from: web3.eth.accounts[1]})

이걸로 트랜잭션 실행시킴

app.getStudentInfo(1111)



가나슈를 쓰려면 test의 truffle.js에서 환경설정을 해야함

```javascript
module.exports = {
	// 이 안을 지우고 수정
	network: {
		ganache: {
			host: "localhost",
			port: 8545,
			network_id: "*" // 어떤 네트워크든 가능
		}
	}
}
```

 ```
truffle migrate --compile-all --reset --network ganache

// 콘솔창에서 놀기
truffle console --network ganache
 ```

