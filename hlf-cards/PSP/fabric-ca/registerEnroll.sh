#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createPSP {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/PSP.hlfcards.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:13054 --caname ca-PSP --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-PSP.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-PSP.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-PSP.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-13054-ca-PSP.pem
    OrganizationalUnitIdentifier: orderer' > ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/msp/config.yaml

	infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-PSP --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
  { set +x; } 2>/dev/null

#  # registering peer1
#   infoln "Registering peer1"
#   set -x
# 	fabric-ca-client register --caname ca-PSP --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
#   { set +x; } 2>/dev/null
#   ###################

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-PSP --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-PSP --id.name PSPadmin --id.secret PSPadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:13054 --caname ca-PSP -M ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/msp --csr.hosts peer0.PSP.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/msp/config.yaml

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:13054 --caname ca-PSP -M ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer0.PSP.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
  { set +x; } 2>/dev/null


  cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/ca.crt
  cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/server.crt
  cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/server.key

  mkdir ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/msp/tlscacerts
  cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/tlsca
  cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/tlsca/tlsca.PSP.hlfcards.com-cert.pem

  mkdir ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/ca
  cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/ca/ca.PSP.hlfcards.com-cert.pem

#### adding peer 1

# infoln "Generating the peer1 msp"
#   set -x
# 	fabric-ca-client enroll -u https://peer1:peer1pw@localhost:13054 --caname ca-PSP -M ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/msp --csr.hosts peer1.PSP.hlfcards.com --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
#   { set +x; } 2>/dev/null

#   cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/msp/config.yaml

#   infoln "Generating the peer1-tls certificates"
#   set -x
#   fabric-ca-client enroll -u https://peer1:peer1pw@localhost:13054 --caname ca-PSP -M ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/tls --enrollment.profile tls --csr.hosts peer1.PSP.hlfcards.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
#   { set +x; } 2>/dev/null


#   cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/tls/ca.crt
#   cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/tls/signcerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/tls/server.crt
#   cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/tls/keystore/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/tls/server.key

#   mkdir ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/msp/tlscacerts
#   cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/msp/tlscacerts/ca.crt

#   mkdir ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/tlsca
#   cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/tls/tlscacerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/tlsca/tlsca.PSP.hlfcards.com-cert.pem

#   mkdir ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/ca
#   cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer1.PSP.hlfcards.com/msp/cacerts/* ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/ca/ca.PSP.hlfcards.com-cert.pem


####
  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:13054 --caname ca-PSP -M ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/users/User1@PSP.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/users/User1@PSP.hlfcards.com/msp/config.yaml

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://PSPadmin:PSPadminpw@localhost:13054 --caname ca-PSP -M ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/users/Admin@PSP.hlfcards.com/msp --tls.certfiles ${PWD}/fabric-ca/PSP/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/msp/config.yaml ${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/users/Admin@PSP.hlfcards.com/msp/config.yaml
}
