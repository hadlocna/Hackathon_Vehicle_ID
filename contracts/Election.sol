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

        addVehicle(1, "Nathan", "Hadlock", "JHDUEUJ12388U8FJEBJRFUBCDSEW12488", "Mercedes-Benz-EClass", "02/14/1995", 0);
        addVehicle(2, "Tom", "Biskup", "JHAXSAQPOIIWE878378JFHIURI23U8R90","Volkswagen-FClass", "09/16/2000", 0);

        // Authorize certain people
        address admin = 0xD482940Ba6B2429b38E634B50A954EA7803011D0;
        address admin2 = 0x5629cB04722435AE2C85e37a1Fd61f0AF6EA4dC0;
        address peasant = 0x8586c212FDC0bf87dd6Fd90fFec35b0c29301872;
        address peasant2 = 0x3CD7e4491244176E70239C92353F3f7f43146C8D;
        authorized[admin] = true;
        authorized[admin2] = true;
        authorized[peasant] = false;
        authorized[peasant2] = false;

        
    }

    function addVehicle (uint _id, string _fname, string _lname, string _vin, string _model, string _date, uint _readCount) private {
        vehiclesCount ++;
        vehicles[vehiclesCount] = Vehicle(_id, _fname, _lname, _vin, _model, _date, _readCount);
    }


    function vote (uint _vehicleId) public {
       
        require(authorized[msg.sender]);


        // require a valid candidate
        require(_vehicleId > 0 && _vehicleId <= vehiclesCount);

        // update candidate vote Count
        vehicles[_vehicleId].readCount ++;

        // trigger voted event
        votedEvent(_vehicleId);
    }
}
