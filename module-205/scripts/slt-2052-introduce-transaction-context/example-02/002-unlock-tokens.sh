#!/bin/bash

. ../../env.sh
. ../../utils.sh

slot=$1

ex2_validator_addr=addr_test1wr7xdtlcvsfhvspptnfrwkmvexh3kwv069pzhmk3fvhvj4q575evy
ex2_reference_utxo=b5e5347ad28203f5b961a6d9e2040decf7aa8a240b40c1ac7d7923fecf13697e#0

sender_tx_in=$(get_address_biggest_lovelace ${sender})

validator_tx_in=$(get_address_biggest_lovelace ${ex2_validator_addr})

cardano-cli conway transaction build \
  --testnet-magic 1 \
  --tx-in $sender_tx_in \
  --tx-in-collateral $sender_tx_in \
  --tx-in $validator_tx_in \
  --spending-tx-in-reference $ex2_reference_utxo \
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
