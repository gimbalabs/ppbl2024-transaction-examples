```bash
tx_in_fees=3554d51ba2596a621bf8d17503fdf85310d240d9a1f26b497a41cecfae62b458#1
sender=addr_test1qryqg2zrfyhh8qf2j8tg8zg42grnjanj6kjkwzqlrv0dynqey0knpanmr7ef6k2eagl2j4qdukh7r8zke92p56ah0crquj2ugx
validator_path=my-faucet-script.plutus

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in_fees \
--tx-out $sender+17925290 \
--tx-out-reference-script-file $validator_path \
--change-address $sender \
--out-file deploy-reference-script.draft

cardano-cli transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file deploy-reference-script.draft \
--out-file deploy-reference-script.signed

cardano-cli transaction submit \
--tx-file deploy-reference-script.signed \
--testnet-magic 1
```