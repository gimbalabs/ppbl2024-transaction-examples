

### Faucet Datum

Here is the type in PlutusTx
```haskell
data FaucetDatum = FaucetDatum
  { withdrawalAmount :: !Integer,
    faucetTokenName :: !TokenName
  }
```

And here is how the same type is represented on-chain:
```json
{
    "constructor": 0,
    "fields": [
        { "int": 1000000 },
        { "bytes": "7070626c323032342d73636166666f6c642d746f6b656e" }
    ]
}
```

Create a new file called `faucet-datum.json`, and paste these contents inside.

### Build Transaction
```bash
sender=addr_test1qryqg2zrfyhh8qf2j8tg8zg42grnjanj6kjkwzqlrv0dynqey0knpanmr7ef6k2eagl2j4qdukh7r8zke92p56ah0crquj2ugx
tx_in_fees=bc7c99a49cd0b498c885d7ed7cfbfd6f8657c8709b4df3b731d46a37655f003b#0
tx_in_tokens=db467527b6b2c25def691eea28eb95bf51e87989a50fad26d242c8a46bad02af#1
faucet_validator_addr=addr_test1wpp780qmzd99t7pykafxu3545pzxgvjj5c4echey470ad4qlsnscq
quantity="2000"
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