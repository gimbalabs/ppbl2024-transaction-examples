#!/bin/bash

. ../env.sh
. ../utils.sh

lovelace_to_lock=$1
ref=$2
duration_minutes=$3

validator_addr=addr_test1wr7ts2t5e2gc9xalqllh22uleyl8v7n6w8qenee2zwffv4g7jhtlh

tx_in=$(get_address_biggest_lovelace ${sender})

current_posix=$(($(date +%s) * 1000))

posix_duration=$(expr $duration_minutes \* 60 \* 1000)

end_posix_time=$(expr $current_posix \+ $posix_duration)

echo "Current time: $current_posix"
echo "Duration: $posix_duration"
echo "End time: $end_posix_time"

echo "{
    \"constructor\": 0,
    \"fields\": [
        {
            \"int\": $end_posix_time
        }
    ]
}" >datum-$ref.json

cardano-cli conway transaction build \
	--testnet-magic 1 \
	--tx-in $tx_in \
	--tx-out $validator_addr+$lovelace_to_lock \
	--tx-out-inline-datum-file datum-$ref.json \
	--change-address $sender \
	--out-file lock-tokens-and-deploy-validator.draft

cardano-cli conway transaction sign \
	--signing-key-file $sender_key \
	--testnet-magic 1 \
	--tx-body-file lock-tokens-and-deploy-validator.draft \
	--out-file lock-tokens-and-deploy-validator.signed

cardano-cli conway transaction submit \
	--tx-file lock-tokens-and-deploy-validator.signed \
	--testnet-magic 1
