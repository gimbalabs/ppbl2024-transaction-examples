# Lesson 202.2
## Minting Native Assets with Cardano CLI

## Step 1: Make Keys
```bash
cardano-cli address key-gen --verification-key-file minting.vkey --signing-key-file minting.skey
cardano-cli address key-hash --payment-verification-key-file minting.vkey
```

## Step 2: Create Policy Id
```bash
touch my-token-policy.script
```

Add these contents to `my-token-policy.script`, replacing the `keyHash` with the one you created in step 1.
```json
{
    "keyHash": "0f2114964f9cfe40dfcb69237e3bee68a344d8e395b62d9cae677a6d",
    "type": "sig"
}
```

Finally, generate a token Policy ID from this new script:
```bash
cardano-cli transaction policyid --script-file my-token-policy.script
```


## Minting Transaction
```bash
tx_in=c279890452a2bf507be24630aa50d6d60952c1862e56abe907e33a3188d6bbdb#0
receiver=addr_test1qrzv26r3vadrgs7pq3qnhtde3m8adpnj46rhlqw76plt9dm4zsuhgkmr7qez5qj58jk6gkq8pgz0npcv33qvc7zresas9c3z8l
quantity=2024000000
policy_id=5e74a87d8109db21fe3d407950c161cd2df7975f0868e10682a3dbfe
token_hex=7070626c323032342d73636166666f6c642d746f6b656e
mint_script_file_path=my-token-policy.script
sender=addr_test1qryqg2zrfyhh8qf2j8tg8zg42grnjanj6kjkwzqlrv0dynqey0knpanmr7ef6k2eagl2j4qdukh7r8zke92p56ah0crquj2ugx

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in \
--tx-out $receiver+"1500000 + $quantity $policy_id.$token_hex" \
--mint "$quantity $policy_id.$token_hex" \
--mint-script-file $mint_script_file_path \
--metadata-json-file token-metadata.json \
--change-address $sender \
--required-signer minting.skey \
--out-file mint-native-assets.draft

cardano-cli transaction sign \
--signing-key-file minting.skey \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file mint-native-assets.draft \
--out-file mint-native-assets.signed

cardano-cli transaction submit \
--tx-file mint-native-assets.signed \
--testnet-magic 1
```