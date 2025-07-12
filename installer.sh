#!/bin/bash
# ========================================================
#  One Click Pipe Node Installer by Clownyy
#  Telegram: https://t.me/md_alfaaz
#  GitHub: https://github.com/imscaryclown/
# ========================================================

set -e

# === Colors ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

ARCHIVE="pop-v0.3.2-linux-x64.tar.gz"
INSTALL_DIR="/opt/popcache"
POP_BIN="$INSTALL_DIR/pop"

# === Banner ===
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
center " | |    | |/ _ \ \ /\ / / '_ \| | | | | | |" "$CYAN"
center " | |____| | (_) \ V  V /| | | | |_| | |_| |" "$CYAN"
center "  \_____|_|\___/ \_/\_/ |_| |_|\__, |\__, |" "$CYAN"
center "                                __/ | __/ |" "$CYAN"
center "                               |___/ |___/ " "$CYAN"
center "==============================================================" "$CYAN"
center "🚀 One Click Pipe Node Installer by Clownyy " "$GREEN"
center "📬 Telegram: https://t.me/md_alfaaz" "$BLUE"
center "💻 GitHub: https://github.com/imscaryclown/" "$BLUE"
center "==============================================================" "$CYAN"

# === Menu ===
echo -e "${YELLOW}1.${NC} Install New Node"
echo -e "${YELLOW}2.${NC} Get POP ID & Node Info"
echo -e "${YELLOW}3.${NC} Get Full IP & Server Info"
echo -e "${YELLOW}4.${NC} View Node Logs"
echo -e "${YELLOW}5.${NC} Exit"
echo -e "${BLUE}-------------------------------${NC}"
read -rp "$(echo -e "${CYAN}Choose an option [1-5]: ${NC}")" OPTION

if [ "$OPTION" = "1" ]; then
  read -rp "$(echo -e "${YELLOW}Enter your INVITE CODE: ${NC}")" INVITE_CODE
  read -rp "$(echo -e "${YELLOW}Enter a POP NAME (e.g. my-pop-node): ${NC}")" POP_NAME
  read -rp "$(echo -e "${YELLOW}Enter your POP LOCATION (City, Country): ${NC}")" POP_LOCATION
  read -rp "$(echo -e "${YELLOW}Enter your SOLANA ADDRESS: ${NC}")" SOLANA_PUBKEY
  read -rp "$(echo -e "${YELLOW}Enter Memory Cache Size in MB (e.g. 4096): ${NC}")" MEMORY_SIZE_MB
  read -rp "$(echo -e "${YELLOW}Enter Disk Cache Size in GB (e.g. 100): ${NC}")" DISK_SIZE_GB

  NODE_NAME="node-01"
  NAME="Your Name"
  EMAIL="you@example.com"
  WEBSITE="https://example.com"
  TWITTER="clownyy"
  DISCORD="clownyy#1234"
  TELEGRAM="clownyy"
  WORKERS=0

  if [ ! -f "$ARCHIVE" ]; then
    echo -e "${RED}❌ File $ARCHIVE not found in current directory!${NC}"
    exit 1
  fi

  chmod 777 "$ARCHIVE"

  useradd -m -s /bin/bash popcache || echo "User 'popcache' already exists."
  usermod -aG sudo popcache

  apt update -y
  apt install -y libssl-dev ca-certificates curl tar jq

  mkdir -p "$INSTALL_DIR" "$INSTALL_DIR/logs"
  tar -xzf "$ARCHIVE" -C "$INSTALL_DIR"
  chmod +x "$POP_BIN"
  chown -R popcache:popcache "$INSTALL_DIR"
  ln -sf "$POP_BIN" /usr/local/bin/pop

  echo -e "${CYAN}🚀 Running the binary manually (in background)...${NC}"
  # sudo -u popcache "$POP_BIN" &

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
  sudo -u popcache "$POP_BIN" --validate-config

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

  systemctl daemon-reload
  systemctl enable --now popcache.service
# === Allow ports ===
sudo ufw allow 22
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow ssh
sudo ufw enable
sudo ufw reload

  echo -e "\n${GREEN}✅ Pipe POP Node service installed and enabled!${NC}"
  echo -e "${BLUE}📄 View logs: journalctl -u popcache -f${NC}"
  echo -e "${CYAN}🚀 Manually running the node now (foreground below):${NC}"
  sudo -u popcache "$POP_BIN"

elif [ "$OPTION" = "2" ]; then
  echo -e "${CYAN}🔍 Fetching POP metrics, state, and health...${NC}"
  curl -sk http://localhost/metrics | jq . || echo -e "${RED}Could not fetch metrics${NC}"
  curl -sk http://localhost/state | jq . || echo -e "${RED}Could not fetch state${NC}"
  curl -sk http://localhost/health | jq . || echo -e "${RED}Could not fetch health${NC}"

elif [ "$OPTION" = "3" ]; then
  echo -e "${CYAN}🌍 Fetching public IP and server info...${NC}"
  apt install -y curl jq >/dev/null 2>&1
  IP_DATA=$(curl -s https://ipinfo.io)
  if [ -n "$IP_DATA" ]; then
    echo "$IP_DATA" | jq .
  else
    echo -e "${RED}Failed to fetch IP info from ipinfo.io${NC}"
  fi

elif [ "$OPTION" = "4" ]; then
  echo -e "${BLUE}📜 Showing logs for popcache service...${NC}"
  journalctl -u popcache -f

elif [ "$OPTION" = "5" ]; then
  echo -e "${GREEN}👋 Exiting...${NC}"
  exit 0

else
  echo -e "${RED}Invalid option. Exiting.${NC}"
  exit 1
fi
