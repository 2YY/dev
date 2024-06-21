#!/bin/bash

# 関数: is_ubuntu
# Ubuntuかどうかを判定する
function is_ubuntu() {
  if grep -qi 'ubuntu' /etc/os-release; then
    return 0
  else
    return 1
  fi
}
