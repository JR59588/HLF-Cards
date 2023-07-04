#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createAOD {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/AOD.hlfcards.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:19054 --caname ca-AOD --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-AOD.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-AOD.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-AOD.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-AOD.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/msp/config.yaml

	infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-AOD --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-AOD --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-AOD --id.name AODadmin --id.secret AODadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  { set +x; } 2>/dev/null

  # infoln "Registering peer1"
  # set -x
	# fabric-ca-client register --caname ca-AOD --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  # { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:19054 --caname ca-AOD -M ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/msp --csr.hosts peer0.AOD.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:19054 --caname ca-AOD -M ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer0.AOD.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/tlsca/tlsca.AOD.hlfcards.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/ca
  cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/ca/ca.AOD.hlfcards.com-cert.pem

  # infoln "Generating the peer1 msp"
  # set -x
	# fabric-ca-client enroll -u https://peer1:peer1pw@localhost:19054 --caname ca-AOD -M ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/msp --csr.hosts peer1.AOD.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/msp/config.yaml

  # infoln "Generating the peer1-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer1:peer1pw@localhost:19054 --caname ca-AOD -M ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer1.AOD.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  # { set +x; } 2>/dev/null


  # cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/tls/ca.crt
  # cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/tls/server.crt
  # cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/tls/server.key

  # mkdir ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/msp/tlscacerts
  # cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/msp/tlscacerts/ca.crt

  # mkdir ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/tlsca
  # cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/tlsca/tlsca.AOD.hlfcards.com-cert.pem

  # mkdir ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/ca
  # cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer1.AOD.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/ca/ca.AOD.hlfcards.com-cert.pem

  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:19054 --caname ca-AOD -M ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/users/User1@AOD.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/users/User1@AOD.hlfcards.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://AODadmin:AODadminpw@localhost:19054 --caname ca-AOD -M ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/users/Admin@AOD.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/AOD/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/users/Admin@AOD.hlfcards.com/msp/config.yaml
}
