#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/msp/tlscacerts/tlsca.vltenterprise.com-cert.pem
export PEER0_VOLTLAUNDRY_CA=${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/ca.crt
export PEER0_VOLTLOGISTICS_CA=${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.vltenterprise.com/peers/peer0.org3.vltenterprise.com/tls/ca.crt
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ "$USING_ORG" = "voltlaundry" ]; then
    export CORE_PEER_LOCALMSPID="VoltLaundryMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_VOLTLAUNDRY_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/Admin@voltlaundry.vltenterprise.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ "$USING_ORG" = "voltlogistics" ]; then
    export CORE_PEER_LOCALMSPID="VoltLogisticsMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_VOLTLOGISTICS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/Admin@voltlogistics.vltenterprise.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  # elif [ $USING_ORG -eq 3 ]; then
  #   export CORE_PEER_LOCALMSPID="Org3MSP"
  #   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
  #   export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org3.vltenterprise.com/users/Admin@org3.vltenterprise.com/msp
  #   export CORE_PEER_ADDRESS=localhost:11051
  else
    errorln "ORG $USING_ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ "$USING_ORG" = "voltlaundry" ]; then
    export CORE_PEER_ADDRESS=peer0.voltlaundry.vltenterprise.com:7051
  elif [ "$USING_ORG" = "voltlogistics" ]; then
    export CORE_PEER_ADDRESS=peer0.voltlogistics.vltenterprise.com:9051
  # elif [ "$USING_ORG" = 3 ]; then
  #   export CORE_PEER_ADDRESS=peer0.org3.vltenterprise.com:11051
  else
    errorln "ORG $USING_ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEER0_$1_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
