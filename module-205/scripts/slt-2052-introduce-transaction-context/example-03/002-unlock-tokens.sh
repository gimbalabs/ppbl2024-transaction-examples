#!/bin/bash

. ../../env.sh
. ../../utils.sh

slot=$1

ex3_validator_addr=addr_test1wrfnpwc7q449exndnrf436sjljrvcmvd4wkwua4e0s2nhgquu8hy5
ex3_reference_utxo=0a6457a520107ec68d87b2c13f3bff7dfbc549aa55ff9394035dfeaa9df42602#0

sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_tx_in=$(get_address_biggest_lovelace ${ex3_validator_addr})

cardano-cli conway transaction build \
  --testnet-magic 1 \
  --tx-in $sender_tx_in \
  --tx-in-collateral $sender_tx_in \
  --tx-in $validator_tx_in \
  --spending-tx-in-reference $ex3_reference_utxo \
  --spending-plutus-script-v3 \
  --spending-reference-tx-in-inline-datum-present \
  --spending-reference-tx-in-redeemer-file datum.json \
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
