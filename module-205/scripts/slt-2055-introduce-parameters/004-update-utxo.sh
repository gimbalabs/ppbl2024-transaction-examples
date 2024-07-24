#!/bin/bash

. ../env.sh
. ../utils.sh

ref=$1

reference_utxo=e62ffce45c6f5d0141ca1a9ee6db38545bf63154ffdd774f75213cccd5e69fe5#1

sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file introduce-redeemer-aiken.plutus)
validator_tx_in=$(get_address_biggest_lovelace ${validator_addr})

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $sender_tx_in \
--tx-in-collateral $sender_tx_in \
--tx-in $validator_tx_in \
--spending-tx-in-reference $reference_utxo \
--spending-plutus-script-v2 \
--spending-reference-tx-in-inline-datum-present \
--spending-reference-tx-in-redeemer-file Update.json \
--change-address $sender \
--required-signer $sender_key \
--out-file unlock-tokens.draft

cardano-cli transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file unlock-tokens.draft \
--out-file unlock-tokens.signed

cardano-cli transaction submit \
--tx-file unlock-tokens.signed \
--testnet-magic 1