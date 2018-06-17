var Election = artifacts.require("./Election.sol");

contract("Election", function(accounts) {
  var electionInstance;

  it("initializes with two vehicles", function() {
    return Election.deployed().then(function(instance) {
      return instance.vehiclesCount();
    }).then(function(count) {
      assert.equal(count, 2);
    });
  });

  it("it initializes the vehicles with the correct values", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.vehicles(1);
    }).then(function(vehicle) {
      assert.equal(vehicle[0], 1, "contains the correct id");
      assert.equal(vehicle[1], "vehicle 1", "contains the correct name");
      assert.equal(vehicle[2], 0, "contains the correct votes count");
      return electionInstance.vehicles(2);
    }).then(function(vehicle) {
      assert.equal(vehicle[0], 2, "contains the correct id");
      assert.equal(vehicle[1], "vehicle 2", "contains the correct name");
      assert.equal(vehicle[2], 0, "contains the correct votes count");
    });
  });

  it("allows a voter to cast a vote", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      vehicleId = 1;
      return electionInstance.vote(vehicleId, { from: accounts[0] });
    }).then(function(receipt) {
      assert.equal(receipt.logs.length, 1, "an event was triggered");
      assert.equal(receipt.logs[0].event, "votedEvent", "the event type is correct");
      assert.equal(receipt.logs[0].args._vehicleId.toNumber(), vehicleId, "the vehicle id is correct");
      return electionInstance.voters(accounts[0]);
    }).then(function(voted) {
      assert(voted, "the voter was marked as voted");
      return electionInstance.vehicles(vehicleId);
    }).then(function(vehicle) {
      var readCount = vehicle[2];
      assert.equal(readCount, 1, "increments the vehicle's vote count");
    })
  });

  it("throws an exception for invalid candiates", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.vote(99, { from: accounts[1] })
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert");
      return electionInstance.vehicles(1);
    }).then(function(vehicle1) {
      var readCount = vehicle1[6];
      assert.equal(readCount, 1, "vehicle 1 did not receive any votes");
      return electionInstance.vehicles(2);
    }).then(function(vehicle2) {
      var readCount = vehicle2[6];
      assert.equal(readCount, 0, "vehicle 2 did not receive any votes");
    });
  });

  it("throws an exception for double voting", function() {
    return Election.deployed().then(function(instance) {
      electionInstance = instance;
      vehicleId = 2;
      electionInstance.vote(vehicleId, { from: accounts[1] });
      return electionInstance.vehicles(vehicleId);
    }).then(function(vehicle) {
      var readCount = vehicle[6];
      assert.equal(readCount, 1, "accepts first vote");
      // Try to vote again
      return electionInstance.vote(vehicleId, { from: accounts[1] });
    }).then(assert.fail).catch(function(error) {
      assert(error.message.indexOf('revert') >= 0, "error message must contain revert");
      return electionInstance.vehicles(1);
    }).then(function(vehicle1) {
      var readCount = vehicle1[6];
      assert.equal(readCount, 1, "vehicle 1 did not receive any votes");
      return electionInstance.vehicles(2);
    }).then(function(vehicle2) {
      var readCount = vehicle2[6];
      assert.equal(readCount, 1, "vehicle 2 did not receive any votes");
    });
  });
});
