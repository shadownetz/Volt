#!/bin/bash

function createVoltLaundry() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/voltlaundry.vltenterprise.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-voltlaundry --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-voltlaundry.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-voltlaundry.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-voltlaundry.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-voltlaundry.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-voltlaundry --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-voltlaundry --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering peer2"
  set -x
  fabric-ca-client register --caname ca-voltlaundry --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-voltlaundry --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-voltlaundry --id.name voltlaundryadmin --id.secret voltlaundryadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-voltlaundry -M "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/msp" --csr.hosts peer0.voltlaundry.vltenterprise.com --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-voltlaundry -M "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/msp" --csr.hosts peer1.voltlaundry.vltenterprise.com --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ca-voltlaundry -M "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/msp" --csr.hosts peer2.voltlaundry.vltenterprise.com --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null



  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/msp/config.yaml"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/msp/config.yaml"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/msp/config.yaml"


  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-voltlaundry -M "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls" --enrollment.profile tls --csr.hosts peer0.voltlaundry.vltenterprise.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-voltlaundry -M "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/tls" --enrollment.profile tls --csr.hosts peer1.voltlaundry.vltenterprise.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:7054 --caname ca-voltlaundry -M "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/tls" --enrollment.profile tls --csr.hosts peer2.voltlaundry.vltenterprise.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null


  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/server.key"

  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/tls/server.key"


  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/tls/server.key"


  mkdir -p "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/tlscacerts/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/tlscacerts/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/tlscacerts/ca.crt"


  mkdir -p "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/tlsca/tlsca.voltlaundry.vltenterprise.com-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/tlsca/tlsca.voltlaundry.vltenterprise.com-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/tlsca/tlsca.voltlaundry.vltenterprise.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/ca"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer0.voltlaundry.vltenterprise.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/ca/ca.voltlaundry.vltenterprise.com-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer1.voltlaundry.vltenterprise.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/ca/ca.voltlaundry.vltenterprise.com-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/peers/peer2.voltlaundry.vltenterprise.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/ca/ca.voltlaundry.vltenterprise.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-voltlaundry -M "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/User1@voltlaundry.vltenterprise.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/User1@voltlaundry.vltenterprise.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://voltlaundryadmin:voltlaundryadminpw@localhost:7054 --caname ca-voltlaundry -M "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/Admin@voltlaundry.vltenterprise.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/voltlaundry/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlaundry.vltenterprise.com/users/Admin@voltlaundry.vltenterprise.com/msp/config.yaml"
}

function createVoltLogistics() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/voltlogistics.vltenterprise.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-voltlogistics --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-voltlogistics.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-voltlogistics.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-voltlogistics.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-voltlogistics.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/config.yaml"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-voltlogistics --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null
  
  infoln "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-voltlogistics --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null
  
  infoln "Registering peer2"
  set -x
  fabric-ca-client register --caname ca-voltlogistics --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null


  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-voltlogistics --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-voltlogistics --id.name voltlogisticsadmin --id.secret voltlogisticsadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-voltlogistics -M "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/msp" --csr.hosts peer0.voltlogistics.vltenterprise.com --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-voltlogistics -M "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/msp" --csr.hosts peer1.voltlogistics.vltenterprise.com --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054 --caname ca-voltlogistics -M "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/msp" --csr.hosts peer2.voltlogistics.vltenterprise.com --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/msp/config.yaml"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/msp/config.yaml"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-voltlogistics -M "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls" --enrollment.profile tls --csr.hosts peer0.voltlogistics.vltenterprise.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-voltlogistics -M "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/tls" --enrollment.profile tls --csr.hosts peer1.voltlogistics.vltenterprise.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054 --caname ca-voltlogistics -M "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/tls" --enrollment.profile tls --csr.hosts peer2.voltlogistics.vltenterprise.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/server.key"

  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/tls/server.key"

  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/tls/server.key"



  mkdir -p "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/tlscacerts"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/tlscacerts/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/tlscacerts/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/tlsca"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/tlsca/tlsca.voltlogistics.vltenterprise.com-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/tlsca/tlsca.voltlogistics.vltenterprise.com-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/tlsca/tlsca.voltlogistics.vltenterprise.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/ca"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer0.voltlogistics.vltenterprise.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/ca/ca.voltlogistics.vltenterprise.com-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer1.voltlogistics.vltenterprise.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/ca/ca.voltlogistics.vltenterprise.com-cert.pem"
  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/peers/peer2.voltlogistics.vltenterprise.com/msp/cacerts/"* "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/ca/ca.voltlogistics.vltenterprise.com-cert.pem"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-voltlogistics -M "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/User1@voltlogistics.vltenterprise.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/User1@voltlogistics.vltenterprise.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://voltlogisticsadmin:voltlogisticsadminpw@localhost:8054 --caname ca-voltlogistics -M "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/Admin@voltlogistics.vltenterprise.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/voltlogistics/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/voltlogistics.vltenterprise.com/users/Admin@voltlogistics.vltenterprise.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/vltenterprise.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/vltenterprise.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/vltenterprise.com/msp/config.yaml"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/msp" --csr.hosts orderer.vltenterprise.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/vltenterprise.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls" --enrollment.profile tls --csr.hosts orderer.vltenterprise.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/msp/tlscacerts/tlsca.vltenterprise.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/vltenterprise.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/vltenterprise.com/orderers/orderer.vltenterprise.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/vltenterprise.com/msp/tlscacerts/tlsca.vltenterprise.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/vltenterprise.com/users/Admin@vltenterprise.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/vltenterprise.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/vltenterprise.com/users/Admin@vltenterprise.com/msp/config.yaml"
}
