/*
 * Volt Ordering Contract
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Fabric smart contract classes
const { Contract, Context } = require('fabric-contract-api');

// Ordering Network specifc classes
const Order = require('./order.js');
const OrderList = require('./orderlist.js');
const QueryUtils = require('./queries.js');

/**
 * A custom context provides easy access to list of all orders
 */
class OrderContext extends Context {

    constructor() {
        super();
        // All papers are held in a list of papers
        this.orderList = new OrderList(this);
    }

}

/**
 * Define order smart contract by extending Fabric Contract class
 *
 */
class OrderContract extends Contract {

    constructor() {
        // Unique namespace when multiple contracts per chaincode file
        super('org.orderingnetwork.order');
    }

    /**
     * Define a custom context for commercial paper
    */
    createContext() {
        return new OrderContext();
    }

    /**
     * Instantiate to perform any setup of the ledger that might be required.
     * @param {Context} ctx the transaction context
     */
    async instantiate(ctx) {
        // No implementation required with this example
        // It could be where data migration is performed, if necessary
        console.log('Instantiate the contract');
    }

    /**
     * Place An Order
     *
     * @param {Context} ctx the transaction context
     * @param {String} orderNumber user friendly reference for order
     * @param {String} owner logistics org name
     * @param {Number} createdAt timestamp of order creation in milliseconds
     * @param {String} createdBy user reference who created the order
     * @param {String} deliveryMode PICKUP | DROPOFF
     * @param {String} serviceType  WASH_IRON | IRON | DRY_CLEAN
     * @param {Integer} totalOrder total number of order placed
     * @param {Number} amount total cost of order
     * @param {String} currency
     */
    async place(ctx, orderNumber,owner, createdBy, createdAt, deliveryMode, serviceType, totalOrder, amount, currency) {
        // create an instance of the paper
        let order = Order.createInstance(owner, orderNumber, createdBy, createdAt, deliveryMode, serviceType, parseInt(totalOrder), parseFloat(amount), currency);

        // Smart contract, rather than order, moves order into PLACED state
        order.setPlaced();

        // save the owner's MSP
        let mspid = ctx.clientIdentity.getMSPID();
        order.setOwnerMSP(mspid);

        // Newly issued order is owned by the issuer to begin with (recorded for reporting purposes)
        order.setOwner(owner);

        // Add the paper to the list of all similar orders in the ledger world state
        await ctx.orderList.addOrder(order);

        // Must return a serialized order to caller of smart contract
        return order;
    }

    /**
     * Process an order
     * @param {Context} ctx the transaction context
     * @param {String} owner logistics org name
     * @param {String} orderNumber user friendly reference for order
     * @param {String} logistics reference for assigned logistics
     * @param {Number} updatedAt timestamp in milliseconds
     */
    async process(ctx, owner, orderNumber, logistics, updatedAt) {

        // Retrieve the current paper using key fields provided
        let orderKey = Order.makeKey([owner, orderNumber]);
        let order = await ctx.orderList.getOrder(orderKey);

        // Validate current owner
        if (order.getOwner() !== owner) {
            throw new Error('\nOrder ' + orderNumber + ' is not owned by ' + owner);
        }
        order.setLogistics(logistics);
        order.setProcessing();
        order.setUpdateTimestamp(updatedAt);

        // Update the order
        await ctx.orderList.updateOrder(order);
        return order;
    }

    /**
     * Ship an order after an order has been processed
     *
     * @param {Context} ctx the transaction context
     * @param {String} owner logistics org name
     * @param {String} orderNumber user friendly reference for order
     * @param {String} logistics reference for assigned logistics
     * @param {Number} updatedAt timestamp in milliseconds
     */
    async ship(ctx,owner, orderNumber, logistics, updatedAt) {

        // Retrieve the current paper using key fields provided
        let orderKey = Order.makeKey([owner, orderNumber]);
        let order = await ctx.orderList.getOrder(orderKey);
        // Validate current owner
        if (order.getOwner() !== owner) {
            throw new Error('\nOrder ' + orderNumber + ' is not owned by ' + owner);
        }
        order.setLogistics(logistics);
        order.setShipped();
        order.setUpdateTimestamp(updatedAt);

        // Update the order
        await ctx.orderList.updateOrder(order);
        return order;
    }

    /**
     * Deliver an order after an order has been shipped
     *
     * @param {Context} ctx the transaction context
     * @param {String} owner logistics org name
     * @param {String} orderNumber user friendly reference for order
     * @param {String} logistics reference for assigned logistics
     * @param {Number} updatedAt timestamp in milliseconds
     */
    async deliver(ctx,owner, orderNumber, logistics, updatedAt) {

        // Retrieve the current paper using key fields provided
        let orderKey = Order.makeKey([owner, orderNumber]);
        let order = await ctx.orderList.getOrder(orderKey);
        // Validate current owner
        if (order.getOwner() !== owner) {
            throw new Error('\nOrder ' + orderNumber + ' is not owned by ' + owner);
        }
        order.setLogistics(logistics);
        order.setDelivered();
        order.setUpdateTimestamp(updatedAt);

        // Update the order
        await ctx.orderList.updateOrder(order);
        return order;
    }

