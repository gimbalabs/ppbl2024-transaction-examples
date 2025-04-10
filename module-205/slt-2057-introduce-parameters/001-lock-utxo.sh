#!/bin/bash

. ../env.sh
. ../utils.sh

lovelace_to_lock=$1
duration_minutes=$2
ref=$3

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
        }
    ]
}" >slt2057-datum-$ref.json

validator_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file slt2057.plutus)

tx_in=$(get_address_biggest_lovelace ${sender})

cardano-cli conway transaction build \
	--testnet-magic 1 \
	--tx-in $tx_in \
	--tx-out $validator_addr+$lovelace_to_lock \
	--tx-out-inline-datum-file slt2057-datum-$ref.json \
	--change-address $sender \
	--out-file lock-tokens-slt2057-$ref.draft

cardano-cli conway transaction sign \
	--signing-key-file $sender_key \
	--testnet-magic 1 \
	--tx-body-file lock-tokens-slt2057-$ref.draft \
	--out-file lock-tokens-slt2057-$ref.signed

cardano-cli conway transaction submit \
	--tx-file lock-tokens-slt2057-$ref.signed \
	--testnet-magic 1
