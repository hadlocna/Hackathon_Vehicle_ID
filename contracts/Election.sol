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
        address nathanAuth = 0xF415156fA2540e1488CE57B7CC4f751642f7f90c;
        address keerthanaAuth = 0x5629cB04722435AE2C85e37a1Fd61f0AF6EA4dC0;
        address tomAuth = 0xd82d10e270770e4ec46483a52577FE85e35472A9;
        address nathanNotAuth = 0x8586c212FDC0bf87dd6Fd90fFec35b0c29301872;
        address keerthanaNotAuth = 0x3CD7e4491244176E70239C92353F3f7f43146C8D;
        address tomNotAuth = 0x27A0a1541976E203EDef3743B5F237e4da263f59;
        authorized[nathanAuth] = true;
        authorized[keerthanaAuth] = true;
        authorized[tomAuth] = true;
        authorized[nathanNotAuth] = false;
        authorized[keerthanaNotAuth] = false;
        authorized[tomNotAuth] = false;

        // Defining authorized persons
        addCandidate("Nathan", "Hadlock");
        addCandidate("Tom", "Biskup");
    }

    function addCandidate (string _name, string _vin) private {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, _vin);
    }

    function vote (uint _candidateId, string _name) public {
        // Check that the sender is authorized
        
        require(authorized[msg.sender]);
        candidates[_candidateId].name = _name;
       

        // require a valid candidate
        require(_candidateId > 0 && _candidateId <= candidatesCount);

        // update candidate vote Count
        candidates[_candidateId].voteCount ++;

        // trigger voted event
        votedEvent(_candidateId);
    }
}
