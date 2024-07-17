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
sender=addr_test1qrm2py5drdq6p7xxh444jnks09d44qtfcuvzrts23n9klhkeqn5l8a5zqdvx4zafffqy2hn7r6grra5y8rx3gjqgttzqhwxky0
sender_key=/home/james/hd2/01-projects/ppbl2024/ppbl2024-transaction-examples/wallets/payment.skey


if [ -e "mint-secret-number.cs" ]; then
    rm mint-secret-number.cs
fi

cardano-cli transaction policyid --script-file mint-secret-number.plutus >> mint-secret-number.cs

# Set variables
mint_script_file_path=mint-secret-number.plutus
policy_id=$(cat mint-secret-number.cs)

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
    --tx-in-collateral $tx_in \
    --tx-out $receiver_addr+"1500000 + $quantity $policy_id.$token_hex" \
    --mint "$quantity $policy_id.$token_hex" \
    --mint-script-file $mint_script_file_path \
    --mint-redeemer-value 1618033988 \
    --change-address $sender \
    --out-file mint-native-assets.draft

# Sign Tx
cardano-cli transaction sign \
    --signing-key-file $sender_key \
    --testnet-magic 1 \
    --tx-body-file mint-native-assets.draft \
    --out-file mint-native-assets.signed

# Submit Tx
cardano-cli transaction submit \
    --tx-file mint-native-assets.signed \
    --testnet-magic 1
