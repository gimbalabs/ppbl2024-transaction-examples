#!/bin/bash

. ../env.sh
. ../utils.sh

start_slot=$1
end_slot=$(expr $start_slot + 1200)

validator_addr=addr_test1wp68tpl58h0nc4nctluhz4j8ypjqetpcrnly9ss6mn0zxgqg6sw6s
reference_utxo=e1e15d2a348537350c4dcfbf6e5220468b81d80c2a5e32dcb058411e1c4e4bc2#0
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
