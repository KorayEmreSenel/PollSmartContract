// SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.0;

contract PullRequestPoll{

        struct Poll {
        uint id;
        address creator;
        string link;
        uint startTime;
        uint endTime;
        uint approveVotes;
        uint declineVotes;
    }

    uint public count;

    mapping(uint => Poll) public idToPoll;
    mapping(address => uint[]) public addressToVotedPolls;

    event CreatePoll (uint id, address creator, string link);
    event Vote (uint id, address voter, uint option);

    function createPoll(string memory _link, uint _startTime, uint _endTime) public {
        count++;

        Poll memory _poll = Poll({
            id: count,
            creator: msg.sender,
            link: _link,
            startTime: _startTime,
            endTime: _endTime,
            approveVotes: 0,
            declineVotes: 0
        });
    
    idToPoll[count] = _poll;

    emit CreatePoll(count, msg.sender, _link);
    }

    function isVoted(uint _id) private view returns (bool){
        for (uint i = 0; i < addressToVotedPolls[msg.sender].length; i++) {
        if(addressToVotedPolls[msg.sender][i] == _id) {
        return true;
      }
    }
    return false;
    }

    function vote (uint _id, uint _index) public{
        Poll storage poll = idToPoll[_id];
        require(_id <= count);
        require(!isVoted(_id));
        require(poll.startTime <= block.timestamp && poll.endTime >= block.timestamp );
        if(_index == 0)
        poll.approveVotes++;
        else
        poll.declineVotes++;
        addressToVotedPolls[msg.sender].push(_id);
        emit Vote(_id, msg.sender, _index);
    }

}
