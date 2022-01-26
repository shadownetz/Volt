/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for collections of ledger states --  a state list
const StateList = require('../ledger-api/statelist.js');

const Order = require('./order.js');

class OrderList extends StateList {

    constructor(ctx) {
        super(ctx, 'org.orderingnetwork.order');
        this.use(Order);
    }

    async addOrder(order) {
        return this.addState(order);
    }

    async getOrder(orderKey) {
        return this.getState(orderKey);
    }

    async updateOrder(order) {
        return this.updateState(order);
    }
}


module.exports = OrderList;
