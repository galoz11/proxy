echo "Installing Dependencies"
apt-get update &>/dev/null
apt-get install -y curl &>/dev/null
apt-get install -y git &>/dev/null
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
