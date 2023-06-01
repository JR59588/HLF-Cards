#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createAP {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/AP.hlfcards.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:15054 --caname ca-AP --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-AP.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-AP.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-AP.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-AP.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-AP --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  { set +x; } 2>/dev/null

# added for peer 1 for Registering
  # infoln "Registering peer1"
  # set -x
	# fabric-ca-client register --caname ca-AP --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  # { set +x; } 2>/dev/null
#####

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-AP --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-AP --id.name APadmin --id.secret APadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:15054 --caname ca-AP -M ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/msp --csr.hosts peer0.AP.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:15054 --caname ca-AP -M ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer0.AP.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/tlsca/tlsca.AP.hlfcards.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/ca
  cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/ca/ca.AP.hlfcards.com-cert.pem

  ## adding peer 1 

  # infoln "Generating the peer1 msp"
  # set -x
	# fabric-ca-client enroll -u https://peer1:peer1pw@localhost:15054 --caname ca-AP -M ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/msp --csr.hosts peer1.AP.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/msp/config.yaml

  # infoln "Generating the peer1-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer1:peer1pw@localhost:15054 --caname ca-AP -M ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer1.AP.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  # { set +x; } 2>/dev/null


  # cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/tls/ca.crt
  # cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/tls/server.crt
  # cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/tls/server.key

  # mkdir ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/msp/tlscacerts
  # cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/msp/tlscacerts/ca.crt

  # mkdir ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/tlsca
  # cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/tlsca/tlsca.AP.hlfcards.com-cert.pem

  # mkdir ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/ca
  # cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/peers/peer1.AP.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/ca/ca.AP.hlfcards.com-cert.pem
  
  ####

  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:15054 --caname ca-AP -M ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/users/User1@AP.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/users/User1@AP.hlfcards.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://APadmin:APadminpw@localhost:15054 --caname ca-AP -M ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/users/Admin@AP.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/AP/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AP.hlfcards.com/users/Admin@AP.hlfcards.com/msp/config.yaml
}
