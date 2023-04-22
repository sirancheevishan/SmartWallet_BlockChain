// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <=0.9.0;

contract SmartWallet {
    address owner;
    mapping(address => uint256) AllowanceLimit;
    mapping(address => bool) AllowanceList;
    mapping(address => bool) GuirdianList;
    mapping(address => mapping(address => bool)) AlreadyVotedGuardianList;
    address _nextOwner;
    uint256 VotedGuirdianCount;
    constructor() {
        owner = msg.sender;
    }

    function AddGuirdian(address _add) public {
        if (owner == msg.sender) {
            GuirdianList[_add] = true;
        }
    }

    function GetBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function ProposeNewOwner(address _add) public {
        require(
            GuirdianList[msg.sender],
            "You are not allowed to set new owner"
        );
        if (_add != _nextOwner) {
            _nextOwner = _add;
            VotedGuirdianCount = 0;
        }
        //require(AlreadyVotedGuardianList[_add][msg.sender], "You aleady voted");
        VotedGuirdianCount++;
        AlreadyVotedGuardianList[_add][msg.sender] = true;
        if (VotedGuirdianCount == 3) {
            owner = _nextOwner;
        }
    }

    function viewGuardian(address _add) public view returns (bool) {
        return GuirdianList[_add];
    }

    function AddAllowance(address _add, uint256 amount) public {
        if (owner == msg.sender) {
            AllowanceList[_add] = true;
            if (amount > 0) {
                AllowanceLimit[_add] += amount;
            }
        }
    }

    function ViewAllowanceMember(address AllowanceAdd)
        public
        view
        returns (bool isAllwanceUser, uint256 AllowanceAmount)
    {
        isAllwanceUser = AllowanceList[AllowanceAdd];
        AllowanceAmount = AllowanceLimit[AllowanceAdd];
    }

    function Transfer(
        address _to,
        uint256 Amount,
        bytes memory payload
    ) public returns (bytes memory) {
        if (owner != msg.sender) {
            require(
                AllowanceList[msg.sender],
                "You are not allowed to transaction"
            );
            require(
                AllowanceLimit[msg.sender] > Amount,
                "You can not tranfer more than you allowed"
            );
            AllowanceLimit[msg.sender] -= Amount;
        }
        (bool result, bytes memory returData) = _to.call{value: Amount}(
            payload
        );
        // (bool success, bytes memory returnData) = _to.call{value: Amount}(payload);

        require(result, "Invalid Transfer");
        return returData;
    }

    function EncodeString(string memory _input)
        public
        pure
        returns (bytes memory)
    {
        bytes memory payload = abi.encodeWithSignature(_input);
        return payload;
    }

    function GetCurrentUser() public view returns (address) {
        return msg.sender;
    }

    function GetOwner() public view returns (address) {
        return owner;
    }

    receive() external payable {}
}

contract Consumer {
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function Depostit() public payable {}
}
