#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0




# default to using Org1
ORG=${1:-VoltLaundry}

# Exit on first error, print all commands.
set -e
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ORDERER_CA=${DIR}/VoltOrderingNetwork/organizations/ordererOrganizations/example.com/orderers/orderer.vltenterprise.com/msp/tlscacerts/tlsca.vltenterprise.com-cert.pem
PEER0_VOLTLAUNDRY_CA=${DIR}/VoltOrderingNetwork/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/ca.crt
PEER0_VOLTLOGISTICS_CA=${DIR}/VoltOrderingNetwork/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/ca.crt
PEER0_ORG3_CA=${DIR}/VoltOrderingNetwork/organizations/peerOrganizations/org3.vltenterprise.com/peers/peer0.org3.vltenterprise.com/tls/ca.crt


if [[ ${ORG,,} == "voltlaundry" || ${ORG,,} == "digibank" ]]; then

   CORE_PEER_LOCALMSPID=VoltLaundryMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/VoltOrderingNetwork/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/Admin@voltlaundry.vltenterprise.com/msp
   CORE_PEER_ADDRESS=localhost:7051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/VoltOrderingNetwork/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/ca.crt

elif [[ ${ORG,,} == "voltlogistics" || ${ORG,,} == "magnetocorp" ]]; then

   CORE_PEER_LOCALMSPID=VoltLogisticsMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/VoltOrderingNetwork/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/Admin@voltlogistics.vltenterprise.com/msp
   CORE_PEER_ADDRESS=localhost:9051
   CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/VoltOrderingNetwork/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/ca.crt

else
   echo "Unknown \"$ORG\", please choose VoltLaundry/Digibank or VoltLogistics/Magnetocorp"
   echo "For example to get the environment variables to set upa Org2 shell environment run:  ./setOrgEnv.sh VoltLogistics"
   echo
   echo "This can be automated to set them as well with:"
   echo
   echo 'export $(./setOrgEnv.sh Org2 | xargs)'
   exit 1
fi

# output the variables that need to be set
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER0_VOLTLAUNDRY_CA=${PEER0_VOLTLAUNDRY_CA}"
echo "PEER0_VOLTLOGISTICS_CA=${PEER0_VOLTLOGISTICS_CA}"
echo "PEER0_ORG3_CA=${PEER0_ORG3_CA}"

echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"