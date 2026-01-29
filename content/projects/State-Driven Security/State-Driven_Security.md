---
title: "State-Driven Security: Building a Modular Nervous System"
description: "Moving beyond log-reading: How I re-architected my homelab into a self-diagnosing state machine using a decoupled MOTD, root-privileged SSH defense, and binary-state logic."
date: 2026-01-29
lastmod: 2026-01-29
draft: false
tags: ["homelab", "security", "bash", "architecture", "proxmox", "zfs", "automation"]
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

To maintain this discipline without "alert fatigue," I have re-architected how the server communicates its health to me.

## The Nervous System: Modular MOTD Architecture

I have moved away from monolithic login scripts that hang the terminal while checking disk arrays. Instead, I built a **Decoupled State Architecture**.

### The Architecture: "The Renderer knows nothing"
The core innovation here is the separation of **Detection** (Heavy) from **Presentation** (Light).



1.  **The Workers (Background):** Specialized bash scripts (`check-storage.sh`, `check-security.sh`) run in the background via systemd timers. They do the heavy lifting: querying ZFS, parsing logs, and checking APIs.
2.  **The State (Persistence):** These scripts output their findings to a transient RAM-disk (`/run/motd-health/`). They write atomic key-value pairs (`STATUS`, `SUMMARY`, `REMEDIATE`).
3.  **The Renderer (Frontend):** When I SSH in, the MOTD script **does not check the system**. It simply reads the text files left by the workers.

**Result:** Zero-latency login, even if ZFS is hanging or the network is congested.

---

## The Logic: Binary State & Maximized Thinking

The system leverages a strict **PASS / FAIL** binary to minimize cognitive load.
* **PASS [Nominal]:** The system is behaving exactly as designed. **No thinking required.** I can focus on building new features.
* **FAIL [Actionable]:** The system has diagnosed a fault. The dashboard provides:
    * **The Note:** *What* is wrong.
    * **The Action:** The exact command to remediate it.

This transforms the MOTD from a "Status Update" into a "Decision Support System."

---

## Functional Breakdown: The 8 Pillars

### 1. INTEGRITY (System Stability)
* **Function:** Validates the fundamental stability of the OS kernel and boot process.
* **Checks:**
    * **Dirty Shutdowns:** Scans logs for power failures vs. clean reboots.
    * **Uptime Stability:** Calculates stability in human-readable format (Days/Hours).
    * **Kernel Taint:** Smartly ignores ZFS-related taints (common in Proxmox) while alerting on hardware or proprietary driver errors.
* **Value:** Proves the hardware is trustworthy before software runs on top.

### 2. SECURITY (Active Defense)
* **Function:** Interfaces with a custom, root-privileged **SSH Defense Daemon**.
* **Checks:**
    * **Daemon Health:** Ensures the background watcher is active.
    * **Real-Time Threat Intelligence:** Displays the count of currently blocked IPs and active threats.
    * **Key-Only Awareness:** Unlike standard tools, this daemon detects "Connection Closed" events typical of bots failing against Proxmox's Key-Only auth.
* **Remediation:** Instant `zpool status -v` command provided on failure.

### 3. PERFORMANCE (Resource Discipline)
* **Function:** Monitors the finite resources (CPU/RAM) that forced the "Noise-Gen" pivot.
* **Checks:**
    * **Load Average:** Relative to core count.
    * **Memory Pressure:** Alerts if swap is thrashing.
* **Value:** Ensures the privacy scripts aren't cannibalizing the cluster.

### 4. STORAGE (ZFS Hardening)
* **Function:** Visualizes the health of the 1.3TB ZFS RAID array.
* **Checks:**
    * **Pool Status:** Checks for `DEGRADED` or `FAULTED` states.
    * **Capacity:** Renders ASCII bars to visualize usage (Alerts > 80%).
    * **Mount Status:** Detects if filesystems have flipped to Read-Only.
* **Remediation:** Instant `zpool status -v` command provided on failure.

### 5. SERVICES (Orchestration)
* **Function:** Monitors the Docker and Systemd stack.
* **Checks:**
    * **Failed Units:** Scans `systemctl --failed` for crashed services (e.g., Gluetun, Pi-hole).
* **Value:** Instant visibility if the VPN tunnel or DNS resolver has crashed.

### 6. NETWORK (Connectivity)
* **Function:** Ensures the "Dual-Network" strategy is intact.
* **Checks:**
    * **Interface State:** Verifies `tailscale0` and physical ethernet links are `UP`.
* **Value:** Prevents diagnosing "DNS issues" when the cable is effectively unplugged.

### 7. MAINTENANCE (Hygiene)
* **Function:** Keeps the system patched without manual checking.
* **Checks:**
    * **APT Updates:** Counts pending security updates.
    * **Reboot Required:** Checks for the reboot flag file.

### 8. FLEET (Guest Management)
* **Function:** Proxmox-specific monitoring of LXC/VM guests.
* **Checks:**
    * **Guest State:** Warns if a critical VM is `stopped`.
    * **Filtering:** Smartly ignores "Dev" VMs (like ID 100) to keep the board Green for production.

---

## TL;DR – Current State (26 Jan 2026)

* **Infrastructure:** Four-node hybrid cluster unified via Tailscale.
* **Privacy Stack:** Hardened Docker architecture using Gluetun (NordLynx) with location-hopping.
* **DNS Hardening:** Pi-hole refactored into **Host Mode** to enable per-client visibility via Tailscale IPs.
* **Active Defense:** Automated "Privacy Noise" generation hitting 540k+ domains 24/7.

GitHub repo: [mccrudd3n/server_security](https://github.com/mccrudd3n/server_security)

## Final Verdict
Your homelab has evolved from a "Black Box" to a **Transparent State Machine**. By maximizing thinking through binary states, I have ensured that my finite human resources are spent on **building the future**, not **debugging the past**.