echo $1 $2

#=======================================================ACD======================================================
cd ACD

#Exporting path variables for ACD
# export PATH=${PWD}/../bin:$PATH 
# export FABRIC_CFG_PATH=$PWD/../../config/ 
# export CORE_PEER_TLS_ENABLED=true 
# export CORE_PEER_LOCALMSPID="ACDMSP" 
# export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/ca.crt 
# export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/users/Admin@ACD.hlfcards.com/msp 
# export CORE_PEER_ADDRESS=localhost:15051 


# Account Chaincode comitted on ACD (Signature policy: ACD & AOD)
# peer lifecycle chaincode package AccountSettlementTxCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-account-ACD --lang node --label AccountSettlementTxCC
# peer lifecycle chaincode install AccountSettlementTxCC.tar.gz >&log1.txt
# cat log1.txt
# export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
# printenv CC_PACKAGE_ID
# peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name AccountSettlementTxCC --version $1.0 --sequence $2 --package-id $CC_PACKAGE_ID  --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --signature-policy 'AND('\''ACDMSP.member'\'','\''AODMSP.member'\'')' --waitForEvent
# echo "4444444444444444444444444444444444444444444444444444444444444444444444444444444444"



#=======================================================AOD START======================================================

#Exporting path variables for AOD
cd ../AOD

export PATH=${PWD}/../bin:$PATH 
export FABRIC_CFG_PATH=$PWD/../../config/ 
export CORE_PEER_TLS_ENABLED=true 
export CORE_PEER_LOCALMSPID="AODMSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/ca.crt 
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/users/Admin@AOD.hlfcards.com/msp 
export CORE_PEER_ADDRESS=localhost:19051 


# Account Chaincode comitted on AOD (Signature policy: ACD & AOD)
peer lifecycle chaincode package AccountSettlementTxCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-account-AOD --lang node --label AccountSettlementTxCC
peer lifecycle chaincode install AccountSettlementTxCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name AccountSettlementTxCC --version $1.0 --sequence $2 --package-id $CC_PACKAGE_ID --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --signature-policy 'AND('\''ACDMSP.member'\'','\''AODMSP.member'\'')' --waitForEvent
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name AccountSettlementTxCC --version $1.0 --sequence $2 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" --peerAddresses localhost:15051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/ACD.hlfcards.com/peers/peer0.ACD.hlfcards.com/tls/ca.crt" --peerAddresses localhost:19051 --tlsRootCertFiles "${PWD}/../organizations/peerOrganizations/AOD.hlfcards.com/peers/peer0.AOD.hlfcards.com/tls/ca.crt" --signature-policy 'AND('\''ACDMSP.member'\'','\''AODMSP.member'\'')' --waitForEvent
echo "99999999999999999999999999999999999999999999999999999999999999999999999999999"
