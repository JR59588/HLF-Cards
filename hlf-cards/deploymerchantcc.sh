export PATH=${PWD}/bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/peers/peer0.merchantOrg1.hlfcards.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/merchantOrg1.hlfcards.com/users/Admin@merchantOrg1.hlfcards.com/msp
export CORE_PEER_ADDRESS=localhost:7051


./network.sh deployCC -ccn MC_PYMTTxMerchantCC -ccp ../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-merchant -ccl javascript -c channel1 -ccs $2 -ccv $1.0

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


#MC_PYMTTxMerchantCC Chaincode
peer lifecycle chaincode package MC_PYMTTxMerchantCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-merchant --lang node --label MC_PYMTTxMerchantCC 
peer lifecycle chaincode install MC_PYMTTxMerchantCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name MC_PYMTTxMerchantCC --version $1.0 --package-id $CC_PACKAGE_ID --sequence $2 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" 
echo "2222222222222222222222222222222222222222222222222222222222222222222222222222"


#=======================================================ACD END======================================================


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

#MC_PYMTTxMerchantCC Chaincode
peer lifecycle chaincode package MC_PYMTTxMerchantCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-merchant --lang node --label MC_PYMTTxMerchantCC 
peer lifecycle chaincode install MC_PYMTTxMerchantCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name MC_PYMTTxMerchantCC --version $1.0 --package-id $CC_PACKAGE_ID --sequence $2 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" 
echo "777777777777777777777777777777777777777777777777777777777777777777777777"



#=======================================================AOD END======================================================


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


#MC_PYMTTxMerchantCC Chaincode
peer lifecycle chaincode package MC_PYMTTxMerchantCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-merchant --lang node --label MC_PYMTTxMerchantCC 
peer lifecycle chaincode install MC_PYMTTxMerchantCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name MC_PYMTTxMerchantCC --version $1.0 --package-id $CC_PACKAGE_ID --sequence $2 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" 
echo "12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-12-"

#=======================================================AAD END======================================================

#=======================================================PSP START======================================================

#Export path variables for PSP
cd ../PSP

export PATH=${PWD}/../bin:$PATH 
export FABRIC_CFG_PATH=$PWD/../../config/ 
export CORE_PEER_TLS_ENABLED=true 
export CORE_PEER_LOCALMSPID="PSPMSP" 
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/peers/peer0.PSP.hlfcards.com/tls/ca.crt 
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/PSP.hlfcards.com/users/Admin@PSP.hlfcards.com/msp 
export CORE_PEER_ADDRESS=localhost:13051 

#MC_PYMTTxMerchantCC Chaincode

peer lifecycle chaincode package MC_PYMTTxMerchantCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-merchant --lang node --label MC_PYMTTxMerchantCC 
peer lifecycle chaincode install MC_PYMTTxMerchantCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name MC_PYMTTxMerchantCC --version $1.0 --package-id $CC_PACKAGE_ID --sequence $2 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" 
echo "17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-17-"
#=======================================================PSP END======================================================
