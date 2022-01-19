#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0

function _exit(){
    printf "Exiting:%s\n" "$1"
    exit -1
}

# Exit on first error, print all commands.
set -ev
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NETWORK_FOLDER="VoltOrderingNetwork"

export FABRIC_CFG_PATH="${DIR}/../config"

cd "${DIR}/../${NETWORK_FOLDER}/"

docker kill cliVoltLaundry cliVoltLogistics logspout || true
./network.sh down
./network.sh up createChannel -ca -s couchdb

# Copy the connection profiles so they are in the correct organizations.
cp "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/connection-voltlaundry.yaml" "${DIR}/organization/voltlaundry/gateway/"
cp "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/connection-voltlogistics.yaml" "${DIR}/organization/voltlogistics/gateway/"

cp "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/User1@voltlaundry.vltenterprise.com/msp/signcerts/"* "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/User1@voltlaundry.vltenterprise.com/msp/signcerts/User1@voltlaundry.vltenterprise.com-cert.pem"
cp "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/User1@voltlaundry.vltenterprise.com/msp/keystore/"* "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/User1@voltlaundry.vltenterprise.com/msp/keystore/priv_sk"

cp "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/User1@voltlogistics.vltenterprise.com/msp/signcerts/"* "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/User1@voltlogistics.vltenterprise.com/msp/signcerts/User1@voltlogistics.vltenterprise.com-cert.pem"
cp "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/User1@voltlogistics.vltenterprise.com/msp/keystore/"* "${DIR}/../${NETWORK_FOLDER}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/User1@voltlogistics.vltenterprise.com/msp/keystore/priv_sk"

echo Suggest that you monitor the docker containers by running
echo "./organization/voltlaundry/configuration/cli/monitor-docker.sh volt_ordering_network"
