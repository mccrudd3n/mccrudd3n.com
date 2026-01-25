---
title: "Proxmox Architecture – The Virtualization Foundation"
description: "Moving from fragile bare-metal to a resilient, clustered Type-1 Hypervisor environment. My roadmap for high availability, ZFS storage, and automated disaster recovery."
date: 2026-01-25
lastmod: 2026-01-25
draft: false
tags: ["proxmox", "virtualization", "ZFS", "homelab", "high-availability", "tailscale"]
cover:
  image: "/images/projects/servers.jpg"
  alt: "Proxmox VE Cluster View"
  caption: "One interface to rule them all."
  credit: "Past, Present and AI Future self"
toc: true
featured: true
---

## TL;DR – Current State (25 Jan 2026)

- **The Catalyst:** Transitioned from a single Linux server to Proxmox VE after a critical drive failure nearly wiped my family archives.
- **The Core:** Single-node powerhouse repurposed from my old home server, now running a mix of **LXC** for speed and **VMs** for isolation.
- **Storage:** 3-tier RAID system powered by ZFS with real-time compression and bit-rot protection.
- **Networking:** Tailscale Peer-to-Peer mesh connecting all virtualized family drives with zero open ports.

## Phase 1 – Infrastructure & Recovery (Complete)



| Component           | Status | Technical Implementation                                                                 |
|---------------------|--------|------------------------------------------------------------------------------------------|
| Hypervisor Layer    | ✅      | Proxmox VE 8.x (Type-1) installed on NVMe boot drive.                                    |
| Data Integrity      | ✅      | ZFS Pool (RAIDZ) protecting against single-drive parity loss.                            |
| Mesh Networking     | ✅      | Tailscale LXC acting as a Subnet Router for the entire Proxmox bridge (`vmbr0`).          |
| Automation          | ✅      | Syncthing LXC keeping mobile/laptop data synced to the ZFS "Source of Truth."            |
| Forensics/Recovery  | ✅      | 99% data salvaged from corrupted NTFS drive using `ddrescue` and `photorec`.             |

## Networking & Access Control: The Family Mesh

A major milestone was mapping the ZFS datasets to family members securely. I avoided traditional VPNs in favor of a **Tailscale Zero-Trust** approach.



### Granular Permission Mapping
Instead of a "one-size-fits-all" share, I implemented a layered permission model:
1.  **Tailscale ACLs:** Restrict which devices in the family mesh can even "see" the storage node.
2.  **Bind Mounts:** Safely passed ZFS datasets from the Proxmox host into a privileged LXC container.
3.  **Linux Permissions (UID/GID):** Mapped specific folders to specific users.
    * `Family_Archive`: Read-only for kids, Read/Write for parents.
    * `Personal_Backups`: Isolated folders mapped 1:1 with Tailscale identities.

## Phase 2 – In Progress (The "Unbreakable" Lab)

### The Storage Strategy



| Pool Name       | Purpose                      | Configuration         | Status    |
|-----------------|------------------------------|-----------------------|-----------|
| **Tank-Archive**| Family Photos & Documents     | 3-Drive ZFS RAIDZ     | Active    |
| **VM-SSD** | High-speed OS drives for VMs | Mirror (RAID 1)       | Active    |
| **Backup-Vault**| Off-site/Secondary Backups   | Proxmox Backup Server | Testing   |

### Future roadmap (Next 4 Weeks)

| Feature                 | Tooling                   | Goal                                                                 |
|-------------------------|---------------------------|----------------------------------------------------------------------|
| **HA Cluster** | 2x Mini PCs (N100)        | If my main server fails, critical services migrate to another node.  |
| **PBS Integration** | Proxmox Backup Server     | Incremental, deduplicated backups to a remote Wasabi/S3 bucket.      |
| **Terraform/Ansible** | IaC (Infrastructure as Code)| Define my entire VM lab in code. `terraform apply` = New Lab.        |

## Core Proxmox Config (LXC Deployment Snippet)

```bash
# Example: Create a lightweight Debian 12 container for Syncthing
pct create 101 /var/lib/vz/template/cache/debian-12-standard_12.0-1_amd64.tar.zst \
  --hostname syncthing-srv \
  --cores 1 \
  --memory 512 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --storage local-zfs \
  --password <REDACTED> \
  --unprivileged 1 \
  --features nesting=1
  ```

### Reflections: Why I’m Never Going Back
Building on bare metal is like building a house on sand. Building on Proxmox is like building a house on a modular platform. If a "room" (VM) catches fire, I delete it and roll back the floor plan to yesterday.