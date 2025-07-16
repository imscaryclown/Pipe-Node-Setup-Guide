#!/bin/bash
# One Click Pipe Testnet Node Installer by Clownyy 🤡
# GitHub: https://github.com/imscaryclown/pipe-node-setup-guide
# Telegram: https://t.me/clownyy

# === Auto elevate to sudo if not root ===
if [ "$EUID" -ne 0 ]; then
  if [ -f "$0" ]; then
    echo "🔐 Script needs sudo/root permissions. Re-running with sudo..."
    chmod +x "$0"
    exec sudo "$0" "$@"
  else
    echo -e "\033[0;31m❌ This script must be run as root.\033[0m"
    echo -e "\033[1;33m💡 Try this instead:\033[0m"
    echo "curl -sSL https://raw.githubusercontent.com/imscaryclown/pipe-node-setup-guide/main/setup_pipe_node.sh | sudo bash"
    exit 1
  fi
fi

set -e

# === Colors ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[1;36m'
NC='\033[0m'

ARCHIVE="pop-v0.3.2-linux-x64.tar.gz"
INSTALL_DIR="/opt/popcache"
POP_BIN="$INSTALL_DIR/pop"

# === Centered Banner ===
clear
center() {
  local str="$1"
  local color="${2:-$NC}"
  local term_width=$(tput cols)
  local padding=$(( (term_width - ${#str}) / 2 ))
  printf "%b%*s%s%b\n" "$color" "$padding" "" "$str" "$NC"
}

center "==============================================================" "$CYAN"
center "   _____ _                                 " "$CYAN"
center "  / ____| |                                " "$CYAN"
center " | |    | | _____      ___ __  _   _ _   _ " "$CYAN"
center " | |    | |/ _ \\ \\ /\\ / / '_ \\| | | | | | |" "$CYAN"
center " | |____| | (_) \\ V  V /| | | | |_| | |_| |" "$CYAN"
center "  \\_____|_|\\___/ \\_/\\_/ |_| |_|\\__, |\\__, |" "$CYAN"
center "                                __/ | __/ |" "$CYAN"
center "                               |___/ |___/ " "$CYAN"
center "==============================================================" "$CYAN"
center "🚀 One Click Pipe Node Installer by Clownyy 🤡" "$GREEN"
center "📬 Telegram: https://t.me/clownyy" "$BLUE"
center "==============================================================" "$CYAN"

# === Menu ===
while true; do
echo -e "${YELLOW}1.${NC} Install New Node"
echo -e "${YELLOW}2.${NC} Get POP ID & Node Info"
echo -e "${YELLOW}3.${NC} Get Full IP & Server Info"
echo -e "${YELLOW}4.${NC} View Node Logs"
echo -e "${YELLOW}5.${NC} Exit"
echo -e "${BLUE}-------------------------------${NC}"
read -rp "$(echo -e "${CYAN}Choose an option [1-5]: ${NC}")" OPTION

if [ "$OPTION" = "1" ]; then
  read -rp "$(echo -e "${YELLOW}Enter your INVITE CODE: ${NC}")" INVITE_CODE
  read -rp "$(echo -e "${YELLOW}Enter POP NAME (e.g. my-pop-node): ${NC}")" POP_NAME
  read -rp "$(echo -e "${YELLOW}Enter POP LOCATION (e.g. City, Country): ${NC}")" POP_LOCATION
  read -rp "$(echo -e "${YELLOW}Enter your SOLANA ADDRESS: ${NC}")" SOLANA_PUBKEY
  read -rp "$(echo -e "${YELLOW}Enter Memory Cache Size in MB (e.g. 4096): ${NC}")" MEMORY_SIZE_MB
  read -rp "$(echo -e "${YELLOW}Enter Disk Cache Size in GB (e.g. 100): ${NC}")" DISK_SIZE_GB

  NODE_NAME="node-01"
  NAME="Clownyy"
  EMAIL="[email protected]"
  WEBSITE="https://t.me/clownyy"
  TWITTER="imscaryclown"
  DISCORD="clownyy#0001"
  TELEGRAM="clownyy"
  WORKERS=0

  if [ ! -f "$ARCHIVE" ]; then
    echo -e "${RED}❌ File $ARCHIVE not found in current directory!${NC}"
    exit 1
  fi

  chmod 777 "$ARCHIVE"

  useradd -m -s /bin/bash popcache || echo -e "${BLUE}User 'popcache' already exists.${NC}"
  usermod -aG sudo popcache

  apt update -y
  apt install -y libssl-dev ca-certificates curl tar jq

  # 🔧 System tuning
  cat > /etc/sysctl.d/99-popcache.conf <<EOF
net.ipv4.ip_local_port_range = 1024 65535
net.core.somaxconn = 65535
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.core.wmem_max = 16777216
net.core.rmem_max = 16777216
EOF
  sysctl --system

  cat > /etc/security/limits.d/popcache.conf <<EOF
*    hard nofile 65535
*    soft nofile 65535
EOF

  mkdir -p "$INSTALL_DIR" "$INSTALL_DIR/logs"
  tar -xzf "$ARCHIVE" -C "$INSTALL_DIR"
  chmod +x "$POP_BIN"
  chown -R popcache:popcache "$INSTALL_DIR"
  ln -sf "$POP_BIN" /usr/local/bin/pop

  # 🔧 Generate config
  cat > "$INSTALL_DIR/config.json" <<EOF
{
  "pop_name": "$POP_NAME",
  "pop_location": "$POP_LOCATION",
  "invite_code": "$INVITE_CODE",
  "server": {
    "host": "0.0.0.0",
    "port": 443,
    "http_port": 80,
    "workers": $WORKERS
  },
  "cache_config": {
    "memory_cache_size_mb": $MEMORY_SIZE_MB,
    "disk_cache_path": "./cache",
    "disk_cache_size_gb": $DISK_SIZE_GB,
    "default_ttl_seconds": 86400,
    "respect_origin_headers": true,
    "max_cacheable_size_mb": 1024
  },
  "api_endpoints": {
    "base_url": "https://dataplane.pipenetwork.com"
  },
  "identity_config": {
    "node_name": "$NODE_NAME",
    "name": "$NAME",
    "email": "$EMAIL",
    "website": "$WEBSITE",
    "twitter": "$TWITTER",
    "discord": "$DISCORD",
    "telegram": "$TELEGRAM",
    "solana_pubkey": "$SOLANA_PUBKEY"
  }
}
EOF

  chown popcache:popcache "$INSTALL_DIR/config.json"

  # 🧼 Clean .pop.lock
  LOCK_FILE="$INSTALL_DIR/.pop.lock"
  if [ -f "$LOCK_FILE" ]; then
    echo -e "${YELLOW}⚠️  Removing leftover lock file...${NC}"
    rm -f "$LOCK_FILE"
  fi

  # ✅ Validate config from inside the install directory
  chown -R popcache:popcache "$INSTALL_DIR"
  chmod -R 755 "$INSTALL_DIR"
  sudo -u popcache bash -c "cd $INSTALL_DIR && ./pop --validate-config"

  # 🔧 Setup systemd service
  cat > /etc/systemd/system/popcache.service <<EOF
[Unit]
Description=POP Cache Node
After=network.target

[Service]
Type=simple
User=popcache
Group=popcache
WorkingDirectory=$INSTALL_DIR
ExecStart=$POP_BIN
Restart=always
RestartSec=5
LimitNOFILE=65535
StandardOutput=append:$INSTALL_DIR/logs/stdout.log
StandardError=append:$INSTALL_DIR/logs/stderr.log
Environment=POP_CONFIG_PATH=$INSTALL_DIR/config.json

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reexec
  systemctl daemon-reload
  systemctl enable popcache
  systemctl restart popcache

  echo -e "${GREEN}✅ POP Node service started via systemd.${NC}"
  echo -e "${CYAN}📜 To view logs: ${NC}journalctl -u popcache -f"

elif [ "$OPTION" = "2" ]; then
  curl -sk http://localhost/metrics | jq .
  curl -sk http://localhost/state | jq .
  curl -sk http://localhost/health | jq .

elif [ "$OPTION" = "3" ]; then
  curl -s https://ipinfo.io | jq .

elif [ "$OPTION" = "4" ]; then
  journalctl -u popcache -f

else
  echo -e "${RED}❌ Invalid option or exiting.${NC}"
  exit 0
fi
