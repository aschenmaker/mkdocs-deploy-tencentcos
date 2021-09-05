#!/bin/bash

set -e

function print_info() {
    echo -e "\e[36mINFO: ${1}\e[m"
}


if [ -n "${INPUT_CONFIG_FILE}" ]; then
    print_info "Setting custom path for mkdocs config yml"
    export CONFIG_FILE="${GITHUB_WORKSPACE}/${INPUT_CONFIG_FILE}"
else
    export CONFIG_FILE="${GITHUB_WORKSPACE}/mkdocs.yml"
fi

REQUIREMENTS="${GITHUB_WORKSPACE}/requirements.txt"
if [ -f "${REQUIREMENTS}" ]; then
    pip install -r "${REQUIREMENTS}"
fi

mkdocs build  --config-file "${CONFIG_FILE}"

UPLOAD_ARGS = "delete -r -f / && upload -r ./site/ /"

if [ -z "$INPUT_SECRET_ID" ]; then
  print_info '::error::Required SecretId parameter'
  exit 1
fi

if [ -z "$INPUT_SECRET_KEY" ]; then
  print_info '::error::Required SecretKey parameter'
  exit 1
fi

if [ -z "$INPUT_BUCKET" ]; then
  print_info '::error::Required Bucket parameter'
  exit 1
fi

if [ -z "$INPUT_REGION" ]; then
  print_info '::error::Required Region parameter'
  exit 1
fi


coscmd config -a $INPUT_SECRET_ID -s $INPUT_SECRET_KEY -b $INPUT_BUCKET -r $INPUT_REGION -m 30

IFS="&&"
arrARGS=($UPLOAD_ARGS)

for each in ${arrARGS[@]}
do
  unset IFS
  each=$(echo ${each} | xargs)
  if [ -n "$each" ]; then
  print_info "Running command: coscmd ${each}"
  coscmd $each
  fi
done

print_info "Commands ran successfully"