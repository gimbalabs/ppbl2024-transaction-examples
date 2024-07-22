#!/bin/bash

# A

# Usage ./mint-native-assets-automate-policy-id.sh receiver_addr token_name quantity

# Helpful functions
. utils.sh
. env.sh

# Args
receiver_addr=$1
token_name=$2
tx_in_222_token=$3
tx_in_100_token=$4

# Set variables
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
    --tx-in $tx_in_222_token \
    --tx-in $tx_in_100_token \
    --spending-tx-in-reference df55a5e77507869dd4a3aa6dc4cdaa0a9dcf1aa8d41193d1fe0fd671708e33b9#0 \
    --spending-plutus-script-v2 \
    --spending-reference-tx-in-inline-datum-present \
    --spending-reference-tx-in-redeemer-file update-redeemer.json \
    --tx-out $receiver_addr+"2000000 + 1 $policy_id.$token_hex_222" \
    --tx-out $reference_addr+"2000000 + 1 $policy_id.$token_hex_100" \
    --tx-out-inline-datum-file updated-reference-token-datum.json \
    --tx-in-collateral $tx_in \
    --change-address $sender \
    --out-file mint-native-assets.draft

# # Sign Tx
# cardano-cli transaction sign \
#     --signing-key-file $mint_signing_key_file_path \
#     --signing-key-file $sender_key \
#     --testnet-magic 1 \
#     --tx-body-file mint-native-assets.draft \
#     --out-file mint-native-assets.signed

# # Submit Tx
# cardano-cli transaction submit \
#     --tx-file mint-native-assets.signed \
#     --testnet-magic 1