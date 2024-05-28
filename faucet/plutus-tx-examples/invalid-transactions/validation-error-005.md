# Error Example #5

## Task:
Build an example transaction that fails with the validation error: `"Cannot change datum"`.

## Note:
This error is easy to recreate. The question (perhaps for live coding) is, why do we need it?

## Example

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

What happens if we use datum that does not match the current datum on-chain? Use `invalid-faucet-datum.json` as example.

```bash
cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in_fees \
--tx-in $tx_in_ppbl2024 \
--tx-in-collateral $tx_in_fees \
--tx-in $faucet_validator_tx_in \
--spending-tx-in-reference $ref_utxo \
--spending-plutus-script-v2 \
--spending-reference-tx-in-inline-datum-present \
--spending-reference-tx-in-redeemer-file valid-faucet-redeemer.json \
--tx-out $sender+"2000000 + 1000000 $faucet_token_unit" \
--tx-out $sender+"2000000 + 1 $ppbl_token_unit" \
--tx-out $faucet_addr+"2000000 + $number_tokens_output $faucet_token_unit" \
--tx-out-inline-datum-file invalid-faucet-datum.json \
--change-address $sender \
--out-file deposit-tokens-in-faucet.draft
```

## Discussion Question
Why do we need this?