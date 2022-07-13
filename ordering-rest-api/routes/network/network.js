const express = require("express");
const app = express();
const path = require('path');
const FABRIC = require("../../utils/fabric");
const USER_FILE_WALLET_PATH = [
    '..','..','..','volt-ordering','organization','voltlaundry','identity','user'
]
const CONNECTION_CONFIG_PATH = [
    '..','..','..','volt-ordering','organization','voltlaundry','gateway','connection-voltlaundry.yaml'
]
const CustomResponse = require("../../utils/customResponse");


app.get('/', (req, res)=>{
    return res.status(200).send("Welcome to Volt Ordering Network REST API");
});

app.post('/blocks', async (req, res)=>{
    const {userId} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();
    try{
        await fabric.connectGateway();
        // get system chain code contract
        const contract = await fabric.getSystemContract( 'qscc');
        // get chain info (height, etc)
        const resultByte = await contract.evaluateTransaction('GetChainInfo', `${process.env.FABRIC_NETWORK_CHANNEL}`, '');
        response.setData(resultByte);
        // we then loop through the height value which represents total
        // block number and fetch info for each blocks.
        // might as well note the transaction hash in each blocks and also
        // fetch the info

        // logger.debug('queryBlock', resultJson);

        // const resultByte = await contract.evaluateTransaction(
        //     'GetBlockByNumber',
        //     channelName,
        //     String(blockNum)
        // );
        // const resultJson = BlockDecoder.decode(resultByte);
        // logger.debug('queryBlock', resultJson);

        // let result = await contract.evaluateTransaction("GetTransactionByID", channelName, txId);



    }catch (e){
        response.hasError(`Error fetching blocks. ${e}`);
        console.log(response.message);
        console.log(e.stack);
    }finally {
        fabric.disconnectGateway();
        console.log("Disconnected from fabric gateway")
    }
    return res.json(response);
})

module.exports = app