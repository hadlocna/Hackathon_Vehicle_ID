# Hackathon_Vehicle_ID
Lets Improve Vehicle Identity

This is a decentralised app based on the ethreum framework that proposes to improve privacy of car owners, help government and law enforcement manage vehicles for violations, safety/pollution standards and dealers/manufacturers with maintenance and servicing.
The core idea is achieved by removing the license places and transmitting a dynamic ID via QR code or bluetooth becaons on car which can only be encrypted by authorised parties. This allows for irrefutable ownership and history of cars as well which is of value in user car sales market. 

A presnetation of our idea can be found [here](https://docs.google.com/presentation/d/1HG1xXLB_KTHT5bFT4plJwzJKtlSCwIT6F_nScdoOXmI/edit?usp=sharing)
# Dependencies
Install the dependencies:
* node-js: v8.11.3 or higher
* npm: v5.6.0 or higher
* truffle framework: 4.1.11 or higher : https://github.com/trufflesuite/truffle
* Ganache: http://truffleframework.com/ganache/
* Metamask: https://metamask.io/

# Set Up Instructions

## Step 1. Clone the project
`https://github.com/hadlocna/Hackathon_Vehicle_ID

## Step 2. Install dependencies
```
$ cd Hackathon_Vehicle_ID
$ npm install
```
## Step 3. Start Ganache
Open Ganache GUI client. This will start your local blockchain instance. 

## Step 4. Compile & Deploy Vehicle_ID Smart Contract
`$ truffle migrate --reset`
You must migrate the Vehicle_ID smart contract each time your restart ganache.

## Step 5. Configure Metamask
* Unlock Metamask
* Connect metamask to your local Etherum blockchain provided by Ganache.
* Import an account provided by ganache.

## Step 6. Run the Front End Application
`$ npm run dev`
Visit this URL in your browser: http://localhost:3000

If you get stuck, please reference: https://youtu.be/3681ZYbDSSk
This repo has been created by tutorials from [Dapp University](https://github.com/dappuniversity/election)

