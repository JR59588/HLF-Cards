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

ORG=4
P0PORT=13051
CAPORT=13054
PEERPEM=../organizations/peerOrganizations/PSP.hlfcards.com/tlsca/tlsca.PSP.hlfcards.com-cert.pem
CAPEM=../organizations/peerOrganizations/PSP.hlfcards.com/ca/ca.PSP.hlfcards.com-cert.pem

#PEERPEM=../organizations/peerOrganizations/ap.hlfcards.com/tlsca/tlsca.PSP.hlfcards.com-cert.pem
#CAPEM=../organizations/peerOrganizations/ap.hlfcards.com/ca/ca.PSP.hlfcards.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/PSP.hlfcards.com/connection-PSP.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/PSP.hlfcards.com/connection-PSP.yaml

#echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/ap.hlfcards.com/connection-PSP.json
#echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/ap.hlfcards.com/connection-PSP.yaml

