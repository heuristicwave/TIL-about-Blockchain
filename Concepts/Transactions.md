## Transactions

### Transaction Signing

트랜잭션 서명 == RLP 시리얼라이즈 TX에, Keccak-256 해시에 서명



**서명 과정**

1. nonce, gasPrice, gasLimit, to, value, data, chainID, 0, 0의 9개 필드를 포함하는 데이터구조 만들기
2. RLP로 인코딩된 데이터 구조의 시리얼라이즈 메시지 생성
3. 시리얼라이즈 메시지에 Keccak-256 해시 계산
4. EOA의 개인키로 해시에 서명하여 ECDSA 서명 계산
5. ECDSA 서명에 계산된 v, r, s 값을 트랜잭션에 추가



서명 변수 v는 ECDSArecover 함수가 서명을 확인하는데 도움이 되는 복구 식별자와 체인 ID다. v는 27, 28 중 하나로 계산되거나, 체인 ID의 2배에 35또는 36이 더해져 계산된다. 





#### Raw Transaction Creation and Signing

https://github.com/ethereumbook/ethereumbook/blob/develop/code/web3js/raw_tx/raw_tx_demo.js









---

#### Reference

https://github.com/ethereumbook/ethereumbook/blob/develop/06transactions.asciidoc