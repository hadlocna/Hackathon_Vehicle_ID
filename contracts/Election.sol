pragma solidity ^0.4.2;

contract Election {
    // Model a Candidate
    struct Vehicle {
        string id;
        string fname;
        string lname;        
        string vin;        
        string model;        
        string date; //In 'mm/dd/yy' format  
        uint readCount; //how many times your record has been read      
    }

    // Store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(uint => Vehicle) public vehicles;
    // Store Candidates Count
    uint public vehiclesCount;

    // voted event
    event votedEvent (
        uint indexed _vehicleId
    );

    function Election () public {
        addVehicle("ABY485", "Nathan", "Hadlock", "JHDUEUJ12388U8FJEBJRFUBCDSEW12488", "Mercedes-Benz-EClass", "02/14/1995", 0);
        addVehicle("CD6795", "Tom", "Biskup", "JHAXSAQPOIIWE878378JFHIURI23U8R90","Volkswagen-FClass", "09/16/2000", 0);
    }

    function addVehicle (string _id, string _fname, string _lname, string _vin, string _model, string _date, uint _readCount) private {
        vehiclesCount ++;
        vehicles[vehiclesCount] = Vehicle(_id, _fname, _lname, _vin, _model, _date, _readCount);
    }

    function vote (uint _vehicleId) public {
        // require that they haven't voted before
        require(!voters[msg.sender]);

        // require a valid candidate
        require(_vehicleId > 0 && _vehicleId <= vehiclesCount);

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        vehicles[_vehicleId].readCount ++;

        // trigger voted event
        votedEvent(_vehicleId);
    }
}
