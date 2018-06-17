App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',
  hasVoted: false,

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // TODO: refactor conditional
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("Election.json", function(election) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Election = TruffleContract(election);
      // Connect provider to interact with contract
      App.contracts.Election.setProvider(App.web3Provider);

      App.listenForEvents();

      return App.render();
    });
  },

  // Listen for events emitted from the contract
  listenForEvents: function() {
    App.contracts.Election.deployed().then(function(instance) {
      // Restart Chrome if you are unable to receive this event
      // This is a known issue with Metamask
      // https://github.com/MetaMask/metamask-extension/issues/2393
      instance.votedEvent({}, {
        fromBlock: 0,
        toBlock: 'latest'
      }).watch(function(error, event) {
        console.log("event triggered", event)
        // Reload when a new vote is recorded
        App.render();
      });
    });
  },

  render: function() {
    var electionInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.vehiclesCount();
    }).then(function(vehiclesCount) {
      var vehiclesResults = $("#vehiclesResults");
      vehiclesResults.empty();

      var vehiclesSelect = $('#vehiclesSelect');
      vehiclesSelect.empty();

      for (var i = 1; i <= vehiclesCount; i++) {
        electionInstance.vehicles(i).then(function(vehicle) { 
          var id = vehicle[0];
          var fname = vehicle[1];
          var lname = vehicle[2];        
          var vin = vehicle[3];          
          var model = vehicle[4];        
          var date = vehicle[5]; //In 'mm/dd/yy' format  
          var readCount = vehicle[6];
 
          // Render candidate Result
          var vehicleTemplate = "<tr><th>" + id + "</th><td>" + fname +"</td><td>" + lname +"</td><td>" + vin + "</td><td>"+ model + "</td><td>" + date + "</td><td>" + readCount + "</td></tr>"
          vehiclesResults.append(vehicleTemplate);

          // Render candidate ballot option
          var vehicleOption = "<option value='" + id + "' >" + fname + "</ option>"
          vehiclesSelect.append(vehicleOption);
        });
      }
      return electionInstance.authorized(App.account);
    }).then(function(hasVoted) {
      // Do not allow a user to vote
      if(hasVoted) {
        //$('form').hide();
      }
      loader.hide();
      content.show();
    }).catch(function(error) {
      console.warn(error);
    });
  },

  castVote: function() {

    var vehicleId = $('#vehiclesSelect').val();
    var name = $('#ownerName').val();
    console.log($('#cryptAddress').val())
    //var encrypted = $('#cryptAddress').val();
    var encrypted = CryptoJS.AES.encrypt($('#cryptAddress').val(), "Secret Passphrase");
    var decryptAddress = CryptoJS.AES.decrypt(encrypted, "Secret Passphrase");
    console.log(encrypted)
    console.log(decryptAddress)
    console.log(decryptAddress.toString(CryptoJS.enc.Utf8))
    App.contracts.Election.deployed().then(function(instance) {
      return instance.vote(vehicleId, name,  { from: App.account });

    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  },
  // encryption: function(){
  //   console.log('in encryption function');
  //   var address = $('#cryptAddress').val();
  //   var encrypted = CryptoJS.AES.encrypt(address, "Secret Passphrase");
   

  //   var decrypted = CryptoJS.AES.decrypt(encrypted, "Secret Passphrase");
    
  //   document.getElementById("demo1").innerHTML = encrypted;
  //   document.getElementById("demo2").innerHTML = decrypted;
  //   document.getElementById("demo3").innerHTML = decrypted.toString(CryptoJS.enc.Utf8);
  //   console.log(decrypted.toString(CryptoJS.enc.Utf8));
  // },

  


  
};



$(function() {
  $(window).load(function() {
    App.init();
  });
});

// Identity = {
//   encryption: function(){
//     console.log('in encryption function')
//     var address = $('#cryptAddress').val();
//     var encrypted = CryptoJS.AES.encrypt(address, "Secret Passphrase");
   

//     var decrypted = CryptoJS.AES.decrypt(encrypted, "Secret Passphrase");
    
//     document.getElementById("demo1").innerHTML = encrypted;
//     document.getElementById("demo2").innerHTML = decrypted;
//     document.getElementById("demo3").innerHTML = decrypted.toString(CryptoJS.enc.Utf8);
//   }
// };

