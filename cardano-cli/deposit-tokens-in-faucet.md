

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
sender_key=""
tx_in_fees=e56f91066154467b5c636801a81c0f3787ccab708d875d852bdd8b7493921dd8#1
tx_in_tokens=e13dc0058c02df2157d9eb125adcd1777bd696ef145f3dbb9a855321e2b68e99#0
faucet_validator_addr=addr_test1wpj47k0wgxqy5qtf9kcvge6xq4y4ua7lvz9dgnc7uuy5ugcz5dr76
quantity="1024000000"
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