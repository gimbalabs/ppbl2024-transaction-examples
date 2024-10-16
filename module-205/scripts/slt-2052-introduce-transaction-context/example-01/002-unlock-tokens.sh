#!/bin/bash

. ../../env.sh
. ../../utils.sh

slot=$1

ex1_validator_addr=addr_test1wq6k0e945l0t75kqjkduxa44v4u788vqkuv7899fj3meeesv8jtyl
ex1_reference_utxo=bc20743f10262b0a5e0ba949f54a4cd79d18ddd05c9c4eca9f4fb11a313258c9#0

ex2_validator_addr=0
ex2_reference_utxo=0

ex3_validator_addr=0
ex3_reference_utxo=0

sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_tx_in=$(get_address_biggest_lovelace ${ex1_validator_addr})

cardano-cli conway transaction build \
  --testnet-magic 1 \
  --tx-in $sender_tx_in \
  --tx-in-collateral $sender_tx_in \
  --tx-in $validator_tx_in \
  --spending-tx-in-reference $ex1_reference_utxo \
  --spending-plutus-script-v3 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-value 1337 \
  --invalid-before $slot \
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
