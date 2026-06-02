---
title: "The Hidden Complexity of 'Simple' File Distribution"
date: 2026-06-02
draft: false
tags: ["infrastructure", "automation", "self-hosting", "data-pipelines", "proxmox"]
description: "How a 'simple' Syncthing-based log collection system revealed deeper problems with permissions, resource constraints, and centralized thinking — and what we built instead."
---

I started with what seemed like a straightforward problem: I wanted reliable, low-overhead log collection and processing across a small fleet of servers.

The initial idea was elegant in its simplicity. Use Syncthing in send-only mode from each node, pushing raw logs into a central location. From there, a lightweight process would analyze them, generate reports, and surface problems. Victor — a non-sudo, low-privilege user — would handle most of the work on the remote machines. Everything would stay lightweight, auditable, and cheap in terms of both compute and cognitive load.

That vision lasted about three weeks.

## The Syncthing Promise

Syncthing is genuinely excellent for many things. It’s reliable, works over Tailscale without exposing ports, and the one-way folder model felt like a perfect fit for log shipping. Each node could run a small collection script that dropped logs into a send-only folder. The central machine would receive everything without any node needing to know or care about the destination.

On paper, this was minimal and clean.

In practice, it exposed several uncomfortable truths.

## The Resource Bottleneck Nobody Talks About

The first real problem appeared when I considered how to actually *process* the logs.

Raw log collection is easy. Meaningful analysis is not.

I initially assumed I could keep processing extremely light — just some shell scripts and occasional Python. When that proved insufficient, the natural next thought was “we should use Ansible for proper orchestration and configuration management across the fleet.”

That’s when reality hit.

Most of these machines run inside constrained Proxmox VMs. They have limited CPU, memory, and — critically — they are already doing real work. Adding a full Ansible control plane (or even regular Ansible pull runs) would have roughly doubled the baseline workload on several of these systems.

Worse, it would have done so in a way that was difficult to measure until the degradation was already noticeable. Ansible is not a lightweight tool when you start using it seriously. The Python runtime, fact gathering, module execution, and connection handling all add up.

I had fallen into the classic trap: treating “simple file transfer” as an isolated problem, when the real system includes collection, transport, processing, alerting, and long-term archival. Each layer has hidden costs.

## The Permission Model Was the Real Enemy

The second, deeper problem was permissions and ownership.

I had deliberately designed the remote machines around a low-privilege user called `victor`. The idea was sound: minimize the blast radius of any compromise or mistake. Victor had a narrow `sudoers` rule that only allowed execution of specific scripts in a particular directory.

This worked fine for simple maintenance tasks.

It failed completely when we tried to build real data pipelines.

The log processing scripts needed to read raw logs, write processed summaries, trigger archival, and eventually generate reports. These operations crossed multiple ownership boundaries. The processing code ended up needing privileges that Victor was intentionally denied.

We spent significant time discovering this the hard way — attempting to run processors as victor, hitting permission denied errors, trying to work around them with increasingly ugly sudo rules, and realizing that the entire architecture was fighting against the security model we had intentionally put in place.

This was not a small implementation detail. It was a fundamental mismatch between the security posture and the data processing requirements.

## Centralized Thinking in a Distributed World

The third issue was more philosophical but just as practical.

Because everything funneled through a central location, the central machine (and the processes running on it) became a single point of both coordination and failure. Every time we wanted to add new analysis, we had to either:

- Pull more data over SSH from the nodes, or
- Increase the privileges of the low-privilege user, or
- Accept that some analysis simply wouldn’t happen reliably.

None of these options were good.

We eventually realized that the correct direction was the opposite of what we started with. Instead of pulling everything to the center for processing, we should push *intelligence* out to the edges.

Each node should be responsible for understanding its own logs and producing small, high-signal “action items” files. The center’s job should mostly be aggregation and presentation, not deep analysis.

This is the classic shift from pull to push, and it only became obvious after we had already built a fair amount of the pull-based system.

## What We Actually Built

After several iterations and one fairly painful post-mortem, the current system looks like this:

- Nodes still use Syncthing for reliable, one-way log distribution when needed.
- Local processing happens on the nodes themselves where possible (running with appropriate privileges).
- A very small number of low-token cron jobs (using Hermes’ `no_agent` mode) handle aggregation and the weekly actionable report.
- The weekly email no longer dumps raw status. It produces a short, prioritized list of things that actually need human attention.
- Victor’s permissions remain narrow by design. We stopped trying to make him do work he was never meant to do.

The system is still imperfect, which is why we have a clear V2 proposal that moves even further toward distributed, local-first intelligence generation.

## Lessons

A few things became obvious only in hindsight:

**“Simple” almost always means “simple for the first 80% of the problem.”** The last 20% — permissions, resource accounting, failure modes, and ownership — usually contains the real architectural decisions.

**Security boundaries are not free.** When you intentionally limit what a user or process can do, you must design your data flows around those limits from the beginning. Retrofitting is painful.

**Tool choice has second-order costs.** Adding Ansible to a fleet of constrained VMs is not just “installing Ansible.” It is a permanent increase in baseline resource usage and operational complexity. Sometimes that trade-off is worth it. Often it is not.

**Centralization is seductive but fragile.** It feels easier to have one place that knows everything. In practice, it creates coupling and hides the real distribution of work.

**Actionable output is much harder than status output.** Generating “here are all the errors” is trivial compared to generating “here is the specific thing a human should do this week, and why.”

## Where This Is Going

We now have a much clearer picture of what a sustainable version of this system should look like. The next major iteration moves even more processing and decision-making to the individual nodes, reduces the central machine’s role to coordination and long-term archival, and treats the weekly actionable report as the primary interface rather than an afterthought.

The goal is no longer “collect all the logs centrally and figure it out later.” The goal is “every node should be able to tell you what it needs, with minimal central intelligence required.”

That is a fundamentally different system from the one we started building.

---

*This post documents a real, messy evolution rather than a clean success story. The system is still in active development, and several of the architectural questions remain open. That’s the point.*

If you’re building similar low-overhead infrastructure, I’m happy to compare notes. The gap between “this should be simple” and “this is actually maintainable at 2am” is where most of the interesting work happens.