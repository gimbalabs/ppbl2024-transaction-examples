#!/bin/bash

# A

# Usage ./mint-native-assets-automate-policy-id.sh receiver_addr token_name quantity

# Helpful functions
. ../utils.sh

# Args
receiver_addr=$1
token_name=$2
quantity=$3

mkdir mint-$token_name
cd mint-$token_name

# Use yours
sender=
sender_key=

# Automatically create a new policy id
cardano-cli address key-gen --verification-key-file mint-$token_name.vkey --signing-key-file mint-$token_name.skey
cardano-cli address key-hash --payment-verification-key-file mint-$token_name.vkey --out-file mint-$token_name.pkh

echo "{
    \"keyHash\": \"$(cat mint-$token_name.pkh)\",
    \"type\": \"sig\"
}" >> mint-$token_name.script

cardano-cli transaction policyid --script-file mint-$token_name.script >> $token_name.cs

# Set variables
mint_script_file_path=mint-$token_name.script
mint_signing_key_file_path=mint-$token_name.skey
policy_id=$(cat $token_name.cs)

# Use get_address_biggest_lovelace from ../utils.sh
# to get the utxo with the most lovelace
tx_in=$(get_address_biggest_lovelace ${sender})

# Convert token name to hex string
token_hex=$(printf '%s' "$token_name" | xxd -p)

echo "Minting $token_name"

# Build Tx
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 1 \
    --tx-in $tx_in \
    --tx-out $receiver_addr+"1500000 + $quantity $policy_id.$token_hex" \
    --mint "$quantity $policy_id.$token_hex" \
    --mint-script-file $mint_script_file_path \
    --change-address $sender \
    --required-signer $mint_signing_key_file_path \
    --out-file mint-native-assets.draft

# Sign Tx
cardano-cli transaction sign \
    --signing-key-file $mint_signing_key_file_path \
    --signing-key-file $sender_key \
    --testnet-magic 1 \
    --tx-body-file mint-native-assets.draft \
    --out-file mint-native-assets.signed

# Submit Tx
cardano-cli transaction submit \
    --tx-file mint-native-assets.signed \
    --testnet-magic 1
