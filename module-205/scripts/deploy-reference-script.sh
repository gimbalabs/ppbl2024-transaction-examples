#!/bin/bash

. env.sh
. utils.sh

validator_path=$1
min_utxo_lovelace=$2

reference_address=addr_test1qpy5pxpz96h673r9qu592hurf2tw72nx6fn5eytksgf5ghydkhtdsytfajqartg2jpd0p4kt3frs6ga579a05w6hy8nqtvjuqj

tx_in_fees=$(get_address_biggest_lovelace ${sender})

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in_fees \
--tx-out $reference_address+$min_utxo_lovelace \
--tx-out-reference-script-file $validator_path \
--change-address $sender \
--out-file deploy-reference-script.draft

cardano-cli transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file deploy-reference-script.draft \
--out-file deploy-reference-script.signed

cardano-cli transaction submit \
--tx-file deploy-reference-script.signed \
--testnet-magic 1
