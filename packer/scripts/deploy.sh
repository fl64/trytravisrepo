#!/bin/bash
cd /var/local
git clone -b monolith https://github.com/express42/reddit.git
chown  appuser:appuser -R /var/local/reddit
cd reddit && bundle install
cat <<EOF > /etc/systemd/system/puma.service
[Unit]
Description=Test app (puma server)
After=network.target
[Service]
Type=simple
User=appuser
WorkingDirectory=/var/local/reddit
ExecStart=/usr/local/bin/puma
ExecStop=/bin/kill -9
KillMode=process
KillSignal=SIGTERM
SendSIGKILL=no
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now puma.service