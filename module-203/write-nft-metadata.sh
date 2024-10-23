#!/bin/bash

. utils.sh

policyid=$1
assetName=$2
imageUrl=$3
description=$4

imageUrlArray=$(split_string $imageUrl)
echo $imageUrlArray

descriptionArray=$(split_string "$description")

echo "
{
  \"721\": {
    \"$policyid\": {
      \"$assetName\": {
        \"name\": \"$assetName\",
        \"image\": [$imageUrlArray], 
        \"mediaType\": \"img/png\",
        \"description\": [$descriptionArray],
        \"files\": [
          {
            \"mediaType\": \"img/png\",
            \"src\": [$imageUrlArray]
          }
        ]
      }
    }
  }
}
" >metadata-$assetName.json

