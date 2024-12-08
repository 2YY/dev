#!/bin/bash

source scripts/functions/error.sh
source scripts/functions/file_exists.sh

if [ -z "$1" ]; then
    error "パッケージ名が指定されていません。"
fi

PACKAGE_SCRIPT="scripts/packages/$1.sh"
file_exists "$PACKAGE_SCRIPT"

bash "$PACKAGE_SCRIPT"
