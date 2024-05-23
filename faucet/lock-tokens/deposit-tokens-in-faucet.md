SLT 102.5

### Step 1: Prepare Faucet Datum

Here is the type in PlutusTx
```haskell
data FaucetDatum = FaucetDatum
  { withdrawalAmount :: !Integer,
    faucetTokenName :: !TokenName
  }
```

And here is how the same type is represented on-chain. Create a new file called `faucet-datum.json`, and paste these contents inside:
```json
{
    "constructor": 0,
    "fields": [
        { "int": 1000000 },
        { "bytes": "7070626c323032342d73636166666f6c642d746f6b656e" }
    ]
}
```


### Step 2: Build Transaction
```bash
sender=
sender_key=
tx_in_fees=
tx_in_tokens=
faucet_validator_addr=
quantity=
unit="5e74a87d8109db21fe3d407950c161cd2df7975f0868e10682a3dbfe.7070626c323032342d73636166666f6c642d746f6b656e"

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in_fees \
--tx-in $tx_in_tokens \
--tx-out $faucet_validator_addr+"2000000 + $quantity $unit" \
--tx-out-inline-datum-file faucet-datum.json \
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

### Project for students:
- Deploy a utxo with a different `faucetTokenName` and/or a different `withdrawalAmount`. Share with other students.