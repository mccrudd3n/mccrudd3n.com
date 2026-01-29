---
title: "Server-Side Security – A Living Journey"
description: "Security is a process, not a state. This is my real-time, public notebook of turning four random machines into a hardened, monitored, and automated personal cloud."
date: 2025-12-11
lastmod: 2026-01-26
draft: false
tags: ["homelab", "security", "gluetun", "wireguard", "proxmox", "zfs", "privacy", "tailscale"]
cover:
  image: "/images/projects/servers.jpg"
  alt: "Server Rack"
  caption: "Homelab Infrastructure"
  credit: "Past, Present and AI Future self"
toc: true
featured: true
---

## The Philosophy: Security as Discipline

Security is a fine balance between **following the process to stay secured** and having the **discipline to follow and maintain that process**. From my perspective, this also means that the more security you want, the more resources you will need. 

It is interesting that as much as I would like to build a system in which my behavior data is obfuscated, this requires a bigger overhead in terms of Hardware RAM and CPU. Within my home lab, these resources are finite. This hardware reality forced a pivot: to achieve high-level privacy without crippling the cluster, I transitioned from heavy browser-based automation to a surgical, lightweight web-probing script. Security in a constrained environment is about the discipline to optimize the process until it is sustainable.

## TL;DR – Current State (26 Jan 2026)

- **Infrastructure:** Four-node hybrid cluster unified via Tailscale. Added **Portainer** for visual orchestration.
- **Privacy Stack:** Hardened Docker architecture using Gluetun (NordLynx) with location-hopping (Poland/US/UK).
- **DNS Hardening:** Pi-hole refactored into **Host Mode** to enable per-client visibility via Tailscale IPs, bypassing ISP DNS locking.
- **Active Defense:** Automated "Privacy Noise" generation via a lightweight Python scraper hitting 540k+ domains 24/7 with minimal resource impact (~30MB RAM).

GitHub repo: [mccrudd3n/server_security](https://github.com/mccrudd3n/server_security)

## Phase 1 – Foundations & Storage Hardening (Complete)

| Component                | Status | Details                                                                 |
|--------------------------|--------|-------------------------------------------------------------------------|
| Zero-trust network       | ✅      | Tailscale + MagicDNS integration for global encrypted access.           |
| Unified Storage Path     | ✅      | 1.3TB ZFS RAID mounted to LXC 102 for Docker Root and heavy I/O.        |
| Container Isolation      | ✅      | Decoupled LAN DNS (Pi-hole) from VPN-bound services (qBittorrent).      |
| Secure Management        | ✅      | Portainer/Web UI hardening with SSL bypass and basic auth layers.       |

## Phase 2 – Privacy Architecture & Resource Optimization (In Progress)

I have pivoted to a **Dual-Network Strategy**. I utilize "Host Networking" for infrastructure services to ensure identity transparency, while wrapping "Consumer Services" in a VPN-silo.

### Current "Privacy Stack" (LXC 102)

| Service          | Purpose                                   | Isolation Method                 | Resource Impact |
|------------------|-------------------------------------------|---------------------------------|-----------------|
| **Gluetun** | WireGuard (NordLynx) Gateway              | Primary Network Namespace       | Low             |
| **qBittorrent** | P2P with Killswitch                       | Shares Gluetun Net-Namespace    | Medium          |
| **Pi-hole** | Global Adblocking & Local DNS             | **Host Mode** (Tailscale Ready) | Low             |
| **Noise-Gen** | Lightweight Python Obfuscator             | VPN-Isolated (via Gluetun)      | **Very Low** |



### Detection & Monitoring Capabilities

- **Traffic Camouflage:** The `noise-generator` script hits HaGeZi’s Ultimate blocklist domains via the VPN, poisoning tracking profiles with "junk" requests.
- **Global Privacy Tunnel:** Tailscale "Override DNS" integration allows my mobile devices to tunnel DNS back to the Pi-hole from anywhere.
- **Log Discipline:** Implemented Docker `json-file` rotation to cap logs at 10MB, ensuring the 24/7 noise generation doesn't lead to disk exhaustion.
- **FIM (File Integrity Monitoring):** Wazuh alerts on changes to critical config files (`sshd_config`, `.env`).

## Infrastructure Highlights

### Tailscale + Pi-hole "Invisible" Integration
By moving Pi-hole to `network_mode: host` and forcing `IPv6=false`, I eliminated the 2-second DNS latency loop. This allows Tailscale clients to appear as unique IPs rather than the generic Docker bridge gateway.

### Resource-Aware Obfuscation
The pivot from a Selkies-Firefox container to a `python:3.11-slim` script was a turning point. It proved that privacy doesn't have to be expensive if you have the discipline to refine the process.

```yaml
# Optimized Privacy Noise Config
# Replaces heavy Firefox/Selenium with lightweight Python Requests
noise-generator:
  image: python:3.11-slim
  container_name: noise-generator
  network_mode: "service:gluetun"
  logging:
    driver: "json-file"
    options:
      max-size: "10m"
      max-file: "3"
  volumes:
    - ./noise_profile:/app
  entrypoint: sh -c "pip install requests && python noise_script.py"
  restart: always

```

## Phase 3 – Future Defense-in-Depth (Next 30 Days)

| Feature | Tooling | Why it matters |
| --- | --- | --- |
| **Unbound Deployment** | Recursive DNS | Removing dependence on upstream providers (1.1.1.1/8.8.8.8). |
| **Vaultwarden** | Bitwarden API | Self-hosting credential management within the ZFS pool. |
| **Fail2Ban for LXC** | IP Jailing | Hardening the Proxmox host against brute-force Tailscale peers. |
| **Uptime Kuma** | Monitoring | Real-time status dashboards for the VPN tunnel and Noise-Gen health. |
