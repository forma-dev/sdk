#!/bin/sh


SKIPS=(
  "SimpleERC1155.sol"
  "Types.sol"
)

yarn clean
yarn build
yarn build:ts

mkdir ./abi

for file in $(find ./contracts -name "*.sol")
do
  if [[ " ${SKIPS[@]} " =~ " $(basename $file) " ]]; then
    continue
  fi
  cp ./out/$(basename $file)/$(basename $file .sol).json ./abi/$(basename $file .sol).json
done
