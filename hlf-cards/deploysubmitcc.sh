cd ./AOD

export PATH=${PWD}/../bin:$PATH 
export FABRIC_CFG_PATH=$PWD/../../config/ 
export CORE_PEER_TLS_ENABLED=true 
export CORE_PEER_LOCALMSPID="AODMSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/ca.crt 
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/users/Admin@AOD.hlfcards.com/msp 
export CORE_PEER_ADDRESS=localhost:19051 

# Submit Chaincode comitted on AOD (Signature policy: AOD & AAD)
echo "Installing chaincode SubmitSettlementTxCC on AOD"
peer lifecycle chaincode package SubmitSettlementTxCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-submit-AOD --lang node --label SubmitSettlementTxCC
peer lifecycle chaincode install SubmitSettlementTxCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name SubmitSettlementTxCC --version 3.0 --package-id $CC_PACKAGE_ID --sequence 3 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --signature-policy 'AND('\''AADMSP.member'\'','\''AODMSP.member'\'')' --waitForEvent
echo "Installed chaincode SubmitSettlementTxCC on AOD"
echo "888888888888888888888888888888888888888888888888888888888888888888888888888"


cd ../AAD

export PATH=${PWD}/../bin:$PATH 
export FABRIC_CFG_PATH=$PWD/../../config/ 
export CORE_PEER_TLS_ENABLED=true 
export CORE_PEER_LOCALMSPID="AADMSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/ca.crt 
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/users/Admin@AAD.hlfcards.com/msp 
export CORE_PEER_ADDRESS=localhost:11051


# Submit Chaincode comitted on AAD (Signature policy: AOD & AAD)
echo "Installing chaincode SubmitSettlementTxCC on AAD"
peer lifecycle chaincode package SubmitSettlementTxCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-submit-AAD --lang node --label SubmitSettlementTxCC
peer lifecycle chaincode install SubmitSettlementTxCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name SubmitSettlementTxCC --version 3.0 --package-id $CC_PACKAGE_ID --sequence 3 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --signature-policy 'AND('\''AADMSP.member'\'','\''AODMSP.member'\'')' --waitForEvent
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name SubmitSettlementTxCC --version 3.0 --sequence 3 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --peerAddresses localhost:11051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/AAD.hlfcards.com/peers/peer0.AAD.hlfcards.com/tls/ca.crt" --peerAddresses localhost:19051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/ca.crt" --signature-policy 'AND('\''AADMSP.member'\'','\''AODMSP.member'\'')' --waitForEvent
echo "Installed chaincode SubmitSettlementTxCC on AAD"
echo "14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-14-"
