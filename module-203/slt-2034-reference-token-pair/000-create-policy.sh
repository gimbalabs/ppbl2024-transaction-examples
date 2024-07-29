#!/bin/bash
token_name=$1

mkdir $token_name
cd $token_name

# Automatically create a new policy id
cardano-cli address key-gen --verification-key-file mint-$token_name.vkey --signing-key-file mint-$token_name.skey
cardano-cli address key-hash --payment-verification-key-file mint-$token_name.vkey --out-file mint-$token_name.pkh

echo "{
    \"keyHash\": \"$(cat mint-$token_name.pkh)\",
    \"type\": \"sig\"
}" >>mint-$token_name.script

cardano-cli transaction policyid --script-file mint-$token_name.script >>$token_name.cs
