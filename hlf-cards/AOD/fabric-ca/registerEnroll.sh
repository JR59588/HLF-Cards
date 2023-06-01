#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createEDI {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/EDI.hlfcards.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:19054 --caname ca-EDI --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-EDI.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-EDI.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-EDI.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-19054-ca-EDI.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/msp/config.yaml

	infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-EDI --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-EDI --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-EDI --id.name EDIadmin --id.secret EDIadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  { set +x; } 2>/dev/null

  # infoln "Registering peer1"
  # set -x
	# fabric-ca-client register --caname ca-EDI --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  # { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:19054 --caname ca-EDI -M ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/msp --csr.hosts peer0.EDI.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:19054 --caname ca-EDI -M ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer0.EDI.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/tlsca/tlsca.EDI.hlfcards.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/ca
  cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/ca/ca.EDI.hlfcards.com-cert.pem

  # infoln "Generating the peer1 msp"
  # set -x
	# fabric-ca-client enroll -u https://peer1:peer1pw@localhost:19054 --caname ca-EDI -M ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/msp --csr.hosts peer1.EDI.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/msp/config.yaml

  # infoln "Generating the peer1-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer1:peer1pw@localhost:19054 --caname ca-EDI -M ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer1.EDI.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  # { set +x; } 2>/dev/null


  # cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/tls/ca.crt
  # cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/tls/server.crt
  # cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/tls/server.key

  # mkdir ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/msp/tlscacerts
  # cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/msp/tlscacerts/ca.crt

  # mkdir ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/tlsca
  # cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/tlsca/tlsca.EDI.hlfcards.com-cert.pem

  # mkdir ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/ca
  # cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/peers/peer1.EDI.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/ca/ca.EDI.hlfcards.com-cert.pem

  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:19054 --caname ca-EDI -M ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/users/User1@EDI.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/users/User1@EDI.hlfcards.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://EDIadmin:EDIadminpw@localhost:19054 --caname ca-EDI -M ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/users/Admin@EDI.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/EDI/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/EDI.hlfcards.com/users/Admin@EDI.hlfcards.com/msp/config.yaml
}
