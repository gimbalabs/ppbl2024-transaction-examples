#!/bin/bash

. env.sh
. utils.sh

reference_address=addr_test1qpy5pxpz96h673r9qu592hurf2tw72nx6fn5eytksgf5ghydkhtdsytfajqartg2jpd0p4kt3frs6ga579a05w6hy8nqtvjuqj

cardano-cli query utxo --testnet-magic 1 --address $reference_address