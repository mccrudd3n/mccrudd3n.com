---
title: "Minilab Initialised - The Proxmox Migration"
description: "From Data Disaster to High Availability 🚀"
date: 2026-01-25
draft: false
tags: ["Proxmox", "Virtualization", "Homelab", "ZFS", "Data-Recovery"]
cover:
  image: "/images/journals/journal2.jpg"
  alt: "Proxmox Dashboard"
  caption: "Virtualization is the ultimate safety net."
  credit: "Past, Present and AI Future self"
toc: true
featured: true
---

# My Second Brain: Proxmox Edition ⚠️

The transition from running services on bare metal to a dedicated **Proxmox Virtual Environment (VE)** is officially underway. My "Second Brain" is no longer just a site; it’s a cluster of nodes designed for high availability and tinkering.

## Key Takeaways
* **Snapshot Culture:** Before you break it, snapshot it. Proxmox makes "failing fast" safe.
* **LXC vs VM:** Learning when to use a lightweight Linux Container (LXC) for speed versus a full Virtual Machine (VM) for isolation.
* **RAID is not a Backup:** But it is essential for uptime. I've learned the hard way that redundancy saves heartaches.
* **Thanks [NetworkChuck](https://www.youtube.com/@NetworkChuck):** Your Proxmox series helped me move from manual chaos to an automated network.

---

## Proxmox Architecture Goals
I am restructuring my digital life around the following Proxmox pillars:

1.  **High Availability:** Setting up a cluster so that if one machine dies, my brain stays online.
2.  **ZFS Storage:** Protecting my data against bit-rot and drive failure at the file-system level.
3.  **Proxmox Backup Server (PBS):** Deduplicated, incremental backups—because data I haven't backed up is data I don't care about.

## Performance Comparison
| Resource Type | Overhead | Ideal Use Case |
| :--- | :--- | :--- |
| **LXC (Container)** | Very Low | DNS (Pi-hole), Reverse Proxies, Web Servers |
| **VM (Virtual Machine)** | Moderate | Windows, Docker Hosts, Home Assistant |
| **Hardware Passthrough** | N/A | Transcoding (Plex?/Jellyfin?), AI/LLM workloads |

---

## Log
**Log: 25012026**

The holiday period brought a brutal realization. A drive I purchased only a few months ago—with less than 200 operating hours—died unexpectedly. Upon plugging it in, the system reported it as corrupted. 

After the initial panic subsided, I realized my standard procedure for cloning drives hadn't been as airtight as I thought. I needed a real **RAID system**. Drawing on my experience with data scraping and forensics lessons, I performed a deep dive into the sectors and managed to salvage 99% of my data. While I can't be 100% certain every single bit is back, the **Family Archive** is safe.

This scare was the catalyst. I searched for more robust systems and found **Proxmox**. I was immediately sold on its VM capabilities and repurposed my Linux home server into a dedicated Proxmox node.

### Current Infrastructure Progress:
- **Triple RAID System:** Established three separate RAID pools for specific data redundancy needs.
- **Tailscale Mesh:** Mapped drives across family members using a Tailscale private peer-to-peer mesh for secure remote access.
- **Automated Disaster Recovery:** Set up automated VM backup procedures to ensure that even if my main OS drive fails, I can be back up in minutes.
- **Synchronization:** Deployed **Syncthing** to ensure all local devices are perfectly mirrored.

The "Wet Floor" sign is staying up while I fine-tune the storage pools. The journey from one physical machine to an infinite number of virtual ones has begun. 

> "Stop thinking about it and just install the ISO."

---