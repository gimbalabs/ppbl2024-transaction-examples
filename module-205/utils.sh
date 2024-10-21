#!/bin/bash

get_address_biggest_lovelace() {
    cardano-cli query utxo --address $1 --testnet-magic 1 |
        tail -n +3 |
        awk '{printf "%s#%s %s \n", $1 , $2, $3}' |
        sort -rn -k2 |
        head -n1 |
        awk '{print $1}'
}

string-to-tokenName() {
    printf '%s' "$1" | xxd -p
}