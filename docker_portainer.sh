#!/bin/bash
function header_info {
echo  
echo -e "  ${DGN}${APP}${CL}"
echo  
}

APP="Docker and Portainer"
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
CN="${RD}✗${CL}"

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
  [Nn]*) kill -INT $$ ;;
  *) echo "Please answer yes or no." ;;
  esac
done
# ----------------------installing---------------------------------
echo "Installing updates"
apt update &>/dev/null
echo "Installed updates"

if command -v docker &> /dev/null; then
  echo -e "${CM} Docker is installed"
else
  echo -e "${CN} Docker is not installed"
  apt-get install docker.io -y &>/dev/null
  echo -e "${CM} Docker is installed"
fi


CONTAINER=portainer
if [ "$(docker ps -a -q -f name=^/${CONTAINER}$)" ]; then
  echo -e "${CM} $CONTAINER exists"
else
  echo -e "${CN} '$CONTAINER' does not exist, creating it now"
  docker volume create portainer_data &>/dev/null
  docker run -d \
  -p 8000:8000 \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest &>/dev/null
  echo -e "${BFR}${BFR}${CM} $CONTAINER installed"
  echo -e "Portainer should be reachable by going to the following URL.
           ${BL}https://$IP:9443${CL} \n"

fi
