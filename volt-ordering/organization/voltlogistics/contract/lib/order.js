/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for ledger state
const State = require('../ledger-api/state.js');

// Enumerate order state values
const orderState = {
    PLACED: 1,
    CANCELLED: 2,
    PROCESSING: 3,
    SHIPPED: 4,
    DELIVERED: 5
};

/**
 * Order class extends State class
 * Class will be used by application and smart contract to define an order
 */
class Order extends State {

    constructor(obj) {
        super(Order.getClass(), [obj.owner, obj.orderNumber]);
        Object.assign(this, obj);
    }

    /**
     * Basic getters and setters
    */

    setOwner(newOwner) {
        this.owner = newOwner;
    }

    getOwner() {
        return this.owner;
    }

    setOwnerMSP(mspid) {
        this.mspid = mspid;
    }

    getOwnerMSP() {
        return this.mspid;
    }

    setLogistics(logistics) {
        this.logistics = logistics;
    }

    getLogistics() {
        return this.logistics;
    }

    /**
     * 
     * @param {Number} updatedAt updated timestamp in miliseconds
     */
    setUpdateTimestamp(updatedAt){
        this.updatedAt = updatedAt;
    }


    /**
     * Useful methods to encapsulate commercial paper states
     */
    setPlaced() {
        this.currentState = orderState.PLACED;
    }

    setCancelled() {
        this.currentState = orderState.CANCELLED;
    }

    setProcessing() {
        this.currentState = orderState.PROCESSING;
    }

    setShipped() {
        this.currentState = orderState.SHIPPED;
    }

    setDelivered() {
        this.currentState = orderState.DELIVERED;
    }

    isPlaced() {
        return this.currentState === orderState.PLACED;
    }

    isCancelled() {
        return this.currentState === orderState.CANCELLED;
    }

    isProcessing() {
        return this.currentState === orderState.PROCESSING;
    }

    isShipped() {
        return this.currentState === orderState.SHIPPED;
    }

    isDelivered() {
        return this.currentState === orderState.DELIVERED;
    }

    static fromBuffer(buffer) {
        return Order.deserialize(buffer);
    }

    toBuffer() {
        return Buffer.from(JSON.stringify(this));
    }

    /**
     * Deserialize a state data to commercial paper
     * @param {Buffer} data to form back into the object
     */
    static deserialize(data) {
        return State.deserializeClass(data, Order);
    }

    /**
     * Factory method to create an order object
     * @param {String} owner peer creator of the order
     * @param {String} orderNumber user friendly reference for order
     * @param {String} createdAt timestamp of order creation
     * @param {String} deliveryMode PICKUP | DROPOFF
     * @param {String} serviceType  WASH_IRON | IRON | DRY_CLEAN
     * @param {Integer} totalOrder total number of order placed
     * @param {Float} amount total cost of order
     * @param {String} currency 
     */
    static createInstance(owner, orderNumber, createdBy, createdAt, deliveryMode, serviceType, totalOrder, amount, currency) {
        return new Order(
            {
                owner,
                orderNumber,
                createdAt,
                createdBy,
                updatedAt="",
                logistics="",
                deliveryMode,
                serviceType,
                totalOrder,
                amount,
                currency
            }
        );
    }

    static getClass() {
        return 'org.volt.orderingnetwork.order';
    }
}

module.exports = Order;
