문제 해설에 들어가기 전,  이더넛 내에서 콘솔창과 상호작용을 할 줄 알고 기본적인 리믹스 및 메타마스크 사용법이 숙지되어 있다는 가정 하에 해설을 진행합니다. 필자의 풀이 방법이 절대적은 풀이 방법은 아니므로 이 점 참고하시기 바랍니다.

![대표이미지](https://github.com/heuristicwave/TIL-about-Blockchain/blob/master/OpenZeppelin/ethernaut/Heuristic%20Wave%20Ethernaut.png?raw=true)



## Alien Codex Problem



이번에도 역시 주어진 조건을 읽어보자. 필자의 초월해석이 담겨 있기 때문에, 원문을 직접 읽는 것이 제일 좋다. 이번 문제는 내 힘으로 푼것이 거의 아니,,, 아예 없다. 오랜만이라는 핑계를 대고 싶지만, 아직 부족해서 https://ylv.io/ethernaut-alien-codex-solution/ 에 포스팅된 해설을 해석해가며 이해한대로 써내려관 결과물이다. 내가 최대한 이해하려고 애쓴, Igor Yalovoy의 풀이에 덧붙인 설명 시작!



Alien 컨트랙트를 찾았다. 오너십을 주장하여 이번단계를 해결하자!

- 어떻게 배열이 저장되는지 이해하여야 한다.
- ABI의 특징들을 이해해야 한다.
- Using a very `underhanded` approach (무슨말인지 잘 모르겠다)





### 코드 분석



#### AlienCodex.sol

```javascript
pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract AlienCodex is Ownable {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }
  
  function make_contact(bytes32[] _firstContactMessage) public {
    assert(_firstContactMessage.length > 2**200);
    contact = true;
  }

  function record(bytes32 _content) contacted public {
  	codex.push(_content);
  }

  function retract() contacted public {
    codex.length--;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }
}
```

코드를 봐도 무슨말인지 모르겠다. 그러나, remix에서 주어진 instanceAddress를 넣고 불러와보니 현재, contact의 값은 false인 상태고 record, retract, revise 3개의 함수 모두 contacted라는 modifier를 가지고 있다. 여기서 make_contact로 contact의 값을 true로 먼저 바꿔야지 다른 함수들이 접근 가능하다는 것을 알 수 있다.

그 다음 3개의 함수를 보니 이전 문제들과는 다르게 오너를 바꾸는 함수가 존재 하지 않는다. 각각의 기능을 살펴보면 record에서는 동적할당을 하고, retract에서는 동적배열의 길이에서 1을 빼고, revise에서는 동적배열을 _content로 쓴다. 힌트와 조합하여 생각해보면, 어떤 동적배열이 오너와 관련이 있을 것이고 그배열을 revise함수를 사용하여 나의 주소값을 넣으면 해결이 될 것 같다는 느낌적인 느낌이 든다.



우선, contact를 true로 변환해 보자!

(_firstContactMessage.length > 2**200) 의 조건을 맞추면, contact의 값이 true로 바뀐다. 메시지의 길이가 2^200보다 크면 성공한다는 조건에 다음과 같은 트랜잭션을 보낼수 있는 코드를 작성했다. 

```
sendTransaction({to: "0x2abc6d922d6c6413adfc826ff4c5669ce9dd6bed", data: "0x1d3d4c0b00000000000000000000000000000000000000000000000000000000000000201000000000000000000000000000000000000000000000000000000000000000", from: "0x344FbEe17c2d215D364EC5943Bc4a0c7030cfaA1", gas: 900000});
```

to는 InstanceAddress에 해당하고 data 부분에 payload에 해당하는 부분의 16진수data를 넣으면된다. 우리는 make_contact라는 함수를 호출할것이기 때문에, ABI에서 해당하는 functionSelector를(1d3d4c0b) 찾자!  우리는 데이터 값을 넣기위해서 OPCODE를 16진수로 변환한 (0x20)도함께 넣을 것이다. 이어서, 2의 200제곱은 (1606938044258990275541962092341162602522202993782792835301376) 이다. 이것을16진수로 표현하면 0x100000000000000000000000000000000000000000000000000 (0이50개)이기 때문에 이것보다 길이가 길면된다. EVM슬롯의 크기는 32byte로 64글자를 채우기위해 부족한만큼 0을 채워 data를 만들면 된다.

내가 참고한 자료에서는 1뒤에 0을 63개를작성해서 64



---

### 컨트랙트가 만들어 지는 과정



---



### 문제 풀이 과정



[Etherscan(ROPSTEN)](https://ropsten.etherscan.io/)을 통해서 거래과정을 추적할 수 있다.

우선적으로, 발급받은 문제인 Instance Address를 이더스캔에 조회해보자!

> [19번 문제풀이](https://medium.com/coinmonks/ethernaut-lvl-19-magicnumber-walkthrough-how-to-deploy-contracts-using-raw-assembly-opcodes-c50edb0f71a2)

이더넛 정상에 오르기까지, 내 힘으로 푼 문제도 있었지만 다른 분들의 포스팅의 도움을 받아서 해결하기도하였다. 특히 11번? 문제 이후로부터 어려울때마다 도움을 주신 [Nicole Zhu](https://medium.com/@nicolezhu?source=post_header_lockup)님께 감사하다. 이 분의 포스팅은 문제를 풀기위해 필요한 지식을 잘 설명해 주는 것과 더불어 길을 터주시고 독자들이 문자를 스스로 해결 할 수 있도록 정답에 가까운 길로 인도해주셨다. (필자는 이것도 어려워서 몇 시간을 분투하던 기억이 머리속에 선하다. 때문에 포스팅을 할 때, 필자와 같은 사람이 있을것이라고 생각하여 풀이과정을 일일히 캡쳐하여 담았다. 그래도 스스로 생각해보는 시간을 갖고 문제에 들어가면 더욱더 도움이 될 것 같다.)

3달전 마지막으로 19번 문제를 풀고 기말고사 준비로 손을 놓고 있다보니, 다시 머리를 쓰기가 무척이나 힘들었다. (이게 다 게으름 때문이지만...) 최근 들어 구글링을 해보니 나 말고도 문제풀이를 올리시는 분들이 보이기 시작했다. 어서 빨리 나도 연재를 끝내야지....  3달 동안 내 실력도 많이 늘어 이전문제에 대한 풀이 방법이 부끄럽게 느껴진다. 



21번 문제 Denial에서 만나요!