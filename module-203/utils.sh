#!/bin/bash

get_address_biggest_lovelace() {
  cardano-cli query utxo --address $1 --testnet-magic 1 |
    tail -n +3 |
    awk '{printf "%s#%s %s \n", $1 , $2, $3}' |
    sort -rn -k2 |
    head -n1 |
    awk '{print $1}'
}

string-to-tokenName() {
  printf '%s' "$1" | xxd -p
}

split_string() {
  varString=$1
  maxLength=56

  if [ ${#varString} -le $maxLength ]; then
    echo \"$varString\"
  else
    declare -a stringArray
    while [ ${#varString} -gt 0 ]; do
      stringArray+=("${varString:0:$maxLength}")
      varString="${varString:$maxLength}"
    done

    for ((i = 0; i < ${#stringArray[@]}; i++)); do
      if [ $i -lt $((${#stringArray[@]} - 1)) ]; then
        echo -n "\"${stringArray[$i]}\","
      else
        echo "\"${stringArray[$i]}\""
      fi
    done
  fi
}
