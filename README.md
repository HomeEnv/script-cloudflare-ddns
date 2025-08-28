# script-cloudflare-ddns

A lightweight Docker-based Dynamic DNS (DDNS) updater for Cloudflare.  
This script periodically checks your public IP and updates a DNS record in Cloudflare so your domain always points to your current IP (useful for home servers with dynamic IPs).

---

## 📂 Repository Structure

- `docker-compose.yml` → Defines the service that runs the DDNS updater inside an Alpine container.  
- `update-dns.sh` → Shell script that fetches your public IP and updates your Cloudflare DNS record.  

---

## 🚀 Usage

### 1. Clone the repo
```bash
git clone https://github.com/<your-username>/script-cloudflare-ddns.git
cd script-cloudflare-ddns
```

### 2. Configure `docker-compose.yml`
Edit the environment variables in `docker-compose.yml`:

```yaml
environment:
  CF_TOKEN:       "Token of full access to your domain defined in Cloudflare"
  CF_ZONE_ID:     "Your domain's zone id"
  CF_RECORD_ID:   "Your DNS record id"
  CF_RECORD_NAME: "yourdomain.com"
  SLEEP_INTERVAL: "30"   # (seconds) how often to check/update
```

> 💡 You can find `CF_ZONE_ID` and `CF_RECORD_ID` in the Cloudflare dashboard or via the Cloudflare API.

### 3. Start the service
```bash
docker compose up -d
```

The container will now:
- Install `curl` and `jq` inside the Alpine container
- Continuously fetch your public IP (via `https://api.ipify.org`)
- Update the given DNS record in Cloudflare using the API
- Repeat every `SLEEP_INTERVAL` seconds (default: 300)

---

## 📝 Logs
View update logs with:
```bash
docker logs -f cloudflare-ddns
```

---

## ⚙️ Example Log Output
```
2025-08-28 14:00:01 updated mydomain.com → 123.45.67.89
2025-08-28 14:05:01 updated mydomain.com → 123.45.67.89
```

---

## 📌 Notes
- Only supports **A records** (IPv4).  
- Make sure your Cloudflare API token has **DNS:Edit** permissions for the zone.  
- Recommended to set `SLEEP_INTERVAL` to at least 300 seconds (5 minutes) to avoid hitting API limits.  

---

## 🛠️ Requirements
- Docker & Docker Compose installed  
- Cloudflare account with an API token  

---

## 🧑‍💻 Author
Made for self-hosters who want a **free & simple DDNS** solution using Cloudflare.