    /**
     * Cancel an order
     *
     * @param {Context} ctx the transaction context
     * @param {String} owner logistics org name
     * @param {String} orderNumber user friendly reference for order
     * @param {Number} updatedAt timestamp in milliseconds
     */
    async cancel(ctx,owner, orderNumber, updatedAt) {

        // Retrieve the current paper using key fields provided
        let orderKey = Order.makeKey([owner, orderNumber]);
        let order = await ctx.orderList.getOrder(orderKey);
        // Validate current owner
        if (order.getOwner() !== owner) {
            throw new Error('\nOrder ' + orderNumber + ' is not owned by ' + owner);
        }

        order.setUpdateTimestamp(updatedAt);
        order.setCancelled();

        // Update the paper
        await ctx.orderList.updateOrder(order);
        return order;
    }


    // Query transactions

    /**
     * Query world state of an order
     * @param {Context} ctx the transaction context
     * @param {String} orderNumber user friendly reference for order
     * @param {String} owner ord name
     */
     async queryAsset(ctx, orderNumber, owner){
        let query = new QueryUtils(ctx, 'org.orderingnetwork.order');
        let result = await query.getAsset(owner, orderNumber); // (cpKey);
        return result;
    }

    /**
     * Query history of an order
     * @param {Context} ctx the transaction context
     * @param {String} orderNumber user friendly reference for order
     * @param {String} owner logistics org name
     */
    async queryHistory(ctx, orderNumber, owner) {

        // Get a key to be used for History query

        let query = new QueryUtils(ctx, 'org.orderingnetwork.order');
        let results = await query.getAssetHistory(owner, orderNumber); // (cpKey);
        return results;

    }

    /**
    * queryOwner order: supply name of owning org, to find list of orders based on owner field
    * @param {Context} ctx the transaction context
    * @param {String} owner order peer owner
    */
    async queryOwner(ctx, owner) {

        let query = new QueryUtils(ctx, 'org.orderingnetwork.order');
        let owner_results = await query.queryKeyByOwner(owner);

        return owner_results;
    }

    /**
    * queryPartial order - provide a prefix eg. "DigiBank" will list all orders _issued_ by DigiBank etc etc
    * @param {Context} ctx the transaction context
    * @param {String} prefix asset class prefix (added to orderList namespace) eg. org.papernet.paperMagnetoCorp asset listing: papers issued by MagnetoCorp.
    */
    async queryPartial(ctx, prefix) {

        let query = new QueryUtils(ctx, 'org.orderingnetwork.order');
        let partial_results = await query.queryKeyByPartial(prefix);

        return partial_results;
    }

    /**
    * queryAdHoc commercial paper - supply a custom mango query
    * eg - as supplied as a param:     
    * ex1:  ["{\"selector\":{\"faceValue\":{\"$lt\":8000000}}}"]
    * ex2:  ["{\"selector\":{\"faceValue\":{\"$gt\":4999999}}}"]
    * 
    * @param {Context} ctx the transaction context
    * @param {String} queryString querystring
    */
    async queryAdhoc(ctx, queryString) {

        let query = new QueryUtils(ctx, 'org.orderingnetwork.order');
        let querySelector = JSON.parse(queryString);
        let adhoc_results = await query.queryByAdhoc(querySelector);

        return adhoc_results;
    }


    /**
     * queryNamed - supply named query - 'case' statement chooses selector to build (pre-canned for demo purposes)
     * @param {Context} ctx the transaction context
     * @param {String} queryname the 'named' query (built here) - or - the adHoc query string, provided as a parameter
     */
    async queryNamed(ctx, queryname) {
        let querySelector = {};
        switch (queryname) {
            case "delivered":
                querySelector = { "selector": { "currentState": 5 } };  // 5 = DELIVERED state
                break;
            case "processing":
                querySelector = { "selector": { "currentState": 3 } };  // 3 = PROCESSING state
                break;
            case "placed":
                querySelector = { "selector": { "currentState": 1 } };  // 1 = PLACED state
                break; 
            case "cancelled":
                querySelector = { "selector": { "currentState": 2 } };  // 2 = CANCELLED state
                break; 
            case "shipped":
                querySelector = { "selector": { "currentState": 4 } };  // 4 = SHIPPED state
                break;  
            case "value":
                // may change to provide as a param - fixed value for now in this sample
                querySelector = { "selector": { "amount": { "$gt": 4000000 } } };  // to test, issue CommPapers with faceValue <= or => this figure.
                break;
            default: // else, unknown named query
                throw new Error('invalid named query supplied: ' + queryname + '- please try again ');
        }

        let query = new QueryUtils(ctx, 'org.orderingnetwork.order');
        let adhoc_results = await query.queryByAdhoc(querySelector);

        return adhoc_results;
    }

}

module.exports = OrderContract;
