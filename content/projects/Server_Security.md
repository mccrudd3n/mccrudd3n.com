---
title: "Server-Side Security – A Living Journey"
description: "Security is a process, not a state. This is my real-time, public notebook of turning four random machines into a hardened, monitored, and automated personal cloud."
date: 2025-12-11
lastmod: 2025-12-11
draft: false
tags: ["homelab", "security", "tailscale", "ansible", "cloudflare", "monitoring", "defense-in-depth"]
cover:
  image: "/images/projects/server-security-banner.jpg"
  alt: "Four green Ansible pongs and a dark dashboard with OSSEC alerts"
  caption: "When your entire fleet finally says pong and nothing is on fire."
toc: true
featured: true
---

## TL;DR – Current State (11 Dec 2025)

- Four machines (Lenovo laptop + home server + 2× Vultr) fully connected via Tailscale MagicDNS  
- Unified username `username` everywhere  
- Passwordless, key-only SSH (even on the weird one running SSH on 2222)  
- Ansible control plane working with zero warnings  
- Cloudflare proxy + DNS handling all public exposure  
- Next phase → passive breach detection & response (already half built)

GitHub repo (public, everything is in here):  
https://github.com/mccrudd3n/server_security

## Phase 1 – Complete (The Foundations)

| Component              | Status   | Details                                                                 |
|------------------------|----------|-------------------------------------------------------------------------|
| Zero-trust network     | ✅     | Tailscale + MagicDNS (`blackhole`, `cloud99`, `production`, `home`)               |
| Unified username       | ✅     | `username` on every box                                                 |
| Key-only SSH           | ✅     | No passwords anywhere                                                   |
| Ansible orchestration  | ✅     | Single `inventory.ini`, works even on non-standard ports                |
| Public exposure        | ✅     | Only Cloudflare Tunnel / Proxy → no open ports on any machine           |
| Firewalling            | ✅     | UFW only allows Tailscale subnet (100.64.0.0/10) + 80/443 where needed  |

## Phase 2 – In Progress (Security Monitoring & Passive Prevention)

Security is a process → I want to learn how the second something weird happens, I am alerted.

### Tools I’m looking to deploy (all free, all open-source)

| Tool                  | Purpose                                          | Deployment method          | Status     |
|-----------------------|--------------------------------------------------|----------------------------|------------|
| OSSEC (Atomic OSSEC)  | Host-based intrusion detection (file integrity, rootkits, log analysis) | Ansible playbook           | Running on all nodes |
| Wazuh (fork of OSSEC) | Central manager + beautiful dashboard + active response | Docker on `production`     | Manager up, agents connected |
| Fail2Ban              | Ban IPs after repeated failed logins             | Ansible                    | Done       |
| CrowdSec              | Collaborative bouncer + modern fail2ban alternative | Ansible + central console  | Testing    |
| UFW + nftables logging| Log dropped packets                              | Already active             | Done       |
| Prometheus Node Exporter + Alertmanager | System metrics + alerting                     | Ansible                    | Next       |

### Current detection capabilities (already live)

- Any change to `/etc/passwd`, `/etc/ssh/sshd_config`, or critical binaries → instant alert  
- New user created → alert  
- SSH brute-force attempts → auto-ban (Fail2Ban + CrowdSec)  
- Rootkit signatures → alert  
- Unexpected processes → alert  
- All logs shipped in real-time to central Wazuh dashboard at `https://wazuh.production.mccrudd3n.com`

### Future additions (next 2 weeks)

| Feature                         | Tooling                             | Why it matters                              |
|---------------------------------|-------------------------------------|---------------------------------------------|
| Automated backups of OSSEC alerts | Rclone → encrypted off-site        | Even if attacker wipes logs, I still have them |
| Honey pots                      | Cowrie SSH honeypot on a fake port  | Early warning + attacker fingerprinting     |
| Canary tokens                   | Thinkst Canary on fake files        | Instant alert if someone reads them         |
| Daily vulnerability scanning    | OpenVAS / Trivy (container)         | Know when I’m vulnerable               |
| eBPF-based monitoring           | Falco or Tracee                     | Detect weird syscalls in real time          |

## My Current Ansible Playbooks (public)

```yaml
# roles/common/tasks/main.yml
- name: Unified user exists
  user:
    name: username
    shell: /bin/bash
    groups: sudo,docker
    append: yes

- name: Deploy SSH key
  authorized_key:
    user: username
    key: "{{ lookup('file', '~/.ssh/id_ed25519.pub') }}"

- name: Harden SSH
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^PermitRootLogin'
    line: 'PermitRootLogin prohibit-password'

- name: Install and configure OSSEC agent
  include_role:
    name: ossec-agent
```

Everything is idempotent, version-controlled, and tested.

## P.S. – If you’re a friendly hacker reading this…

Yes, I know this is public.  
Yes, I want you to look.  
If you spot a wee hole (misconfig, bad practice, exposed service, weak ACL, anything), please open an issue or DM me on john@mccrudd3n.com!  
I learn fastest when someone actually breaks in (ethically) and tells me how.  
I’ll credit you in the next blog post and buy you an ethernet coffee if our paths ever cross!

Security is a process.  
This document will never be “finished” — it will only get longer and greener.

...Once the project is somewhat live, i will move this section into the blog or journal so that the projects section presents this project rather than my blabber!
