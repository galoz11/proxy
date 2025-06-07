#!/bin/bash

function header_info {
echo  
echo -e "  ${DGN}${APP}${CL}"
echo  
}

APP="Coder Code Server"
hostname="$(hostname)"
IP=$(hostname -I | awk '{print $1}')
YW=$(echo "\033[33m")
BL=$(echo "\033[36m")
RD=$(echo "\033[01;31m")
BGN=$(echo "\033[4;92m")
GN=$(echo "\033[1;92m")
DGN=$(echo "\033[32m")
CL=$(echo "\033[m")
# print overwrite message
BFR="\\r\\033[K"
HOLD="-"
CM="${GN}✓${CL}"

# show header info
header_info
# Can't Install on Proxmox or Alpine
if command -v pveversion >/dev/null 2>&1; then
  echo -e "   Can't Install on Proxmox "
  exit
fi
if [ -e /etc/alpine-release ]; then
  echo -e "   Can't Install on Alpine"
  exit
fi
while true; do
  read -p "This will Install ${APP} on $hostname. Proceed(y/n)?" yn
  case $yn in
  [Yy]*) break ;;
  [Nn]*) exit ;;
  *) echo "Please answer yes or no." ;;
  esac
done

echo -e "${BL}Ready yo install ${APP} on $hostname${CL}"
echo bye

