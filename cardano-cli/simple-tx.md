# Here is an example of a simple spending transaction from one wallet to another

```bash
tx_in=bc7c99a49cd0b498c885d7ed7cfbfd6f8657c8709b4df3b731d46a37655f003b#1
receiver=addr_test1qpp88dxk9vtlcernf9ypup5prfkg0fryvt9ysljedpgz2t45hddez4eu2p3fefc0888e4wtswsrfurjtepuemwpl8h2qcfz9ew
sender=addr_test1qryqg2zrfyhh8qf2j8tg8zg42grnjanj6kjkwzqlrv0dynqey0knpanmr7ef6k2eagl2j4qdukh7r8zke92p56ah0crquj2ugx
sender_key=payment.skey

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in \
--tx-out $receiver+25000000 \
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