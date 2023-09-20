#!/bin/bash 
set -e

echo "creating new folder $2 using $1 as base"
cp -r $1 $2 

cd $2
## TODO change the names, the dollar 3,4,5,6 are the port numbers and the dollar 7,8,9,10 are input port numbers
#ORG=9
sed -i "s|ORG=${12}|ORG=${11}|g" ccp-generate.sh
echo $PWD
echo $1

files=("./docker/docker-compose-${1}.yaml" "./docker/docker-compose-ca-$1.yaml" "./docker/docker-compose-couch-$1.yaml" "./fabric-ca/$1/fabric-ca-server-config.yaml" "./fabric-ca/registerEnroll.sh" "./$1-crypto.yaml" "./$1.sh" "./ccp-generate.sh" "./ccp-template.json" "./ccp-template.yaml" "./configtx.yaml")

# Loop through the list of files and generate sed commands
for file in "${files[@]}"; do
    sed -i "s|${1}|${2}|g" "$file"
    sed -i "s|${3}|${7}|g" "$file"
    sed -i "s|${4}|${8}|g" "$file"
    sed -i "s|${5}|${9}|g" "$file"
    sed -i "s|${6}|${10}|g" "$file"
    
done

# find . -type f -exec sed -i "s|$1|$2|g" {} +
echo $PWD
# find . -type f -exec sed -i "s|$3|$7|g" {} +
# echo $2
# find . -type f -exec sed -i "s|$4|$8|g" {} +
# find . -type f -exec sed -i "s|$5|$9|g" {} +
# find . -type f -exec sed -i "s|$6|${10}|g" {} +
# echo "the above changed code is working and all the ports changed in $2 file,,,......."
# Function to rename files recursively
rename_files() {
    find "$1" -type f -name "*$2*" | while read -r oldname; do
        newname="${oldname//$2/$3}"
        mv "$oldname" "$newname"
    done
}

rename_files . $1 $2

echo " all the file names are getting changed...,,,....... 32 line    "
rename_directories() {
    find "$1" -depth -type d -name "*$2*" | while read -r oldname; do
        newname="${oldname//$2/$3}"
        mv "$oldname" "$newname"
    done
}
# Call the function with directory path and old/new strings
rename_directories . $1 $2
echo "the above changed code is working,,,...... 45 line."
# moving to the cripts folder and changing stuff ober tyhere....

cd ./../scripts
cp -r $1-scripts $2-scripts
cd $2-scripts

find . -type f -exec sed -i "s|$1|$2|g" {} +
#sed -i "s|${12}|${11}|g" joinChannel.sh 
echo "the above changed code is working,,,.......56 line"
echo $PWD
echo "s|setGlobalsCLI ${12}|setGlobalsCLI ${11}|g"
sed -i "s|setGlobalsCLI ${12}|setGlobalsCLI ${11}|g" joinChannel.sh 
sed -i "s|joinChannel ${12}|joinChannel ${11}|g" joinChannel.sh 
sed -i "s|setAnchorPeer ${12}|setAnchorPeer ${11}|g" joinChannel.sh 
echo "line number 59"
echo "the above changed code is working,,,.......63 line"

echo $PWD
add_text_before() {
    local target_text="$1"
    local text_to_add="$2"
    local input_file="$3"
    
    # Escape special characters for use in sed
    local escaped_target_text=$(sed 's/[\/&]/\\&/g' <<< "$target_text")
    local escaped_text_to_add=$(sed 's/[\/&]/\\&/g' <<< "$text_to_add")
echo $PWD
echo "iniside the add text before"
    # Use sed to add the text before the target text
    sed "s|$escaped_target_text|$escaped_text_to_add\\
$escaped_target_text|" "$input_file" > "${input_file}.tmp"
    
    mv "${input_file}.tmp" "$input_file"
    echo "Text added successfully."
}
echo "the above changed code is working,,,.......line 73"

# Usage
cd ./..
echo $PWD
add_text_before "###token1" "export PEER0_$2_CA=\${PWD}/organizations/peerOrganizations/$2.hlfcards.com/peers/peer0.$2.hlfcards.com/tls/ca.crt" envVar.sh
echo >> envVar.sh

