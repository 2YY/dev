#!/bin/bash

# 指定したコマンドが存在するかを判定する関数
# 引数1: 判定したいコマンド名
function exists_command() {
  local cmd="$1"

  # command -v を使ってコマンドが存在するかチェック
  if command -v "$cmd" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}
