#!/bin/bash

. env.sh

cardano-cli conway transaction build \
	--tx-in 01eb2661a34457852902edd0e0f7613f0d411994168fb015f249707117428a5f#0 \
	--tx-in 0a6457a520107ec68d87b2c13f3bff7dfbc549aa55ff9394035dfeaa9df42602#0 \
	--tx-in 0f7405ebc9d8be81abb3337e4f9ed2619956631faeced869f65f0a16ecacc6b6#1 \
	--tx-in 4cbe6fd16e515ff8da30a50ae9909f3524b3ba570cf8d19ebe6ab83b93ce2690#0 \
	--tx-in 4f5d6bf40f82225f36b2dadc3b0368e37ee334a0a6c2e770643d2681601dbad2#1 \
	--tx-in 59bb6b0f541bde278c8c933c183fedb115882ae432904414321f4a7e9966de33#0 \
	--tx-in 6e60fd768529089f001a30d4b43b373c52240e92a5ff05cb5a171a0ad57db783#0 \
	--tx-in 75aad1789aa5b29142ca623492a0b06dbe568c8007a384446def89bb0385d6a6#0 \
	--tx-in 794cb4788d09989798ee8f41ec6175b3f9a2ef082ec44971c927246ab73482bb#0 \
	--tx-in aadfe74b13cd0001d067d02467788e618106459f96bf53c96f3a2da03b0f1b72#0 \
	--tx-in b5e5347ad28203f5b961a6d9e2040decf7aa8a240b40c1ac7d7923fecf13697e#0 \
	--tx-in b60756502eaa7ea2bb994cc13b67cb851da307063bab11ab8beaf6da89be661b#0 \
	--tx-in bc20743f10262b0a5e0ba949f54a4cd79d18ddd05c9c4eca9f4fb11a313258c9#0 \
	--tx-in bf531db00ecf67e377c51d1ee9999bd7890191b81e76e797503d055f42cbd678#1 \
	--tx-in e62ffce45c6f5d0141ca1a9ee6db38545bf63154ffdd774f75213cccd5e69fe5#1 \
	--change-address $sender \
	--testnet-magic 1 \
	--out-file remove-reference-scripts.draft

cardano-cli conway transaction sign \
	--signing-key-file $reference_scripts_skey \
	--testnet-magic 1 \
	--tx-body-file remove-reference-scripts.draft \
	--out-file remove-reference-scripts.signed

cardano-cli conway transaction submit \
	--tx-file remove-reference-scripts.signed \
	--testnet-magic 1
