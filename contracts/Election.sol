pragma solidity ^0.4.2;

contract Election {
    // Model a vehicle
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
    // Fetch vehicle
    mapping(uint => Vehicle) public vehicles;
    // Store Candidates Count
    uint public vehiclesCount;

    // voted event
    event votedEvent (
        uint indexed _vehicleId
    );

    function Election () public {
        addVehicle(1, "Tom", "Biskup", "JHAXSAQPOIIWE878378JFHIURI23U8R90","Volkswagen-FClass", "09/16/2000", " ", 0);

        // Authorize certain people
        address nathanAuth = 0x5dE32589bf4cAfA976c062Ba370CBd3eddBD5953;
        address keerthanaAuth = 0x41979C70443714bb0a49294ABd09653EfAE94Ec5;
        address tomAuth = 0xd82d10e270770e4ec46483a52577FE85e35472A9;

				// Unauthorized addresses
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


    function update (uint _vehicleId,  string _name, string _lastName) public {
        // Check that the sender is authorized
        require(authorized[msg.sender]);
        vehicles[_vehicleId].fname = _name;
        vehicles[_vehicleId].lname = _lastName;
       
        // require a valid candidate
        require(_vehicleId > 0 && _vehicleId <= vehiclesCount);

        // trigger voted event
        votedEvent(_vehicleId);
    }

    function read (uint _vehicleId) public {
        require(authorized[msg.sender]);
        vehicles[_vehicleId].readconfirm = "We can read successfully";
        votedEvent(_vehicleId);
        
    }
}
