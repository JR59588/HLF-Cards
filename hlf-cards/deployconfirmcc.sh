#=======================================================ACD======================================================
cd ACD

#Exporting path variables for ACD
export PATH=${PWD}/../bin:$PATH 
export FABRIC_CFG_PATH=$PWD/../../config/ 
export CORE_PEER_TLS_ENABLED=true 
export CORE_PEER_LOCALMSPID="ACDMSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/ca.crt 
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/users/Admin@ACD.hlfcards.com/msp 
export CORE_PEER_ADDRESS=localhost:15051 



# Confirm Chaincode comitted on ACD (Signature policy: ACD & AAD)
peer lifecycle chaincode package ConfirmSettlementTxCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-confirm-ACD --lang node --label ConfirmSettlementTxCC
peer lifecycle chaincode install ConfirmSettlementTxCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name ConfirmSettlementTxCC --version $1.0 --package-id $CC_PACKAGE_ID --sequence $2 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --signature-policy 'AND('\''ACDMSP.member'\'','\''AADMSP.member'\'')' --waitForEvent
echo "3333333333333333333333333333333333333333333333333333333333333333333333333333"



#=======================================================ACD END======================================================


#=======================================================AAD START======================================================

#Export path variables for AAD
cd ../AAD

export PATH=${PWD}/../bin:$PATH 
export FABRIC_CFG_PATH=$PWD/../../config/ 
export CORE_PEER_TLS_ENABLED=true 
export CORE_PEER_LOCALMSPID="AADMSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/ca.crt 
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/users/Admin@AAD.hlfcards.com/msp 
export CORE_PEER_ADDRESS=localhost:11051 



# Confirm Chaincode comitted on ACD (Signature policy: ACD & AAD)
echo "Installing chaincode ConfirmSettlmentTxCC on AAD"
peer lifecycle chaincode package ConfirmSettlementTxCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-confirm-AAD --lang node --label ConfirmSettlementTxCC
peer lifecycle chaincode install ConfirmSettlementTxCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name ConfirmSettlementTxCC --version $1.0 --package-id $CC_PACKAGE_ID --sequence $2 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --signature-policy 'AND('\''ACDMSP.member'\'','\''AADMSP.member'\'')' --waitForEvent
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name ConfirmSettlementTxCC --version $1.0 --sequence $2 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --peerAddresses localhost:15051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/ca.crt" --peerAddresses localhost:11051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/ca.crt" --signature-policy 'AND('\''ACDMSP.member'\'','\''AADMSP.member'\'')' --waitForEvent
echo "Installed chaincode ConfirmSettlmentTxCC on AAD"
echo "13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-"

