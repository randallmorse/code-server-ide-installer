if [[ ! -n "${vs_password}" ]]; then 
    echo "Please set an ENV variable for your visual studio code server password (ex: export vs_password=swordfish)"
    exit
fi

#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -yqq
apt-get upgrade -yqq
apt-get install build-essential htop tmux vim-nox -yqq
sudo apt-get update
sudo apt-get upgrade
mkdir ~/code-server
wget https://github.com/cdr/code-server/releases/download/v3.3.1/code-server-3.3.1-linux-amd64.tar.gz
tar -xzvf code-server-3.3.1-linux-amd64.tar.gz
sudo cp -r code-server-3.3.1-linux-amd64 /usr/lib/code-server
sudo ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server
sudo mkdir /var/lib/code-server
echo "[Unit]
Description=code-server
After=nginx.service

[Service]
Type=simple
Environment=PASSWORD=$vs_password
ExecStart=/usr/bin/code-server --bind-addr 127.0.0.1:8080 --user-data-dir /var/lib/code-server --auth password
Restart=always

[Install]
WantedBy=multi-user.target" >> /lib/systemd/system/code-server.service
sudo systemctl enable code-server
sudo systemctl start code-server
export ext_ip=$(curl ifconfig.me)
export rvs_dns=$(host $ext_ip | cut -d " " -f 5)
echo"Tunnel to vs studio:"
echo "ssh -L 8080:127.0.0.1:8080 root@$ext_ip"
