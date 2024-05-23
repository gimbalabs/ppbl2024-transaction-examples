# Error Example #1


```bash
faucet_token_unit=
ppbl_token_unit=
faucet_validator_tx_in=
number_tokens_input=
number_tokens_output=
ref_utxo=
sender=
sender_key=
tx_in_ppbl2024=
tx_in_fees=
```

What happens if we do not include the `tx_in_ppbl2024` and the output, like this:

```bash
cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in_fees \
--tx-in-collateral $tx_in_fees \
--tx-in $faucet_validator_tx_in \
--spending-tx-in-reference $ref_utxo \
--spending-plutus-script-v2 \
--spending-reference-tx-in-inline-datum-present \
--spending-reference-tx-in-redeemer-file valid-faucet-redeemer.json \
--tx-out $sender+"2000000 + 1000000 $faucet_token_unit" \
--tx-out $faucet_addr+"2000000 + $number_tokens_output $faucet_token_unit" \
--tx-out-inline-datum-file valid-faucet-datum.json \
--change-address $sender \
--out-file deposit-tokens-in-faucet.draft

cardano-cli transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file deposit-tokens-in-faucet.draft \
--out-file deposit-tokens-in-faucet.signed

cardano-cli transaction submit \
--tx-file deposit-tokens-in-faucet.signed \
--testnet-magic 1
```

## Challenge:
Q: What are some other ways to get the `Input must include PPBL 2024 token` error?
(A: Try changing the redeemer)