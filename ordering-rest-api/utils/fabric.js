const {Wallets, Gateway} = require("fabric-network");
const FabricCAServices = require('fabric-ca-client');
const fs = require('fs');
const yaml = require('js-yaml');
const ORDER = require("../../volt-ordering/organization/voltlaundry/contract/lib/order");
const path = require("path");

class Fabric{
    constructor({userId,USER_FILE_WALLET_PATH,CONNECTION_CONFIG_PATH}) {
        this.user = userId;
        this.gateway = new Gateway();
        this.USER_FILE_WALLET_PATH = USER_FILE_WALLET_PATH;
        this.CONNECTION_CONFIG_PATH = CONNECTION_CONFIG_PATH;
    }

    async connectGateway(){
        const wallet = await Wallets.newFileSystemWallet(`${this.USER_FILE_WALLET_PATH}/${this.user}/wallet`);
        const connectionProfile = yaml.load(fs.readFileSync(this.CONNECTION_CONFIG_PATH,'utf8'));
        const connectionOptions = {
            identity: this.user,
            wallet: wallet,
            discovery: { enabled: true, asLocalhost: true }
        };
        console.log('Connecting to fabric gateway...');
        await this.gateway.connect(connectionProfile, connectionOptions);
        return this;
    }

    async enrollUser(ca_namespace, org_name){
        // load the network configuration
        let connectionProfile = yaml.load(fs.readFileSync(this.CONNECTION_CONFIG_PATH, 'utf8'));

        // Create a new CA client for interacting with the CA.
        const caInfo = connectionProfile.certificateAuthorities[ca_namespace];
        const caTLSCACerts = caInfo.tlsCACerts.pem;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName);

        // Create a new file system based wallet for managing identities.
        const wallet = await Wallets.newFileSystemWallet(`${this.USER_FILE_WALLET_PATH}/${this.user}/wallet`);
        // Check to see if we've already enrolled the admin user.
        const userExists = await wallet.get(this.user);
        if (userExists) {
            throw new Error(`An identity for the client user "${this.user}" already exists in the wallet`)
        }

        // Enroll the admin user, and import the new identity into the wallet.
        const enrollment = await ca.enroll({ enrollmentID: 'user1', enrollmentSecret: 'user1pw' });
        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: org_name+'MSP',// Org1MSP
            type: 'X.509',
        };
        await wallet.put(this.user, x509Identity);
    }

    /**
     * get contract by name
     * defaults to network contract 'orderingcontract'
     * @param {String} name 
     * @returns Contract
     */
    async getContract(){
        const default_contract = process.env.FABRIC_CONTRACT_NAME;
        console.log("Using network channel "+process.env.FABRIC_NETWORK_CHANNEL);
        const network = await this.gateway.getNetwork(`${process.env.FABRIC_NETWORK_CHANNEL}`);
        return network.getContract(name || default_contract, ORDER.getClass());
    }
    async getSystemContract(name){
        const default_contract = process.env.FABRIC_CONTRACT_NAME;
        console.log("Using network channel "+process.env.FABRIC_NETWORK_CHANNEL);
        const network = await this.gateway.getNetwork(`${process.env.FABRIC_NETWORK_CHANNEL}`);
        return network.getContract(name);
    }
    disconnectGateway(){
        return this.gateway.disconnect();
    }
}

module.exports = Fabric;