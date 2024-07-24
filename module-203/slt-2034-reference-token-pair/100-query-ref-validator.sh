#!/bin/bash

validator_path=reference-token-pair-aiken.plutus

validator_addr=$(cardano-cli address build --testnet-magic 1 --payment-script-file $validator_path)

echo $validator_addr

echo ""
echo ""

cardano-cli query utxo --testnet-magic 1 --address $validator_addr