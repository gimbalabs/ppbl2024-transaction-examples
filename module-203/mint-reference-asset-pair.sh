#!/bin/bash

# A

# Usage ./mint-reference-asset-pair.sh receiver_addr token_name

# Helpful functions
. utils.sh
. env.sh

# Args
receiver_addr=$1
token_name=$2

# Set variables
mint_script_file_path=../minting-policy/mint-aiken-reference-token-pair.script
mint_signing_key_file_path=../minting-policy/mint-aiken-reference-token-pair.skey
policy_id=$(cat ../minting-policy/aiken-reference-token-pair.cs)
reference_addr=$(cat ../minting-policy/reference-validator.addr)

# Use get_address_biggest_lovelace from ../utils.sh
# to get the utxo with the most lovelace
tx_in=$(get_address_biggest_lovelace ${sender})

# Convert token name to hex string
token_hex_100=$(printf '%s' "100$token_name" | xxd -p)
token_hex_222=$(printf '%s' "222$token_name" | xxd -p)

echo "Minting $token_name pair..."

# Build Tx
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 1 \
    --tx-in $tx_in \
    --tx-out $receiver_addr+"2000000 + 1 $policy_id.$token_hex_222" \
    --tx-out $reference_addr+"2000000 + 1 $policy_id.$token_hex_100" \
    --tx-out-inline-datum-file reference-token-datum.json \
    --mint "1 $policy_id.$token_hex_222 + 1 $policy_id.$token_hex_100" \
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
