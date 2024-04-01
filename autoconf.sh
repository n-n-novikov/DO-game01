#! /bin/bash

cd /home/mkim 
apt install nginx -y

#if [[ $(systemctl status nginx || grep disabled) != "" ]] 
#then 
#	systmectl enable nginx
#fi
echo 1;
cat << EOF > /etc/nginx/sites-available/default 
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                proxy_pass http://127.0.0.1:8080;
        }
}
EOF

systemctl restart nginx
echo 2
git clone https://gitfront.io/r/deusops/JnacRhR4iD8q/2048-game.git
chown -R mkim:mkim 2048-game
chown mkim:mkim package-lock.json
apt install nodejs npm -y

cd 2048-game
npm install --include=dev
npm run build

cat << EOF > /etc/systemd/system/game.service 
[Unit]
Description=DeusOps_game01_start
After=nginx.service
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/mkim/2048-game
Environment=NODE_PORT=8080

User=mkim
Group=mkim

OOMScoreAdjust=-1000

ExecStratPre=/usr/bin/npm install --include=dev
ExecStartPre=/usr/bin/npm run build
ExecStart=/usr/bin/npm start
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart game.service

