tx_in=60736e02e8113a6939490628f92bdcff7a3375a7f0ecc5837241559362a5830b#1
sender=addr_test1qrm2py5drdq6p7xxh444jnks09d44qtfcuvzrts23n9klhkeqn5l8a5zqdvx4zafffqy2hn7r6grra5y8rx3gjqgttzqhwxky0
receiver_addr=addr_test1qrm2py5drdq6p7xxh444jnks09d44qtfcuvzrts23n9klhkeqn5l8a5zqdvx4zafffqy2hn7r6grra5y8rx3gjqgttzqhwxky0
quantity=1
policy_id=19bdeaeaef1ce1a8ab4d0a6cc3235ce8aef754ce5ee0bc3015884c56
token_hex=34343434
mint_script_file_path=mint-timebound-token-66669605.script
deadlineSlot=66669605
mint_signing_key_file_path=mint-66669605.skey

cardano-cli transaction build \
  --babbage-era \
  --testnet-magic 1 \
  --tx-in $tx_in \
  --tx-out $receiver_addr+"1500000 + $quantity $policy_id.$token_hex" \
  --mint "$quantity $policy_id.$token_hex" \
  --mint-script-file $mint_script_file_path \
  --invalid-hereafter 66669700 \
  --change-address $sender \
  --required-signer $mint_signing_key_file_path \
  --out-file mint-native-assets.draft


  cardano-cli transaction sign \
  --signing-key-file $mint_signing_key_file_path \
  --signing-key-file $sender_key \
  --testnet-magic 1 \
  --tx-body-file mint-native-assets.draft \
  --out-file mint-native-assets.signed

  cardano-cli transaction submit \
  --tx-file mint-native-assets.signed \
  --testnet-magic 1
