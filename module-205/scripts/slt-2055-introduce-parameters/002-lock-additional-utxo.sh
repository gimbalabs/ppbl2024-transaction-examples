#!/bin/bash

. ../env.sh
. ../utils.sh

validator_path=$1
lovelace_to_lock=$2
duration_minutes=$3
admin_pkh=$4
ref=$5

current_posix=$(($(date +%s) * 1000))

posix_duration=$(expr $duration_minutes \* 60 \* 1000)

start_posix_time=$(expr $current_posix \+ 300000)
end_posix_time=$(expr $start_posix_time \+ $posix_duration)

echo "Current time: $current_posix"
echo "Duration: $posix_duration"
echo "Etart time: $start_posix_time"
echo "End time: $end_posix_time"

echo "{
    \"constructor\": 0,
    \"fields\": [
        {
            \"int\": $start_posix_time
        },
        {
            \"int\": $end_posix_time
        }
    ]
}" > claim-window-datum-$ref.json

validator_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file $validator_path)

tx_in=$(get_address_biggest_lovelace ${sender})

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in \
--tx-out $validator_addr+$lovelace_to_lock \
--tx-out-inline-datum-file claim-window-datum-$ref.json \
--change-address $sender \
--out-file lock-tokens-slt2054-$ref.draft

cardano-cli transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file lock-tokens-slt2054-$ref.draft \
--out-file lock-tokens-slt2054-$ref.signed

cardano-cli transaction submit \
--tx-file lock-tokens-slt2054-$ref.signed \
--testnet-magic 1