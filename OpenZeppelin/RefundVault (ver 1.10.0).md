### RefundVault  (ver 1.10.0)

Crowdsale이 진행되는 동안 자금을 보관하는 데 사용한다. crowdsale가 실패하면 환불하고 crowdsale가 성공하면 송금한다. 

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/distribution/utils/RefundVault.sol>

````
import "../../../math/SafeMath.sol";
import "../../../ownership/Ownable.sol";
````

------

#### Enum

State { Active, Refunding, Closed } 



#### Mapping

mapping (address => uint256) public deposited; 



#### Variable

address public wallet; 

State public state;

------



###  Constructor

````
constructor(address _wallet) public {
  require(_wallet != address(0));
  wallet = _wallet;
  state = State.Active;
}
````

------



### Functions



##### deposit 

````
function deposit(address investor) onlyOwner public payable {
  require(state == State.Active);
  deposited[investor] = deposited[investor].add(msg.value);
}
````

활성화  상태이면, 투자자의 금액을 더한다. 



##### close

````
function close() onlyOwner public {
  require(state == State.Active);
  state = State.Closed;
  emit Closed();
  wallet.transfer(address(this).balance);
}
````

활성화 상태에서 잠금 상태로 바꾸는 함수. 상태를 바꾼 후, 이 컨트랙트의 금액을 지갑으로 이동



##### enableRefunds 

````
function enableRefunds() onlyOwner public {
  require(state == State.Active);
  state = State.Refunding;
  emit RefundsEnabled();
}
````

환불 가능 상태로 만드는 함수



##### refund 

````
function refund(address investor) public {
  require(state == State.Refunding);
  uint256 depositedValue = deposited[investor];
  deposited[investor] = 0;
  investor.transfer(depositedValue);
  emit Refunded(investor, depositedValue);
}
````

환불 가능한 상태 일때, 투자자의 보증금을 0으로 만들고, 투자자의 계좌로 전송한다.