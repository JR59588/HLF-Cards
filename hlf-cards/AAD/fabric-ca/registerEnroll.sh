#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createAAD {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/AAD.hlfcards.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-AAD --tls.certfiles ${PWD}/fabric-ca/AAD/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-AAD.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-AAD.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-AAD.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-AAD.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/msp/config.yaml

	infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-AAD --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/AAD/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-AAD --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/AAD/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-AAD --id.name AADadmin --id.secret AADadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/AAD/tls-cert.pem
  { set +x; } 2>/dev/null

  # infoln "Registering peer1"
  # set -x
	# fabric-ca-client register --caname ca-AAD --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/AAD/tls-cert.pem
  # { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-AAD -M ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/msp --csr.hosts peer0.AAD.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/AAD/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-AAD -M ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer0.AAD.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/AAD/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/tlsca/tlsca.AAD.hlfcards.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/ca
  cp ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/ca/ca.AAD.hlfcards.com-cert.pem

  
  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-AAD -M ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/users/User1@AAD.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/AAD/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/users/User1@AAD.hlfcards.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://AADadmin:AADadminpw@localhost:11054 --caname ca-AAD -M ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/users/Admin@AAD.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/AAD/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/users/Admin@AAD.hlfcards.com/msp/config.yaml
}
