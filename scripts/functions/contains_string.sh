#!/bin/bash

# 指定したファイルに文字列が含まれているかを判定する関数
# 引数1: 検索する文字列
# 引数2: 検索対象のファイル
function contains_string() {
  local search_string="$1"
  local file="$2"

  # Ripgrepを使用して検索
  if rg -q "$search_string" "$file"; then
    return 0
  else
    return 1
  fi
}
