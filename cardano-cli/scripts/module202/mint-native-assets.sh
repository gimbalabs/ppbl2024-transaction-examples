#!/bin/bash

# A

# Usage ./mint-native-assets.sh receiver_addr token_name quantity

# Helpful functions
. ../utils.sh

# Args
receiver_addr=$1
token_name=$2
quantity=$3

# Use yours
sender=
sender_key=

# Change these
# See Lesson 202.2 (https://www.andamio.io/course/ppbl2024/202/lesson/2)
policy_id=
mint_script_file_path=
mint_signing_key_file_path=

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
