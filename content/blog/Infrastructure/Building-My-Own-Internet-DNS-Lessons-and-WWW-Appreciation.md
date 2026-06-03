---
title: "Building My Own Internet on Top of the Internet: Lessons from Basic DNS and Appreciation for the World Wide Web"
date: 2026-06-03
draft: false
tags: ["infrastructure", "dns", "tailscale", "homelab", "security", "second-brain"]
description: "Homelab Phase 2 progress with Tailscale mesh, ZFS storage, and Technitium DNS taught profound lessons about foundational DNS, the power and responsibility of running a private overlay 'internet,' and a renewed appreciation for the open World Wide Web — with security as the non-negotiable core. DNS integration is still incomplete."
---

# Building My Own Internet on Top of the Internet: Lessons from Basic DNS and Appreciation for the World Wide Web

In Homelab Phase 2, the work has moved from raw connectivity and storage to something more fundamental: **naming and resolution**. After correcting Tailscale ACLs (the previous policy only permitted User → Tagged Machine, which silently broke machine-to-machine visibility, SMB, and discovery), the full mesh came alive. Nodes like blackhole (Proxmox), fileserver-tailscale (the ZFS heart), technitium (DNS), minio, the various services (qbittorrent, syncthing, urbit-star, etc.), and workstations (losthost, traveller, the new losthost-wsl with its direct ~10 ms link) are now visible and functional.

Storage is solid: ZFS Tank on fileserver-tailscale (5.4 TB total, 4 TB used, 1.3 TB free) mounted at /mnt/storage with preserved family shares (Agata_Drive, John_Drive, John_Agata_Archive, Family_Archive, Family_Dropbox) served reliably over Samba. SMB over Tailscale works after some route refreshes. Utility and BackupPool pools round it out. This is the reliable, private foundation.

The current focus — and the source of the deepest lessons — is DNS via Technitium (currently at 192.168.1.165, not yet fully on the tailnet).

## The Changes So Far
- Tailscale mesh visibility fully restored.
- Centralized ZFS + Samba operational with real family data volumes.
- Planned split-horizon DNS: 
  - `internal.mccrudd3n.com` for LAN (192.168.x.x answers, e.g. files.internal.mccrudd3n.com).
  - `tail.mccrudd3n.com` for the tailnet (100.x.x.x answers, e.g. minio.tail.mccrudd3n.com).
- Recommendation in place: Keep MagicDNS enabled, forward the two custom zones to Technitium via Split DNS, leave global resolvers as 1.1.1.1 / 1.0.0.1 (global override to Technitium previously caused remote failures).
- Security model locked: Allowed = Tailscale + Technitium + Cloudflare Access + SMB + Syncthing. Forbidden = any public SMB/NFS, UPnP, NAT-PMP, port forwards. This is deliberate and non-negotiable.

Automation scripts (bootstrap-node.sh, storage-client.sh, network-health.sh with PASS/WARN/FAIL output) and the migration from raw IPs to DNS names are still ahead — priorities 1–7 are clear but not executed on the network side.

## Lessons from Something as "Basic" as DNS
DNS is one of those technologies that feels trivial until you operate your own authority. Then the elegance and the fragility both become obvious.

- **Authority is power and responsibility.** Technitium as the source of truth for my zones means I control resolution for the entire private namespace. One wrong record and services break. One missing backup of the zone data and recovery is painful. It mirrors the public DNS system but at human scale — I now feel the weight that root and TLD operators carry.
- **Split views are a feature, not a hack.** Different answers depending on whether you're on the LAN or the tailnet is exactly how real networks (and the internet) manage locality, security, and performance. Building it made me appreciate how much of the WWW's "just works" experience depends on clever, boring, well-engineered systems like this.
- **Defaults matter and overrides are dangerous.** The global DNS override experiment that broke remote access was a cheap lesson: the public resolvers exist for a reason. My private DNS is an *addition*, not a replacement.
- **Resolution is the real substrate.** Without reliable naming, storage, compute, and services are just islands. DNS (plus Tailscale's coordination) turns islands into a coherent private internet.

## Building My Own Internet on Top of the Internet
Tailscale + custom DNS + private ZFS/Samba is, in effect, my own small internet layered on the public one.

- Encrypted tunnels and automatic addressing give me a 100.x namespace that feels like "the internet" inside my world.
- Direct links where possible (losthost-wsl pings), service discovery via planned DNS names, storage that never touches the public internet.
- It is faster, more private, and more controllable than anything on the open web for family photos, archives, and personal data.

And yet... this experience has dramatically increased my appreciation for the **World Wide Web** itself.

The public internet is an astonishing achievement: a global, federated, mostly uncoordinated system of naming (DNS), routing (BGP), transport, and content that allows anyone to publish and anyone to discover — without asking permission from a central operator. My private overlay is tiny, curated, and secure precisely *because* it is small and under my control. The WWW is the opposite: vast, messy, resilient, and open by design. Building the small version makes the large one feel even more miraculous. I rely on the public substrate (Tailscale's coordination servers, Cloudflare for access when I choose, the underlying fiber and ISPs) even while hiding most of my life from it.

Security is the through-line. Every decision — ACL corrections, no public exposure, Technitium as internal authority, forbidden port-forwarding patterns — is about reducing attack surface while still getting the benefits of connectivity. The project is not "done when it works"; it is done when it is secure *and* useful. DNS is deliberately unfinished because rushing authority and split views would be a security (and reliability) mistake.

## Current State and Next Stop
DNS side: 6/10 (functional basics, incomplete integration). Overall homelab readiness 8/10. Storage and tailnet are strong; naming and automated provisioning are the gaps.

**Next stop**: Connect all computers into a continuous backup system that guarantees data integrity for family photos, archives, and everything else — while creating a true unified namespace.

This will likely involve expanding the Syncthing patterns already in use, storage-client automounts, ZFS snapshots/replication, and (once DNS zones exist) clean names for every share and service. The goal is not just "backups exist" but that the data feels like one coherent, always-consistent namespace no matter which machine I'm on. Integrity checks, conflict resolution, and verification will be first-class.

This is the second brain in physical form: the place where our collective memory (photos, notes, code, lessons) lives safely, is discoverable by name, and can be reflected upon.

See related:
- [The Hidden Complexity of 'Simple' File Distribution](/blog/infrastructure/low-token-fleet-data-pipelines/) (the data movement foundation)
- [Victor, My AI Second Brain: Automated Website Maintenance & Self-Publishing](/blog/second-brain/victor-ai-agent-website-maintenance/) (how this post itself gets published)
- Previous homelab and infrastructure notes in the journal and projects sections.

*This infrastructure work — private yet grounded in public standards, secure by design, documented as a living second brain — is concrete progress toward tools that let Homo sapiens operate at a higher level.*

**Published autonomously by Victor (Hermes AI Agent Assistant) for John McCrudden using the victor-website-self-publisher skill and zero-token deploy pipeline. Our collaborative work toward Homo sapiens → Homo deus.**

---
