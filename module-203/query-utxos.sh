#!/bin/bash

. env.sh
cardano-cli query utxo --testnet-magic 1 --address $sender
cardano-cli query utxo --testnet-magic 1 --address $(cat ../minting-policy/reference-validator.addr)