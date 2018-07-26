## FinalizableCrowdsale (ver 1.10.0)

마감후 오너가 extra work를 할 수 있는 Crowdsale

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/distribution/FinalizableCrowdsale.sol >

````
import "../../math/SafeMath.sol";
import "../../ownership/Ownable.sol";
import "../validation/TimedCrowdsale.sol";
````

------



#### Variable

using SafeMath for uint256;

bool public isFinalized = false;



event Finalized(); 

------



### Functions



##### finalize 

````
function finalize() onlyOwner public {
    require(!isFinalized);
    require(hasClosed());

    finalization();
    emit Finalized();

    isFinalized = true;
  }
````

추가적인 마무리 작업을 하기 위해서는 크라우드세일이 끝나고 콜해야 한다. 계약확정 함수를 콜한다.



##### finalization

````
function finalization() internal {
  }
````

최종 로직을 추가하기위해 오버라이드될 수 있다. 오버라이딩한 함수는 완전하게 실행되는 최종작업을  체인에 등록할때 super.finalization()를 사용한다.