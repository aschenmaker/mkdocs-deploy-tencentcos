#!/bin/bash

set -e

function print_info() {
    echo -e "\e[36mINFO: ${1}\e[m"
}


if [ -n "${CONFIG_FILE}" ]; then
    print_info "Setting custom path for mkdocs config yml"
    export CONFIG_FILE="${GITHUB_WORKSPACE}/${CONFIG_FILE}"
else
    export CONFIG_FILE="${GITHUB_WORKSPACE}/mkdocs.yml"
fi

REQUIREMENTS="${GITHUB_WORKSPACE}/requirements.txt"
if [ -f "${REQUIREMENTS}" ]; then
    pip install -r "${REQUIREMENTS}"
fi

mkdocs build  --config-file "${CONFIG_FILE}"

if [ -z "$SECRET_ID" ]; then
  print_info '::error::Required SecretId parameter'
  exit 1
fi

if [ -z "$SECRET_KEY" ]; then
  print_info '::error::Required SecretKey parameter'
  exit 1
fi

if [ -z "$BUCKET" ]; then
  print_info '::error::Required Bucket parameter'
  exit 1
fi

if [ -z "$REGION" ]; then
  print_info '::error::Required Region parameter'
  exit 1
fi

coscmd config -a "$SECRET_ID" -s "$SECRET_KEY" -b "$BUCKET" -r "$REGION" -m 30

print_info "Running command: coscmd upload -r ${GITHUB_WORKSPACE}/site/ /"
coscmd upload -r "${GITHUB_WORKSPACE}"/site/ /


print_info "Commands ran successfully"