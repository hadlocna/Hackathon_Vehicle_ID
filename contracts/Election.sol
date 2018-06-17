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
        address admin = 0xD482940Ba6B2429b38E634B50A954EA7803011D0;
        address admin2 = 0x5629cB04722435AE2C85e37a1Fd61f0AF6EA4dC0;
        address peasant = 0x8586c212FDC0bf87dd6Fd90fFec35b0c29301872;
        address peasant2 = 0x3CD7e4491244176E70239C92353F3f7f43146C8D;
        authorized[admin] = true;
        authorized[admin2] = true;
        authorized[peasant] = false;
        authorized[peasant2] = false;

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

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        votedEvent(_candidateId);
    }
}
