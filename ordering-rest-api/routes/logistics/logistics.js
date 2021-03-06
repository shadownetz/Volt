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
const orderQueriesRoute = require("./orderQueries");

// app.use((req, res, next)=>{
//     if(req.body._app.name === 'voltlogistics') next();
//     else return res.status(403).send("Unauthorized route access")
// });

app.post('/process-order', async (req, res)=>{
    const {userId,orderNumber, owner} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();

    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const processOrderResponse = await contract.submitTransaction(
            'process',
            owner,
            orderNumber,
            userId,
            new Date().valueOf().toString()
        );
        const order = ORDER.fromBuffer(processOrderResponse);
        response.setMessage(`successfully processed order #${order.orderNumber}`);
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
    const {userId,orderNumber, owner} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();

    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const updatedAt = new Date().valueOf().toString();
        const shipOrderResponse = await contract.submitTransaction(
            'ship',
            owner,
            orderNumber,
            userId,
            updatedAt
        );
        const order = ORDER.fromBuffer(shipOrderResponse);
        response.setMessage(`successfully shipped order #${order.orderNumber}`);
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
    const {userId,orderNumber,owner} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();
    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const updatedAt = new Date().valueOf().toString();
        const deliverOrderResponse = await contract.submitTransaction(
            'deliver',
            owner,
            orderNumber,
            userId,
            updatedAt
        );
        const order = ORDER.fromBuffer(deliverOrderResponse);
        response.setMessage(`successfully delivered order #${order.orderNumber}`);
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
    const {userId,orderNumber,owner} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();
    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const cancelOrderResponse = await contract.submitTransaction(
            'cancel',
            owner,
            orderNumber,
            new Date().valueOf().toString()
        );
        const order = ORDER.fromBuffer(cancelOrderResponse);
        response.setMessage(`successfully cancelled order #${order.orderNumber}`);
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

app.post('/enroll-user', async(req, res)=>{
    const {userId} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();
    try{
        await fabric.enrollUser('ca.voltlogistics.vltenterprise.com','VoltLogistics');
        response.setMessage(`Successfully enrolled client user ${userId} and imported it into the wallet`)
    }catch (e){
        response.hasError(`Error enrolling user: ${e}`)
    }
    return res.json(response);
})

app.use("/queries", orderQueriesRoute);

module.exports = app;