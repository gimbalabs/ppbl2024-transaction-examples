# Error Example #1

## Task:
Build an example transaction that fails with the validation error: `"Input must include PPBL 2024 token"`.

## Notes:
- `cardano-cli transaction build` is a helpful utility, because we can build as many transactions as we want to without signing and submitting. It's only at the submit stage that transaction are actually executed on-chain.
- In these examples, our goal is to see specific errors as written in [Faucet.Validator](https://github.com/gimbalabs/ppbl2024-plutus-examples/blob/f674596625d32fda7391e994ec838e60ec2c4846/src/Faucet/Validator.hs#L81C20-L81C56). Including these error messages make a script larger and more expensive to execute, so often in production code, errors are removed. For our purposes, we are working on testnet and our goal is to learn (more than it is to save on tx fees!)

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

What happens if we do not include the `tx_in_ppbl2024` and the corresponding output, like this:

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
```

## Challenge:
Q: What are some other ways to get the `Input must include PPBL 2024 token` error?
(A: Try changing the redeemer)