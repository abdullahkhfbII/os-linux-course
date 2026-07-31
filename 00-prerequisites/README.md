# 0. Prerequisites — The Concepts the Labs Never Explained

The original labs use words like "kernel," "process," "port," "regular
expression," and "PATH" as if you already know them. You don't need a
computer science degree to follow this course, but you do need these
foundational ideas straight in your head first. Read this whole page before
Lab 1 — everything else depends on it.

> **⚠ Out of scope note:** everything in this file is background knowledge.
> None of it is a lab topic on its own, but concepts from Labs 2, 4, 6, 7,
> and 8 will not make sense without it.

## 1. What is an Operating System, really?

Your computer's hardware (CPU, RAM, disk, network card) is dumb on its own.
The **Operating System (OS)** is the software layer that sits between the
hardware and every other program, and its main jobs are:

- Deciding which program gets to use the CPU, and when (**process management**)
- Deciding where in RAM each program's data lives (**memory management**)
- Organizing data on disk into files and folders (**file system**)
- Letting programs talk to hardware like network cards, keyboards, disks
  (**device management**)

Linux is one such operating system. Its core — the part that actually talks
to the hardware — is called the **kernel**. Everything you type in a
terminal eventually asks the kernel to do something on your behalf.

## 2. Terminal vs. Shell vs. Kernel — three different things

These three words get used loosely and it's confusing at first:

| Term | What it actually is |
|------|----------------------|
| **Terminal** | The window/app you type into. Just a text input/output box. |
| **Shell** | The program *running inside* the terminal that reads what you type, interprets it as a command, and runs it. Bash is a shell. |
| **Kernel** | The core of the OS. The shell asks the kernel to actually create files, start programs, etc. You never talk to the kernel directly. |

So when you type `ls` in a terminal: the **terminal** displays your keystrokes,
the **shell** (bash) figures out you mean "run the program called `ls`,"
and the **kernel** actually reads the directory from disk and hands the
results back up the chain.

## 3. Files, directories, and paths

Everything in Linux — including devices like your hard disk — is represented
as a **file**, organized into a single tree of **directories** (folders)
starting from one root, written `/`. There is no "C: drive" like Windows;
everything hangs off of `/`.

- An **absolute path** starts from `/` and always means the same location no
  matter where you currently are, e.g. `/home/student/notes.txt`.
- A **relative path** is relative to your *current directory*, e.g. `notes.txt`
  or `../notes.txt` (the `..` means "go up one directory first").
- `.` always means "the current directory," `..` always means "the parent
  directory," and `~` always means "my home directory."

Lab 1 covers `cd`, `pwd`, `ls` — the commands for moving around this tree —
but this is the mental model behind them.

## 4. Standard Input, Standard Output, and Standard Error

Every command-line program has three default communication channels open when
it runs:

| Stream | Number | Purpose |
|--------|--------|---------|
| **stdin** (standard input) | 0 | Where a program reads input from (usually your keyboard) |
| **stdout** (standard output) | 1 | Where a program prints its normal output (usually your screen) |
| **stderr** (standard error) | 2 | Where a program prints error messages (also your screen, but a separate channel) |

This matters because of **redirection**, which Lab 1 and Lab 4 use constantly:

```bash
echo "hello" > file.txt     # redirect stdout INTO file.txt (overwrite)
echo "again" >> file.txt    # redirect stdout, APPEND instead of overwrite
command 2> errors.log       # redirect only STDERR into errors.log
command 2>/dev/null         # throw away error messages entirely
                             # (used in Lab 9: find / -perm /4000 2>/dev/null)
command < input.txt         # feed a file's contents in as stdin
```

`/dev/null` is a special "black hole" file — anything written to it just
disappears. It's used to silence output you don't care about.

## 5. The Pipe (`|`) — connecting programs together

A **pipe** takes the stdout of one command and feeds it directly into the
stdin of the next command, without needing a temporary file. This is the
backbone of Lab 4's `grep`/`awk` examples:

```bash
ps -ef | grep firefox
# ps -ef prints EVERY running process (its stdout)
# the pipe sends that output as INPUT to grep
# grep filters it down to only lines containing "firefox"
```

You can chain many pipes: `command1 | command2 | command3 | command4`. Think
of it as an assembly line — each stage transforms the data a bit more.

## 6. Exit codes (`$?`) and `if [ -f file ]` style checks

Every command, when it finishes, returns a number called an **exit status**
(or exit code) to the shell: `0` means "success," any non-zero number means
"something went wrong." Bash's `if` statements are actually testing exit
codes, not "truthiness" like other languages.

```bash
ls /tmp
echo $?        # prints the exit code of the PREVIOUS command (0 = success)

grep "root" /etc/passwd
echo $?        # 0 if a match was found, 1 if not found
```

The square-bracket tests you'll see everywhere (`[ -f file.txt ]`,
`[ "$a" -gt 5 ]`) are really just a command called `test` in disguise — it
runs, checks the condition, and returns exit code 0 (true) or 1 (false),
which `if` then reacts to. Some common file-test flags:

