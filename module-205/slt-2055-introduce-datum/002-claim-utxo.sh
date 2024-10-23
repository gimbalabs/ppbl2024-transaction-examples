#!/bin/bash

. ../env.sh
. ../utils.sh

start_slot=$1
end_slot=$(expr $start_slot + 1200)

validator_addr=addr_test1wqw9veqvlh9j7f7ea9cptefrnvp4rqcs0hfvuqnpzr93f6cqnyum4
reference_utxo=6e60fd768529089f001a30d4b43b373c52240e92a5ff05cb5a171a0ad57db783#0
sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_tx_in=$(get_address_biggest_lovelace ${validator_addr})

cardano-cli conway transaction build \
  --testnet-magic 1 \
  --tx-in $sender_tx_in \
  --tx-in-collateral $sender_tx_in \
  --tx-in $validator_tx_in \
  --spending-tx-in-reference $reference_utxo \
  --spending-plutus-script-v3 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file redeemer.json \
  --invalid-before $start_slot \
  --invalid-hereafter $end_slot \
  --change-address $sender \
  --out-file unlock-tokens.draft

cardano-cli conway transaction sign \
  --signing-key-file $sender_key \
  --testnet-magic 1 \
  --tx-body-file unlock-tokens.draft \
  --out-file unlock-tokens.signed

cardano-cli conway transaction submit \
  --tx-file unlock-tokens.signed \
  --testnet-magic 1
