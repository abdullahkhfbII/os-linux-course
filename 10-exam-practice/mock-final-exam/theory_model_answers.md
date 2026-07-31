# Mock Final Exam — Part B Model Answers

These are model answers, not the only acceptable wording. Marks are
awarded for the underlying understanding, not for matching this text
exactly.

## B1. Sticky Bit vs. plain `777`

`chmod 777` controls whether users can read, write, and execute inside a
shared folder at all — but it says nothing about *deletion specifically*.
Once "others" have write access to a directory, they can delete or rename
**any** file inside it, including files that belong to someone else,
because deletion is governed by the directory's write permission, not the
individual file's owner. The Sticky Bit adds one extra rule on top of
that: even in a fully writable shared directory, a user may only delete
(or rename) files **they personally own**. Avoiding `777` entirely isn't
always practical because a genuinely shared team folder often does need
every member to create, edit, and organize files freely — the goal isn't
to lock the folder down, just to stop people from deleting each other's
work by accident or on purpose.

## B2. Real UID vs. Effective UID

The **real UID** is simply who actually launched the process — your own
account. The **effective UID** is the identity the kernel uses when
deciding what that process is *allowed to do* at any given moment. For
almost all programs these are identical, but they diverge specifically for
SUID-enabled executables: the process's real UID stays as the person who
ran it, while its effective UID temporarily becomes the file's owner. This
distinction has to exist so a regular user can be granted a narrow,
specific elevated capability (like changing their own password, which
requires writing to a root-only file) without handing them full
administrative control over everything else on the system — the program
can check "who really invoked me" for logging/auditing purposes while
still acting with elevated permission for the one operation it performs.

## B3. Zombie processes

A process in state `Z` has already finished executing — it's not
consuming CPU and isn't doing any work — but its entry in the process
table hasn't been removed yet. The operating system deliberately keeps
this small record around so that the process's **parent** has a chance to
retrieve its exit status (how it finished, success or failure) by calling
`wait()`. The zombie disappears once that happens — either because the
parent calls `wait()` on it directly, or because the parent process itself
ends first, in which case the zombie is automatically "adopted" by
`systemd` (PID 1), which immediately cleans it up on the original parent's
behalf.

## B4. Daemon vs. cron job

A **daemon** is a program that starts once (usually at boot) and then
keeps running continuously in the background, constantly available to
respond the instant something relevant happens — `sshd` is always
listening for a login attempt, for example. A **cron job**, by contrast,
does not run continuously at all; it stays inactive until its scheduled
time arrives, then runs once, performs its task, and exits. From this
exam's scenario, the weekly backup-cleanup task (A4) must be a cron job,
not a daemon, because it only needs to *do something* at one specific
moment each week (Sunday, 3:00 AM) — there's no ongoing event to wait for
in between, so keeping a process alive and idle the rest of the time would
waste resources for no benefit.

## B5. Chains, rules, and default policy in `iptables`

A **chain** is the stage of traffic flow a rule applies to — in this
scenario, `INPUT` represents traffic arriving *at* this server. A **rule**
is one specific condition-plus-action added to that chain, e.g. "if a
packet is TCP and its destination port is 22, `ACCEPT` it" — and the same
logic is repeated for port 443. Chains are checked top-to-bottom, rule by
rule, until one matches. The **default policy** (`DROP`, in this case) is
what happens only when a packet reaches the end of the chain without
matching *any* of the specific rules above it — so after explicitly
allowing SSH and HTTPS, every other kind of inbound traffic (any other
port, any other protocol) falls through to that default and gets dropped
automatically, without needing an explicit rule written for every single
case.
