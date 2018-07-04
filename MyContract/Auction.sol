pragma solidity ^0.4.25;

contract Auction {
	address public highestBidder;	// 최고 입찰자 주소
	uint public highestBid;	// 최고 입찰액
	
	constructor () public payable  {
		highestBidder = msg.sender;
		highestBid = 0;
	}
	
	/// 입찰 처리 함수
	function bid() public payable {
		// 현재 입찰액이 최고 입찰액보다 높은지 확인
		require(msg.value > highestBid);
		
		// 기존 최고 입찰자에게 반환할 액수 설정
		uint refundAmount = highestBid;
		
		// 최고 입찰자 주소 업데이트
		address currentHighestBidder = highestBidder;
		
		// 상태값 업데이트
		highestBid = msg.value;
		highestBidder = msg.sender;
		
		// 이전 최고액 입찰자에게 입찰금 반환
		if(!currentHighestBidder.send(refundAmount)) {
			throw;
		}
		/*send 앞에는 송금 대상이 되는 address 인자로 송금액(wei)을 지정한다. 송금실패시 false 리턴0 */
	}
}
