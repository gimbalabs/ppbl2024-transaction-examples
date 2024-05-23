# Deploy a Reference Script

Here is a simple transaction with one additional, and very powerful detail:

```bash
--tx-out-reference-script-file $validator_path \
```

```bash
tx_in_fees=1099aafc99e18e36da5933ff81942519f796c6041f5073d99af05c6965d63704#1
sender=addr_test1qryqg2zrfyhh8qf2j8tg8zg42grnjanj6kjkwzqlrv0dynqey0knpanmr7ef6k2eagl2j4qdukh7r8zke92p56ah0crquj2ugx
validator_path=aiken-faucet-002.plutus

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in_fees \
--tx-out $sender+4990980 \
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

### Usage:
- After this transaction is confirmed on chain, you can use the `--tx-out` as a reference UTxO.
- [Link to details]() - add lesson link in Andamio