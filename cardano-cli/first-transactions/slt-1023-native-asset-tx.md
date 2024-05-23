SLT 102.3

# How to Include Native Assets in a Cardano Transaction
### Prerequisite:
Send some Scaffold Tokens and your PPBL 2024 Token from your browser wallet to the address you just built with `cardano-cli`.

Your wallet should include some number of scaffold tokens. In this case, it's 5000:
```bash
ppbl-2024-cli-wallet $ cardano-cli query utxo --testnet-magic 1 --address $(cat payment.addr)
                           TxHash                                 TxIx        Amount
--------------------------------------------------------------------------------------
14bccae0db2169d1c088a0e04c1cb18e1a0f8fe7e10792f0dfa82e3a605c8cdf     0        1228350 lovelace + 5000 5e74a87d8109db21fe3d407950c161cd2df7975f0868e10682a3dbfe.7070626c323032342d73636166666f6c642d746f6b656e + TxOutDatumNone
88c75d8946df437963f76b462a65cb1820d5c75e8a04a62cd038ed72e8bae39a     0        1193870 lovelace + 1 903c419ee7ebb6bf4687c61fb133d233ef9db2f80e4d734db3fbaf0b.3232327070626c323032342d64656d6f33 + TxOutDatumNone
f3d0125ea6bda66d5be8cdb2abc6c23d2d31a1511f018eccd798c42ba0312fdd     0        250000000 lovelace + TxOutDatumNone
```

### Sending 12 Scaffold Token
Or:
- change the 12 to any number
- change the "Asset ID" from `5e74a87d8109db21fe3d407950c161cd2df7975f0868e10682a3dbfe.7070626c323032342d73636166666f6c642d746f6b656e` to another.

```bash
tx_in=f3d0125ea6bda66d5be8cdb2abc6c23d2d31a1511f018eccd798c42ba0312fdd#0
tx_in_tokens=14bccae0db2169d1c088a0e04c1cb18e1a0f8fe7e10792f0dfa82e3a605c8cdf#0
asset_id="5e74a87d8109db21fe3d407950c161cd2df7975f0868e10682a3dbfe.7070626c323032342d73636166666f6c642d746f6b656e"
receiver=
sender=
sender_key=payment.skey

cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in \
--tx-in $tx_in_tokens \
--tx-out $receiver+"2000000 + 12 $asset_id" \
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

## Errors to Try:
1. Do not include `$tx_in_tokens`:
```bash
cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in \
--tx-out $receiver+"2000000 + 12 $asset_id" \
--change-address $sender \
--out-file simple-tx.draft
```
2. Send too many tokens:
```bash
cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $tx_in \
--tx-in $tx_in_tokens \
--tx-out $receiver+"2000000 + 5001 $asset_id" \
--change-address $sender \
--out-file simple-tx.draft
```