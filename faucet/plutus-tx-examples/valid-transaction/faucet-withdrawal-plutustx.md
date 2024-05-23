# Valid Faucet Transaction Example:

### Set Token Asset IDs
```bash
faucet_token_unit=5e74a87d8109db21fe3d407950c161cd2df7975f0868e10682a3dbfe.7070626c323032342d73636166666f6c642d746f6b656e
ppbl_token_unit=903c419ee7ebb6bf4687c61fb133d233ef9db2f80e4d734db3fbaf0b.<YOUR TOKEN NAME>
```

### Prepare Datum
faucet/plutus-tx-examples/datums/valid-faucet-datum.json should look like this:
```json
{
    "constructor": 0,
    "fields": [
        { "int": 1000000 },
        { "bytes": "7070626c323032342d73636166666f6c642d746f6b656e" }
    ]
}
```

### Prepare Redeemer
Get your public key hash:
```bash
cardano-cli address key-hash --payment-verification-key-file payment.vkey
```

Get the name of your PPBL 2024 Token:

For example, in:
```bash
88c75d8946df437963f76b462a65cb1820d5c75e8a04a62cd038ed72e8bae39a     0        1193870 lovelace + 1 903c419ee7ebb6bf4687c61fb133d233ef9db2f80e4d734db3fbaf0b.3232327070626c323032342d64656d6f33 + TxOutDatumNone

```

The token name is: `3232327070626c323032342d64656d6f33`

Add these values to `faucet/plutus-tx-examples/redeemers/valid-faucet-redeemer.json`

```json
{
    "constructor": 0,
    "fields": [
        { "bytes": "YOUR PUBKEY HASH HERE" },
        { "bytes": "YOUR PPBL 2024 TOKEN NAME HERE" }
    ]
}
```

### Query the Faucet Validator:
```bash
faucet_addr=addr_test1wpj47k0wgxqy5qtf9kcvge6xq4y4ua7lvz9dgnc7uuy5ugcz5dr76
cardano-cli query utxo --testnet-magic 1 --address $faucet_addr

# Set variables from result of query
faucet_validator_tx_in=
number_tokens_output= # 1000000 less than current number of tokens
```

### Use Provided Reference UTxO
```bash
ref_utxo=1099aafc99e18e36da5933ff81942519f796c6041f5073d99af05c6965d63704#0
```

### Get UTxOs from Your Wallet
```bash
sender=
sender_key=payment.skey
cardano-cli query utxo --testnet-magic 1 --address $sender

tx_in_ppbl2024=
tx_in_fees=
```



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

cardano-cli transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file deposit-tokens-in-faucet.draft \
--out-file deposit-tokens-in-faucet.signed

cardano-cli transaction submit \
--tx-file deposit-tokens-in-faucet.signed \
--testnet-magic 1
```
