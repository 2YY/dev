#!/bin/bash

# Ubuntuかどうかを判定する
function is_ubuntu() {
  if [ -f /etc/os-release ] && grep -qi 'ubuntu' /etc/os-release; then
    return 0
  else
    return 1
  fi
}
