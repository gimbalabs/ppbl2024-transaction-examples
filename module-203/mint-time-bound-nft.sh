#!/bin/bash

# Usage ./mint-time-bound-nft.sh receiver_addr

# Helpful functions
. env.sh # See note on Line 14
. utils.sh

# Args
receiver_addr=$1
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

# ----------------------------------------------------------------------------------------------------------------------
# ** Calculate Slot **
# You will need to have jq installed to use this line:
currentSlot=$(echo $(cardano-cli query tip --testnet-magic 1) | jq '.slot')
# Learn about jq + install it: https://jqlang.github.io/jq/
# Or, hard code the currentSlot into this file by un-commenting this line:
# currentSlot=
# ----------------------------------------------------------------------------------------------------------------------
echo "The current slot is: $currentSlot"

# Add 15 minutes (900 seconds) to $currentSlot to get minting deadline
deadlineSlot=$(expr $currentSlot + 900)
echo "The deadline slot is $deadlineSlot"

# Create a new directory named by $deadlineSlot
mkdir $deadlineSlot
cd $deadlineSlot

# Automatically create a new policy id
cardano-cli address key-gen --verification-key-file mint-$deadlineSlot.vkey --signing-key-file mint-$deadlineSlot.skey
cardano-cli address key-hash --payment-verification-key-file mint-$deadlineSlot.vkey --out-file mint-$deadlineSlot.pkh

# Set variables
mint_signing_key_file_path=mint-$deadlineSlot.skey
mint_script_file_path=mint-timebound-token-$deadlineSlot.script

# Use $deadlineSlot in the minting script. In 15 minutes, it will not longer be possible to mint this token.
echo "{
  \"type\": \"all\",
  \"scripts\": [
    {
      \"type\": \"before\",
      \"slot\": $deadlineSlot
    },
    {
      \"type\": \"sig\",
      \"keyHash\": \"$(cat mint-$deadlineSlot.pkh)\"
    }
  ]
}" >>$mint_script_file_path

# Create Policy ID:
cardano-cli transaction policyid --script-file $mint_script_file_path >>$deadlineSlot.cs
policy_id=$(cat $deadlineSlot.cs)

# Use get_address_biggest_lovelace from ../utils.sh
# to get the utxo with the most lovelace
tx_in=$(get_address_biggest_lovelace ${sender})

# Convert token name to hex string. In this case, the $deadlineSlot will be the name of the token.
token_hex=$(printf '%s' "$deadlineSlot" | xxd -p)

echo "Minting $deadlineSlot"

# Build Tx
cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 1 \
  --tx-in $tx_in \
  --tx-out $receiver_addr+"1500000 + $quantity $policy_id.$token_hex" \
  --mint "$quantity $policy_id.$token_hex" \
  --mint-script-file $mint_script_file_path \
  --invalid-hereafter $deadlineSlot \
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

