#!/bin/bash


if command -v pveversion >/dev/null 2>&1; then
  echo -e "⚠️  Can't Install on Proxmox "
  exit
fi

header_info

