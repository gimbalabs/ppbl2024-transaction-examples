### Valid Transaction Example:

```bash
tx_in_ppbl2024=21644e01dc5abb1b9c6888dfa2075ce336d87c576a9518f94506ccff4de4721a#0
tx_in_fees=6ebc45104c8077ed075886fd52c2416fbec7a39cee01e9c0d7129647c94ee3c8#0
faucet_validator_tx_in=209705dabcf2c6222fe44e169b567e62303426d85f05ee8f86bdd0e5b2dc50e3#0
faucet_addr=addr_test1wpj47k0wgxqy5qtf9kcvge6xq4y4ua7lvz9dgnc7uuy5ugcz5dr76
ref_utxo=1099aafc99e18e36da5933ff81942519f796c6041f5073d99af05c6965d63704#0
quantity=1008000000
unit=5e74a87d8109db21fe3d407950c161cd2df7975f0868e10682a3dbfe.7070626c323032342d73636166666f6c642d746f6b656e
sender=addr_test1qryqg2zrfyhh8qf2j8tg8zg42grnjanj6kjkwzqlrv0dynqey0knpanmr7ef6k2eagl2j4qdukh7r8zke92p56ah0crquj2ugx
ppbl_token_unit=903c419ee7ebb6bf4687c61fb133d233ef9db2f80e4d734db3fbaf0b.3232327070626c323032342d747474

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
--spending-reference-tx-in-redeemer-file ../redeemers/faucet-redeemer-correct.json \
--tx-out $sender+"2000000 + 1000000 $unit" \
--tx-out $sender+"2000000 + 1 $ppbl_token_unit" \
--tx-out $faucet_addr+"2000000 + $quantity $unit" \
--tx-out-inline-datum-file ../datums/faucet-datum-plutustx.json \
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


## Invalid Transactions
