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

unlock_time=$(expr $current_posix \+ $posix_duration)

echo "Current time: $current_posix"
echo "Duration: $posix_duration"
echo "Unlock time: $unlock_time"

echo "{
    \"constructor\": 0,
    \"fields\": [
        {
            \"int\": $unlock_time
        },
        {
            \"bytes\": \"$admin_pkh\"
        }
    ]
}" >slt-2056-datum-$ref.json

validator_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file $validator_path)

tx_in=$(get_address_biggest_lovelace ${sender})

cardano-cli conway transaction build \
	--testnet-magic 1 \
	--tx-in $tx_in \
	--tx-out $validator_addr+$lovelace_to_lock \
	--tx-out-inline-datum-file slt-2056-datum-$ref.json \
	--change-address $sender \
	--out-file lock-tokens-slt2056-$ref.draft

cardano-cli conway transaction sign \
	--signing-key-file $sender_key \
	--testnet-magic 1 \
	--tx-body-file lock-tokens-slt2056-$ref.draft \
	--out-file lock-tokens-slt2056-$ref.signed

cardano-cli conway transaction submit \
	--tx-file lock-tokens-slt2056-$ref.signed \
	--testnet-magic 1
