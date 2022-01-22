#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp_voltlaundry {
    local PP=$(one_line_pem $1)
    local CP=$(one_line_pem $2)
    sed -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp/voltlaundry/connection-voltlaundry.json
}

function yaml_ccp_voltlaundry {
    local PP=$(one_line_pem $1)
    local CP=$(one_line_pem $2)
    sed -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp/voltlaundry/connection-voltlaundry.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

function json_ccp_voltlogistics {
    local PP=$(one_line_pem $1)
    local CP=$(one_line_pem $2)
    sed -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp/voltlogistics/connection-voltlogistics.json
}

function yaml_ccp_voltlogistics {
    local PP=$(one_line_pem $1)
    local CP=$(one_line_pem $2)
    sed -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp/voltlogistics/connection-voltlogistics.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=voltlaundry
P0PORT=7051
P1PORT=7151
P2PORT=7251
CAPORT=7054
PEERPEM=organizations/peerOrganizations/voltlaundry.vltenterprise.com/tlsca/tlsca.voltlaundry.vltenterprise.com-cert.pem
CAPEM=organizations/peerOrganizations/voltlaundry.vltenterprise.com/ca/ca.voltlaundry.vltenterprise.com-cert.pem

echo "$(json_ccp_voltlaundry $PEERPEM $CAPEM)" > organizations/peerOrganizations/voltlaundry.vltenterprise.com/connection-voltlaundry.json
echo "$(yaml_ccp_voltlaundry $PEERPEM $CAPEM)" > organizations/peerOrganizations/voltlaundry.vltenterprise.com/connection-voltlaundry.yaml


ORG=voltlogistics
P0PORT=9051
P1PORT=9151
P2PORT=9251
CAPORT=8054
PEERPEM=organizations/peerOrganizations/voltlogistics.vltenterprise.com/tlsca/tlsca.voltlogistics.vltenterprise.com-cert.pem
CAPEM=organizations/peerOrganizations/voltlogistics.vltenterprise.com/ca/ca.voltlogistics.vltenterprise.com-cert.pem

echo "$(json_ccp_voltlogistics $PEERPEM $CAPEM)" > organizations/peerOrganizations/voltlogistics.vltenterprise.com/connection-voltlogistics.json
echo "$(yaml_ccp_voltlogistics $PEERPEM $CAPEM)" > organizations/peerOrganizations/voltlogistics.vltenterprise.com/connection-voltlogistics.yaml
