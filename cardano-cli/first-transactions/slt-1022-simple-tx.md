# Here is an example of a simple spending transaction from one wallet to another

```bash
tx_in=
receiver=
sender=
sender_key=payment.skey

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in \
--tx-out $receiver+5000000 \
--change-address $sender \
--out-file simple-tx.draft

cardano-cli transaction sign \
--signing-key-file $sender_key \
--testnet-magic 1 \
--tx-body-file simple-tx.draft \
--out-file simple-tx.signed

cardano-cli transaction submit \
--tx-file simple-tx.signed \
--testnet-magic 1
```