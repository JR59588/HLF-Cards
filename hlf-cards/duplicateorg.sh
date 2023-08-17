#!/bin/bash
set -e

echo "creating new folder $2 using $1 as base"
cp -r $1 $2 

cd $2
## TODO change the names, the dollar 3,4,5,6 are the port numbers and the dollar 7,8,9,10 are input port numbers

echo $PWD
echo $1


find . -type f -exec sed -i "s|$1|$2|g" {} +
find . -type f -exec sed -i "s|$3|$7|g" {} +
echo $2
find . -type f -exec sed -i "s|$4|$8|g" {} +
find . -type f -exec sed -i "s|$5|$9|g" {} +
find . -type f -exec sed -i "s|$6|$10|g" {} +
echo "the above changed code is working,,,......."
# Function to rename files recursively
rename_files() {
    find "$1" -type f -name "*$2*" | while read -r oldname; do
        newname="${oldname//$2/$3}"
        mv "$oldname" "$newname"
    done
}

# Call the function with directory path and old/new strings
rename_files . $1 $2

echo "the above changed code is working,,,....... 32 line    "
#!/bin/bash

# Function to recursively rename directories
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
#sed -i "s|$12|$11|g" joinChannel.sh 
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
add_text_before "###token1" "export PEER0_$2_CA=\${PWD}/organizations/peerOrganizations/$2.hlfdec.com/peers/peer0.$2.hlfdec.com/tls/ca.crt" envVar.sh
echo >> envVar.sh

add_text_before "###token2" "  elif [ \$USING_ORG -eq $11 ]; then" envVar.sh
add_text_before "###token2" "    echo \"setting peer env for \$USING_ORG\"" envVar.sh
add_text_before "###token2" "    export CORE_PEER_LOCALMSPID=\"$2MSP\"" envVar.sh
add_text_before "###token2" "    export CORE_PEER_TLS_ROOTCERT_FILE=\$PEER0_$2_CA" envVar.sh
add_text_before "###token2" "    export CORE_PEER_MSPCONFIGPATH=\${PWD}/organizations/peerOrganizations/$2.hlfdec.com/users/Admin@$2.hlfdec.com/msp" envVar.sh
add_text_before "###token2" "    export CORE_PEER_ADDRESS=localhost:$7" envVar.sh
echo >> envVar.sh

add_text_before "###token3" "  elif [ \$USING_ORG -eq $11 ]; then" envVar.sh
add_text_before "###token3" "    export CORE_PEER_ADDRESS=peer0.$2.hlfdec.com:$7" envVar.sh
echo >> envVar.sh

add_text_before "###token4" "  elif [ \$ORG -eq $11 ]; then" setAnchorPeer.sh
add_text_before "###token4" "    HOST=\"peer0.$2.hlfdec.com\"" setAnchorPeer.sh
add_text_before "###token4" "    PORT=$7" setAnchorPeer.sh
echo >> setAnchorPeer.sh

echo "the above changed code is working,,,.......line 92 "

cd ./..
echo $PWD
#./$2.sh up createChannel -c channel1 -ca -s chouchdb

