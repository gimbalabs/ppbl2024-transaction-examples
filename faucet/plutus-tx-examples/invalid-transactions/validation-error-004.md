# Error Example #4

## Task:
Build an example transaction that fails with the validation error: `"Must return remaining faucet tokens to contract address"`.

## Note:
This error is related to Error Example #3. We can try several ways to send too many or too few tokens from the faucet. It's actually challenge to get this error precisely - but it can be done! Might be neat to make this a live coding exercise or to leave it as a challenge?

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

Hint: how might we use another address to help get this particular error?

```bash
different_address=
```

Start with a valid transaction - what should we change?

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
--tx-out-inline-datum-file valid-faucet-datum.json \
--change-address $sender \
--out-file deposit-tokens-in-faucet.draft
```
