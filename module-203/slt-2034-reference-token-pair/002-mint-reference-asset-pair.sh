#!/bin/bash

# Usage ./mint-reference-asset-pair.sh receiver_addr token_name

# Helpful functions
. ../utils.sh
. ../env.sh

# Args
receiver_addr=$1
token_name=$2

# Set variables
mint_script_file_path=minting-policy/minting-2034-ref-token.script
mint_signing_key_file_path=minting-policy/minting-2034-ref-token.skey
policy_id=$(cat minting-policy/minting-2034-ref-token.cs)

validator_path=reference-token-pair-aiken.plutus

reference_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file $validator_path)

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
    --out-file mint-reference-token-pair.draft


# Sign Tx
cardano-cli transaction sign \
    --signing-key-file $mint_signing_key_file_path \
    --signing-key-file $sender_key \
    --testnet-magic 1 \
    --tx-body-file mint-reference-token-pair.draft \
    --out-file mint-reference-token-pair.signed

# Submit Tx
cardano-cli transaction submit \
    --tx-file mint-reference-token-pair.signed \
    --testnet-magic 1
