## MintedCrowdsale  (ver 1.10.0)

각 구매에서 토큰이 mint되는 Crowdsale, 토큰 소유권은 minting를 위해 MinatCrowdsale로 옮겨져야 한다.

< a href = https://github.com/OpenZeppelin/openzeppelin-solidity/blob/v1.10.0/contracts/crowdsale/emission/MintedCrowdsale.sol >

````
import "../Crowdsale.sol";
import "../../token/ERC20/MintableToken.sol";
````

------



### Functions



##### _deliverTokens 

````
function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
  require(MintableToken(token).mint(_beneficiary, _tokenAmount));
}
````
