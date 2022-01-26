const express = require("express");
const app = express();
const path = require('path');
const ORDER = require("../../../volt-ordering/organization/voltlogistics/contract/lib/order");
const FABRIC = require("../../utils/fabric");
const USER_FILE_WALLET_PATH = [
    '..','..','..','volt-ordering','organization','voltlogistics','identity','user'
]
const CONNECTION_CONFIG_PATH = [
    '..','..','..','volt-ordering','organization','voltlogistics','gateway','connection-voltlogistics.yaml'
]
const CustomResponse = require("../../utils/customResponse");

const response = new CustomResponse();

// app.use((req, res, next)=>{
//     if(req.body._app.name === 'voltlogistics') next();
//     else return res.status(403).send("Unauthorized route access")
// });

app.post('/process-order', async (req, res)=>{
    const {userId,orderNumber} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();

    try{
        const contract = await fabric.connectGateway().getContract();
        const processOrderResponse = await contract.submitTransaction('process', orderNumber, userId);
        const order = ORDER.fromBuffer(processOrderResponse);
        response.setMessage(`${order.owner} successfully processed order #${order.orderNumber}`);
        console.log(response.message);
    }catch (e){
        response.hasError(`Error processing transaction. ${e}`);
        console.log(response.message);
        console.log(e.stack);
    }finally {
        fabric.disconnectGateway();
        console.log("Disconnected from fabric gateway");
    }
    return res.json(response);
});

app.post('/ship-order', async(req, res)=>{
    const {userId,orderNumber} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();

    try{
        const contract = await fabric.connectGateway().getContract();
        const shipOrderResponse = await contract.submitTransaction('ship', orderNumber, userId);
        const order = ORDER.fromBuffer(shipOrderResponse);
        response.setMessage(`${order.owner} successfully shipped order #${order.orderNumber}`);
        console.log(response.message);
    }catch (e){
        response.hasError(`Error processing transaction. ${e}`);
        console.log(response.message);
        console.log(e.stack);
    }finally {
        fabric.disconnectGateway();
        console.log("Disconnected from fabric gateway");
    }
    return res.json(response);
});

app.post('/deliver-order', async(req, res)=>{
    const {userId,orderNumber} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();
    try{
        const contract = await fabric.connectGateway().getContract();
        const deliverOrderResponse = await contract.submitTransaction('deliver', orderNumber, userId);
        const order = ORDER.fromBuffer(deliverOrderResponse);
        response.setMessage(`${order.owner} successfully delivered order #${order.orderNumber}`);
        console.log(response.message);
    }catch (e){
        response.hasError(`Error processing transaction. ${e}`);
        console.log(response.message);
        console.log(e.stack);
    }finally {
        fabric.disconnectGateway();
        console.log("Disconnected from fabric gateway");
    }
    return res.json(response);
});

app.post('/cancel-order', async(req, res)=>{
    const {userId,orderNumber} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();
    try{
        const contract = await fabric.connectGateway().getContract();
        const cancelOrderResponse = await contract.submitTransaction('cancel', orderNumber);
        const order = ORDER.fromBuffer(cancelOrderResponse);
        response.setMessage(`${order.owner} successfully cancelled order #${order.orderNumber}`)
        console.log(response.message);
    }catch (e){
        response.hasError(`Error processing transaction. ${e}`);
        console.log(response.message);
        console.log(e.stack);
    }finally {
        fabric.disconnectGateway();
        console.log("Disconnected from fabric gateway")
    }
    return res.json(response);
});

module.exports = app;