add_text_before "###token2" "  elif [ \$USING_ORG -eq ${11} ]; then" envVar.sh
add_text_before "###token2" "    echo \"setting peer env for \$USING_ORG\"" envVar.sh
add_text_before "###token2" "    export CORE_PEER_LOCALMSPID=\"$2MSP\"" envVar.sh
add_text_before "###token2" "    export CORE_PEER_TLS_ROOTCERT_FILE=\$PEER0_$2_CA" envVar.sh
add_text_before "###token2" "    export CORE_PEER_MSPCONFIGPATH=\${PWD}/organizations/peerOrganizations/$2.hlfcards.com/users/Admin@$2.hlfcards.com/msp" envVar.sh
add_text_before "###token2" "    export CORE_PEER_ADDRESS=localhost:$7" envVar.sh
echo >> envVar.sh

add_text_before "###token3" "  elif [ \$USING_ORG -eq ${11} ]; then" envVar.sh
add_text_before "###token3" "    export CORE_PEER_ADDRESS=peer0.$2.hlfcards.com:$7" envVar.sh
echo >> envVar.sh

add_text_before "###token4" "  elif [ \$ORG -eq ${11} ]; then" setAnchorPeer.sh
add_text_before "###token4" "    HOST=\"peer0.$2.hlfcards.com\"" setAnchorPeer.sh
add_text_before "###token4" "    PORT=$7" setAnchorPeer.sh
echo >> setAnchorPeer.sh

echo "the above changed code is working,,,.......line 92 "

cd ./..
cd ./$2
echo $PWD

# find . -type f -exec sed -i "s|peer0|peer0$2|g" {} +
# find . -type f -exec sed -i "s|user1|user1$2|g" {} +
# find . -type f -exec sed -i "s|$2admin|$2admin$2|g" {} +

# cd ./..
# cd ./scripts
# echo $PWD

# find . -type f -exec sed -i "s|peer0.$2|peer0$2.$2|g" {} +
# echo "changed in scripts .....................125"

# cd ./..
# cd ./$2
echo "reached sudo command... 133"
who
sudo chmod -R 777 ./../../hlf-cards/

./$2.sh up -c channel1 -ca -s couchdb

export PATH=${PWD}/../bin:$PATH
echo "PATH"
echo $PATH
export FABRIC_CFG_PATH=$PWD/../../config/
echo "FABRIC_CFG_PATH"
echo $FABRIC_CFG_PATH
export CORE_PEER_TLS_ENABLED=true
echo "CORE_PEER_TLS_ENABLED"
echo $CORE_PEER_TLS_ENABLED
export CORE_PEER_LOCALMSPID="$2MSP"
echo "CORE_PEER_LOCALMSPID"
echo $CORE_PEER_LOCALMSPID
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/$2.hlfcards.com/peers/peer0.$2.hlfcards.com/tls/ca.crt
echo "CORE_PEER_TLS_ROOTCERT_FILE"
echo $CORE_PEER_TLS_ROOTCERT_FILE
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/$2.hlfcards.com/users/Admin@$2.hlfcards.com/msp
echo "CORE_PEER_MSPCONFIGPATH"
echo $CORE_PEER_MSPCONFIGPATH
export CORE_PEER_ADDRESS=localhost:$7
echo "CORE_PEER_ADDRESS"
echo $CORE_PEER_ADDRESS

echo "exported paths :..........................:"
peer lifecycle chaincode package PYMTUtilsCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-utility --lang node --label PYMTUtilsCC
peer lifecycle chaincode install PYMTUtilsCC.tar.gz >&log1.txt
cat log1.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log1.txt)
echo "CC_PACKAGE_ID"
echo "$CC_PACKAGE_ID"
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name PYMTUtilsCC --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

echo "first chaincode is installed ..........................................."

peer lifecycle chaincode package MC_PYMTTxMerchantCC.tar.gz --path ../../../CardsChaincodeV1/hlf-chaincode/chaincode/chaincode-merchant --lang node --label MC_PYMTTxMerchantCC
peer lifecycle chaincode install MC_PYMTTxMerchantCC.tar.gz >&log2.txt
cat log2.txt
export CC_PACKAGE_ID=$(sed -n 's/.*Chaincode code package identifier: \([^ ]*\).*/\1/p' log2.txt)
echo "CC_PACKAGE_ID"
echo "$CC_PACKAGE_ID"
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --channelID channel1 --name MC_PYMTTxMerchantCC  --version 1.0 --package-id $CC_PACKAGE_ID --sequence 1 --tls --cafile "${PWD}/../organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
echo "second chaincode installed .................................."
