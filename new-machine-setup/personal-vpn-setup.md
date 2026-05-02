# Personal VPN (Tailscale Exit Node on DigitalOcean)

A cheap cloud VM running Tailscale as an exit node. Gives you:
- A stable public IP for whitelisting (e.g. Azure SQL corp firewall rules)
- Encrypted egress on hostile/random wifi
- Pseudonymous routing without trusting a commercial VPN provider

Tailscale: https://tailscale.com
DigitalOcean: https://cloud.digitalocean.com

## 1. Create the droplet

- Sign up / log in: https://cloud.digitalocean.com
- **Settings → Security → SSH Keys → Add SSH Key**: paste output of `cat ~/.ssh/id_ed25519.pub`
  - If no key exists: `ssh-keygen -t ed25519` (do **not** overwrite an existing key)
- **Create → Droplets**
  - Region: closest to you (or to the Azure region you'll hit)
  - OS: Ubuntu 24.04 LTS x64
  - Size: Basic → Regular CPU → **$4/mo (512MB / 1 vCPU / 10GB / 500GB)** is enough for an exit node; bump to $6/mo for headroom
  - IPv6: enabled
  - Authentication: SSH Key (the one you added)
  - Hostname: leave as the default DO name (e.g. `ubuntu-s-1vcpu-512mb-10gb-sfo2`) or set your own — Tailscale will use whatever the OS hostname is at first `tailscale up`
- Note the public IPv4.

## 2. Bootstrap the droplet

From your laptop:
```bash
ssh root@<droplet-ip>
```

Confirm `whoami` says `root`, then paste:

```bash
apt update && apt upgrade -y
apt install -y ufw

ufw allow 22/tcp
ufw allow 41641/udp
ufw --force enable

cat > /etc/sysctl.d/99-tailscale.conf <<EOF
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
EOF
sysctl -p /etc/sysctl.d/99-tailscale.conf

curl -fsSL https://tailscale.com/install.sh | sh

tailscale up --advertise-exit-node --ssh
```

The last command prints a URL. Open it, log in to Tailscale (GitHub/Google SSO is fine for a new account).

## 3. Approve in Tailscale admin console

https://login.tailscale.com/admin/machines

- Find `<exit-node-name>` → ⋯ → **Edit route settings** → enable "Use as exit node" → Save
- Same menu → **Disable key expiry** (otherwise the tunnel breaks every 6 months)

## 4. Install Tailscale on the laptop

Skip if already installed.

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

Approve the laptop in the admin console the same way.

## 5. Route laptop traffic through the exit node

Find the droplet's Tailscale IP (`100.x.y.z`):
```bash
tailscale status
```

Then route through it:
```bash
sudo tailscale set --exit-node=100.x.y.z --exit-node-allow-lan-access=true
```

Verify:
```bash
curl ifconfig.me
```
Should print the droplet's public IP. That IP is what you give for firewall whitelisting.

Toggle off:
```bash
sudo tailscale set --exit-node=
```

## 6. Close public SSH

Once `tailscale ssh root@<droplet-tailscale-name>` works from your laptop, close port 22 to the public internet entirely. Tailscale SSH is tunneled over the WireGuard mesh, so it keeps working.

On the droplet (over Tailscale):
```bash
tailscale ssh root@<droplet-tailscale-name>
ufw delete allow 22/tcp
ufw status
reboot
```

Only `41641/udp` (Tailscale) should remain.

Emergency fallback if you ever lose Tailscale access: DigitalOcean's web console (Droplet → Access → Launch Console).

## 7. Lock down DNS

By default the laptop still uses the local wifi's DNS resolver, so the network operator can see which hostnames you look up (content stays HTTPS-encrypted, but the metadata leaks). Push DNS through the tunnel:

- https://login.tailscale.com/admin/dns
- **Nameservers** → Add `1.1.1.1` (or `9.9.9.9`)
- Enable **Override local DNS**

Verify on the laptop — answers should come `via tailscale0`:
```bash
resolvectl query example.com
```

If it says `via wlan0` (or your wifi link name), DNS is leaking. Check `resolvectl status` — the `tailscale0` link should have `DNS Domain: ~.` (the `~.` is the catch-all marker that makes it handle all queries).

## Re-provisioning

If the droplet dies or you migrate hosts: destroy it, create a fresh one (step 1), re-run step 2. If the new droplet's hostname matches an existing Tailscale node, delete the old one from the admin console first, or let `tailscale up` claim the name.
