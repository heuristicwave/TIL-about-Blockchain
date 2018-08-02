### Hierarchical deterministic wallet

Hierarchical deterministic wallet은 **seed**라고 불리는 단일 시작 지점으로 부터 주소와 키를 얻어낼 수 있는 시스템이다. **Deterministic**이란 만약 같은 시드를 사용하면 같은 주소와 키를 생성할 수 있음을 의미하며, **Hierarchical**이란 주소와 키가 같은 순서로 생성됨을 의미한다. 이는 개별 키와 주소를 저장하지 않고 단지 시드만 저장하면 다수의 계좌를 백업하고 저장하는 것을 쉽게 해준다.

다양한 HD 지갑이 있으며, 시드의 형식과 주소 및 키를 생성하는 알고리즘 간에는 차이가 있다.

ex) BIP32, Armory, Coinkite, Coinb.in

BIP (Bitcoin Improvement Proposal)은 비트코인 커뮤니티에 정보를 제공하거나 비트코인 및 절차 환경에 대한 새로운 기능을 설명하는 디자인 문서다. BIP32 및 BIP39는 각각  HD 지갑을 구현하기 위한 알고리즘과 mnemonic 시드 사양에 대한 정보를 제공함. https://github.com/bitcoin/bips



### 키 유도 함수

대칭 암호화 알고리즘은 키의 크기만을 정의한다. KDF(key derivation function)는 비밀 값(마스터키, 비밀번호, 비밀 구문)으로부터 대칭키를 얻기 위한 알고리즘이다. 비밀번호 기반의 키 유도 함수는 비밀번호를 받아들여 대칭 키를 생성한다. 사용자들이 대개 약한 보안 수준의 비밀번호를 사용하므로 비밀번호 기반의

p158이후