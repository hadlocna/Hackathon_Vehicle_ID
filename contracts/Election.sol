pragma solidity ^0.4.2;

contract Election {
    // Model a Candidate
    struct Vehicle {
        uint id;
        string fname;
        string lname;        
        string vin;        
        string model;        
        string date; //In 'mm/dd/yy' format  
        string readconfirm;
        uint readCount; //how many times your record has been read      
    }

    // Store accounts that have voted
    mapping(address => bool) public authorized;
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

        addVehicle(1, "Nathan", "Hadlock", "JHDUEUJ12388U8FJEBJRFUBCDSEW12488", "Mercedes-Benz-EClass", "02/14/1995", " ", 0);
        addVehicle(2, "Tom", "Biskup", "JHAXSAQPOIIWE878378JFHIURI23U8R90","Volkswagen-FClass", "09/16/2000", " ", 0);

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

        
    }

    function addVehicle (uint _id, string _fname, string _lname, string _vin, string _model, string _date, string _readconfirm, uint _readCount) private {
        vehiclesCount ++;
        vehicles[vehiclesCount] = Vehicle(_id, _fname, _lname, _vin, _model, _date, _readconfirm, _readCount);
    }


    function update (uint _vehicleId,  string _name) public {
        // Check that the sender is authorized
        

        require(authorized[msg.sender]);
        vehicles[_vehicleId].fname = _name;
       


        // require a valid candidate
        require(_vehicleId > 0 && _vehicleId <= vehiclesCount);

        // update candidate vote Count
        vehicles[_vehicleId].readCount ++;

        // trigger voted event
        votedEvent(_vehicleId);
    }

    function read (uint _vehicleId) public {
        require(authorized[msg.sender]);
        vehicles[_vehicleId].readconfirm = "We can read successfully";
        votedEvent(_vehicleId);
        
    }
}
