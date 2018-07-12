 pragma solidity ^0.4.23;

contract CrowdFunding {
    struct Investor {
        address investAdd;
        uint amount;
    }

    address public owner;
    uint public numInvestors;
    uint public deadline; // 마감일(UNIXTIME)
    string public status; // 모금활동
    bool public ended;  // 모금 종료여부
    uint public goalAmount; // 목표액
    uint public totalAmount; //  총 투자액

    mapping (uint => Investor) public investors; // 투자자 관리를 위한 매핑

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor (uint _duration, uint _goalAmount) public {
        owner = msg.sender;

        //마감일 설정
        deadline = now + _duration;

        goalAmount = _goalAmount;
        status = "Funding";
        ended = false;

        numInvestors = 0;
        totalAmount = 0;
    }

    function fund() payable public {
        require(!ended);

        Investor storage inv = investors[numInvestors++];
        inv.investAdd = msg.sender;
        inv.amount = msg.value;
        totalAmount += inv.amount;
    }

    function checkGoalReached () public onlyOwner {
        require(!ended);

        require(now >= deadline);

        if(totalAmount >= goalAmount) {
            status = "Campaign Succeeded";
            ended = true;

            if(!owner.send(address(this).balance)) {
                revert();
            }
        } else {
            uint i = 0;
            status = "Campaign Failed";
            ended = true;

            while ( i <= numInvestors) {
                if(!investors[i].investAdd.send(investors[i].amount)) {
                    revert();
                }
                i++;
            }
        }
    }

     function kill() public onlyOwner {
            selfdestruct(owner);
        }
}