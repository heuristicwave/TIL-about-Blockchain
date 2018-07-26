## RefundableCrowdsale (ver 1.10.0)

자금 펀딩 목표가 있는 Crowdsale이다. 목표에 달성하지 못하면 환불 가능성이 있다.

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/distribution/RefundableCrowdsale.sol >

````
import "../../math/SafeMath.sol";
import "./FinalizableCrowdsale.sol";
import "./utils/RefundVault.sol";
````

------



#### Variable

uint256 public goal;	// `wei`로 모금된 최소 펀딩

RefundVault public vault;	 // crowdsale가 실행되는 동안 자금을 보관하는 데 사용되는 환불 금고 

------



###  Constructor

````
constructor(uint256 _goal) public {
    require(_goal > 0);
    vault = new RefundVault(wallet);
    goal = _goal;
  }
````

------



### Functions



##### claimRefund 

````
 function claimRefund() public {
    require(isFinalized);
    require(!goalReached());

    vault.refund(msg.sender);
  }
````

만약 크라우드세일이 성공하지 못하면 투자자들이 이 함수를 통해서 환불을 요청 할 수 있다.



##### goalReached

````
 function goalReached() public view returns (bool) {
    return weiRaised >= goal;
  }
````

목표금액에 달성했는지 체크하는 함수



##### finalization 

````
function finalization() internal {
    if (goalReached()) {
      vault.close();
    } else {
      vault.enableRefunds();
    }

    super.finalization();
  }
````

오너가 finalize()를 호출할때 금고가 닫히는 함수.  목표에 달성했으면 금고를 닫고 그렇지 않으면 환불이 가능하게 한다. 완료되면 finalization()을 호출



##### _forwardFunds 

````
function _forwardFunds() internal {
  vault.deposit.value(msg.value)(msg.sender);
}
````

Overrides Crowdsale fund forwarding, sending funds to vault. 

포워딩하는거 무시하고 금고로 펀드를 보내는데 여기가 약간 부실함....