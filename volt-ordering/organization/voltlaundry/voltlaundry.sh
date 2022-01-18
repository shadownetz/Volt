#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0


TMPFILE=`mktemp`

shopt -s extglob

function _exit(){
    printf "Exiting:%s\n" "$1"
    exit -1
}


: ${CHANNEL_NAME:="orderingchannel1"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}

# Where am I?
DIR=${PWD}

# Locate the test-network
cd "${DIR}/../../../VoltOrderingNetwork"
env | sort > $TMPFILE

OVERRIDE_ORG="voltlaundry"
. ./scripts/envVar.sh


parsePeerConnectionParameters voltlaundry voltlogistics

# set the fabric config path
export FABRIC_CFG_PATH="${DIR}/../../../config"
export PATH="${DIR}/../../../bin:${PWD}:$PATH"

env | sort | comm -1 -3 $TMPFILE - | sed -E 's/(.*)=(.*)/export \1="\2"/'
rm $TMPFILE

cd "${DIR}"
