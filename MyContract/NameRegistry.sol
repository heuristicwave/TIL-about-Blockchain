pragma solidity ^0.4.24;

contract NameRegistry {

    struct Contract {
        address owner;
        address addr;
        bytes32 description;
    }

    uint public numContracts; // 등록된 레코드 수

    mapping (bytes32 => Contract) public contracts;

    constructor () public {
        numContracts = 0;
    }

    function register(bytes32 _name) public returns (bool) {
        // 아직 사용되지 않은 이름이면 신규 등록
        if (contracts[_name].owner == 0) {
            Contract storage con = contracts[_name];
            con.owner = msg.sender;
            numContracts++;
            return true;
        } else {
            return false;
        }
    }

    /// 계약 해지
    function unregister(bytes32 _name) public returns (bool) {
        if (contracts[_name].owner == msg.sender) {
            contracts[_name].owner = 0;
            numContracts--;
            return true;
        } else {
            return false;
        }
    }

    modifier onlyOwner(bytes32 _name) {
        require(contracts[_name].owner == msg.sender);
        _;
    }
    /// 계약 소유자 변경
    function changeOwner(bytes32 _name, address _newOwner) public onlyOwner(_name) {
        contracts[_name].owner = _newOwner;
    }

    /// 계약 소유자 정보 확인
    function getOwner(bytes32 _name) view public returns (address) {
        return contracts[_name].owner;
    }

    /// 계약 어드레스 변경
    function setAddr(bytes32 _name, address _addr) public onlyOwner(_name) {
        contracts[_name].addr = _addr;
    }

    /// 계약 어드레스 확인
    function getAddr(bytes32 _name) view public returns (address) {
        return contracts[_name].addr;
    }

    /// 계약 설명 변경
    function setDescroption(bytes32 _name, bytes32 _description) public onlyOwner(_name) {
        contracts[_name].description = _description;
    }

    /// 계약 설명 확인
    function getDescrption(bytes32 _name) view public returns (bytes32) {
        return contracts[_name].description;
    }
}