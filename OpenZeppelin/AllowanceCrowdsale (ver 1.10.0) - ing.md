

## AllowanceCrowdsale  (ver 1.10.0)

...

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/emission/AllowanceCrowdsale.sol >

````
import "../Crowdsale.sol";
import "../../token/ERC20/ERC20.sol";
import "../../math/SafeMath.sol";
````

------



#### Variable

address public tokenWallet; 

------



### Constructor

````
constructor(address _tokenWallet) public {
  require(_tokenWallet != address(0));
  tokenWallet = _tokenWallet;
}
````



------



### Functions



##### remainingTokens 

````
function remainingTokens() public view returns (uint256) {
  return token.allowance(tokenWallet, this);
}
````

AllowanceCrowdsale 의 CA에 tokenWallet이 허락한 토큰의 양

**Returns** : 



##### _deliverTokens

````
function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
  token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
}
````

토큰을 토큰 구매자의 주소로 토큰 월렛에서 정한 양만큼 보내주는 함수
