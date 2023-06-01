#!/bin/bash

function createOrg1() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/merchantOrg1.hlfcards.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  # added peer1 by deepak
  
  # infoln "Registering peer1"
  # set -x
  # fabric-ca-client register --caname ca-org1 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # { set +x; } 2>/dev/null
  
  #################

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/msp --csr.hosts peer0.merchantOrg1.hlfcards.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer0.merchantOrg1.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/tlsca/tlsca.merchantOrg1.hlfcards.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/ca
  cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/ca/ca.merchantOrg1.hlfcards.com-cert.pem

  # added by deepak

  # infoln "Generating the peer1 msp"
  # set -x
  # fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/msp --csr.hosts peer1.merchantOrg1.hlfcards.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/msp/config.yaml

  # infoln "Generating the peer1-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer1.merchantOrg1.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/tls/ca.crt
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/tls/server.crt
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/tls/server.key

  # mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/msp/tlscacerts
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/msp/tlscacerts/ca.crt

  # mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/tlsca
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/tlsca/tlsca.merchantOrg1.hlfcards.com-cert.pem

  # mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/ca
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer1.merchantOrg1.hlfcards.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/ca/ca.merchantOrg1.hlfcards.com-cert.pem

  #################

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/users/User1@merchantOrg1.hlfcards.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/users/User1@merchantOrg1.hlfcards.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/users/Admin@merchantOrg1.hlfcards.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/users/Admin@merchantOrg1.hlfcards.com/msp/config.yaml
}

function createOrg2() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/merchantOrg2.hlfcards.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  # added peer1 by deepak
  
  # infoln "Registering peer1"
  # set -x
  # fabric-ca-client register --caname ca-org2 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # { set +x; } 2>/dev/null
  
  #######################
  
  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/msp --csr.hosts peer0.merchantOrg2.hlfcards.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer0.merchantOrg2.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/tlsca/tlsca.merchantOrg2.hlfcards.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/ca
  cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/ca/ca.merchantOrg2.hlfcards.com-cert.pem

  # added by deepak
  
  # infoln "Generating the peer1 msp"
  # set -x
  # fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/msp --csr.hosts peer1.merchantOrg2.hlfcards.com --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/msp/config.yaml

  # infoln "Generating the peer1-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer1.merchantOrg2.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/tls/ca.crt
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/tls/server.crt
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/tls/server.key

  # mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/msp/tlscacerts
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/msp/tlscacerts/ca.crt

  # mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/tlsca
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/tlsca/tlsca.merchantOrg2.hlfcards.com-cert.pem

  # mkdir -p ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/ca
  # cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer1.merchantOrg2.hlfcards.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/ca/ca.merchantOrg2.hlfcards.com-cert.pem

  #################
  
  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/users/User1@merchantOrg2.hlfcards.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/users/User1@merchantOrg2.hlfcards.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-org2 -M ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/users/Admin@merchantOrg2.hlfcards.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/users/Admin@merchantOrg2.hlfcards.com/msp/config.yaml
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
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
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  infoln "Generating the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml
}
