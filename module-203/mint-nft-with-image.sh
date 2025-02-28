#!/bin/bash

# Usage ./mint-nft-with-image.sh receiver_addr name

# Helpful functions
. env.sh # See note on Line 14
. utils.sh

# Args
receiver_addr=$1
name=$2
imageUrl=$3
description=$4
quantity=1

# ----------------------------------------------------------------------------------------------------------------------
# ** Set Address and Signing Key **
# Use yours:
# sender=
# sender_key=
# Optionally, create env.sh file with the following:
# export sender=
# export sender_key=
# These values will be sourced with the . env.sh call on Line 6
# ----------------------------------------------------------------------------------------------------------------------

# Automatically create a new policy id
cardano-cli address key-gen --verification-key-file mint-$name.vkey --signing-key-file mint-$name.skey
cardano-cli address key-hash --payment-verification-key-file mint-$name.vkey --out-file mint-$name.pkh

# Set variables
mint_signing_key_file_path=mint-$name.skey
mint_script_file_path=mint-nft-token-$name.script

# Use $name in the minting script. In 15 minutes, it will not longer be possible to mint this token.
echo "{
 \"type\": \"sig\",
 \"keyHash\": \"$(cat mint-$name.pkh)\"
}" >>$mint_script_file_path

# Create Policy ID:
cardano-cli transaction policyid --script-file $mint_script_file_path >>$name.cs
policy_id=$(cat $name.cs)

./write-nft-metadata.sh $policy_id $name $imageUrl $description

# Use get_address_biggest_lovelace from ../utils.sh
# to get the utxo with the most lovelace
tx_in=$(get_address_biggest_lovelace ${sender})

# Convert token name to hex string. In this case, the $name will be the name of the token.
token_hex=$(printf '%s' "$name" | xxd -p)

echo "Minting $name"

# Build Tx
cardano-cli conway transaction build \
  --testnet-magic 1 \
  --tx-in $tx_in \
  --tx-out $receiver_addr+"1500000 + $quantity $policy_id.$token_hex" \
  --mint "$quantity $policy_id.$token_hex" \
  --mint-script-file $mint_script_file_path \
  --metadata-json-file metadata-$name.json \
  --change-address $sender \
  --required-signer $mint_signing_key_file_path \
  --out-file mint-nft.draft

# Sign Tx
cardano-cli conway transaction sign \
  --signing-key-file $mint_signing_key_file_path \
  --signing-key-file $sender_key \
  --testnet-magic 1 \
  --tx-body-file mint-nft.draft \
  --out-file mint-nft.signed

# Submit Tx
cardano-cli conway transaction submit \
  --tx-file mint-nft.signed \
  --testnet-magic 1
