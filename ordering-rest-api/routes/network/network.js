const express = require("express");
const app = express();
const path = require('path');
const fabproto6 = require('fabric-protos');

const FABRIC = require("../../utils/fabric");
const USER_FILE_WALLET_PATH = [
    '..','..','..','volt-ordering','organization','voltlaundry','identity','user'
]
const CONNECTION_CONFIG_PATH = [
    '..','..','..','volt-ordering','organization','voltlaundry','gateway','connection-voltlaundry.yaml'
]
const CustomResponse = require("../../utils/customResponse");

const getFabricInstance = (userId)=>{
    return new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
}


app.get('/', (req, res)=>{
    return res.status(200).send("Welcome to Volt Ordering Network REST API");
});

app.post('/blocks', async (req, res)=>{
    const {userId} = req.body;
    const fabric = getFabricInstance(userId);
    const response = new CustomResponse();
    try{
        const blockHeight = await fabric.getBlockHeight();
        const blockInfo = await fabric.getBlockInfo(6); // test
        response.setData({
            blockHeight,
            blockInfo
        });
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
});

app.post('/orders/all', async(req, res)=>{
    const {userId} = req.body;
    const fabric = getFabricInstance(userId);
    const response = new CustomResponse();
    try{
        const orders = await fabric.getAllAssets();
        response.setData(JSON.parse(orders.toString()));
    }catch (e){
        response.hasError(`Error fetching orders. ${e}`);
        console.log(response.message);
        console.log(e.stack);
    }finally {
        fabric.disconnectGateway();
        console.log("Disconnected from fabric gateway")
    }
    return res.json(response);
});


app.post('/transactions/:txId', async(req, res)=>{
    const {userId} = req.body;
    const fabric = getFabricInstance(userId);
    const response = new CustomResponse();
    try{
        const orders = await fabric.getTransactionInfo(req.params.txId);
        response.setData(orders);
    }catch (e){
        response.hasError(`Error fetching transaction info. ${e}`);
        console.log(response.message);
        console.log(e.stack);
    }finally {
        fabric.disconnectGateway();
        console.log("Disconnected from fabric gateway")
    }
    return res.json(response);
});

module.exports = app