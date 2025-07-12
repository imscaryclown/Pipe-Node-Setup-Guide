# 🚀 Pipe-Node-Setup-Guide
Welcome to my pipe node setup guide. Use this one click installer to installer node without any hassle.
## 💻 Hardware Requirements
| CPU | Ram     | Storage               |
| :-------- | :------- | :------------------------- |
| **4+ Cores** | **16 GB** | **100 GB+** |

### 🪛 Pre-Requirements
- You need to have invite code of pipe node
- If you have filled the form search it in your email for the invite code
- Get the location and country of the vps using menu option 3

## ⚙️ Menu Options

- 1️⃣ Install Node - install fresh node

- 2️⃣ Check Node Info - get node id which you use to track your pop node on dashboard

- 3️⃣ Chek Ip Info - get the location of your vps which you will use in the node

- 4️⃣ See Node Logs - view the node logs

- 5️⃣ Exit - exit the installer

# Installation (One click)

This won’t copy to clipboard but can **link to the raw script**. GitHub users can right-click > Copy.

---

### ✅ Option 2: Use GitHub’s built-in copy button

When you use fenced code blocks like:

    ```bash
    bash <(curl -s https://raw.githubusercontent.com/username/repo/main/install.sh)
    ```

GitHub **automatically adds a small copy button in the top right of the code block** on its website (on desktop). No need to do anything extra.

📌 Just make sure you're using proper fenced blocks (three backticks).

---

### ✅ Option 3: GitHub Pages + JS Button (if you want real interactivity)

If you want an actual **"Click to Copy" button**, you'll need to host a custom HTML page using **GitHub Pages** and embed JavaScript like:

```html
<pre>
<code id="my-command">bash <(curl -s https://raw.githubusercontent.com/username/repo/main/install.sh)</code>
<button onclick="copyText()">Copy</button>
</pre>

<script>
function copyText() {
  const code = document.getElementById("my-command").innerText;
  navigator.clipboard.writeText(code);
}
</script>

- 🔑 Enter the invite code
- 🏷 Enter pop name (anything you want)
- 📍 Enter vps location (city & country) use menu option 3 for these details
- 🗝 Enter solana address
- 🖥 enter ram in mb (1gb = 1024mb)
- 💾 enter disk in gb (e.g 100)