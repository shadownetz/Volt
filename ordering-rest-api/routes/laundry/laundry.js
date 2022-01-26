const express = require("express");
const app = express();
const path = require('path');
const ORDER = require("../../../volt-ordering/organization/voltlaundry/contract/lib/order");
const FABRIC = require("../../utils/fabric");
const USER_FILE_WALLET_PATH = [
    '..','..','..','volt-ordering','organization','voltlaundry','identity','user'
]
const CONNECTION_CONFIG_PATH = [
    '..','..','..','volt-ordering','organization','voltlaundry','gateway','connection-voltlaundry.yaml'
]
const CustomResponse = require("../../utils/customResponse");


// app.use((req, res, next)=>{
//     if(req.body._app.name === 'voltlaundry') next();
//     else return res.status(403).send("Unauthorized route access")
// });

app.get("/", (req, res)=>{
    return res.status(200).send("Welcome to VoltLaundry Fabric REST API");
})

app.post('/place-order', async (req, res)=>{
    const {
        userId,
        orderNumber,
        deliveryMode,
        serviceType,
        totalOrder,
        amount,
        currency
    } = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();

    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const placeOrderResponse = await contract.submitTransaction(
            'place',
            orderNumber,
            userId,
            new Date().valueOf().toString(),
            deliveryMode,
            serviceType,
            totalOrder,
            amount,
            currency
        );
        const order = ORDER.fromBuffer(placeOrderResponse);
        response.setMessage(`${order.owner} successfully placed order #${order.orderNumber}`);
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

app.post('/cancel-order', async(req, res)=>{
    const {userId,orderNumber} = req.body;
    const fabric = new FABRIC({
        userId,
        USER_FILE_WALLET_PATH: path.join(__dirname, ...USER_FILE_WALLET_PATH),
        CONNECTION_CONFIG_PATH: path.join(__dirname, ...CONNECTION_CONFIG_PATH)
    });
    const response = new CustomResponse();
    try{
        await fabric.connectGateway();
        const contract = await fabric.getContract();
        const cancelOrderResponse = await contract.submitTransaction('cancel', orderNumber);
        const order = ORDER.fromBuffer(cancelOrderResponse);
        response.setMessage(`${order.owner} successfully cancelled order #${order.orderNumber}`);
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
        await fabric.enrollUser('ca.voltlaundry.vltenterprise.com','VoltLaundry');
        response.setMessage(`Successfully enrolled client user ${userId} and imported it into the wallet`)
    }catch (e){
        response.hasError(`Error enrolling user: ${e}`)
    }
    return res.json(response);
})


module.exports = app;