| Test | Meaning |
|------|---------|
| `-f file` | true if `file` exists and is a regular file |
| `-d dir`  | true if `dir` exists and is a directory |
| `-e path` | true if `path` exists at all (file or directory) |
| `-x file` | true if `file` is executable |

## 7. The PATH variable and why `./script.sh` is needed

When you type a command name like `ls`, the shell doesn't search your entire
disk for a program called `ls` — it only looks in a specific list of
directories stored in the environment variable `PATH`. You can see yours:

```bash
echo $PATH
# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Your **own scripts**, sitting in your home directory or Desktop, are *not*
in that list. That's why Lab 2 has you run scripts as `./myscript.sh`
instead of just `myscript.sh` — the `./` explicitly says "look for this file
right here, in the current directory," bypassing PATH entirely.

> **⚠ Out of scope but useful:** you *can* add a folder to your PATH
> permanently by editing `~/.bashrc`, but the labs don't require this — they
> always use `./script.sh` or an absolute path like `/home/user/script.sh`.

## 8. Environment variables vs. shell/script variables

Lab 2 introduces variables (`name="Yahia"`), but there's an important
distinction the labs don't spell out:

- A normal variable (`name="Yahia"`) exists **only in the current shell or
  script**. Child processes (programs you launch from that shell) cannot
  see it.
- An **environment variable** (created with `export name="Yahia"`) is copied
  into every child process you launch afterward. `$PATH`, `$HOME`, and
  `$USER` are all environment variables set by the system.

This is *why* Lab 2's table about `./script.sh` vs `source script.sh` behaves
the way it does — `./script.sh` and `bash script.sh` both start a **new
child process** with its own private variables, while `source script.sh`
runs the code inside your *current* shell, so nothing is "child vs parent"
and the variables stick around.

## 9. Command-line arguments and special variables

Bash scripts can receive input directly from how they're launched, not just
via `read` (which Lab 2 covers). This isn't in the original labs but appears
implicitly in exam-style scripts that reuse values:

```bash
#!/bin/bash
echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "All arguments: $@"
echo "Number of arguments: $#"
```

Run as `./myscript.sh hello world` → `$1` is `hello`, `$2` is `world`.

## 10. Regular Expressions (regex) — the pattern language behind `grep`/`awk`

Lab 4 uses `grep -oE '[0-9.]+'` and similar patterns without ever explaining
regex syntax. A **regular expression** is a mini pattern-matching language.
The essentials you need for this course:

| Pattern | Matches |
|---------|---------|
| `[A-Z]` | any one uppercase letter |
| `[a-z]` | any one lowercase letter |
| `[0-9]` | any one digit |
| `[0-9.]` | any one digit **or** a literal dot |
| `+` | "one or more of the previous thing" (needs `-E` in grep, called *extended* regex) |
| `*` | "zero or more of the previous thing" |
| `.` | any single character (careful: this is different from a literal dot!) |
| `^` | start of the line |
| `$` | end of the line |

So `grep -oE '[0-9.]+'` means: "find one-or-more characters that are each
either a digit or a dot," which is how Lab 4 pulls a number like `4.5` out
of a sentence like `Desktop is 4.5G`.

## 11. Networking basics (needed before Lab 6/7)

The labs jump straight into `ip addr`, `ping`, `iptables`, and ports without
defining the underlying concepts. Here's the minimum you need:

- **IP address**: a numeric address (e.g. `192.168.1.10`) identifying a
  device on a network, similar to a postal address.
- **Subnet mask / CIDR notation** (`/24`, `/16`, etc., as in
  `ip addr add 192.168.1.5/24 dev eth0`): the number after the `/` says how
  many bits of the address identify the *network* vs. the *specific device*.
  `/24` means the first 24 bits (three number groups) identify the network,
  and devices on that network share those first three numbers. You don't
  need to calculate subnets by hand for this course, just recognize the
  notation.
- **Port**: a number (0–65535) identifying *which program* on a device
  should receive network traffic, since one device can run many network
  services at once. Port 22 = SSH, port 80 = HTTP, port 443 = HTTPS. This is
  why Lab 7's firewall rules reference `--dport 22` or `--dport 443`.
- **Protocol (TCP vs UDP)**: TCP is a reliable, connection-based way to send
  data (used by SSH, HTTP); UDP is a faster but "fire and forget" way with
  no guarantee of delivery (used by video streaming, DNS lookups).
- **Socket**: the combination of an IP address + a port + a protocol,
  representing one specific network connection. `netstat` (Lab 6) lists
  active sockets.
- **Daemon**: a program that runs continuously in the background waiting to
  respond to requests (e.g. `sshd`, the SSH daemon, waits for login
  attempts). Lab 6 briefly compares daemons to cron jobs.

## 12. Where to go next

You now have enough background to start the actual course. Continue to
[`01-linux-fundamentals/README.md`](../01-linux-fundamentals/README.md).
