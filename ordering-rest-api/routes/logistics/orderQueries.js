const express = require("express");
const app = express();
const path = require('path');
const FABRIC = require("../../utils/fabric");
const USER_FILE_WALLET_PATH = [
    '..','..','..','volt-ordering','organization','voltlogistics','identity','user'
]
const CONNECTION_CONFIG_PATH = [
    '..','..','..','volt-ordering','organization','voltlogistics','gateway','connection-voltlogistics.yaml'
]
const CustomResponse = require("../../utils/customResponse");

app.post("/history", async (req, res)=>{
    const {orderNumber, owner, userId} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();

    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const processOrderResponse = await contract.evaluateTransaction(
            'queryHistory',
            orderNumber,
            owner
        );
        const orders = JSON.parse(processOrderResponse.toString());
        response.setData(orders);
        response.setMessage(`successfully fetched ${orders.length} orders `);
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
})

app.post("/owner", async (req, res)=>{
    const {owner, userId} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();

    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const processOrderResponse = await contract.evaluateTransaction(
            'queryOwner',
            owner
        );
        const orders = JSON.parse(processOrderResponse.toString());
        response.setData(orders);
        response.setMessage(`successfully fetched ${orders.length} orders `);
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
})

app.post("/current-state", async (req, res)=>{
    const {state, userId} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();

    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const processOrderResponse = await contract.evaluateTransaction('queryNamed',state);
        const orders = JSON.parse(processOrderResponse.toString());
        response.setData(orders);
        response.setMessage(`successfully fetched ${orders.length} orders `);
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
})

app.post("/get-order", async (req, res)=>{
    const {owner,orderNumber, userId} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();

    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const processOrderResponse = await contract.evaluateTransaction(
            'queryAsset',
            orderNumber,
            owner
        );
        const order = JSON.parse(processOrderResponse.toString());
        response.setData(order);
        response.setMessage(`successfully fetched order ${orderNumber}`);
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
})

module.exports = app;