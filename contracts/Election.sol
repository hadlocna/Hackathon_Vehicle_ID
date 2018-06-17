pragma solidity ^0.4.2;

contract Election {
    // Model a Candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
        string vin;
    }

    // Store accounts that have voted
    mapping(address => bool) public authorized;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => Candidate) public candidates;
    // Store Candidates Count
    uint public candidatesCount;

    // voted event
    event votedEvent (
        uint indexed _candidateId
    );

    function Election () public {
        // Authorize certain people
        authorized[0x8586c212FDC0bf87dd6Fd90fFec35b0c29301872] = true;

        // Defining authorized persons
        addCandidate("Nathan", "Hadlock");
        addCandidate("Tom", "Biskup");
    }

    function addCandidate (string _name, string _vin) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, _vin);
    }

    function vote (uint _candidateId) public {
        // Check that the sender is authorized
        require(!authorized[msg.sender]);

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // record that voter has voted
        authorized[msg.sender] = true;

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        votedEvent(_candidateId);
    }
}
