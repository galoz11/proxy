
IP=$(hostname -I | awk '{print $1}')



echo "Installing Dependencies"
apt-get update &>/dev/null
apt-get install -y curl &>/dev/null
apt-get install -y git &>/dev/null
echo "Installed Dependencies"

VERSION=$(curl -fsSL https://api.github.com/repos/coder/code-server/releases/latest |
  grep "tag_name" |
  awk '{print substr($2, 3, length($2)-4) }')

echo "Installing Code-Server v${VERSION}"

echo "Installed Code-Server v${VERSION} on $hostname"

echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://$IP:2____l0${CL} \n"
