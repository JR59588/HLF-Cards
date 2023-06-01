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
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/peers/peer0.merchantOrg2.hlfcards.com/tls/ca.crt
export PEER0_AAD_CA=${PWD}/organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/ca.crt
export PEER0_PSP_CA=${PWD}/organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/ca.crt
export PEER0_AP_CA=${PWD}/organizations/peerOrganizations/AP.hlfcards.com/peers/peer0.AP.hlfcards.com/tls/ca.crt
export PEER0_CAcct_CA=${PWD}/organizations/peerOrganizations/CAcct.hlfcards.com/peers/peer0.CAcct.hlfcards.com/tls/ca.crt
export PEER0_EDI_CA=${PWD}/organizations/peerOrganizations/EDI.hlfcards.com/peers/peer0.EDI.hlfcards.com/tls/ca.crt

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/users/Admin@merchantOrg1.hlfcards.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/merchantOrg2.hlfcards.com/users/Admin@merchantOrg2.hlfcards.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="AADMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_AAD_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/AAD.hlfcards.com/users/Admin@AAD.hlfcards.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
  
  elif [ $USING_ORG -eq 4 ]; then
    echo "setting peer env for $USING_ORG"
    export CORE_PEER_LOCALMSPID="PSPMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PSP_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/PSP.hlfcards.com/users/Admin@PSP.hlfcards.com/msp
    export CORE_PEER_ADDRESS=localhost:13051
  
  elif [ $USING_ORG -eq 5 ]; then
    export CORE_PEER_LOCALMSPID="APMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_AP_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/AP.hlfcards.com/users/Admin@AP.hlfcards.com/msp
    export CORE_PEER_ADDRESS=localhost:15051

  elif [ $USING_ORG -eq 6 ]; then
    echo "setting peer env for $USING_ORG"
    export CORE_PEER_LOCALMSPID="CAcctMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CAcct_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/CAcct.hlfcards.com/users/Admin@CAcct.hlfcards.com/msp
    export CORE_PEER_ADDRESS=localhost:17051

  elif [ $USING_ORG -eq 7 ]; then
    echo "setting peer env for $USING_ORG"
    export CORE_PEER_LOCALMSPID="EDIMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_EDI_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/EDI.hlfcards.com/users/Admin@EDI.hlfcards.com/msp
    export CORE_PEER_ADDRESS=localhost:19051
  
  else
    errorln "ORG Unknown"
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
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.merchantOrg1.hlfcards.com:7051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.merchantOrg2.hlfcards.com:9051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.AAD.hlfcards.com:11051
  elif [ $USING_ORG -eq 4 ]; then
    export CORE_PEER_ADDRESS=peer0.PSP.hlfcards.com:13051
  elif [ $USING_ORG -eq 5 ]; then
    export CORE_PEER_ADDRESS=peer0.AP.hlfcards.com:15051
  elif [ $USING_ORG -eq 6 ]; then
    export CORE_PEER_ADDRESS=peer0.CAcct.hlfcards.com:17051
  elif [ $USING_ORG -eq 7 ]; then
    export CORE_PEER_ADDRESS=peer0.EDI.hlfcards.com:19051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.org$1"
    ## Set peer addresses
    PEERS="$PEERS $PEER"
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    shift
  done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
