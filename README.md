# 🚀 Pipe-Node-Setup-Guide
Welcome to pipe node setup guide. You can  use this one click installer to install node without any hassle.
---   ---
## 💻 Hardware Requirements
| CPU | Ram     | Storage               |
| :-------- | :------- | :------------------------- |
| **4+ Cores** | **16 GB** | **100 GB+** |

### 🪛 Pre-Requirements
- You need to have invite code of pipe node
- If you have filled the form search it in your email for the invite code
- Get the location and country of the vps using menu option 3
---
## ⚙️ Menu Options

- 1️⃣ Install Node - install fresh node

- 2️⃣ Check Node Info - get node id which you use to track your pop node on dashboard

- 3️⃣ Chek Ip Info - get the location of your vps which you will use in the node

- 4️⃣ See Node Logs - view the full node logs

- 5️⃣ Exit - exit the installer
 ---
# Installation (One click)
```
curl -sSL https://raw.githubusercontent.com/imscaryclown/pipe-node-setup-guide/main/installer.sh -o setup_pipe_node.sh
chmod +x setup_pipe_node.sh
sudo ./setup_pipe_node.sh
```

- 🔑 Enter the invite code
- 🏷 Enter pop name (anything you want)
- 📍 Enter vps location (city & country) use menu option 3 for these details
- 🗝 Enter solana address
- 🖥 enter ram in mb (1gb = 1024mb)
- 💾 enter disk in gb (e.g 100)

## ▶️ Start Node

``` 
chmod +x installer.sh
./installer.sh
````
## Check Node Status & Logs
- **Check if node is running**
```
sudo systemctl status popcache
```
- **Check Full Logs**
```
tail -f /opt/popcache/logs/stdout.log
```
# Dashboard
```
https://dashboard.testnet.pipe.network/node/
```
- add the pop id at the end of the link and open it
<img width="1532" height="851" alt="Screenshot 2025-07-12 171724" src="https://github.com/user-attachments/assets/62c1d289-7b71-47df-9a7d-12cf9a4206e2" />

--- 

## 🙋 Need Help?
- 💬 **Contact:** [@Clownyy](https://t.me/md_alfaaz)
- 📺 **Guides & Updates:** [@Hustle_Airdrops](https://t.me/Hustle_Airdrops)
