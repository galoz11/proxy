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
# ----------------------installing---------------------------------
echo "Installing Dependencies"
apt update &>/dev/null
apt install -y curl &>/dev/null
apt install -y git &>/dev/null
echo "Installed Dependencies"

VERSION=$(curl -fsSL https://api.github.com/repos/coder/code-server/releases/latest |
  grep "tag_name" |
  awk '{print substr($2, 3, length($2)-4) }')

echo "Installing Code-Server v${VERSION}"
curl -fOL https://github.com/coder/code-server/releases/download/v"$VERSION"/code-server_"${VERSION}"_amd64.deb &>/dev/null
dpkg -i code-server_"${VERSION}"_amd64.deb &>/dev/null
rm -rf code-server_"${VERSION}"_amd64.deb
mkdir -p ~/.config/code-server/
systemctl enable -q --now code-server@"$USER"
cat <<EOF >~/.config/code-server/config.yaml
bind-addr: 0.0.0.0:8680
auth: none
password: 
cert: false
EOF
systemctl restart code-server@"$USER"
echo "Installed Code-Server v${VERSION} on $hostname"

echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://$IP:8680${CL} \n"
