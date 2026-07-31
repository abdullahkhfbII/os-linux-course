# Linux & Operating Systems Lab Course — Complete Guide

This repository rebuilds the entire "Introduction to Linux Operating System" lab
course from the ground up, in the order you should actually learn it. It exists
because the original lab slides (Lab 1 → Lab 9) jump between topics, assume you
already know things that were never taught, and mix explanation with exam
scenarios. Here, every topic gets:

1. A **README** written for someone who has *never opened a terminal before*.
2. A folder of **runnable example scripts** (`examples/`) — heavily commented,
   safe to read and run, showing the commands from the lab in isolation.
3. A folder of **worked scenario solutions** (`scenarios/`) — the practice
   questions that appeared at the end of each original lab, each one as its
   own standalone `.sh` file, written in **the exact style your Lab Test will
   use** (see below).

If a concept is used in the labs but was **never explained**, it is called out
explicitly with a box like this:

> **⚠ Out of scope / not taught in the labs, but needed here:**
> A short explanation is given anyway, because you cannot understand the rest
> of the topic without it. This is flagged so you know it's "extra," not
> something you'll necessarily be tested on directly.

## How the Lab Test works (and why this repo is organized this way)

Based on the real exam-style scenarios provided (`Extra Scenarios.pdf` and
`Lab test 2 scenarios.pdf`), the Lab Test gives you a **written scenario**
(a short story describing a task), and you must **write a single Bash script**
that accomplishes it, chaining together the commands from the labs (users,
permissions, cron jobs, backups, process control, networking, etc).

Because of this, `10-exam-practice/` is the most important folder once you've
learned the material: it contains dozens of scenario questions, **each as its
own `.sh` file**, formatted the same way a real test answer should look
(shebang line, comments explaining each step, one command per line). Practice
writing these yourself *before* looking at the provided solution.

> **⚠ A note on scope:** this repository is a faithful, cleaned-up
> reorganization of a specific lab course whose original materials were
> not well-written — poorly ordered, missing prerequisite explanations,
> and inconsistent in style. It's structured and explained as clearly as
> possible given that source material, but it is **not** a general,
> professionally designed "Operating Systems" course, and it isn't meant
> to be one. It may get edited over time, and a few generally useful
> topics might get folded in, but a proper, from-scratch OS course would
> live in its own separate repository rather than here.

## Suggested order (this is the whole course, start to finish)

| # | Folder | Topic | Corresponds to |
|---|--------|-------|-----------------|
| 0 | `00-prerequisites/` | Concepts the labs *assume* you know (OS/kernel/shell, streams, PATH, regex, networking basics) | *not in original labs — fills the gaps* |
| 1 | `01-linux-fundamentals/` | What is Linux/Ubuntu, filesystem layout, navigating, files & directories, archiving, sudo | Lab 1 |
| 2 | `02-bash-scripting/` | Writing `.sh` scripts, variables, input, `if`, loops, arrays | Lab 2 |
| 3 | `03-users-groups-permissions/` | Creating users/groups, `chmod`, binary permissions | Lab 3 |
| 4 | `04-monitoring-text-processing/` | `free`, `df`, `du`, `grep`, `awk`, pipes | Lab 4 |
| 5 | `05-cron-jobs-and-backups/` | Scheduling tasks with `cron`, `tar` backups, `find` | Lab 5 |
| 6 | `06-networking-fundamentals/` | Network interfaces, `ip`, `ping`, `traceroute`, `netstat`, SSH access control | Lab 6 |
| 7 | `07-networking-advanced/` | `tcpdump` packet capture, `iptables` firewall | Lab 7 |
| 8 | `08-multiprocessing/` | Processes, `ps`, `top`, background jobs, signals, `fork`/`exec`/`wait`, zombies | Lab 8 |
| 9 | `09-advanced-permissions/` | UID/GID, SUID, SGID, Sticky Bit, real vs effective UID | Lab 9 |
| 10 | `10-exam-practice/` | Every scenario question from every lab, plus the two revision documents, solved as individual bash files, **plus a full 100-mark mock final exam** (`10-exam-practice/mock-final-exam/`) built harder than the real one on purpose | Lab Test 1, Lab Test 2, revision docs |

Every numbered folder builds on the ones before it — later topics (cron,
networking, processes, advanced permissions) constantly reuse commands from
Lab 1–3 (creating files, `chmod`, loops, `if`), so don't skip ahead.

## Module info (from the original course)

- 20% Lab test 1 (Week 6) — expected to cover roughly topics 1–5 below
- 20% Lab test 2 (Week 11) — expected to cover roughly topics 6–9 below (this
  matches the real "Lab test 2 scenarios" document, which focuses heavily on
  Labs 8 and 9 combined with earlier labs)
- 60% Unseen exam

## How to use this repo if you've never used a terminal

Start at `00-prerequisites/README.md`, then `01-linux-fundamentals/README.md`.
Every README explains commands **before** showing them, then shows exactly
what to type and what output to expect. When you see a code block like this:

```bash
pwd
```

That means: type `pwd` into your terminal and press Enter. Do this yourself —
don't just read it. Muscle memory is most of what this course is testing.

> [!IMPORTANT]
> Based on how the labs and exam scenarios are structured, this course
> largely tests whether you can *recall and retype* specific commands
> from memory under exam conditions, rather than whether you understand
> the underlying concepts well enough to derive the right command
> yourself. That's a debatable way to test this material — real-world
> sysadmin work leans on documentation (`man`, `--help`, search) far more
> than memorization — but since it's how the exam is run, this repo still
> drills the exact commands/flags so you're prepared for it. Don't mistake
> that drilling for the only (or the best) way to actually learn Linux.

## A note on safety

Several commands in this course (`rm -r`, `chmod 777`, disabling network
interfaces, firewall rules) can break your system or delete data permanently
if used carelessly. Every example that includes a risky command has a
`# ⚠ CAUTION` comment above it. Practice inside a virtual machine or a
disposable directory, never on a machine you care about.
