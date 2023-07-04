#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

ORG=5
P0PORT=15051
CAPORT=15054
PEERPEM=../organizations/peerOrganizations/ACD.hlfcards.com/tlsca/tlsca.ACD.hlfcards.com-cert.pem
CAPEM=../organizations/peerOrganizations/ACD.hlfcards.com/ca/ca.ACD.hlfcards.com-cert.pem

#PEERPEM=../organizations/peerOrganizations/acd.hlfcards.com/tlsca/tlsca.ACD.hlfcards.com-cert.pem
#CAPEM=../organizations/peerOrganizations/acd.hlfcards.com/ca/ca.ACD.hlfcards.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/ACD.hlfcards.com/connection-ACD.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/ACD.hlfcards.com/connection-ACD.yaml

#echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/acd.hlfcards.com/connection-ACD.json
#echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/acd.hlfcards.com/connection-ACD.yaml

