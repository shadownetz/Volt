## **VLT Enterprise | Hyperledger Fabric Ordering Solution**

## Brief Overview

This network is referred to `volt_ordering_network` in various configuration files. The network has been setup with three organizations (orgs) i.e `voltlaundry` , `voltlogistics` and `orderer` (ordering service of the channel). These orgs have a total of 3 peers each installed on the network excluding the ordering node which has a single ordering peer installed. The channel on which all peers on this network are installed is named `orderingchannel1`

Before you proceed ensure you go through these steps to get the ordering network up and running. The following steps will be covered.

 - Prerequisites
 - Running the ordering network
 - Installing the chaincode on peers (VoltLaundry & VoltLogistics) and commiting them to the channel
 - Submitting a transaction to the channel through our application `coming soon`

## Prerequisites

 1. Visit this [fabric link](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html) to install the required modules on your machine.
 2. Install fabric docker images and binaries using [this link](https://hyperledger-fabric.readthedocs.io/en/latest/install.html)
3. Download Visual Studio Code IDE and install the `docker` extension. This will help you to monitor created and running containers and images on the network.
4. Ensure you have Node Package Manager installed (npm).

## Running the ordering network

 1. Clone this repo and navigate to the `VoltOrderingNetwork` directory
 2. Start a terminal in the current directory and run this code snippet 

	> ./network.sh up createChannel

running this code will create fire up the network and create the channels used by peers in the network. By default it uses cryptogen module to issue identity certificates to the various components of the network, you can overridr this by running the code below instead. This will start the network with Fabric CA (Certificate authority) instead


>./network.sh up createChannel -ca
	
3. Examine the running containers by clicking on the docker icon in the visual studio code editor.
4. You can bring down the network by running the code snippet below

	  > ./network.sh down

## Installing chaincode on peers

Take time and examine the `volt-ordering` directory. The chaincodes lives in this directory for the various organizations we have. 

 1. Navigate to the `volt-ordering` directory and run the code below to start the network.

	   > ./network-starter.sh

	While the script is running, you will see logs of the test network being deployed. When the script is complete, you can use the `docker  ps` command to see the Fabric nodes running on your local machine.

**Installing chaincode on org VoltLaundry**

 - Use the following command to change into the VoltLaundry directory
	 
	    cd organization/voltlaundry/
The first thing we are going to do as VoltLaundry is monitor the components of `volt_ordering_network`. An administrator can view the aggregated output from a set of Docker containers using the  `logspout`  [tool](https://github.com/gliderlabs/logspout#logspout). The tool collects the different output streams into one place, making it easy to see what’s happening from a single window. This can be really helpful for administrators when installing smart contracts or for developers when invoking smart contracts, for example.

In the VoltLaundry directory, run the following command to run the  `monitor-docker.sh`  script and start the  `logspout`  tool for the containers associated with `volt_ordering_network` 

   > ./configuration/cli/monitor-docker.sh

`place`, `cancel` , `process`, `ship`, `deliver` are the five functions at the heart of the volt ordering smart contract. It is used by our applications to submit transactions which correspondingly place, cancel, process, ship and deliver orders on the ledger.
The contract can been seen in the `contract/lib/ordering-contract.js` for the corresponding organizations. 

***You should also note that VoltLaundry can only submit a `place` and `cancel` order transaction proposal to the channel and VoltLogistics can submit a `process`, `ship`, `deliver` and `cancel` transaction proposal to the channel***

 - Next up, run the following command to set the environment variables in our command window
 
    >source voltlaundry.sh
 
 - We package the smart contract into a chaincode using the following command
 
   > peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label cp_0
 
 - We install the chaincode on the VoltLaundry peer using the following command

   > peer lifecycle chaincode install cp.tar.gz

 - The next step is to find the packageID of the chaincode we installed on our peer. We can query the packageID using the following command

   > peer lifecycle chaincode queryinstalled

 - The command will return the same package identifier as the install command. You should see output similar to the following:

   > Installed chaincodes on peer:
Package ID: cp_0:ffda93e26b183e231b7e9d5051e1ee7ca47fbf24f00a8376ec54120b1a2a335c, Label: cp_0

 - We need to save the package id for the next step so run the command below
 
    >export PACKAGE_ID=cp_0:ffda93e26b183e231b7e9d5051e1ee7ca47fbf24f00a8376ec54120b1a2a335c

 - We can now approve the chaincode definition for VoltLaundry using the command

		peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.vltenterprise.com --channelID orderingchannel1 --name orderingcontract -v 0 --package-id $PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_CA

One of the most important chaincode parameters that channel members need to agree to using the chaincode definition is the chaincode endorsement policy. The endorsement policy describes the set of organizations that must endorse (execute and sign) a transaction before it can be determined to be valid. By approving the ordering chaincode without the --policy flag, the VoltLaundry admin agrees to using the channel’s default Endorsement policy, which in the case of the orderingchannel1 channel requires a majority of organizations on the channel to endorse a transaction. All transactions, whether valid or invalid, will be recorded on the ledger blockchain, but only valid transactions will update the world state.


**Installing chaincode on org VoltLogistics**

 - Open a new terminal in the `volt-ordering` directory and use the following command to change into the VoltLogistics directory
	 
	> cd organization/voltlaundry/

Based on the `orderingchannel1`  `LifecycleEndorsement` policy, the Fabric Chaincode lifecycle will require a majority of organizations on the channel to agree to the chaincode definition before the chaincode can be committed to the channel. This implies that we need to approve the `ordering` chaincode as both VoltLaundry and VoltLogistics to get the required majority of 2 out of 2

 - Next up, run the following command to set the environment variables in our command window
 
    >source voltlogistics.sh
 
 - We package the smart contract into a chaincode using the following command
 
   > peer lifecycle chaincode package cp.tar.gz --lang node --path ./contract --label cp_0
 
 - We install the chaincode on the VoltLogistics peer using the following command

   > peer lifecycle chaincode install cp.tar.gz

 - The next step is to find the packageID of the chaincode we installed on our peer. We can query the packageID using the following command

   > peer lifecycle chaincode queryinstalled

 - The command will return the same package identifier as the install command. You should see output similar to the following:

   > Installed chaincodes on peer:
Package ID: cp_0:ffda93e26b183e231b7e9d5051e1ee7ca47fbf24f00a8376ec54120b1a2a335c, Label: cp_0

 - We need to save the package id for the next step so run the command below
 
    >export PACKAGE_ID=cp_0:ffda93e26b183e231b7e9d5051e1ee7ca47fbf24f00a8376ec54120b1a2a335c

 - We can now approve the chaincode definition for VoltLogistics using the command

		peer lifecycle chaincode approveformyorg --orderer localhost:7050 --ordererTLSHostnameOverride orderer.vltenterprise.com --channelID orderingchannel1 --name orderingcontract -v 0 --package-id $PACKAGE_ID --sequence 1 --tls --cafile $ORDERER_CA


## Commit the chaincode definition to the channel
Now that VoltLaundry and VoltLogistics have both approved the `ordering` chaincode, we have the majority we need (2 out of 2) to commit the chaincode definition to the channel. Once the chaincode is successfully defined on the channel, the `Order` smart contract inside the `orderingcontract` chaincode can be invoked by client applications on the channel. Since either organization can commit the chaincode to the channel, we will continue operating as the VoltLogistics admin:

 - Commit the chaincode to the channel using the code below

		peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.vltenterprise.com --peerAddresses localhost:7051 --tlsRootCertFiles ${PEER0_VOLTLAUNDRY_CA} --peerAddresses localhost:9051 --tlsRootCertFiles ${PEER0_VOLTLOGISTICS_CA} --channelID orderingchannel1 --name orderingcontract -v 0 --sequence 1 --tls --cafile $ORDERER_CA --waitForEvent

The chaincode container will start after the chaincode definition has been committed to the channel.
Now that we have deployed the `orderingcontract` chaincode to the channel, we can use the VoltLaundry application to place an order.
