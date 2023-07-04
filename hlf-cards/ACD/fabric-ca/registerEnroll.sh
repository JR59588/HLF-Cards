#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createACD {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/ACD.hlfcards.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:15054 --caname ca-ACD --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-ACD.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-ACD.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-ACD.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-15054-ca-ACD.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/msp/config.yaml

  infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-ACD --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  { set +x; } 2>/dev/null

# added for peer 1 for Registering
  # infoln "Registering peer1"
  # set -x
	# fabric-ca-client register --caname ca-ACD --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  # { set +x; } 2>/dev/null
#####

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-ACD --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-ACD --id.name ACDadmin --id.secret ACDadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:15054 --caname ca-ACD -M ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/msp --csr.hosts peer0.ACD.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:15054 --caname ca-ACD -M ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer0.ACD.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/tlsca/tlsca.ACD.hlfcards.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/ca
  cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/ca/ca.ACD.hlfcards.com-cert.pem

  ## adding peer 1 

  # infoln "Generating the peer1 msp"
  # set -x
	# fabric-ca-client enroll -u https://peer1:peer1pw@localhost:15054 --caname ca-ACD -M ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/msp --csr.hosts peer1.ACD.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  # { set +x; } 2>/dev/null

  # cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/msp/config.yaml

  # infoln "Generating the peer1-tls certificates"
  # set -x
  # fabric-ca-client enroll -u https://peer1:peer1pw@localhost:15054 --caname ca-ACD -M ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer1.ACD.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  # { set +x; } 2>/dev/null


  # cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/tls/ca.crt
  # cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/tls/server.crt
  # cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/tls/server.key

  # mkdir ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/msp/tlscacerts
  # cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/msp/tlscacerts/ca.crt

  # mkdir ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/tlsca
  # cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/tlsca/tlsca.ACD.hlfcards.com-cert.pem

  # mkdir ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/ca
  # cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer1.ACD.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/ca/ca.ACD.hlfcards.com-cert.pem
  
  ####

  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:15054 --caname ca-ACD -M ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/users/User1@ACD.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/users/User1@ACD.hlfcards.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://ACDadmin:ACDadminpw@localhost:15054 --caname ca-ACD -M ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/users/Admin@ACD.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/ACD/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/users/Admin@ACD.hlfcards.com/msp/config.yaml
}
